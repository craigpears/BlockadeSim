package game 
{	
	public interface MoveInputStorageInterface {
		function setMyMoves(myMoves:Array):void;
		function setMyDamage(myDamage:Number):void;
		function addPoints(values:Array):void;
		function getMyShipType():String;
		function getMyJobberLevel():String;
		function getMyDamage():Number;
		function getPoints(team:uint):uint;
		function getTurnTime():int;
		function log(msg:String):void;
		function sendDamageMessage(obj:Object):void;
	}	
}
