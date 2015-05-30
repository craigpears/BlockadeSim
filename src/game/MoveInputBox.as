package game{
	
	public class MoveInputBox extends MoveInputBoxMC
	{
		
		public var _name = '';
		
		public function MoveInputBox(name:String)
		{
			_name = name;
			this.gotoAndStop(1);
		}
		
		public function setToken(token:uint)
		{						
			gotoAndStop(token+1);
		}
	}
}