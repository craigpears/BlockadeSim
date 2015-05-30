package game{
	import flash.display.MovieClip;
	
	public class AutomovesCheckbox extends AutomovesCheckboxMC
	{
		
		protected var currentState:uint=0;
		public function AutomovesCheckbox()
		{
			this.gotoAndStop(currentState+1);
		}
		public function toggleButton()
		{
			currentState++;
			currentState%=2;
			this.gotoAndStop(currentState+1);
		}
		public function setState(newState)
		{
			currentState = newState;
			this.gotoAndStop(currentState+1);
		}		
	}
	
}