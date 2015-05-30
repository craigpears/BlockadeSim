package game 
{
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class ShipFactory 
	{
		
		public function ShipFactory() 
		{
			throw Error("Ship Factory is a singleton class that should not be instantiated");
		}
		
		/**
		 * This function takes a ship and returns a new ship with the same properties as the old
		 * Originally intended to be used in collision mechanics so that things can be modified without
		 * Affecting the GUI
		 * @param	ship
		 */
		public static function copyShip(ship:Ship):Ship
		{
			var playerName = ship.getPlayerName();
			var playerTeam = ship.team;
			var shipType = ship.getShipType();
			
			// Create the shell ship
			var newShip:Ship = new Ship(shipType, playerTeam, shipType);
			
			// Copy over the ship position
			newShip.xBoardPos = ship.xBoardPos;
			newShip.yBoardPos = ship.yBoardPos;
			newShip.rot = ship.rot;
			
			return newShip;
		}
		
	}

}