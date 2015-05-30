package game
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.MovieClip;
	import game.events.GameEvent;
	
	public class cannonball extends Sprite
	{
		protected var cbsize:uint;
		protected var duration:uint;
		protected var animationsLeft:uint;
		protected var cbMC:MovieClip;
		protected var movesLeft:uint;
		protected var side:uint;
		protected var actingRotation:Number;
		
		/*
			cb size 0 - small, 1 - medium, 2 - large
			duration is measured in how many tiles it travels until it explodes
			5 indicates that it travels for 4 tiles and then hits the water
		*/
		public function cannonball(cbsize, duration, actingRotation, delayed)
		{
			this.cbsize = cbsize;
			switch(cbsize)
			{
				case 0:
					cbMC = new smallCBMC();
					break;
				case 1:
					cbMC = new medCBMC();
					break;
				case 2:
					cbMC = new largeCBMC();
					break;
			}
			addChild(cbMC);
			this.duration = duration;
			this.actingRotation = Math.PI * actingRotation / 180;
			this.movesLeft = duration * 8;//Tile is 40x40 and it moves 5 at a time, 8 movements per tile
			if(duration==4)
			movesLeft -=8;
			
			if(!delayed)
			this.addEventListener(Event.ENTER_FRAME,moveCB);
			else
			this.addEventListener(Event.ENTER_FRAME,startMoveCB);
		}
		
		protected function startMoveCB(evt:Event)
		{
			this.addEventListener(Event.ENTER_FRAME,moveCB);
		}
		
		protected function moveCB(evt:Event)
		{
			if(movesLeft > 0)
			{
				this.x += 5*Math.sin(actingRotation);
				this.y -= 5*Math.cos(actingRotation);
				movesLeft--;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME,moveCB);
				startAnimation();
			}
		}
		
		/*
			The explosions for the small and medium cbs have 18 frames each, 
			where each frame is 40x40 pixels
			the large cb explosion is 24 frames long
			these mcs are named animation
			
			the mcs for splashes are named splash
			the small splash is 13 frames long
			the large splash is 12 frames long
			the small splash is for regular cbs, the large one for special ones like chain shot and skull shot perhaps?
		*/
		
		protected function startAnimation()
		{
			/*
				animations left is one more than the number of frames so that it is blank afterwards
			*/
			if(duration < 4)
			{
				if(cbsize==2)
				animationsLeft = 25;
				else
				animationsLeft = 19;				
				this.addEventListener(Event.ENTER_FRAME,incExplosion);				
			}
			else
			{
				animationsLeft = 14;
				this.addEventListener(Event.ENTER_FRAME,incSplash);
			}
			//Move the cb out of sight
			this.cbMC.cb.x-=40;
		}
		
		protected function incExplosion(evt:Event)
		{
			if(animationsLeft > 0)
			{
				cbMC.animation.x-=40;
				animationsLeft--;
			}
			else
			{
				dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
				this.removeEventListener(Event.ENTER_FRAME,incExplosion);
			}
			
		}
		
		protected function incSplash(evt:Event)
		{
			if(animationsLeft > 0)
			{
				cbMC.splash.x-=40;
				animationsLeft--;
			}
			else
			{
				this.removeEventListener(Event.ENTER_FRAME,incSplash);
				dispatchEvent(new GameEvent(GameEvent.ANIM_DONE));
			}
		}
		
	}
}