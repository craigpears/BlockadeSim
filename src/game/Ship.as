package game{
	
	
	import constants;
	
	/**
	 * This class contains all of the functions related to the logic for a ship
	 * @author Craig Pears
	 */
	public class Ship extends ShipGUI
	{
		//Damage is in terms of small cannonballs
		protected var _maxDamage:int;
		
		public function Ship(shipType:String,team:uint,playerNameText:String)
		{
			super(shipType, team, playerNameText);
			// Determine the max damage and class based on the ship type
			switch(shipType)
			{
				case "Sloop": 
					this._maxDamage = constants.SLOOP_MAX_DAMAGE;
					break;
				case "Brig":
					this._maxDamage = constants.BRIG_MAX_DAMAGE;
					break;
				case "Frig":
					this._maxDamage = constants.FRIG_MAX_DAMAGE;
					break;
			}			
		}
		
		public function get maxDamage() { 
			return this._maxDamage;
		}
		

	}	
}