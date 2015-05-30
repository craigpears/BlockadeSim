package game.logic 
{
	
	/**
	 * ...
	 * @author Craig Pears
	 */
	public interface CollisionMechanicsStorageInterface 
	{
		function getMovesTable():Object;
		function getDamageTable():Object;
		function updateDamageTable(damageTable:Object):void;
		function getTeamsTable():Object;
		function registerCBHit(information:Object):void;
		function getFriendlyFire():Boolean;
		function getNumberOfShips():int;
		function setFinalShipInformation(finalShipInformation:Object):void;
		function getFinalShipInformation():Object;
		
	}
	
}