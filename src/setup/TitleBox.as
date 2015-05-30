package setup
{
	
	import flash.text.*;
	import flash.display.*;
	import flash.display.Graphics;

	
	public class TitleBox extends Sprite
	{
		protected var txtField:TextField;
		protected var g:Graphics;
		protected var format:TextFormat;
		protected var _joinButton:JoinButtonMC;
		
		public function TitleBox(arg:String):void
		{
			switch(arg)
			{
				case "Spectators":
					addChild(new SpectatorsMC());
					break;
				case "Team One":
					addChild(new TeamOneMC());
					break;
				case "Team Two":
					addChild(new TeamTwoMC());
					break;
			}
			
			_joinButton = new JoinButtonMC();
			_joinButton.x = 580;
			addChild(_joinButton);
			

		}
		
		public function get joinButton(){ return _joinButton;}
	}
}