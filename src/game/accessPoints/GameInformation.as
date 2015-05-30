package game.accessPoints
{
	
	import com.whirled.game.GameControl;
	import game.Ship;
	import game.data.MapList;
	import game.logic.Flag;
	import game.Ship;
	import flash.utils.Timer;
	import flash.events.Event;
	import com.whirled.game.NetSubControl;
	
	public class GameInformation
	{				
		protected static var _abstractImplementation:IGameInformationAbstractImplementation;
		
		public function GameInformation() {
			// This class shouldn't ever get instantiated, so throw an error
			throw Error("Game Information is a singleton class and should not be instantiated");
		}
		
		public static function initialise(abstractImplementation:IGameInformationAbstractImplementation):void
		{
			_abstractImplementation = abstractImplementation;
		}
		
		// Pass on all function calls to the abstract implementation
		
		// Functions included in the abstract
		
			// Functions that a player wouldn't need to know about					
			public static function get mapName():String { return _abstractImplementation.mapName;}		
			public static function set mapName(value:String):void { _abstractImplementation.mapName = value;}	
			public static function animate(player:int, moveType:int, collision:int = 0, actingRotation:int = -1):void {			
				_abstractImplementation.animate(player, moveType, collision, actingRotation);
			}		
			public static function fireCannons(player:int, side:int, numberFired:int, turnsUntilCollision:int):void	{
				_abstractImplementation.fireCannons(player, side, numberFired, turnsUntilCollision);
			}
				
			public static function get sunkShips():Array { return _abstractImplementation.sunkShips;}		
			public static function set sunkShips(value:Array):void { _abstractImplementation.sunkShips = value; }
			public static function get turnTimer():Timer { return _abstractImplementation.turnTimer;}		
			public static function set turnTimer(value:Timer):void { _abstractImplementation.turnTimer = value;}
			public static function endGame():void { _abstractImplementation.endGame();}		
			public static function addFlag(flag:Flag):void {flagsArray.push(flag);}	
			public static function updateFlags():void {	_abstractImplementation.updateFlags();}			
			public static function clearCannonArrays():void	{ _abstractImplementation.clearCannonArrays(); }	
			public static function setMovesBar(player:int, pos:int):void {_abstractImplementation.setMovesBar(player, pos);}		
			public static function spawnShip(playerNo:int, xRealPos:int, yRealPos:int):void { _abstractImplementation.spawnShip(playerNo, xRealPos, yRealPos); }
			public static function get endOfGame():Boolean { return _abstractImplementation.endOfGame;}		
			public static function set endOfGame(value:Boolean):void { _abstractImplementation.endOfGame = value; }	
			public static function set delayTurnsRemaining(value:int):void { _abstractImplementation.delayTurnsRemaining = value; }	
			public static function get finalCollisionMechanicsShipInformation():Object { return _abstractImplementation.finalCollisionMechanicsShipInformation; }
			public static function set finalCollisionMechanicsShipInformation(value:Object):void { _abstractImplementation.finalCollisionMechanicsShipInformation = value; }
			
			// Functions that a player might need to use
			public static function get board():Array { return _abstractImplementation.board;}		
			public static function set board(value:Array):void { _abstractImplementation.board = value;}		
			public static function get boardTiles():Array { return _abstractImplementation.boardTiles;}		
			public static function set boardTiles(value:Array):void { _abstractImplementation.boardTiles = value;}		
			public static function get sinkDelay():int { return _abstractImplementation.sinkDelay;}		
			public static function get friendlyFire():Boolean { return _abstractImplementation.friendlyFire;}
			public static function get delayTurnsRemaining():int { return _abstractImplementation.delayTurnsRemaining;}	
			public static function get shipsTable():Array { return _abstractImplementation.shipsTable;}
			public static function set shipsTable(value:Array):void { _abstractImplementation.shipsTable = value;}
			public static function get flagsArray():Array { return _abstractImplementation.flagsArray;}
			public static function get mySeat():int { return _abstractImplementation.mySeat; }	
			public static function get myShip():Ship { return _abstractImplementation.myShip;}				
			public static function get numberOfShips():int { return _abstractImplementation.numberOfShips;}	
			public static function getMapArray(mapName:String = null):Array {return _abstractImplementation.getMapArray();}		
			
		
			// Functions that need implementing
		
			// Functions that a player wouldn't need to know about	
			public static function getPlayerPosition(id:int):int { return _abstractImplementation.getPlayerPosition(id); }
			public static function getPlayerIds():Object { return _abstractImplementation.getPlayerIds(); } 
			public static function amInControl():Boolean { return _abstractImplementation.amInControl();}
			public static function get myId():int { return _abstractImplementation.myId; }
			public static function getOccupantName(playerId:int):String { return _abstractImplementation.getOccupantName(playerId); } 
			public static function get myPosition():int { return _abstractImplementation.myPosition; } 
			public static function get playerNames():Object { return _abstractImplementation.playerNames; } 
			public static function getMyPosition():int { return _abstractImplementation.getMyPosition(); }
			public static function endGameWithWinners(winningTeam:Array, losingTeam:Array):void { _abstractImplementation.endGameWithWinners(winningTeam, losingTeam); }
			public static function set shipPositions(value:Object):void { _abstractImplementation.shipPositions = value; }			
			public static function set teamsTable(value:Object):void { _abstractImplementation.teamsTable = value; }
			public static function set damageTable(value:Object):void { _abstractImplementation.damageTable = value; }			
			public static function get map():String { return _abstractImplementation.map; } 			
			public static function get readyStateTable():Object { return _abstractImplementation.readyStateTable; }
			public static function set readyStateTable(value:Object):void { _abstractImplementation.readyStateTable = value; }	
			public static function set movesTable(value:Object):void { _abstractImplementation.movesTable = value; }
			public static function get spectatorTable():Object{ return _abstractImplementation.spectatorTable}
			public static function set spectatorTable(value:Object):void { _abstractImplementation.spectatorTable = value; }
			public static function get teamOneTable():Object { return _abstractImplementation.teamOneTable; }
			public static function set teamOneTable(value:Object):void { _abstractImplementation.teamOneTable = value; }
			public static function get teamTwoTable():Object { return _abstractImplementation.teamTwoTable; }
			public static function set teamTwoTable(value:Object):void { _abstractImplementation.teamTwoTable = value; }
			public static function set shipTypeTable(value:Object):void { _abstractImplementation.shipTypeTable = value; }
			public static function set jobberLevelTable(value:Object):void { _abstractImplementation.jobberLevelTable = value; }
			
			// Functions that a player might need to use
			public static function get TurnTime():int { return _abstractImplementation.TurnTime; }
			public static function getTeamsTable(teamNo:int):Array { return _abstractImplementation.getTeamsTable(teamNo);}			
			public static function get damageTable():Object { return _abstractImplementation.damageTable; } 
			public static function get teamsTable():Object { return _abstractImplementation.teamsTable; }
			public static function get jobberLevelTable():Object { return _abstractImplementation.jobberLevelTable; }
			public static function sendMessage(messageType:String, obj:Object = null, playerId:int = NetSubControl.TO_ALL):void { _abstractImplementation.sendMessage(messageType, obj, playerId);}	
			public static function log(msg:String):void { _abstractImplementation.log(msg); }		
			public static function systemMessage(msg:String):void { _abstractImplementation.systemMessage(msg);}
			public static function get shipTypeTable():Object { return _abstractImplementation.shipTypeTable; }
			public static function get movesTable():Object { return _abstractImplementation.movesTable; } 
			public static function get shipPositions():Object {	return _abstractImplementation.shipPositions;}	
			public static function setAt(property:String, seatNo:int, value:Object):void { _abstractImplementation.setAt(property, seatNo, value); }
			
			
		
		// ==================================================================================================
		// This code allows the singleton class to use events
		// ==================================================================================================
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            _abstractImplementation.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            _abstractImplementation.removeEventListener(type, listener, useCapture);
        }
        public static function dispatchEvent(event:Event):Boolean {
            return _abstractImplementation.dispatchEvent(event);
        }
        public static function hasEventListener(type:String):Boolean {
            return _abstractImplementation.hasEventListener(type);
        }
		
	}
}
