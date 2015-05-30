package unitTests 
{
	import game.interfaces.MoveInputStorageInterface;
	
	public class MoveInputStorageLocal implements MoveInputStorageInterface
	{		
		protected var points = new Array(0,0);
		protected var _myMoves:Array = new Array();
		protected var _myDamage:Number = 0;
		protected var _shipType:String;
		protected var _jobberLevel:String;
		protected var _turnTime:int;
		
		public function MoveInputStorageLocal(shipType:String, jobberLevel:String, turnTime:int) 
		{			
			_shipType = shipType;
			_jobberLevel = jobberLevel;
			_turnTime = turnTime;
		}
		
		public function setMyMoves(myMoves:Array):void
		{
			_myMoves = myMoves;
		}
		
		public function setMyDamage(myDamage:Number):void
		{
			_myDamage = myDamage;
		}
		
		public function addPoints(values:Array):void
		{
			points[0] += values[0];
			points[1] += values[1];
		}
		
		public function getMyShipType():String
		{
			return _shipType;
		}
		
		public function getMyJobberLevel():String
		{
			return _jobberLevel;
		}
		
		public function getMyDamage():Number
		{
			return _myDamage;
		}
		
		public function log(msg:String):void
		{
			trace(msg);
		}
		
		public function getPoints(team:uint):uint
		{
			return points[team-1];
		}
		
		public function getTurnTime():int
		{
			return _turnTime;
		}
		
		public function sendDamageMessage(obj:Object):void
		{
			//TODO: not yet implemented
		}
	}
}
