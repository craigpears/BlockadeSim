package game.logic 
{
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class CollisionMechanicsStorageLocal implements CollisionMechanicsStorageInterface 
	{
		
		protected var movesTable:Array;
		protected var finalShipInformation:Object;
		
		public function CollisionMechanicsStorageLocal() 
		{
			
		}
		
		public function getMovesTable():Object 
		{
			return movesTable;
		}
		
		public function setMovesTable(_movesTable:Array):void
		{
			movesTable = _movesTable;
		}
		
		public function getDamageTable():Object 
		{
			return new Array(0,0,0);
		}
		
		public function updateDamageTable(damageTable:Object):void 
		{
			// No need to do this for tests
		}
		
		public function getTeamsTable():Object 
		{
			var teamsArray:Array = new Array(1,1,1);
			return teamsArray;
		}
		
		public function registerCBHit(information:Object):void 
		{
			// No need to do this for tests
		}
		
		public function getFriendlyFire():Boolean
		{
			return true;
		}
		
		public function getNumberOfShips():int
		{
			return 3;
		}
		
		public function setFinalShipInformation(shipInformation:Object):void
		{
			finalShipInformation = shipInformation;
		}
		
		public function getFinalShipInformation():Object
		{
			return finalShipInformation;
		}
	}

}