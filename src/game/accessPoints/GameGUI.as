package game.accessPoints 
{
	import game.MoveInput;
	/**
	 * This class contains all of the GUI elements
	 * @author Craig Pears
	 */
	public class GameGUI 
	{
		public static var moveInput:MoveInput;
		
		public function GameGUI() 
		{
			throw Error("GameGUI is a singleton class that should not be instantiated");
		}
	}

}