//
// $Id$
//
// The server agent for BlockadeSim - a game for Whirled

package {

	import com.whirled.ServerObject;
	import com.whirled.game.GameControl;
	import com.whirled.net.MessageReceivedEvent;
	import com.whirled.game.NetSubControl;
	
	/**
	 * The server agent for BlockadeSim. Automatically created by the 
	 * whirled server whenever a new game is started. 
	 */
	public class Server extends ServerObject
	{
		
		protected var _control :GameControl;
		protected var _cbHits :Array;
		
		public function Server ()
		{
			_control = new GameControl(this);
			_cbHits = new Array(_control.game.seating.getPlayerIds().length);
			for(var i:int = 0; i < _cbHits.length; i++)
			_cbHits[i]=0;
			_control.net.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceived);
		}
		
		public function messageReceived(evt :MessageReceivedEvent):void
		{
			if(evt.name == constants.CB_HIT)
			{
				//Record this in the array
				_cbHits[evt.value.hitShip]-=evt.value.noCannons;
				_cbHits[evt.value.shootingShip]+=evt.value.noCannons;
			}
			else if(evt.name == constants.MADE_CORRECTION)
			trace("There was an error that had to be corrected" + evt.value.x1 + ", " + evt.value.y1 + " -> " + evt.value.x2 + ", " + evt.value.y2);
			else if(evt.name == constants.END_GAME)
			storeLogs();
			else if(evt.name == constants.DISENGAGE_REQUEST)
			{			
				var information:Object = new Object();
				information.player = _control.game.seating.getPlayerPosition(evt.senderId);
				information.newPos = evt.value.newYPos;
				_control.net.sendMessage(constants.DISENGAGE, information);
			}
			//TODO this event should be replaced by a timer event on the server
			else if(evt.name == constants.TIME_UP)
			{
				//Send a message telling everyone that the turn is up
				_control.net.sendMessage(constants.PERFORM_ANIMATION, null);
			}
		}
		
		protected function storeLogs():void
		{
			trace("game ended with the following hits");
			var playerNames:Array = _control.game.seating.getPlayerNames();
			for(var i:int = 0; i < playerNames.length; i++)
			{
				trace(""+playerNames[i]+": "+_cbHits[i]);
			}
		}
		
	}

}
