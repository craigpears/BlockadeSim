package setup
{
	
	import flash.text.*;
	import flash.display.*;
	import flash.display.Graphics;

	
	public class WhiteBox extends Sprite
	{
		private var txtField:TextField;
		private var g:Graphics;
		private var format:TextFormat;
		private var tick:MovieClip;
		
		public function WhiteBox(arg:String, ready:Boolean):void
		{
			
			
			// Text format
			format = new TextFormat();
			format.font = "Verdana";
			format.size = 12;
			format.align = "center";
	 
			// Input field
			txtField = new TextField();
			txtField.defaultTextFormat = format;
			txtField.text = arg;
			txtField.x = 40;
			txtField.y = 5;
			txtField.width = 47;
			txtField.height = 18;
			addChild(txtField);
			
			if(ready)
			{
				tick = new TickMC();
				tick.x = 85;
				addChild(tick);
			}

		}
	}
}