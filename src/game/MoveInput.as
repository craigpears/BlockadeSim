package game{
	
	import com.whirled.game.GameControl;
	import flash.events.Event;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.MouseEvent;
	import constants;
	import flash.display.Sprite;
	import game.data.ShipStats;
	import game.events.BubbledEvent;
	
	
	import game.Hourglass;
	import game.MoveExpiryInfo;
	import game.MoveInputBox;
	
	import game.MoveInputStorageInterface;
	
	public class MoveInput extends MoveInputMC
	{
		protected var leftsAvailable:Array;
		protected var leftsOriginal:Array;
		protected var forwardsAvailable:Array;
		protected var forwardsOriginal:Array;
		protected var rightsAvailable:Array;
		protected var rightsOriginal:Array;
		
		protected var totalLefts:uint;
		protected var totalForwards:uint;
		protected var totalRights:uint;
		
		protected var myMoves:Array;
		protected var damage:Number=0;
		protected var maxDamage;
		protected var bilge:Number=0;
		protected var maxCannons:uint;//The max amount of cannons a ship can have
		protected var cannonsTotal:uint=0;//The number of cannons left, and that have been entered in as moves
		protected var cannonsAvailable:uint=0;//The number of cannons left that can be entered as moves
		protected var cannonsEntered:uint=0;//The number of cannons that have been entered
		protected var timer:Timer;
		//These vars are calculated from the ship type and jobber level, and are stated in terms of generation per 20th of a move
		protected var moveGenerationRate:Number;
		protected var cannonGenerationRate:Number;
		protected var repairRate:Number;
		protected var bilgeClearRate:Number;
		//Stores partially generated moves
		protected var movesBuffer:Number=0;
		protected var cannonsBuffer:Number=0;
		//1=lefts, 2=forwards, 3=rights
		//Automoves overrules generationMode
		protected var autoMoves:Boolean=true;
		protected var stopGenerating:Boolean=false;
		protected var generationMode:uint=2;
		protected var movesEntered:uint = 0; //How many moves have been entered
		protected var smallShip:Boolean; //Whether or not it can enter four moves
		
		protected var moveExpiryInfo:MoveExpiryInfo;
		
		protected var turnTime:uint;
		protected var timeLeft:uint;
		protected var counter:uint;
		protected var turnTimeTimer:Timer;
		protected var delayTimer:Timer;
		protected var hourglass:Hourglass;
		
		protected var moveInputState:Array = new Array(4);
		
		protected var moveInputBoxes:Array = new Array(new MoveInputBox('input0'), new MoveInputBox('input1'), new MoveInputBox('input2'), new MoveInputBox('input3'));
		
		protected var _storage;
		protected var ui;
		
		public function MoveInput(storage)
		{
			_storage = storage;
			ui = new MoveInputUI();
			addChild(ui);
			
			// Listen for any clicks in the UI			
			ui.addEventListener(BubbledEvent.CANNON_CHANGE, bubbledEventsHandler);
			ui.addEventListener(BubbledEvent.AUTO_MOVES_TOGGLE, bubbledEventsHandler);
			ui.addEventListener(BubbledEvent.SET_GENERATION, bubbledEventsHandler);
			
			// Add move input boxes
			moveInputBoxes[0].x = 209.35;
			moveInputBoxes[0].y = 23.85;
			moveInputBoxes[1].x = 209.35;
			moveInputBoxes[1].y = 58.00;
			moveInputBoxes[2].x = 209.35;
			moveInputBoxes[2].y = 92.15;
			moveInputBoxes[3].x = 209.35;
			moveInputBoxes[3].y = 126.35;
			addChild(moveInputBoxes[0]);
			addChild(moveInputBoxes[1]);
			addChild(moveInputBoxes[2]);
			addChild(moveInputBoxes[3]);
			
			moveInputState[0] = 0;
			moveInputState[1] = 0;
			moveInputState[2] = 0;
			moveInputState[3] = 0;
			
			moveInputBoxes[0].addEventListener(MouseEvent.CLICK,moveChange);
			moveInputBoxes[1].addEventListener(MouseEvent.CLICK,moveChange);
			moveInputBoxes[2].addEventListener(MouseEvent.CLICK,moveChange);
			moveInputBoxes[3].addEventListener(MouseEvent.CLICK,moveChange);
			
			// Add the hover information for the move symbols
			leftsSymbol.addEventListener(MouseEvent.ROLL_OVER,moveExpiry);
			forwardsSymbol.addEventListener(MouseEvent.ROLL_OVER,moveExpiry);
			rightsSymbol.addEventListener(MouseEvent.ROLL_OVER,moveExpiry);
			
			// Initialise the timer
			turnTime = _storage.getTurnTime();
			counter = turnTime;
			var counterTimer = new Timer(1000);
			counterTimer.addEventListener(TimerEvent.TIMER,decCounter);
			counterTimer.start();
			
			timeLeft = turnTime * constants.NUMBER_OF_TURNS;
			timeLeftTxt.text = ""+Math.floor(timeLeft/60)+":"+(timeLeft%60);
			
			// Add the hourglass
			hourglass = new Hourglass(turnTime);
			hourglass.x = 282;
			hourglass.y = 65;
			addChild(hourglass);
			
			resetShip();
			
			var shipType = _storage.getMyShipType();
			var shipStats:Object = ShipStats.getShipStats(_storage.getMyJobberLevel(), shipType);
			
			moveGenerationRate = shipStats.movesPerTurn / turnTime;
			repairRate = shipStats.repairRate / turnTime;
			bilgeClearRate = shipStats.bilgeClearRate / turnTime;
			cannonGenerationRate = shipStats.cannonsPerTurn / turnTime;
			maxDamage = shipStats.maxDamage;
			maxCannons = shipStats.maxCannons;
			smallShip = (shipType == "Sloop")
			
			
			updateDisplay();
		}
		
		private function bubbledEventsHandler(evt:BubbledEvent) {
			if (evt.type == BubbledEvent.CANNON_CHANGE) {
				cannonChange(evt.bubbledEvent);
			} else if (evt.type == BubbledEvent.AUTO_MOVES_TOGGLE) {
				autoMovesToggle(evt.bubbledEvent);
			} else if (evt.type == BubbledEvent.SET_GENERATION) {
				setGeneration(evt.bubbledEvent);
			}
		}
		
		/* Function that catches you up to the other players if you are lagging behind */
		public function setCounterToZero()
		{
			if(timeLeft >= counter)
			timeLeft -= counter;
			else
			timeLeft = 0;
			counter = 0;
			hourglass.counter = 0;
		}
		
		//This is called by both the constructor and when a ship spawns again
		protected function resetShip()
		{
			// Reset any local storage TODO: this shouldn't be needed
			resetMoves();			
			clearMoves();	
			
			// Update the ui
			ui.setDamage(0);
			ui.setBilge(0);
			
			// Update the storage
			_storage.setMyDamage(damage);			
			damage = 0;		
		}
		
		/**
		 *  Sets the original and available moves back to their initial values
		 */
		public function resetMoves()
		{
			leftsAvailable = new Array(0,0,0,0,2);			
			leftsOriginal = new Array(0,0,0,0,2);
			forwardsAvailable = new Array(0,0,0,0,4);
			forwardsOriginal = new Array(0,0,0,0,4);
			rightsAvailable = new Array(0,0,0,0,2);
			rightsOriginal = new Array(0,0,0,0,2);
			bilge = 0;
		}
		
		protected function setToken(inputBox:String, value:int) {
			
			var arrayIndex = 0;
			if (inputBox == 'input0') {
				arrayIndex = 0;
			} else if (inputBox == 'input1') {
				arrayIndex = 1;
			} else if (inputBox == 'input2') {
				arrayIndex = 2;
			} else if (inputBox == 'input3') {
				arrayIndex = 3;
			}
			moveInputState[arrayIndex] = value;
			moveInputBoxes[arrayIndex].setToken(value);
		}
		
		protected function clearMoves()
		{
			/*
				X/L/F/R - Move Type
				Number of cannons shot to the left
				Number of cannons shot to the right
			*/
			myMoves = new Array(["X",0,0],
								["X",0,0],
								["X",0,0],
								["X", 0, 0]);
			setToken('input0', 0);
			setToken('input1', 0);
			setToken('input2', 0);
			setToken('input3', 0);
			
			ui.resetCannonsEntered();
			
			cannonsTotal -= cannonsEntered;
			cannonsEntered = 0;			
			movesEntered = 0;
			
			updateDisplay();
		}
		
		// This function is called at the end of each turn
		public function animationFinished()
		{
			// Clear the ships moves
			clearMoves();
			
			// Shift the arrays
			leftsAvailable.shift();
			leftsAvailable.push(0);
			leftsOriginal.shift();
			leftsOriginal.push(0);
			forwardsAvailable.shift();
			forwardsAvailable.push(0);
			forwardsOriginal.shift();
			forwardsOriginal.push(0);
			rightsAvailable.shift();
			rightsAvailable.push(0);
			rightsOriginal.shift();
			rightsOriginal.push(0);
			
			// Reset the counter
			hourglass.counter = turnTime;
			counter = turnTime;
			
			// Update the damage
			damage = _storage.getMyDamage();
			
			// Update the display
			updateDisplay();
		}
			
		
		protected function autoMovesToggle(evt:Event)
		{
			autoMoves = !autoMoves;
		}
		
		protected function setGeneration(evt:Event)
		{	
			// Set the generation mode
			generationMode = evt.target.generationMode;
			
			// Update the ui
			evt.target.setState(1);
		}
		
		protected function cannonChange(evt:Event)
		{			
			if(counter > 0)
			{
				switch(evt.target.cannonsEntered)
				{
					case 0:
						if(cannonsAvailable > 0)
						{
							cannonsAvailable--;
							cannonsEntered++;
							evt.target.cannonsEntered = 1;
							myMoves[evt.target.number][evt.target.side + 1]=1;						
						}
						break;
					case 1:
						if(cannonsAvailable > 0 && !smallShip)
						{
							cannonsAvailable--;
							cannonsEntered++;
							evt.target.cannonsEntered = 2;
							myMoves[evt.target.number][evt.target.side + 1]=2;
						}
						else
						{
							cannonsAvailable ++;
							cannonsEntered --;
							evt.target.cannonsEntered = 0;
							myMoves[evt.target.number][evt.target.side + 1]=0;
						}
						break;
					case 2:
						cannonsAvailable +=2;
						cannonsEntered -=2;
						evt.target.cannonsEntered = 0;
						myMoves[evt.target.number][evt.target.side + 1]=0;
						break;
				}
				_storage.setMyMoves(myMoves);
			}
		}
		
		protected function moveExpiry(evt:MouseEvent)
		{
			var colour;
			var moveText = "";
			var i;
			switch(evt.target)
			{
				case leftsSymbol:
					colour = 0;
					for(i = 0; i < 5; i++)
					{
						moveText+=leftsAvailable[i];
						if(i<4)
						moveText+=",";
					}
					break;
				case forwardsSymbol:
					colour = 1;
					for(i = 0; i < 5; i++)
					{
						moveText+=forwardsAvailable[i];
						if(i<4)
						moveText+=",";
					}
					break;					
				case rightsSymbol:
					colour = 2;
					for(i = 0; i < 5; i++)
					{
						moveText+=rightsAvailable[i];
						if(i<4)
						moveText+=",";
					}
					break;					
			}
			moveExpiryInfo = new MoveExpiryInfo(colour,moveText);
			moveExpiryInfo.x = evt.target.x - 15;
			moveExpiryInfo.y = evt.target.y + 45;
			addChild(moveExpiryInfo);
			evt.target.addEventListener(MouseEvent.MOUSE_OUT,removeExpiry);
		}
		
		protected function removeExpiry(evt:MouseEvent)
		{
			evt.target.removeEventListener(MouseEvent.MOUSE_OUT,removeExpiry);
			removeChild(moveExpiryInfo);
		}
		
		protected function moveChange(evt:MouseEvent)
		{
			if(counter > 0)
			{
				var box = evt.target;
				var boxName = box._name;
				var moveNo:uint;
				var curMove:uint;
				
				if(boxName == 'input0')	{
					moveNo = 0;
					curMove = moveInputState[0];
				} else if(boxName == 'input1') {
					moveNo = 1;
					curMove = moveInputState[1];
				} else if( boxName == 'input2')	{
					moveNo = 2;
					curMove = moveInputState[2];
				} else if( boxName == 'input3'){
					moveNo = 3;
					curMove = moveInputState[3];
				}
				
				//Put whatever is in there right now back into the available moves list
				if(curMove != 0)
				{
					switch(curMove)
					{
						case 1: incrementLefts(); break;
						case 2: incrementForwards(); break;
						case 3: incrementRights(); break;
					}
					movesEntered--;
				}
				
				switch(curMove)
				{
					case 0: 
						curMove++;
						//If the moves aren't available it misses the break statement and goes to check if it can cycle to the next
						if(movesEntered < 3 || smallShip)
						{
							if(decrementLefts())
							{
								movesEntered++;
								break;
							}
						}																			   
					case 1:					
						curMove++;
						if(movesEntered < 3 || smallShip)
						{
							if(decrementForwards())
							{
								movesEntered++;
								break;
							}
						}																			
						
					
					case 2:
						curMove++;
						if(movesEntered < 3 || smallShip)
						{
							if(decrementRights())
							{
								movesEntered++;
								break;
							}
						}																			
					
					case 3:
						curMove=0;
						break;
				}
				setToken(boxName, curMove);
				
				var curToken:String;
				switch(curMove)
				{
					case 0: curToken = "X"; break;
					case 1: curToken = "L"; break;
					case 2: curToken = "F"; break;
					case 3: curToken = "R"; break;
				}
				updateDisplay();
				myMoves[moveNo][0] = curToken;
				myMoves[4]=true;
				_storage.setMyMoves(myMoves);
			}
		}		
		
		protected function decCounter(evt:TimerEvent)
		{
			if(counter>0)
			{
				counter--;
				if(timeLeft > 0) timeLeft--;
				hourglass.counter = counter;
				updateDmg();
			}
			
			if(counter == 5)//Make sure that the empty set of moves gets transmitted to avoid bugs
			_storage.setMyMoves(myMoves);
			else if(counter == 2)
			{
				var obj = new Object();
				obj.damage = damage;
				_storage.sendDamageMessage(obj);
			}
			
		}
		
		protected function updateDmg(evt:TimerEvent=null)
		{
			damage-=repairRate;
			if(damage < 0)
			damage = 0;
			
			var bilgeMultiplier = 1-((bilge/100)*0.9);
			bilge+=((damage/maxDamage*100/3)+0.7)/turnTime;
			bilge-=bilgeClearRate;
			
			if(bilge < 0)
			bilge = 0;
			else if(bilge > 100)
			bilge = 100;
			cannonsBuffer+=cannonGenerationRate;
			if(cannonsBuffer>=1)
			{				
				if(cannonsTotal < maxCannons)
				{
					cannonsTotal+=Math.floor(cannonsBuffer);
					cannonsAvailable+=Math.floor(cannonsBuffer);
				}
				cannonsBuffer%=1;
			}
			if(!stopGenerating)
			movesBuffer+=moveGenerationRate * bilgeMultiplier;
			if(movesBuffer>=1)
			{
				movesBuffer%=1;
				generateMove();
			}
			updateDisplay();
		}
		
		protected function generateMove()
		{
			var generate;
			if(autoMoves)
			generate=0;
			else
			generate=generationMode;
				switch(generate)
				{
					case 0: if(totalForwards <= totalRights && totalForwards <= totalLefts)
							{
								forwardsAvailable[4]++;
								forwardsOriginal[4]++;
							}
							else if(totalLefts <= totalRights)
							{
								leftsAvailable[4]++;
								leftsOriginal[4]++
							}
							else
							{
								rightsAvailable[4]++;
								rightsOriginal[4]++;
							}
							break;
					case 1: leftsAvailable[4]++;
							leftsOriginal[4]++
							break;
					case 2: forwardsAvailable[4]++;
							forwardsOriginal[4]++;
							break;
					case 3: rightsAvailable[4]++;
							rightsOriginal[4]++;
							break;
				}				
		}
		
		protected function updateDisplay()
		{
			totalLefts = 0;
			totalRights = 0;
			totalForwards = 0;
			
			for(var i = 0; i < 5; i++)
			{
				totalLefts+=leftsAvailable[i];
				totalRights+=rightsAvailable[i];
				totalForwards+=forwardsAvailable[i];				
			}
			
			ui.setBilge(bilge);
			ui.setDamage((damage/maxDamage)*100);
			
			leftsText.text = String(totalLefts);
			forwardsText.text = String(totalForwards);
			rightsText.text = String(totalRights);
			cannonsText.text = String(cannonsAvailable);
			var secondsLeft = ""+(timeLeft % 60);
			if(secondsLeft < 10)
			secondsLeft = "0" + secondsLeft;
			var minutesLeft = ""+(Math.floor(timeLeft / 60));
			if(minutesLeft < 10)
			minutesLeft = "0"+minutesLeft;
			timeLeftTxt.text = ""+minutesLeft+":"+secondsLeft;
		}
		
		public function get winningTeam()
		{
			if(_storage.getPoints(1) > _storage.getPoints(2))
				return 1;
			else if(_storage.getPoints(1) < _storage.getPoints(2))
				return 2;
			else
			{
				_storage.log("There is a tie, continuing for one more round");
				return 0;
			}
		}
		
		public function updatePoints(points:Array)
		{
			_storage.addPoints(points);			
			teamOnePointsTxt.text = ""+_storage.getPoints(1);
			teamTwoPointsTxt.text = ""+_storage.getPoints(2);
		}
		
		public function pauseGenerating()
		{
			stopGenerating = true;
			leftsAvailable = new Array(0,0,0,0,0);			
			leftsOriginal = new Array(0,0,0,0,0);
			forwardsAvailable = new Array(0,0,0,0,0);	
			forwardsOriginal = new Array(0,0,0,0,0);	
			rightsAvailable = new Array(0,0,0,0,0);	
			rightsOriginal = new Array(0,0,0,0,0);
			bilge = 0;
		}
		
		public function resumeGenerating()
		{			
			if(stopGenerating)
			{
				_storage.log("Your moves have resumed generating");
				resetMoves();
				stopGenerating = false;			
			}
		}
		
		protected function incrementLefts():Boolean {
			return incrementMove(leftsOriginal, leftsAvailable);
		}
		
		protected function incrementForwards():Boolean {
			return incrementMove(forwardsOriginal, forwardsAvailable);
		}
		
		protected function incrementRights():Boolean {
			return incrementMove(rightsOriginal, rightsAvailable);
		}
		
		protected function decrementLefts():Boolean {
			return decrementMove(leftsAvailable);
		}
		
		protected function decrementForwards():Boolean {
			return decrementMove(forwardsAvailable);
		}	
				
		protected function decrementRights():Boolean {
			return decrementMove(rightsAvailable);
		}
		
		protected function incrementMove(originalMoves, availableMoves)
		{
			var i = 0;
			while(i < 5)
			{
				if(originalMoves[i] > availableMoves[i])
				{
					availableMoves[i]++;
					return;
				}
				i++;
			}			
		}
		
		protected function decrementMove(availableMoves)
		{
			var i = 0;
			while(i < 5)
			{
				if(availableMoves[i] > 0)
				{
					availableMoves[i]--;
					return true;
				}
				i++;
			}
			return false;
		}
	}
}