package setup
{
	
	import flash.text.*;
	import flash.display.*;
	import flash.display.Graphics;

	
	public class TextBox extends Sprite
	{
		private var txtField:TextField;
		private var g:Graphics;
		private var format:TextFormat;
		
		public function TextBox(arg:String):void
		{
			if(arg=="Empty")
			this.addChild(new PlayerboxTopMC());
			else
			this.addChild(new PlayerboxMC());
			
			// Text format
			format = new TextFormat();
			format.font = "Verdana";
			format.size = 12;
			format.align = "center";
	 
			// Input field
			txtField = new TextField();
			txtField.defaultTextFormat = format;
			txtField.text = arg;
			txtField.x = 0;
			txtField.y = 0;
			txtField.width = 125;
			txtField.height = 18;
			txtField.type = TextFieldType.DYNAMIC;
			txtField.border = false;
			addChild(txtField);

		}
	}
}