package game.data
{
	
	import constants;
	
	public class ShipStats
	{		
	
		//Move stats = {Sloop stats, Brig stats, Frig stats}
		//Sloop stats = {Weak stats, normal stats, elite stats}
		
		//Moves per turn
		private static const movesPerTurn:Array = [
				[1.4, 2.5, 3.5],//Sloop
				[1.6,2.3, 2.9],//Brig
				[1.5,2.2,2.8]];//Frig
		
		//Small cannonballs per turn
		private static const repairRate:Array = [
				[0.1,0.15,0.2],
				[0.4,0.6,0.8],
				[1.0,1.6,2.2]];
		
		//Percentage per turn
		private static const bilgeClearRate:Array = [
				[12,16,25],
				[10,18,23],
				[8,15,19]];
				
		private static const cannonsPerTurn:Array = [
				[1,2,3.5],
				[3,6,8],
				[5,8,12]];
				
		private static const maxDamage:Array = [10, 25, 50];
		private static const maxCannons:Array = [4, 16, 24];
		
		public static function getShipStats(jobberLevel:String,shipType:String):Object
		{
			var returnObject:Object = new Object();
			//Convert the words into numbers
			var jobberLevelNumber:int = constants.convertToConstant(jobberLevel);
			var shipTypeNumber:int = constants.convertToConstant(shipType);
			
			returnObject.movesPerTurn = movesPerTurn[shipTypeNumber][jobberLevelNumber];
			returnObject.repairRate = repairRate[shipTypeNumber][jobberLevelNumber];
			returnObject.bilgeClearRate = bilgeClearRate[shipTypeNumber][jobberLevelNumber];
			returnObject.cannonsPerTurn = cannonsPerTurn[shipTypeNumber][jobberLevelNumber];
			returnObject.maxDamage = maxDamage[shipTypeNumber];
			returnObject.maxCannons = maxCannons[shipTypeNumber];
		
			return returnObject;
		}
	}
}