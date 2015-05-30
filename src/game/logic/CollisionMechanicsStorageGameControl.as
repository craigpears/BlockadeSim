package game.logic 
{
	import game.accessPoints.GameInformation;
	
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class CollisionMechanicsStorageGameControl implements CollisionMechanicsStorageInterface
	{
		public function CollisionMechanicsStorageGameControl():void
		{
		}
		
		public function getMovesTable():Object
		{
			return GameInformation.movesTable;;
		}
		
		public function getDamageTable():Object
		{
			return GameInformation.damageTable;
		}
		
		public function updateDamageTable(damageTable:Object):void
		{
			GameInformation.damageTable = damageTable;
		}
		
		public function getTeamsTable():Object {
			return GameInformation.teamsTable;
		}
		
		public function registerCBHit(information:Object):void {
			GameInformation.sendMessage(constants.CB_HIT,information);
		}
		
		public function getFriendlyFire():Boolean
		{
			return GameInformation.friendlyFire;
		}
		
		public function getNumberOfShips():int
		{
			return GameInformation.numberOfShips;
		}
		
		public function setFinalShipInformation(shipInformation:Object):void
		{
			// This is currently only for tests, don't need to implement this function
		}
		
		public function getFinalShipInformation():Object
		{
			// This is currently only for tests, don't need to implement this function
			return null;
		}
	}

}