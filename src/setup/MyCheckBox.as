package setup
{
	import flash.display.*
	
	public class MyCheckBox extends MyCheckBoxMC
	{
		
		protected var _ticked:Boolean;
		
		public function MyCheckBox()
		{
			_ticked = false;
			this.gotoAndStop(1);
		}
		
		public function get ticked()
		{
			return _ticked;
		}
		
		public function toggleState()
		{
			_ticked = !_ticked;
			if(_ticked)
			{
				this.gotoAndStop(2);
			}
			else
			{
				this.gotoAndStop(1);
			}
		}
	}
}