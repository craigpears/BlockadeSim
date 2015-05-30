package game.accessPoints 
{
	import com.whirled.game.GameControl;
	import com.whirled.game.StateChangedEvent;	
	import com.whirled.net.MessageReceivedEvent; 
	import com.whirled.net.PropertyChangedEvent;
	import com.whirled.game.OccupantChangedEvent;	
	import com.whirled.net.ElementChangedEvent;
	import com.whirled.game.NetSubControl;
	
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class GameInformationLocal extends GameInformationAbstract implements IGameInformationAbstractImplementation
	{
		
		protected var _movesTable:Array = new Array();
		protected var _damageTable:Array = new Array();
		protected var _playerIds:Array = new Array();
		protected var _playerNames:Array = new Array();
		protected var _turnTime:int = 15;
		protected var _teamTables:Array = new Array();
		protected var _setupTables:Array = new Array();
		protected var _gameTables:Array = new Array();
		
		public function GameInformationLocal() 
		{		
			_mySeat = 0;
			
			// Push the player information into the arrays
			_playerIds.push(0);
			_playerNames.push('Player');
			
			_teamTables['Spectators'] = new Array();
			_teamTables['TeamOne'] = new Array();
			_teamTables['TeamTwo'] = new Array();
			_teamTables['Teams'] = new Array();
			
			_gameTables['ShipPositions'] = new Array();
			
			_setupTables['ShipTypes'] = new Array();
			_setupTables['JobberLevels'] = new Array();
			_setupTables['ReadyStates'] = new Array();
			
			// Set the default settings
			_sinkDelay = 2;
			_friendlyFire = true;
			_mapName = "Lilac1_1";
		}
		
		public function getPlayerPosition(id:int):int {
			// For the local version, player position is the same as their id
			return id;
		}
		
		public function getPlayerIds():Object {
			return _playerIds;
		}
		
		public function get TurnTime():int {
			return _turnTime;
		}
		
		public function sendMessage(messageType:String, obj:Object = null, playerId:int = NetSubControl.TO_ALL):void
		{
			if (playerId == NetSubControl.TO_ALL || playerId == mySeat) {
				var evt = new MessageReceivedEvent(messageType, obj, mySeat);
				dispatcher.dispatchEvent(evt);
			}
			
			// Handle the messages that would normally go to the server
			if(messageType == constants.DISENGAGE_REQUEST)
			{			
				var information:Object = new Object();
				information.player = getPlayerPosition(mySeat);
				information.newPos = obj.newYPos;
				var evt = new MessageReceivedEvent(constants.DISENGAGE, information, mySeat);
				dispatcher.dispatchEvent(evt);
			}
			else if(messageType == constants.TIME_UP)
			{
				//Send a message telling everyone that the turn is up
				var evt = new MessageReceivedEvent(constants.PERFORM_ANIMATION, null, mySeat);
				dispatcher.dispatchEvent(evt);
			}
			
			
		}
		
		public override function getTeamsTable(teamNo:int):Array
		{
			if (teamNo == 1) {
				return _teamTables['TeamOne'];
			} else if (teamNo == 2){
				return _teamTables['TeamTwo'];
			}
			throw Error("Invalid teamNo provided");
			return null;
		}
				
		public function log(msg:String):void
		{
			trace(msg);
		}
		
		public override function systemMessage(msg:String):void
		{
			trace(msg);
		}
		
		public override function amInControl():Boolean
		{
			return true;
		}
						
		public override function endGameWithWinners(winningTeam:Array, losingTeam:Array):void
		{
			// Nothing needs to be done
		}
		
		// Functions used in the setup process
		public function get spectatorTable():Object {
			return _teamTables['Spectators'];
		}
		
		public function set spectatorTable(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.SPECTATOR_TABLE, value, _teamTables['Spectators']);
			_teamTables['Spectators'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get teamOneTable():Object {
			return _teamTables['TeamOne'];
		}
		
		public function set teamOneTable(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.TEAM1_TABLE, value, _teamTables['TeamOne']);
			_teamTables['TeamOne'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get teamTwoTable():Object {
			return _teamTables['TeamTwo'];
		}
		
		public function set teamTwoTable(value:Object):void {			
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.TEAM2_TABLE, value, _teamTables['TeamTwo']);
			_teamTables['TeamTwo'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get teamsTable():Object {
			return _teamTables['Teams'];
		}
		
		public function set teamsTable(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.TEAMS_TABLE, value, _teamTables['Teams']);
			_teamTables['Teams'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get shipTypeTable():Object {
			return _setupTables['ShipTypes'];
		}
		
		public function set shipTypeTable(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.SHIP_TYPE_TABLE, value, _setupTables['ShipTypes']);
			_setupTables['ShipTypes'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get jobberLevelTable():Object {
			return _setupTables['JobberLevels'];
		}
		
		public function set jobberLevelTable(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.JOBBER_LEVEL_TABLE, value, _setupTables['JobberLevels']);
			_setupTables['JobberLevels'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get readyStateTable():Object {
			return _setupTables['ReadyStates'];
		}
		
		public function set readyStateTable(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.READY_STATE_TABLE, value, _teamTables['ReadyStates']);
			_setupTables['ReadyStates'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get shipPositions():Object {
			return _gameTables['ShipPositions'];
		}
		
		public function set shipPositions(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.SHIP_POSITIONS, value, _gameTables['ShipPositions']);
			_gameTables['ShipPositions'] = value;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get myId():int { 
			return 0;
		}	
		
		public function getOccupantName(playerId:int):String {
			return _playerNames[playerId];
		} 
		
		public function set damageTable(value:Object):void {
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.DAMAGE_TABLE, value as Array, _damageTable);
			_damageTable = value as Array;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get damageTable():Object {
			return _damageTable;
		} 
			
		public function get myPosition():int { 
			return _mySeat;
		} 
		
		public function setAt(property:String, seatNo:int, value:Object):void {
			if (property == constants.MOVES_TABLE) {				
				var evt = new ElementChangedEvent(ElementChangedEvent.ELEMENT_CHANGED, constants.MOVES_TABLE, value, _movesTable[seatNo], seatNo);
				_movesTable[seatNo] = value;
				dispatcher.dispatchEvent(evt);
			} else if (property == constants.DAMAGE_TABLE) {
				var evt = new ElementChangedEvent(ElementChangedEvent.ELEMENT_CHANGED, constants.DAMAGE_TABLE, value, _damageTable[seatNo], seatNo);
				_damageTable[seatNo] = value;
				dispatcher.dispatchEvent(evt);
			}
		}
		
		public function get movesTable():Object {
			return _movesTable;
		} 
		
		public function set movesTable(value:Object):void { 
			var evt = new PropertyChangedEvent(PropertyChangedEvent.PROPERTY_CHANGED, constants.MOVES_TABLE, value as Array, _movesTable);
			_movesTable = value as Array;
			dispatcher.dispatchEvent(evt);
		}
		
		public function get playerNames():Object {
			return _playerNames;
		} 
		
		public function getMyPosition():int { 
			return _mySeat; 
		}
		
	}

}