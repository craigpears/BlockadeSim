package game.accessPoints
{
	
	import com.whirled.game.GameControl;
	import game.Ship;
	import game.data.MapList;
	import game.logic.Flag;
	import game.Ship;
	import flash.utils.Timer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class GameInformationAbstract
	{		
		protected var _delayTurnsRemaining:int = 0;
		protected var _sunkShips:Array = new Array();//Keeps track of the ships sunk in the turn so that they don't influence points
		protected var _turnTimer:Timer;
		
		protected var _shipsTable:Array = new Array();
		protected var _flagsArray:Array = new Array();
		protected var _mySeat:int;
		protected var _board:Array;
		protected var _boardTiles:Array;		
		protected var _sinkDelay:int;
		protected var _friendlyFire:Boolean;
		protected var _mapName:String = "";
		protected var _endOfGame:Boolean = false;
		protected var _finalCollisionMechanicsShipInformation = new Object();
		
		public function GameInformationAbstract() { }
		
		public function get finalCollisionMechanicsShipInformation():Object
		{
			return _finalCollisionMechanicsShipInformation;
		}
		
		public function set finalCollisionMechanicsShipInformation(value:Object):void
		{
			_finalCollisionMechanicsShipInformation = value;
		}
		
		public function initialiseForTesting():void
		{
			_sinkDelay = 0;
			_friendlyFire = true;
			_mapName = "Lilac1_1";
			_mySeat = 0;
		}
		
		public function get map():String {
			return _mapName;
		} 
		
		public function get shipsTable():Array 
		{
			return _shipsTable;
		}
		
		public function set shipsTable(value:Array):void 
		{
			_shipsTable = value;
		}
		
		public function get flagsArray():Array 
		{
			return _flagsArray;
		}
		
		public function get mySeat():int 
		{
			return _mySeat;
		}
		
		public function get board():Array 
		{
			return _board;
		}
		
		public function set board(value:Array):void 
		{
			_board = value;
		}
		
		public function get boardTiles():Array 
		{
			return _boardTiles;
		}
		
		public function set boardTiles(value:Array):void 
		{
			_boardTiles = value;
		}
		
		public function get sinkDelay():int 
		{
			return _sinkDelay;
		}
		
		public function get friendlyFire():Boolean 
		{
			return _friendlyFire;
		}
		
		public function get mapName():String 
		{
			if (_mapName == "") {
				throw Error("mapName being accessed without being set");
			}
			return _mapName;
		}
		
		public function set mapName(value:String):void 
		{
			_mapName = value;
		}
		
		public function get myShip():Ship
		{
			return _shipsTable[_mySeat];
		}
				
		public function get numberOfShips():int
		{
			return shipsTable.length;
		}
		
		public function get endOfGame():Boolean 
		{
			return _endOfGame;
		}
		
		public function set endOfGame(value:Boolean):void 
		{
			_endOfGame = value;
		}
		
		public function get delayTurnsRemaining():int 
		{
			return _delayTurnsRemaining;
		}
		
		public function set delayTurnsRemaining(value:int):void 
		{
			_delayTurnsRemaining = value;
		}
		
		public function get sunkShips():Array 
		{
			return _sunkShips;
		}
		
		public function set sunkShips(value:Array):void 
		{
			_sunkShips = value;
		}
		
		public function get turnTimer():Timer 
		{
			return _turnTimer;
		}
		
		public function set turnTimer(value:Timer):void 
		{
			_turnTimer = value;
		}
		
		public function endGame():void
		{
			
			var teamOne:Array = this.getTeamsTable(1);
			var teamTwo:Array = this.getTeamsTable(2);
			var winningTeam:Array, losingTeam:Array;
			if(GameGUI.moveInput.winningTeam == 1)
			{
				winningTeam = teamOne;
				losingTeam = teamTwo;
				if(amInControl())
				systemMessage("Team one won!");
			}
			else if(GameGUI.moveInput.winningTeam == 2)
			{					
				winningTeam = teamTwo;
				losingTeam = teamOne;
				if(this.amInControl())
				this.systemMessage("Team two won!");				
			}
			_endOfGame = false;
			
			endGameWithWinners(winningTeam, losingTeam);
		}
		
		public function addFlag(flag:Flag):void
		{
			flagsArray.push(flag);
		}
		
		public function getTeamsTable(teamNo:int):Array
		{
			throw Error("This function needs implementing");
			return null;
		}
		
		public function endGameWithWinners(winningTeam:Array, losingTeam:Array):void
		{
			throw Error("This function needs implementing");
		}
		
		public function amInControl():Boolean
		{
			throw Error("This function needs implementing");
			return false;
		}
		
		public function systemMessage(msg:String):void
		{
			throw Error("This function needs implementing");
		}
		
		public function getMapArray(mapName:String = null):Array
		{	
			var mapList:MapList = new MapList();
			if (mapName == null) {
				mapName = _mapName;
			}
			return mapList.getMap(mapName);
		}
		
		public function updateFlags():void
		{
			// Updates the flags based on the data in the flags array
			for (var flagNo:String in flagsArray) {
				var flag:Flag = flagsArray[flagNo];
				var flagMC:TileMC = boardTiles[flag.xBoardPos][flag.yBoardPos];
				
				// Get the information from the flag on what flags are influencing it
				if (flag.influence == Flag.NONE) {
					flagMC.flag.gotoAndStop(1);
				} else if (flag.influence == Flag.TEAM_ONE) {
					flagMC.flag.gotoAndStop(2);
				} else if (flag.influence == Flag.TEAM_TWO) {
					flagMC.flag.gotoAndStop(3);
				} else if (flag.influence == Flag.BOTH_TEAMS) {
					flagMC.flag.gotoAndStop(4);
				}
			}

		}
		
		public function setMovesBar(player:int, pos:int):void
		{
			shipsTable[player].movesBar.gotoAndStop(pos);
		}
		
		public function spawnShip(playerNo:int, xRealPos:int, yRealPos:int):void
		{
			//Make sure it isn't ontop of another ship
			var collision = false;
			do
			{
				for(var shipNo:String in shipsTable)
				{
					if(int(shipNo) != playerNo && shipsTable[shipNo].yRealPos == yRealPos && shipsTable[shipNo].xRealPos == xRealPos)
					{
						yRealPos += 40;
						if(yRealPos == 820)
						yRealPos = 60;
						
						collision = true;
					}
				}
			}while(collision)
			
			shipsTable[playerNo].yRealPos = yRealPos;
			shipsTable[playerNo].xRealPos = xRealPos;
			if(xRealPos == 60)// Island side
			{
				shipsTable[playerNo].rot = 90;
				shipsTable[playerNo].shipImages.gotoAndStop(2);
			}
			else // Ocean side
			{
				shipsTable[playerNo].rot = 270;
				shipsTable[playerNo].shipImages.gotoAndStop(10);
			}
			
		}
		
		public function clearCannonArrays():void
		{
			for(var i:int = 0; i < this.numberOfShips; i++)
			shipsTable[i].clearCannonArray();
		}
		
		public function animate(player:int, moveType:int, collision:int = 0, actingRotation:int = -1):void
		{			
			//An acting rotation of -1 causes the acting rotation to be assigned the ships rotation
			switch(moveType)
			{
				case constants.LEFT:
					shipsTable[player].leftAnimation(collision, actingRotation);
					break;
				case constants.FORWARD:
					shipsTable[player].forwardAnimation(collision, actingRotation);
					break;
				case constants.RIGHT:
					shipsTable[player].rightAnimation(collision, actingRotation);
					break;
				case constants.DELAYED_FORWARD:
					shipsTable[player].delayedForwardAnimation(actingRotation);
					break;
			}
		}
		
		public function fireCannons(player:int, side:int, numberFired:int, turnsUntilCollision:int):void
		{
			shipsTable[player].cannonAnimation(side, numberFired, turnsUntilCollision);
		}
				
		
		// ==================================================================================================
		// This code allows the singleton class to use events
		// ==================================================================================================
		
		protected var dispatcher:EventDispatcher = new EventDispatcher();
		
		public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
        }
        public function dispatchEvent(event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }
        public function hasEventListener(type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }
		
	}
}
