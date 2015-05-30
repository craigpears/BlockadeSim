package game 
{
	
	import flash.display.MovieClip;
	import flash.filters.GlowFilter;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import constants;
	import com.whirled.game.GameControl;
	import game.events.GameEvent;
	
	/**
	 * This class contains all of the functions related to the GUI for a ship
	 * @author Craig Pears
	 */
	public class ShipGUI extends ShipMC
	{
		
		protected var cannonAnimations:Array = new Array();//An array to hold all of the cannons that are being animated
		protected var collides;
		protected var animationTimer;
		protected var actingRotation;
		protected var differenceRot;//The difference between the acting rotation and the actual rotation
		protected var influenceSquares:Array = new Array();		
		protected var workingRot:int = 90;
		public var shipImages:MovieClip;
		
		protected var _rot:int = 90;
		
		//used in the animation
		protected var _xPos;
		protected var _yPos;
		protected var _xPos2;
		protected var _yPos2;
		protected var _rot2;
		
		protected var _shipClass:int;
		protected var playerTeam:uint;		
		protected var _shipType:String;
		
		public function ShipGUI(shipType:String, playerTeam:uint, playerNameText:String) 
		{
			// Add the movie clip based on what the ship type is
			switch(shipType)
			{
				case "Sloop": 
					shipImages = new SloopImagesMC();
					this._shipClass = constants.SLOOP;
					break;
				case "Brig":
					shipImages = new BrigImagesMC();
					this._shipClass = constants.BRIG;
					break;
				case "Frig":
					shipImages = new FrigImagesMC();
					this._shipClass = constants.FRIG;
					break;
			}
			
			this._shipType = shipType;
			this.playerTeam = playerTeam;
			
			// Set the ship image rotation
			shipImages.rotation -= 45;
			
			// Add the ship glow to indicate what team the player is on
			var colour:uint;
			if (playerTeam == 1) {
				colour = 0x01A3DE;//Blue
			} else {
				colour = 0x00CA13;//Green
			}
			
			
			shipImages.filters = [new GlowFilter(colour,1,1.5,1.5,255,3,false,false)];
			addChildAt(shipImages,0);
			
			shipImages.gotoAndStop(2);
			playerName.text=playerNameText;
			this.movesBar.gotoAndStop(1);
			
			this.shipImages.addEventListener(MouseEvent.MOUSE_OVER,showInfluence);
			this.shipImages.addEventListener(MouseEvent.MOUSE_OUT,removeInfluence);
		}
		
		public function get shipClass():int
		{
			return this._shipClass; 
		}
		
		protected function convertActualPosToBoardPos(position) {
			position -= constants.TILE_SIZE / 2;
			position /= constants.TILE_SIZE;
			return position;
		}
		
		protected function convertBoardPosToActualPos(position) {
			position *= constants.TILE_SIZE;
			position += constants.TILE_SIZE / 2;
			return position;
		}
		
		public function get xBoardPos():int
		{
			return convertActualPosToBoardPos(this.x);
		}
		
		public function get yBoardPos():int
		{
			return convertActualPosToBoardPos(this.y);
		}
		
		public function set xRealPos(position:int):void
		{
			this.x = Math.round(position);
		}
		
		public function set yRealPos(position:int):void
		{
			this.y = Math.round(position);
		}
		
		public function get xRealPos():int
		{
			return Math.round(this.x);
		}
		
		public function get yRealPos():int
		{
			return Math.round(this.y);
		}
		
		public function set xBoardPos(position) {
			this.x = convertBoardPosToActualPos(Math.round(position));
		}
		
		public function set yBoardPos(position) {
			this.y = convertBoardPosToActualPos(Math.round(position));
		}
		
		public function get rot(){
			//Make sure that it isn't in a minus form then return it
			if(_rot < 0) {
				_rot += 360;
				_rot %= 360
			}
			return _rot;
		}
		
		public function set rot(rot){
			_rot = Math.round(rot);
			if(_rot < 0) {
				_rot += 360;
				_rot %= 360
			}
		}
		
		public function getShipType() {
			return this._shipType;
		}
		
		public function getPlayerName() {
			return this.playerName.text;
		}
		
		public function get team() {
			return playerTeam;
		}
		
		public function clearMovesBar() {
			this.movesBar.gotoAndStop(1);
		}
		
		protected function showInfluence(evt:Event)
		{			
			switch(_shipClass)
			{
				/*
					Every bigger ship can influence what a smaller ship can, so just stack them up
				*/
				
				case 2:
					//war frig
					for(var i = 0; i < constants.FRIG_INFLUENCE.length; i++)
					{
						influenceSquares.push(new InfluenceSquareMC());
						influenceSquares[influenceSquares.length - 1].x = -20 + constants.FRIG_INFLUENCE[i][0] * 40;
						influenceSquares[influenceSquares.length - 1].y = -20 + constants.FRIG_INFLUENCE[i][1] * 40;
						this.addChild(influenceSquares[influenceSquares.length - 1]);
					}							
				case 1:
					//war brig
					for(i = 0; i < constants.BRIG_INFLUENCE.length; i++)
					{
						influenceSquares.push(new InfluenceSquareMC());
						influenceSquares[influenceSquares.length - 1].x = -20 + constants.BRIG_INFLUENCE[i][0] * 40;
						influenceSquares[influenceSquares.length - 1].y = -20 + constants.BRIG_INFLUENCE[i][1] * 40;
						this.addChild(influenceSquares[influenceSquares.length - 1]);
					}							
				case 0:
					//sloop
					influenceSquares.push(new InfluenceSquareMC());
					influenceSquares[influenceSquares.length - 1].x = -20;
					influenceSquares[influenceSquares.length - 1].y = -20;
					this.addChild(influenceSquares[influenceSquares.length - 1]);
			}
			//Make sure these are on top of the influence squares
			this.addChild(playerName);				
			this.addChild(movesBar);
			this.addChild(shipImages);
		}
		
		protected function removeInfluence(evt:Event)
		{
			for(var influenceSquareNo in influenceSquares)	{
				this.removeChild(influenceSquares[influenceSquareNo]);				
			}
			influenceSquares = new Array();
		}
		
		// Animation functions
		
		public function delayedForwardAnimation(actingRot)
		{			
			//If it did collide then the collision mechanics wouldn't put in a shove at all
			collides = 0;
			animationTimer = 0;
			this.actingRotation = actingRot;
			var delayTimer = new Timer(300,1);
			delayTimer.addEventListener(TimerEvent.TIMER_COMPLETE,startDelayedAnim);
			delayTimer.start();			
		}
		
		protected function startDelayedAnim(evt:TimerEvent)
		{
			_xPos = this.x;
			_yPos = this.y;
			this.addEventListener(Event.ENTER_FRAME,forwardAnim);			
		}
		
		public function forwardAnimation(coll, actingRot = -1)
		{
			_xPos = this.x;
			_yPos = this.y;
			if(actingRot==-1)
			actingRot = _rot
			workingRot = (_rot + 360) % 360;
			collides = coll;
			animationTimer = 0;
			this.actingRotation = actingRot;			
			this.addEventListener(Event.ENTER_FRAME,forwardAnim);
		}
		
		public function leftAnimation(coll, actingRot = -1)
		{
			_xPos = this.x;
			_yPos = this.y;
			if(actingRot==-1)
			actingRot = _rot
			workingRot = (_rot + 360) % 360;
			collides = coll;
			animationTimer = 0;
			this.actingRotation = actingRot;
			this.addEventListener(Event.ENTER_FRAME,leftAnim)
		}
		
		public function rightAnimation(coll, actingRot = -1)
		{
			_xPos = this.x;
			_yPos = this.y;
			if(actingRot==-1)
			actingRot = _rot
			collides = coll;
			workingRot = (_rot + 360) % 360;
			differenceRot = ((actingRot - ((_rot+360)%360))+360)%360;//The modulus are to turn -90 rotations into +270 rotations
			animationTimer = 0;
			this.actingRotation = actingRot;
			this.addEventListener(Event.ENTER_FRAME,rightAnim)
		}
		
		public function sinkAnimation()
		{
			_xPos = this.x;
			_yPos = this.y;
			animationTimer = 0;
			workingRot = (_rot + 360) % 360;
			this.addEventListener(Event.ENTER_FRAME,sinkAnim)
		}
		
		public function cannonAnimation(side, numberOfCbs, duration)
		{
			_xPos = this.x;
			_yPos = this.y;
			//TODO: will this have layering issues if one ship is on top of another? The cb animation when it hits a ship might not show
			var actingRotation;
			if(side==0)
			actingRotation = ((_rot - 90) + 360) % 360;
			else
			actingRotation = (_rot + 90) % 360;
			
			//All the animation handling is done within the cannonball
			cannonAnimations.push(new cannonball(_shipClass, duration, actingRotation, false));			
			cannonAnimations[cannonAnimations.length - 1].rotation-=45;
			this.addChild(cannonAnimations[cannonAnimations.length - 1]);
			cannonAnimations[cannonAnimations.length - 1].addEventListener(GameEvent.ANIM_DONE,incAnim);			
			if(numberOfCbs==2)
			{
				//false for not delayed, true for delayed
				cannonAnimations.push(new cannonball(_shipClass, duration, actingRotation, true));
				cannonAnimations[cannonAnimations.length - 1].rotation-=45;
				this.addChild(cannonAnimations[cannonAnimations.length - 1]);
			}
		}	
		
		/*
			This function is called at the beginning of each turn to ensure that the mcs are all properly removed
		*/
		public function clearCannonArray()
		{
			for(var i = 0; i < cannonAnimations.length; i++)
			{
				this.removeChild(cannonAnimations[i]);
			}
			cannonAnimations = new Array();
		}
		
		protected function incAnim(evt:Event)
		{
			dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
		}
		
		protected function leftAnim(evt:Event)
		{
			//this might be a bit confusing, but basicly i just shift the axis to another position, so i can work
			//with the standard circle animation
			//the - at start is actually there becuase depending on the rotation the axis mid point gets shift to
			//another point(eg. 0 rotation[base], will make it move[end point] one tile up and one tile left[-]
			//trust me it works :p
			/*
			-------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------
				DON'T AUTOFORMAT THIS, becuase the commented out code is in the middle of the code, it'll place ;'s there
				which causes bugs >_>
				but if you really really really want to be able to do this, i can fix it for ya >_>
			-------------------------------------------------------------------------------------------------------
			-------------------------------------------------------------------------------------------------------
			
			*/
			animationTimer += 1.5;
			switch (collides) {
				case 0 :
						if (animationTimer<24) {														
							if(animationTimer%6==0)
							this.shipImages.prevFrame();
							workingRot -= 90/24*1.5;
							workingRot += 360;
							workingRot %= 360;
							this.x = _xPos-40*Math.cos(Math.PI*actingRotation/180)+40*Math.cos(Math.PI*workingRot/180);
							this.y = _yPos-40*Math.sin(Math.PI*actingRotation/180)+40*Math.sin(Math.PI*workingRot/180);
						} 
						else
						{
							this.x = (Math.round((this.x-20)/40)*40)+20
							this.y = (Math.round((this.y-20)/40)*40)+20
							_xPos = this.x;
							_yPos = this.y;
							_rot = myRound(workingRot);
							this.shipImages.prevFrame();
							this.removeEventListener(Event.ENTER_FRAME,leftAnim);
							dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
						}
					break;
				case 1 :
						//the parts commented out are just for increasing the angle, fiddle around with them if you want to :p
						if (animationTimer<24/2) {
							
							if(animationTimer%6==0)
							this.shipImages.prevFrame();
							workingRot -= 90/24*1.5;
							workingRot += 360;
							workingRot %= 360;
							
							this.x = _xPos-40*Math.cos(Math.PI*actingRotation/180)+40*Math.cos(Math.PI*workingRot/180);
							this.y = _yPos-40*Math.sin(Math.PI*actingRotation/180)+40*Math.sin(Math.PI*workingRot/180);
							_rot2 = workingRot;
							_xPos2 = this.x;
							_yPos2 = this.y;
						} else {
							if (animationTimer<24) {
								if(animationTimer%6==0)
								this.shipImages.prevFrame();
								workingRot -= 90/24*1.5;
								workingRot += 360;
								workingRot %= 360;
								
								this.x = _xPos2+((_xPos-_xPos2)*((2*animationTimer/24)-1));
								this.y = _yPos2+((_yPos-_yPos2)*((2*animationTimer/24)-1));
							} else {
								this.x = (Math.round((this.x-20)/40)*40)+20
								this.y = (Math.round((this.y-20)/40)*40)+20
								_xPos = this.x;
								_yPos = this.y;
								_rot = myRound(workingRot);
								this.shipImages.prevFrame();
								this.removeEventListener(Event.ENTER_FRAME,leftAnim);
								dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
							}
						}
					break;
				case 2 :
						if (animationTimer<24/2) {
							if(animationTimer%6==0)
							this.shipImages.prevFrame();
							workingRot -= 90/24*1.5;
							workingRot += 360;
							workingRot %= 360;
							this.x = _xPos-40*Math.cos(Math.PI*_rot/180)+40*Math.cos(Math.PI*workingRot/180)*(1+Math.abs((Math.sin(Math.PI*_rot/180)/4)));
							this.y = _yPos-40*Math.sin(Math.PI*_rot/180)+40*Math.sin(Math.PI*workingRot/180)*(1+Math.abs((Math.cos(Math.PI*_rot/180)/4)));
							_rot2 = workingRot;
							_xPos2 = this.x;
							_yPos2 = this.y;
						} else {
							if (animationTimer<24) {
								if(animationTimer%6==0)
								this.shipImages.prevFrame();
								workingRot -= 90/24*1.5;
								workingRot += 360;
								workingRot %= 360;
								this.x = _xPos2+((_xPos-_xPos2+(Math.sin(Math.PI*_rot/180)*40))*((2*animationTimer/24)-1));
								this.y = _yPos2+((_yPos-_yPos2-(Math.cos(Math.PI*_rot/180)*40))*((2*animationTimer/24)-1));
							} 
							else
							{
								this.shipImages.prevFrame();
								this.x = (Math.round((this.x-20)/40)*40)+20
								this.y = (Math.round((this.y-20)/40)*40)+20
								_xPos = this.x;
								_yPos = this.y;
								_rot = myRound(workingRot);
								this.removeEventListener(Event.ENTER_FRAME,leftAnim);
								dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
							}
						}
					break;
			}
		}
		
		protected function forwardAnim(evt:Event)
		{
			switch (collides) 
			{
				case 0 :
						if (this.animationTimer<24) {
							this.animationTimer += 2;
							this.x = this._xPos+(this.animationTimer/24*Math.sin(Math.PI*actingRotation/180))*40;
							this.y = this._yPos-(this.animationTimer/24*Math.cos(Math.PI*actingRotation/180))*40;
						} else {
							_xPos = this.x;
							_yPos = this.y;
							_rot = myRound(workingRot);
							this.removeEventListener(Event.ENTER_FRAME,forwardAnim);
							dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
						}
					break;
				case 1 :
							
						if (animationTimer<12) {
							animationTimer += 2;
							this.x = _xPos+(animationTimer/24*Math.sin(Math.PI*actingRotation/180))*40;
							this.y = _yPos-(animationTimer/24*Math.cos(Math.PI*actingRotation/180))*40;
						} else {
							if (animationTimer<24) {
								animationTimer += 2;
								this.x = _xPos+((24-animationTimer)/24*Math.sin(Math.PI*actingRotation/180))*40;
								this.y = _yPos-((24-animationTimer)/24*Math.cos(Math.PI*actingRotation/180))*40;
							} else {
							this.x = (Math.round((this.x-20)/40)*40)+20;
							this.y = (Math.round((this.y-20)/40)*40)+20;
							
							_xPos = this.x;
							_yPos = this.y;
							_rot = myRound(workingRot);
							this.removeEventListener(Event.ENTER_FRAME,forwardAnim);							
							dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
							}
						}
					break;
			}
		
		}
		
		protected function rightAnim(evt:Event)
		{
			animationTimer += 1.5;
			switch (collides) {
				case 0 :
						if (animationTimer<24) {
							if(animationTimer%6==0)
							this.shipImages.nextFrame();
							workingRot += 90/24*1.5;
							workingRot += 360;
							workingRot %= 360;
							this.x = _xPos+40*Math.cos(Math.PI*actingRotation/180)-40*Math.cos(Math.PI*((workingRot + differenceRot)%360)/180);
							this.y = _yPos+40*Math.sin(Math.PI*actingRotation/180)-40*Math.sin(Math.PI*((workingRot + differenceRot)%360)/180);
						} else {
							
							this.x = (Math.round((this.x-20)/40)*40)+20
							this.y = (Math.round((this.y-20)/40)*40)+20
							this.shipImages.nextFrame();
							_xPos = this.x;
							_yPos = this.y;
							_rot = myRound(workingRot);
							this.removeEventListener(Event.ENTER_FRAME,rightAnim);
							dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
						}
					break;
				case 1 :
						if (animationTimer<24/2) {
							if(animationTimer%6==0)
							this.shipImages.nextFrame();
							workingRot += 90/24*1.5;
							workingRot += 360;
							workingRot %= 360;
							this.x = _xPos+40*Math.cos(Math.PI*_rot/180)-40*Math.cos(Math.PI*((workingRot + differenceRot)%360)/180);
							this.y = _yPos+40*Math.sin(Math.PI*_rot/180)-40*Math.sin(Math.PI*((workingRot + differenceRot)%360)/180);
							_xPos2 = this.x;
							_yPos2 = this.y;							
							_rot2 = workingRot;
						} else {
							if (animationTimer<24) {
								if(animationTimer%6==0)
								this.shipImages.nextFrame();
								workingRot += 90/24*1.5;
								workingRot += 360;
								workingRot %= 360;
								this.x = _xPos2+((_xPos-_xPos2)*((2*animationTimer/24)-1));
								this.y = _yPos2+((_yPos-_yPos2)*((2*animationTimer/24)-1));
							} else {
								
								this.x = (Math.round((this.x-20)/40)*40)+20
								this.y = (Math.round((this.y-20)/40)*40)+20
								this.shipImages.nextFrame();
								_xPos = this.x;
								_yPos = this.y;
								_rot = myRound(workingRot);
								this.removeEventListener(Event.ENTER_FRAME,rightAnim);
								dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
							}
						}
					break;
				case 2 :
						if (animationTimer<24/2) {
							if(animationTimer%6==0)
							this.shipImages.nextFrame();
							workingRot += 90/24*1.5;
							workingRot += 360;
							workingRot %= 360;
							this.x = _xPos+40*Math.cos(Math.PI*actingRotation/180)-40*Math.cos(Math.PI*((workingRot + differenceRot)%360)/180)*(1+Math.abs((Math.sin(Math.PI*_rot/180)/4)));
							this.y = _yPos+40*Math.sin(Math.PI*actingRotation/180)-40*Math.sin(Math.PI*((workingRot + differenceRot)%360)/180)*(1+Math.abs((Math.cos(Math.PI*_rot/180)/4)));
							_xPos2 = this.x;
							_yPos2 = this.y;
							_rot2 = workingRot;
						} else {
							if (animationTimer<24) {
								if(animationTimer%6==0)
								this.shipImages.nextFrame();
								workingRot += 90/24*1.5;
								workingRot += 360;
								workingRot %= 360;
								this.x = _xPos2+((_xPos-_xPos2+(Math.sin(Math.PI*_rot/180)*40))*((2*animationTimer/24)-1));
								this.y = _yPos2+((_yPos-_yPos2-(Math.cos(Math.PI*_rot/180)*40))*((2*animationTimer/24)-1));
							} else {
								this.x = (Math.round((this.x-20)/40)*40)+20
								this.y = (Math.round((this.y-20)/40)*40)+20
								this.shipImages.nextFrame();
								_xPos = this.x;
								_yPos = this.y;
								_rot = myRound(workingRot);
								this.removeEventListener(Event.ENTER_FRAME,rightAnim);
								dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
							}
						}
			}
		}
		
		protected function sinkAnim(evt:Event)
		{
			if (animationTimer<144) {
				animationTimer += 1.5;
				if(animationTimer%6==0)
				this.shipImages.nextFrame();
				workingRot += 720/144*1.5;
				workingRot += 360;
				workingRot %= 360;
			} else {				
				this.removeEventListener(Event.ENTER_FRAME,sinkAnim);
				dispatchEvent(new GameEvent(GameEvent.SINK_ANIM_DONE));
			}
		}
		
		//Rounds to the closest of: 0,90,180,270
		protected function myRound(numb)
		{
			numb = (numb + 360) % 360;
			if(numb>340 || numb < 20)
			return 0;
			if(numb <100)
			return 90;
			if(numb < 200)
			return 180;
			else
			return 270;			
		}
		
	}

}