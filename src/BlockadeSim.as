package 
{
	import com.whirled.game.GameControl;
	import com.whirled.game.StateChangedEvent;	
	import com.whirled.net.MessageReceivedEvent; 
	import flash.text.*;
	import flash.display.*;
	import flash.events.*;
	import game.accessPoints.GameInformationWhirled;
	import game.accessPoints.GameInformationLocal;
	import game.Board;
	import game.Ship;
	import setup.SetupScreen;
	import game.GameScreen;
	import unitTests.UnitTests;
	import game.EventsDispatcher;
	import game.accessPoints.GameInformation;
	
	[SWF(width="800", height="500")]
	public class BlockadeSim extends Sprite
	{
		public var setupScreen :SetupScreen;
		public var gameScreen :GameScreen;
		
		/** Main constructor for the game. */
		public function BlockadeSim():void
		{	
			
			
			if (constants.TEST_MODE == true) {
				GameInformation.initialise(new GameInformationLocal());	
				runUnitTests();				
			} else {			
				if (constants.RUN_LOCALLY == true) {
					GameInformation.initialise(new GameInformationLocal());					
					setup();
				} else {
					GameInformation.initialise(new GameInformationWhirled(new GameControl(this)));
					GameInformation.addEventListener(StateChangedEvent.GAME_STARTED, setup);	
				}		
				
				
				
				GameInformation.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceived);
			}
		}
		
		public function messageReceived(evt:MessageReceivedEvent):void
		{
			if(evt.name == constants.START_GAME)
			{
				removeChild(setupScreen);				
				setupScreen = null;
				gameScreen = new GameScreen();
				addChild(gameScreen);
			}				
		}
		
		public function setup(evt:Event = null):void
		{
			trace("setting up");
			setupScreen = new SetupScreen();
			addChild(setupScreen);
		}

		
		/** This is called when your game is unloaded. */
		protected function handleUnload (event :Event) :void
		{
			// stop any sounds, clean up any resources that need it
			removeChild(setupScreen);
			removeChild(gameScreen);
			GameInformation.removeEventListener(StateChangedEvent.GAME_STARTED, setup);
			GameInformation.removeEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceived);
		}
		
		public function runUnitTests():void
		{
			var tests:UnitTests = new UnitTests();
			tests.runAllTests();
			addChild(tests);
		}
		
		
		
		
		
		
	}
		
}