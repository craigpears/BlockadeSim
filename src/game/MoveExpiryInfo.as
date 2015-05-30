package game{
	
	import flash.display.MovieClip;
	
	public class MoveExpiryInfo extends MoveExpiryInfoMC
	{
		public function MoveExpiryInfo(colour:uint,txt:String)
		{
			this.info.text = txt;
			this.gotoAndStop(colour + 1);
		}
		
	}
}