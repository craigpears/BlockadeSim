package setup
{
	import flash.display.*;
	import flash.events.*;
	import constants;
	import game.accessPoints.GameInformation;
	
	public class ChooseShip extends ChooseShipMC
	{
		
		public function ChooseShip()
		{
			this.frigGlow.visible = true;
			this.brigGlow.visible = false;
			this.sloopGlow.visible = false;
			
			weak.visible = true;
			normal.visible = true;
			elite.visible = false;
			weakGlow.visible = false;
			normalGlow.visible = false;
			eliteGlow.visible = true;
			
			this.sloop.addEventListener(MouseEvent.CLICK,clickFunc);
			this.brig.addEventListener(MouseEvent.CLICK,clickFunc);
			this.frig.addEventListener(MouseEvent.CLICK,clickFunc);
			
			this.weak.addEventListener(MouseEvent.CLICK,jobberClick);
			this.normal.addEventListener(MouseEvent.CLICK,jobberClick);
			this.elite.addEventListener(MouseEvent.CLICK,jobberClick);
		}
		
		public function jobberClick (evt:Event)
		{
			weak.visible = true;
			normal.visible = true;
			elite.visible = true;
			weakGlow.visible = false;
			normalGlow.visible = false;
			eliteGlow.visible = false;
			
			var jobberLevel;
			switch(evt.target)
			{
				case this.weak: 
					jobberLevel = "Weak";
					weak.visible = false;
					weakGlow.visible = true;
					break;
				case this.normal:
					jobberLevel = "Normal";
					normal.visible = false;
					normalGlow.visible = true;
					break;
				case this.elite:
					jobberLevel = "Elite";
					elite.visible = false;
					eliteGlow.visible = true;
					break;
			}
			
			var msg = new Object();
			msg[0] = GameInformation.getMyPosition();
			msg[1] = jobberLevel;
			GameInformation.sendMessage(constants.CHANGE_JOBBER_LEVEL, msg);
		}
		
		public function clickFunc (evt:Event) {
			this.frigGlow.visible = false;
			this.brigGlow.visible = false;
			this.sloopGlow.visible = false;
			
			var shipType;
			switch(evt.target)
			{
				case this.sloop: 
					this.sloopGlow.visible = true;
					shipType = "Sloop";
					break;
				case this.brig: 
					this.brigGlow.visible = true;
					shipType = "Brig";
					break;
				case this.frig: 
					this.frigGlow.visible = true;
					shipType = "Frig";
					break;
			}
			
			var msg = new Object();
			msg[0] = GameInformation.getMyPosition();
			msg[1] = shipType;
			GameInformation.sendMessage(constants.CHANGE_SHIP, msg);
			
		}

		
	}
}