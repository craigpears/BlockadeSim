package game 
{
	import flash.display.Sprite;
	import flash.events.EventDispatcher;
	import game.accessPoints.GameInformation;
	import game.accessPoints.GameGUI;
	import flash.events.Event;
	import game.events.GameEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * This class handles all the animation in the GUI
	 * @author Craig Pears
	 */
	public class AnimationController 
	{
		static public var dispatcher:Sprite = new Sprite();
		static public var animationInProgress:Boolean = false;
		static private var moves:Array;
		static private var phase:int, turn:int;
		static private var animationsFinished:int;
		
		public function AnimationController() {
			throw Error("Animation class should not be instantiated");
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
        }
        public static function dispatchEvent(event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }
        public static function hasEventListener(type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }
		
		public static function startAnimation(_moves:Array):void
		{
			// Initialise any variables for the animation
			moves = _moves;
			phase = 0;
			turn = 0;
			animationsFinished = GameInformation.numberOfShips * 2;			
			GameInformation.sunkShips = new Array();
			
			// Put any locks in place
			animationInProgress = true;
			
			// Start off the animation loop
			AnimationController.addEventListener(Event.ENTER_FRAME,animation);
			
		}
		
		public static function animationFinished():void
		{
			// Release any locks
			animationInProgress = false;
			
			GameGUI.moveInput.animationFinished();				
			
			// Clear all the ship move bars
			var shipsTable:Array = GameInformation.shipsTable;
			for(var shipNo:String in shipsTable)
			{
				shipsTable[shipNo].clearMovesBar();
			}
			
			// Check if we need to resume generating
			if(GameInformation.delayTurnsRemaining > 0)
			GameInformation.delayTurnsRemaining--;
			if(GameInformation.delayTurnsRemaining == 0)
			GameGUI.moveInput.resumeGenerating();
					 
			if(GameInformation.amInControl())
			{
				GameInformation.turnTimer.start();
			}
			Scoring.updatePoints();
			AnimationController.removeEventListener(Event.ENTER_FRAME,animation);
			Scoring.checkEndOfGame();			
		}
		
		public static function incAnim(evt:GameEvent):void
		{
			animationsFinished++;
		}
		
		public static function animation(evt:Event):void
		{
			//You have to wait for all the animations from the last phase before continuing to the next
			//Its double because for the first phase there may be shoves, so there are two sets of animation in that phase
			var animationsToFinish:int;
			if(phase == 1 || phase == 0)
			animationsToFinish = GameInformation.numberOfShips * 2;
			else
			animationsToFinish = GameInformation.numberOfShips;
			
			
			if(animationsFinished == animationsToFinish)
			{			
				animationsFinished = 0;
				//Cycle through each ship
				for(var playerNumber:int = 0; playerNumber < GameInformation.numberOfShips; playerNumber++)
				{
					if(GameInformation.shipsTable[playerNumber]!=null)//phase lock added to stop a bug making phase 0 execute twice
					{
						switch(phase)
						{
							case 0://Normal movement phase
								//Execute the normal moves
								//There is a listener on each ship for their animations finishing that calls incAnim
								//Listener was set when the ship was made
								switch(moves[playerNumber][turn].getMoveType())
								{
									case "X":
										animationsFinished++;																					
										break;
									case "L":
										GameInformation.animate(playerNumber, constants.LEFT, moves[playerNumber][turn].getCollisionPhase());
										break;
									case "F":						
										GameInformation.animate(playerNumber, constants.FORWARD, moves[playerNumber][turn].getCollisionPhase());
										break;
									case "R":
										GameInformation.animate(playerNumber, constants.RIGHT, moves[playerNumber][turn].getCollisionPhase());
										break;
								}
								//Execute the shoves
								switch(moves[playerNumber][turn].getShoved())
								{
									case "X":
										animationsFinished++;
										break;										
									case "U":
										GameInformation.animate(playerNumber,constants.DELAYED_FORWARD, 0, 0);
										break;
									case "R":
										GameInformation.animate(playerNumber,constants.DELAYED_FORWARD, 0, 90);
										break;
									case "D":
										GameInformation.animate(playerNumber,constants.DELAYED_FORWARD, 0, 180);
										break;
									case "L":
										GameInformation.animate(playerNumber,constants.DELAYED_FORWARD, 0, 270);
										break;									
								}
								break;
							case 1://wind
								//Switch on the wind action
								switch(moves[playerNumber][turn].getTileAction())
								{
									case "X":
										animationsFinished++;
										break;
									case "F":
										//Wind push
										//do forward anim(phase of collision, acting rotation)
										GameInformation.animate(playerNumber,
														 constants.FORWARD,
														 moves[playerNumber][turn].getTileActionCollisionPhase(),
														 moves[playerNumber][turn].getTileActionActingRotation());
										break;
									case "R":
										//Whirlpool
										GameInformation.animate(playerNumber,
														 constants.RIGHT,
														 moves[playerNumber][turn].getTileActionCollisionPhase(),
														 moves[playerNumber][turn].getTileActionActingRotation());
										break;										
								}
								break;
							case 2://cannons							
								//TODO: clean up the cannons that were fired from the last turn
								switch(moves[playerNumber][turn].getLeftCannonsFired())
								{
									case 0:
										animationsFinished++;
										break;
									case 1:										
									case 2:
										//0 indicates that its from the left cannon, the second is how many cannons, the third is when do they hit something
										GameInformation.fireCannons(playerNumber, constants.LEFT_SIDE, moves[playerNumber][turn].getLeftCannonsFired(),moves[playerNumber][turn].getLeftCannonsCollisionTime());
										break;
								}
								switch(moves[playerNumber][turn].getRightCannonsFired())
								{
									case 0:
										animationsFinished++;
										break;
									case 1:										
									case 2:
										GameInformation.fireCannons(playerNumber, constants.RIGHT_SIDE, moves[playerNumber][turn].getRightCannonsFired(), moves[playerNumber][turn].getRightCannonsCollisionTime());
										break;
								}							
								break;
						}
					}
					else
					{
						if(phase == 0 || phase == 2)
							animationsFinished += 2;
						else
							animationsFinished++;
					}
					
				}	
				
				var shipsTable:Object = GameInformation.shipsTable;
				for(var shipNo:String in shipsTable)
				{
					
					if(moves[shipNo][turn].getShipSunk() && moves[shipNo][turn].getSinkPhase() == phase)
					{
						GameInformation.sunkShips.push(shipNo);
						shipsTable[shipNo].sinkAnimation();
						if(int(shipNo) == GameInformation.mySeat)
						shipsTable[shipNo].addEventListener(GameEvent.SINK_ANIM_DONE,sink);						
					}
				}	
				
				
				phase = (phase + 1) % 3;
				if(phase == 0)
				turn++;
				
				if(turn == 4) animationFinished();
			}
			
			
			
		}
		
		protected static function sink(evt:Event):void
		{
			//TODO: make sure ships cant spawn ontop of each other
			//Delay this for a tiny amount of time to make sure that everyone has finished the sink animation
			var timerr:Timer = new Timer(200,1);
			timerr.addEventListener(TimerEvent.TIMER_COMPLETE,sinkk);
			timerr.start();			
		}
		
		protected static function sinkk(evt:Event):void
		{
			var yPosUponRespawn:int = 40*(Math.round((Math.random()*19))+1)+20;			
			GameInformation.sendMessage(constants.SPAWN_SHIP,yPosUponRespawn);
			
			
			GameInformation.delayTurnsRemaining = GameInformation.sinkDelay;
			if(GameInformation.delayTurnsRemaining > 0)
			{
				GameGUI.moveInput.pauseGenerating();
				GameInformation.log("You have been given a sink delay of " + GameInformation.delayTurnsRemaining + " turns until your moves will start spawning again");	
			}
		}
		
	}

}