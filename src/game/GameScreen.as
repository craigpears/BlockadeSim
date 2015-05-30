package game
{
	import flash.display.Sprite;
	import com.whirled.net.MessageReceivedEvent; 
	import com.whirled.net.PropertyChangedEvent;
	import com.whirled.net.ElementChangedEvent;
	import com.whirled.game.OccupantChangedEvent;
	import com.whirled.game.NetSubControl;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import flash.events.Event;
	import game.logic.CollisionMechanics;
	import game.logic.CollisionMechanicsStorageGameControl;
	import game.logic.Move;
	import game.accessPoints.GameInformation;
	import game.events.GameEvent;
	import game.logic.Flag;
	import game.accessPoints.GameGUI;
	
	
	public class GameScreen extends Sprite
	{
		/*
		The board needs its own holder so that it can be dragged, the ships need their own so that they can
		be used as buttons to issues commands later.
		*/
		protected var flagsArray:Array = new Array();
		protected var influences:Array;
		
		
		protected var count:uint = 0;//How many times the moves table has updated, want to ignore the first x updates
		protected var moves:Array;
		//How many players have finished their animation
		protected var playersCompletedAnimationController:int = 0;
		//Is any player still performing their animation?
		protected var animationInProgress:Boolean = false;
		//Has the update to reset the moves table occured?
		protected var resetOccured:Boolean = true;
		protected var sinkDelayTimer:Timer;
		
		protected var board:Board;
				
		public function GameScreen()
		{		
			addListeners();
			//Everyone does this else there are problems when each person tries to set their moves, they need an immediate
			//local copy of the moves table
			addMap();
			
			/* Only one person controls the turn time and all the co-ordination etc. */
			if(GameInformation.amInControl())
			{
				initialiseTimer();
			}
			
			//IF NOT A SPECTATOR! TODO
			GameGUI.moveInput = new MoveInput(new MoveInputStorageGameControl());
			GameGUI.moveInput.y = 330;
			GameGUI.moveInput.x = 466;
			addChild(GameGUI.moveInput);
			GameGUI.moveInput.disengage.addEventListener(MouseEvent.CLICK, disengage);
			
			// Add the animation controller dispatcher to the stage so that it can use enter frame events
			addChild(AnimationController.dispatcher);
		}
		
		protected function disengage(evt:MouseEvent):void
		{
			//Check that you are allowed to disengage
			var myX:int = GameInformation.myShip.xBoardPos;
			if(myX >= 4 && myX <= 33)
			return;
			// Come up with a space on the board that isn't taken by another ship
			
			var positionFree:Boolean = false;
			var newYPos:int;
			while(positionFree == false) {
				newYPos = 40 * (Math.round((Math.random() * 19)) + 1) + 20;
				var shipsTable = GameInformation.shipsTable;
				positionFree = true;
				for (var index:String in shipsTable) {
					if (shipsTable[index].x == 1460 && shipsTable[index].y == newYPos) {
						positionFree = false;
					}
				}				
			}
			var newPos:Object = new Object();
			newPos.newYPos = newYPos;
			
			//Tell the server that you want to disengage
			GameInformation.sendMessage(constants.DISENGAGE_REQUEST, newPos, NetSubControl.TO_SERVER_AGENT);
		}
		
		protected function addListeners():void
		{
			GameInformation.addEventListener(PropertyChangedEvent.PROPERTY_CHANGED, propertyChanged);
			GameInformation.addEventListener(MessageReceivedEvent.MESSAGE_RECEIVED, messageReceived);
			GameInformation.addEventListener(ElementChangedEvent.ELEMENT_CHANGED, elementChanged);
			GameInformation.addEventListener(OccupantChangedEvent.OCCUPANT_LEFT, removePlayer);
		}
				
		protected function removePlayer(evt:OccupantChangedEvent):void
		{
			var id:int = evt.occupantId;
			var seat:int = GameInformation.getPlayerPosition(id);
			if(GameInformation.amInControl())
			{
				//Clear that persons moves
				var myMoves:Array = new Array(["X",0,0],
											  ["X",0,0],
											  ["X",0,0],
											  ["X",0,0]);
				GameInformation.setAt(constants.MOVES_TABLE,seat,myMoves);
				
				//Clear their team
				var oldTeamOne:Object = GameInformation.teamOneTable;
				var oldTeamTwo:Object = GameInformation.teamTwoTable;
				var newTeamOne:Array = new Array();
				var newTeamTwo:Array = new Array();
				for(var i:int = 0; i < oldTeamOne.length; i++)
				{
					if(oldTeamOne[i]!=id)
					newTeamOne.push(oldTeamOne[i]);
				}
				for(i = 0; i < oldTeamTwo.length; i++)
				{
					if(oldTeamTwo[i]!=id)
					newTeamTwo.push(oldTeamTwo[i]);
				}
				GameInformation.teamOneTable = newTeamOne;
				GameInformation.teamTwoTable = newTeamTwo;
			}
			
			//Remove their ship from the board
			board.hideShip(GameInformation.shipsTable[seat]);
			GameInformation.shipsTable[seat].xRealPos = 0;
			GameInformation.shipsTable[seat].yRealPos = 0;
		}
		
		/* Adds the map and the ships */
		protected function addMap():void
		{
			board = new Board();
			this.addChild(board);
			
			//Spawn all the initial ships						
			var ids:Object = GameInformation.getPlayerIds();
			
			//If you are in control set up the ships table
			//The others will spawn their ships once the table has been initialised
			if(GameInformation.amInControl())
			{				
				//Create a table with all the players relevant teams in
				//0=Spectator, else 1 or 2
				var teamsArray:Array = new Array(ids.length);
				
				var spectators:Object = GameInformation.spectatorTable;
				var team1:Object = GameInformation.teamOneTable;
				var team2:Object = GameInformation.teamTwoTable;
				
				for(var i:int = 0; i < ids.length; i++)
				{
					for(var j:int = 0; j < spectators.length; j++)
					{
						if(spectators[j]==ids[i])
						teamsArray[i] = 0;
					}
					for(j = 0; j < team1.length; j++)
					{
						if(team1[j]==ids[i])
						teamsArray[i] = 1;
					}
					for(j = 0; j < team2.length; j++)
					{
						if(team2[j]==ids[i])
						teamsArray[i] = 2;
					}
				}
				/* Needed to synchronise the positions that each client places the ships in */
				var shipPositions:Array = new Array();
				for(i = 0; i < ids.length; i++)
				{
					shipPositions.push(40*(Math.round((Math.random()*19))+1)+20);
				}
				//Check for any positions that are the same, if so change them!
				var collisions:Boolean;
				do
				{					
					collisions = false;
					for(i = 0; i < shipPositions.length; i++)
					{
						for(j = 0; j < shipPositions.length; j++)
						{
							if(i!=j && shipPositions[i]==shipPositions[j])
							{
								collisions = true;
								shipPositions[i]+=40;
								if(shipPositions[i]==820)
								shipPositions[i]=60;
							}
						}
					}
				}while(collisions)
				//Important to do these in the right order!!
				GameInformation.shipPositions = shipPositions;
				GameInformation.teamsTable = teamsArray;
				
			}
		}
		
		protected function initialiseTimer():void
		{
			//Add one to give last second moves the chance to take effect on the server
			GameInformation.turnTimer = new Timer((GameInformation.TurnTime * 1000)+1500);
			//The round timer is implemented by reading the currentCount property of how many times the turn timer went off
			GameInformation.turnTimer.addEventListener(TimerEvent.TIMER, startMoves);
			GameInformation.turnTimer.start();
		}
		
		protected function startMoves(evt:TimerEvent):void
		{
			//Tell the server to send a message to 
			//TODO - this timer should really be on the server
			GameInformation.sendMessage(constants.TIME_UP, null, NetSubControl.TO_SERVER_AGENT);
			GameInformation.turnTimer.stop();
			//This causes a change in the moves table
			//The collisions class broadcasts a message to start the animation and updates everything
			
			if(GameInformation.turnTimer.currentCount == constants.NUMBER_OF_TURNS)
			{
				GameInformation.log("the game is over but you may continue if you wish");//Finish the game
				GameInformation.sendMessage(constants.END_GAME, new Object());
				//Flag that at the end of the animation to declare the winners
				GameInformation.endOfGame = true;
			}
		}
		
		protected function messageReceived(evt: MessageReceivedEvent):void
		{
			var player:int = GameInformation.getPlayerPosition(evt.senderId);
			if(evt.name == constants.SPAWN_SHIP)
			{							
				GameInformation.spawnShip(player, 60, int(evt.value));
				if(player == GameInformation.mySeat)
				board.centerViewOnShip();
			}
			else if(evt.name == constants.DISENGAGE)
			{
				GameInformation.spawnShip(evt.value.player, 1460, evt.value.newPos);
				if(evt.value.player == GameInformation.mySeat)
				board.centerViewOnShip(true);
			}
			else if(evt.name == constants.DAMAGE_TABLE)
			{
				if(!animationInProgress)
				{
					GameInformation.setAt(constants.DAMAGE_TABLE,player,evt.value.damage);
				}
			}
			else if(evt.name == constants.PERFORM_ANIMATION)
			{	
				var collisions:CollisionMechanics = new CollisionMechanics();
				moves = collisions.calculateMoves(GameInformation.board,GameInformation.shipsTable) as Array;
				/* If this player is lagging behind, make sure their counter gets set to 0 so they can't send any more moves */
				GameGUI.moveInput.setCounterToZero();
				//Make sure that there aren't any cannonballs hanging around
				GameInformation.clearCannonArrays();				
				if(GameInformation.amInControl())	
				{
					GameInformation.turnTimer.stop();		
				}
				// Start the animation
				AnimationController.startAnimation(moves);
			}
		}
		
		
		/** Responds to property changes. */
		protected function propertyChanged (evt :PropertyChangedEvent):void
		{
			/* Add the ships to the board */
			if(evt.name == constants.TEAMS_TABLE)
			{
				var ids = GameInformation.getPlayerIds();
				var teamsArray = GameInformation.teamsTable;
				var ships = GameInformation.shipTypeTable;
				var positions = GameInformation.shipPositions;
				if(positions.length != ids.length && GameInformation.amInControl())
				throw Error("error: the teams table update arrived before the positions arrived");
				var names = GameInformation.playerNames;
				
				for(var playerNo:int = 0; playerNo < ids.length; playerNo++)
				{
					if(teamsArray[playerNo] > 0)
					{
						GameInformation.shipsTable[playerNo] = new Ship(ships[playerNo],teamsArray[playerNo],names[playerNo]);						
						GameInformation.shipsTable[playerNo].xRealPos = 60;
						GameInformation.shipsTable[playerNo].yRealPos = positions[playerNo];
						GameInformation.shipsTable[playerNo].addEventListener(GameEvent.ANIM_DONE,AnimationController.incAnim);
						board.displayShip(GameInformation.shipsTable[playerNo]);
					}
				}
				board.centerViewOnShip();//Move the board so that you can see your ship
			}			
		}
		
		protected function elementChanged(evt:ElementChangedEvent):void
		{			
			if(evt.name==constants.MOVES_TABLE)
			{
				updateMoveBar(evt.index);
			}
		}
		
		protected function updateMoveBar(shipNo:int):void
		{
			var movess:Object = GameInformation.movesTable;
				
			var numberOfMoves:uint = 0;
			for(var turn:int = 0; turn < 4; turn++)
			{
				if(movess[shipNo][turn][0] != "X" || movess[shipNo][turn][1] != 0 || movess[shipNo][turn][2] != 0)
				numberOfMoves++;
			}
			GameInformation.setMovesBar(shipNo, numberOfMoves + 1);;
		}
	}
}