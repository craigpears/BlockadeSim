package game{
	import flash.display.MovieClip;
	
	public class Hourglass extends HourglassMC
	{
		protected var turnTime:uint;
		/*
		top mask starts at: 3
		finishes at: 48
		bottom mask starts at: 90
		finishes at: 48
		*/
		
		public function Hourglass(turnTime:uint)
		{
			this.turnTime = turnTime;
		}
		
		public function set counter(c)
		{
			var percentDone = (turnTime - c) / turnTime * 100;
			topMask.y = 3+(percentDone * 0.45);
			bottomMask.y = 90-(percentDone * 0.42);
		}
	}
}