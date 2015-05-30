package game{
	import flash.display.MovieClip;
	
	public class MyRadioButton extends MyRadioButtonMC
	{
		
		protected var currentState:uint = 0;
		public var generationMode:int;
		
		public function MyRadioButton(_generationMode):void
		{
			generationMode = _generationMode;
			this.gotoAndStop(currentState+1);
		}
		public function toggleButton():void
		{
			currentState++;
			currentState%=2;
			this.gotoAndStop(currentState+1);
		}
		public function setState(newState:int):void
		{
			currentState = newState;
			this.gotoAndStop(currentState+1);
		}		
	}
	
}