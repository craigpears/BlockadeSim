package game 
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import game.DamageRadial;
	import game.events.BubbledEvent;
	
	import game.MyRadioButton;
	import game.AutomovesCheckbox;
	
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class MoveInputUI extends Sprite
	{
		protected var damageRadial:DamageRadial = new DamageRadial();
		
		protected var cb00:CannonInput = new CannonInput();
		protected var cb01:CannonInput = new CannonInput();
		protected var cb02:CannonInput = new CannonInput();
		protected var cb03:CannonInput = new CannonInput();
		
		protected var cb10:CannonInput = new CannonInput();
		protected var cb11:CannonInput = new CannonInput();
		protected var cb12:CannonInput = new CannonInput();
		protected var cb13:CannonInput = new CannonInput();
		
		protected var AutoMovesRadio:AutomovesCheckbox = new AutomovesCheckbox();
		protected var LeftsRadio:MyRadioButton = new MyRadioButton(1);
		protected var ForwardsRadio:MyRadioButton = new MyRadioButton(2);
		protected var RightsRadio:MyRadioButton = new MyRadioButton(3);
		
		public function MoveInputUI() 
		{
			// Add the UI components			
			addDamageRadial();
			addCannonballInputs();			
			addRadioButtons();
			
		}
		
		public function setDamage(percentage:Number) {
			damageRadial.damage = percentage;
		}
		
		public function setBilge(percentage:Number) {
			damageRadial.bilge = percentage;
		}
		
		private function addDamageRadial() {
			damageRadial.x = 272.60;
			damageRadial.y = 19.25;
			damageRadial.width = 44.20;
			damageRadial.height = 44.20;
			addChild(damageRadial);
		}
		
		private function addCannonballInputs() {
			// Set the co-ordinates for the inputs
			// Inputs on the left side
			cb00.x = 176.30;
			cb00.y = 29.00;
			cb01.x = 176.30;
			cb01.y = 63.15;
			cb02.x = 176.30;
			cb02.y = 97.30;
			cb03.x = 176.30;
			cb03.y = 131.50;
			
			// Inputs on the right side
			cb10.x = 236.80;
			cb10.y = 29.00;
			cb11.x = 236.80;
			cb11.y = 63.15;
			cb12.x = 236.80;
			cb12.y = 97.30;
			cb13.x = 236.80;
			cb13.y = 131.50;
			
			// Set the types
			cb00.setType(0,0);
			cb01.setType(0,1);
			cb02.setType(0,2);
			cb03.setType(0, 3);
			
			cb10.setType(1,0);
			cb11.setType(1,1);
			cb12.setType(1,2);
			cb13.setType(1, 3);
			
			// Add the event listeners 
			cb00.addEventListener(MouseEvent.CLICK,cannonChange);
			cb01.addEventListener(MouseEvent.CLICK,cannonChange);
			cb02.addEventListener(MouseEvent.CLICK,cannonChange);
			cb03.addEventListener(MouseEvent.CLICK,cannonChange);
			cb10.addEventListener(MouseEvent.CLICK,cannonChange);
			cb11.addEventListener(MouseEvent.CLICK,cannonChange);
			cb12.addEventListener(MouseEvent.CLICK,cannonChange);
			cb13.addEventListener(MouseEvent.CLICK,cannonChange);
			
			//Add both sets of inputs to the stage
			addChild(cb00);
			addChild(cb01);
			addChild(cb02);
			addChild(cb03);
			
			addChild(cb10);
			addChild(cb11);
			addChild(cb12);
			addChild(cb13);
		}
		
		private function cannonChange(evt:MouseEvent) {
			dispatchEvent(new BubbledEvent(BubbledEvent.CANNON_CHANGE, evt));
		}
		
		public function resetCannonsEntered() {			
			cb00.cannonsEntered = 0;
			cb01.cannonsEntered = 0;
			cb02.cannonsEntered = 0;
			cb03.cannonsEntered = 0;
			cb10.cannonsEntered = 0;
			cb11.cannonsEntered = 0;
			cb12.cannonsEntered = 0;
			cb13.cannonsEntered = 0;
		}
		
		private function addRadioButtons() {
			AutoMovesRadio.x = 53.35;
			AutoMovesRadio.y = 37.85;
			LeftsRadio.x = 81.85;
			LeftsRadio.y = 39.85;
			ForwardsRadio.x = 114.15;
			ForwardsRadio.y = 39.85;
			RightsRadio.x = 146.00;
			RightsRadio.y = 39.85;
			
			addChild(AutoMovesRadio);
			addChild(LeftsRadio);
			addChild(ForwardsRadio);
			addChild(RightsRadio);
			
			AutoMovesRadio.setState(1);
			LeftsRadio.setState(0);
			ForwardsRadio.setState(1);
			RightsRadio.setState(0);
			
			AutoMovesRadio.addEventListener(MouseEvent.CLICK,autoMovesToggle);
			LeftsRadio.addEventListener(MouseEvent.CLICK,setGeneration);
			ForwardsRadio.addEventListener(MouseEvent.CLICK,setGeneration);
			RightsRadio.addEventListener(MouseEvent.CLICK,setGeneration);
		}
		
		private function autoMovesToggle(evt:Event) {			
			AutoMovesRadio.toggleButton();
			dispatchEvent(new BubbledEvent(BubbledEvent.AUTO_MOVES_TOGGLE, evt));
		}
		
		private function setGeneration(evt:Event) {
			LeftsRadio.setState(0);
			ForwardsRadio.setState(0);
			RightsRadio.setState(0);
		
			dispatchEvent(new BubbledEvent(BubbledEvent.SET_GENERATION, evt));
		}
		
		
	}

}