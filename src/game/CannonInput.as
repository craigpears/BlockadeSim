package game
{
	import flash.display.MovieClip;
	
	public class CannonInput extends CannonInputMC
	{
		
		protected var _cannonsEntered:uint = 0;
		protected var _side:uint;
		protected var _number:uint;
		
		public function CannonInput()
		{
			this.gotoAndStop(1);
		}
		
		public function setType(side,number)
		{
			//Type is 0 or 1 depending on if it is on the left or the right - images will be different
			_side = side;
			_number = number;
		}
		public function set cannonsEntered(i)
		{
			this.gotoAndStop(i+1);
			if(side==1 && i==1)
			this.gotoAndStop(4);
			_cannonsEntered = i;
		}
		public function get cannonsEntered(){return _cannonsEntered;}
		public function get side(){ return _side;}
		public function get number(){ return _number;}
		
	}
}