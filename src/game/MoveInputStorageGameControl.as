package game 
{
	import constants;
	import game.accessPoints.GameInformation;
	
	public class MoveInputStorageGameControl implements MoveInputStorageInterface
	{		
		protected var mySeat:uint;
		protected var points:Array = new Array(0,0);
		
		public function MoveInputStorageGameControl():void 
		{
			mySeat = GameInformation.getMyPosition();			
		}
		
		public function setMyMoves(myMoves:Array):void
		{
			GameInformation.setAt(constants.MOVES_TABLE,mySeat,myMoves);
		}
		
		public function setMyDamage(myDamage:Number):void
		{
			GameInformation.setAt(constants.DAMAGE_TABLE,mySeat,myDamage);
		}
		
		public function addPoints(values:Array):void
		{
			points[0] += values[0];
			points[1] += values[1];
		}
		
		public function getMyShipType():String
		{
			return GameInformation.shipTypeTable[mySeat];
		}
		
		public function getMyJobberLevel():String
		{
			return GameInformation.jobberLevelTable[mySeat];
		}
		
		public function getMyDamage():Number
		{
			return GameInformation.damageTable[mySeat];
		}
		
		public function log(msg:String):void
		{
			GameInformation.log(msg);
		}
		
		public function getPoints(team:uint):uint
		{
			return points[team-1];
		}
		
		public function getTurnTime():int
		{
			return GameInformation.TurnTime;
		}
		
		public function sendDamageMessage(obj:Object):void
		{
			GameInformation.sendMessage(constants.DAMAGE_TABLE,obj);
		}
	}
}
