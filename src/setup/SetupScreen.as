package setup
{
	
	import flash.display.Sprite
	import flash.events.MouseEvent;
	import com.whirled.game.GameControl;
	import com.whirled.net.MessageReceivedEvent; 
	import com.whirled.net.PropertyChangedEvent;
	import game.accessPoints.GameInformation;
	import game.data.MapList;
		
	public class SetupScreen extends Sprite
	{		
	
		public var playerIds :Array;
		public var teamList :TeamList;
		public var chooseShip :ChooseShip;
		private var myCheckBox:MyCheckBox;
		protected var mapDisplay:MapDisplay;
		protected var mapList:MapList;
		
		
		public function SetupScreen()
		{			
			var bg = new BackgroundMC();
			addChild(bg);
						
			teamList = new TeamList();
			teamList.x = 0;
			teamList.y = 100;
			addChild(teamList);			
			
			chooseShip = new ChooseShip();
			chooseShip.x = 680;
			chooseShip.y = 80;
			addChild(chooseShip);
			
			
			//Checkbox
			myCheckBox = new MyCheckBox();
			myCheckBox.x = 760;
			myCheckBox.y = 390;
			myCheckBox.addEventListener(MouseEvent.CLICK, checkBoxClick);
			addChild(myCheckBox);
			
			//Map		
			addMapDisplay(GameInformation.map);	
			
			
			GameInformation.addEventListener(PropertyChangedEvent.PROPERTY_CHANGED, propertyChanged);			
						
		}
		protected function addMapDisplay(map:String)
		{
			mapList = new MapList();
			mapDisplay = new MapDisplay(mapList.getMap(map));			
			mapDisplay.rotation = 45;
			mapDisplay.y = 5;
			mapDisplay.x = 200;
			mapDisplay.scaleX = 0.2;
			mapDisplay.scaleY = 0.2;
			mapDisplay.addEventListener(MouseEvent.MOUSE_OVER, enlargeMap);
			mapDisplay.addEventListener(MouseEvent.MOUSE_OUT, shrinkMap);
			addChild(mapDisplay);
		}
		
		/** Responds to property changes. */
		protected function propertyChanged (evt :PropertyChangedEvent) :void
		{
			if(evt.name == constants.MAP)
			{
				addMapDisplay(evt.newValue.toString());
			}
		}
		
		protected function enlargeMap(evt:MouseEvent)
		{
			mapDisplay.scaleX = 1;
			mapDisplay.scaleY = 1;
		}
		
		protected function shrinkMap(evt:MouseEvent)
		{
			mapDisplay.scaleX = 0.2;
			mapDisplay.scaleY = 0.2;
		}
		
		public function checkBoxClick(evt:MouseEvent)
		{
			myCheckBox.toggleState();
			var msg = new Object();
			msg[0] = GameInformation.getMyPosition();
			msg[1] = myCheckBox.ticked;
			GameInformation.sendMessage (constants.CHANGE_READY, msg);
			
		}
		
	}
}