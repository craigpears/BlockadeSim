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
	public class GameInformationWhirled extends GameInformationAbstract implements IGameInformationAbstractImplementation
	{
		protected var _control:GameControl;
		
		public function GameInformationWhirled(control:GameControl ) 
		{
			_control = control;			
			_mySeat = _control.game.seating.getMyPosition();
			//Set up tables
			//TODO: shouldn't this be server-side code?
			_control.net.set(constants.MOVES_TABLE,new Array(_control.game.seating.getPlayerIds().length),true);
			_control.net.set(constants.DAMAGE_TABLE, new Array(_control.game.seating.getPlayerIds().length), true);
			
			// Set the sink delay variable
			var config:Object = _control.game.getConfig();			
			_sinkDelay = config.SinkDelay;
			_friendlyFire = config.friendlyFire;
			_mapName = config.map;
		}
		
		public function getPlayerPosition(id:int):int {
			return _control.game.seating.getPlayerPosition(id);
		}
		
		public function getPlayerIds():Object {
			return _control.game.seating.getPlayerIds();
		}
		
		public function get TurnTime():int {
			var config :Object = _control.game.getConfig();
			return config.TurnTime;
		}
		
		public function sendMessage(messageType:String, obj:Object = null, playerId:int = NetSubControl.TO_ALL):void
		{
			_control.net.sendMessage(messageType, obj, playerId);
		}
		
		public override function getTeamsTable(teamNo:int):Array
		{
			if (teamNo == 1) {
				return Array(_control.net.get(constants.TEAM1_TABLE));
			} else if (teamNo == 2){
				return Array(_control.net.get(constants.TEAM2_TABLE));
			}
			throw Error("Invalid teamNo provided");
			return null;
		}
				
		public function log(msg:String):void
		{
			_control.local.feedback(msg);
		}
		
		public override function systemMessage(msg:String):void
		{
			_control.game.systemMessage(msg);
		}
		
		public override function amInControl():Boolean
		{
			return _control.game.amInControl();
		}
						
		public override function endGameWithWinners(winningTeam:Array, losingTeam:Array):void
		{
			_control.game.endGameWithWinners(winningTeam, losingTeam, 1);
		}
		
		// Functions used in the setup process
		public function get spectatorTable():Object {
			return _control.net.get(constants.SPECTATOR_TABLE);
		}
		
		public function set spectatorTable(value:Object):void {
			_control.net.set(constants.SPECTATOR_TABLE, value);
		}
		
		public function get teamOneTable():Object {
			return _control.net.get(constants.TEAM1_TABLE);
		}
		
		public function set teamOneTable(value:Object):void {
			_control.net.set(constants.TEAM1_TABLE, value);
		}
		
		public function get teamTwoTable():Object {
			return _control.net.get(constants.TEAM2_TABLE);
		}
		
		public function set teamTwoTable(value:Object):void {
			_control.net.set(constants.TEAM2_TABLE, value);
		}
		
		public function get teamsTable():Object {
			return _control.net.get(constants.TEAMS_TABLE);
		}
		
		public function set teamsTable(value:Object):void {
			_control.net.set(constants.TEAMS_TABLE, value);
		}
		
		public function get shipTypeTable():Object {
			return _control.net.get(constants.SHIP_TYPE_TABLE);
		}
		
		public function set shipTypeTable(value:Object):void {
			_control.net.set(constants.SHIP_TYPE_TABLE, value);
		}
		
		public function get jobberLevelTable():Object {
			return _control.net.get(constants.JOBBER_LEVEL_TABLE);
		}
		
		public function set jobberLevelTable(value:Object):void {
			_control.net.set(constants.JOBBER_LEVEL_TABLE, value);
		}
		
		public function get readyStateTable():Object {
			return _control.net.get(constants.READY_STATE_TABLE);
		}
		
		public function set readyStateTable(value:Object):void {
			_control.net.set(constants.READY_STATE_TABLE, value);
		}
		
		public function get shipPositions():Object {
			return _control.net.get(constants.SHIP_POSITIONS);
		}
		
		public function set shipPositions(value:Object):void {
			_control.net.set(constants.SHIP_POSITIONS, value);
		}
		
		public override function  addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void 
		{
            // Check if the event listener needs to be added to _control
			if (type == MessageReceivedEvent.MESSAGE_RECEIVED || 
				type == PropertyChangedEvent.PROPERTY_CHANGED ||
				type == ElementChangedEvent.ELEMENT_CHANGED) 
			{
				_control.net.addEventListener(type, listener, useCapture, priority, useWeakReference);
			} 
			else if (type == OccupantChangedEvent.OCCUPANT_LEFT ||
					 type == OccupantChangedEvent.OCCUPANT_ENTERED ||
					 type == StateChangedEvent.GAME_STARTED) 
			{
				_control.game.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
			else 
			{
				dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
			}
        }
        public override function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
			// Check if the event listener needs to be removed from _control
			if (type == MessageReceivedEvent.MESSAGE_RECEIVED || 
				type == PropertyChangedEvent.PROPERTY_CHANGED ||
				type == ElementChangedEvent.ELEMENT_CHANGED) 
			{
				_control.net.removeEventListener(type, listener, useCapture);
			} 
			else if (type == OccupantChangedEvent.OCCUPANT_LEFT ||
					 type == OccupantChangedEvent.OCCUPANT_ENTERED ||
					 type == StateChangedEvent.GAME_STARTED) 
			{
				_control.game.removeEventListener(type, listener, useCapture);
			}
			else 
			{
				dispatcher.removeEventListener(type, listener, useCapture);
			}
        }
		
		public function get myId():int { 
			return _control.game.getMyId();
		}	
		
		public function getOccupantName(playerId:int):String {
			return _control.game.getOccupantName(playerId); 
		} 
		
		
		public function set damageTable(value:Object):void {
			_control.net.set(constants.DAMAGE_TABLE, value, true); 
		}
		
		public function get damageTable():Object {
			return _control.net.get(constants.DAMAGE_TABLE); 
		} 
			
		public function get myPosition():int { 
			return _control.game.seating.getMyPosition();
		} 
		
		public function setAt(property:String, seatNo:int, value:Object):void {
			_control.net.setAt(property, seatNo, value); 
		}
		
		public function get movesTable():Object {
			return _control.net.get(constants.MOVES_TABLE);
		} 
		
		public function set movesTable(value:Object):void { 
			_control.net.set(constants.MOVES_TABLE, value);
		}
		
		public function get playerNames():Object {
			return _control.game.seating.getPlayerNames();
		} 
		
		public function getMyPosition():int { 
			return _control.game.seating.getMyPosition(); 
		}
		
	}

}