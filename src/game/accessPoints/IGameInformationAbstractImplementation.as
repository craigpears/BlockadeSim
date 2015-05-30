package game.accessPoints 
{
	import flash.events.Event;
	import flash.utils.Timer;
	import game.logic.Flag;
	import game.Ship;
	import com.whirled.game.NetSubControl;
	
	/**
	 * ...
	 * @author Craig Pears
	 */
	public interface IGameInformationAbstractImplementation 
	{		
		// Functions that need implementing
		function sendMessage(messageType:String, obj:Object = null, playerId:int = NetSubControl.TO_ALL):void;	
		function getTeamsTable(teamNo:int):Array;				
		function log(msg:String):void;		
		function systemMessage(msg:String):void;
		function amInControl():Boolean;
		function endGameWithWinners(winningTeam:Array, losingTeam:Array):void;
		function get shipPositions():Object;
		function set shipPositions(value:Object):void;
		function get teamsTable():Object;		
		function set teamsTable(value:Object):void;
		function get myId():int;
		function getOccupantName(playerId:int):String;
		function get map():String;
		function set damageTable(value:Object):void;
		function get damageTable():Object;
		function get myPosition():int;
		function setAt(property:String, seatNo:int, value:Object):void;
		function get movesTable():Object;
		function set movesTable(value:Object):void;
		function get playerNames():Object;
		function getMyPosition():int;
		
		
		// Functions that need implementing, used in the setup process
		function getPlayerPosition(id:int):int;
		function getPlayerIds():Object;
		function get TurnTime():int;
		function get spectatorTable():Object;
		function set spectatorTable(value:Object):void;
		function get teamOneTable():Object;
		function set teamOneTable(value:Object):void;
		function get teamTwoTable():Object;
		function set teamTwoTable(value:Object):void;
		function get shipTypeTable():Object;
		function set shipTypeTable(value:Object):void;
		function get jobberLevelTable():Object;
		function set jobberLevelTable(value:Object):void;
		function get readyStateTable():Object;
		function set readyStateTable(value:Object):void;

		
		// Functions implemented in the Abstract class
		function get finalCollisionMechanicsShipInformation():Object;
		function set finalCollisionMechanicsShipInformation(value:Object):void;
		function get shipsTable():Array;
		function set shipsTable(value:Array):void;
		function get flagsArray():Array;
		function get mySeat():int;		
		function get board():Array;		
		function set board(value:Array):void;	
		function get boardTiles():Array;	
		function set boardTiles(value:Array):void;	
		function get sinkDelay():int;	
		function get friendlyFire():Boolean;	
		function get mapName():String;		
		function set mapName(value:String):void;		
		function get myShip():Ship;			
		function get numberOfShips():int;	
		function get endOfGame():Boolean;	
		function set endOfGame(value:Boolean):void;	
		function get sunkShips():Array;	
		function set sunkShips(value:Array):void;		
		function get delayTurnsRemaining():int;	
		function set delayTurnsRemaining(value:int):void;		
		function get turnTimer():Timer;	
		function set turnTimer(value:Timer):void;
		function endGame():void;	
		function addFlag(flag:Flag):void;	
		function getMapArray(mapName:String = null):Array;
		function updateFlags():void;	
		function setMovesBar(player:int, pos:int):void;		
		function spawnShip(playerNo:int, xRealPos:int, yRealPos:int):void;	
		function clearCannonArrays():void;
		function animate(player:int, moveType:int, collision:int = 0, actingRotation:int = -1):void;
		function fireCannons(player:int, side:int, numberFired:int, turnsUntilCollision:int):void;
		
		// Make sure that it can use events
		function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void;
        function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void;
        function dispatchEvent(event:Event):Boolean;
        function hasEventListener(type:String):Boolean;
	}
	
}