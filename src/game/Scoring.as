package game 
{
	
	import game.accessPoints.GameInformation;
	import game.logic.Flag;
	import game.Ship;
	import game.ShipGUI;
	import game.accessPoints.GameGUI;
	
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class Scoring 
	{
		
		public function Scoring() 
		{
			throw Error("Scoring is a singleton class that should not be instantiated");
		}
		
		public static function updatePoints():void
		{
			var flagsArray:Array = GameInformation.flagsArray;
			var shipsTable:Array = GameInformation.shipsTable;
			// Declare any variables
			var flagNo:String, shipNo:String, sunkShipNo:String, influenceSquareNo:String;
			var flag:Flag, ship:Ship, influenceSquare:Array, shipsTeam:int;
			
			// Reset all flag influence back to NONE
			for (flagNo in flagsArray) {
				flagsArray[flagNo].resetInfluence();
			}
			
			// Declare some constants for use with the influence square arrays to make the code slightly more readable
			const X_OFFSET:int = 0;
			const Y_OFFSET:int = 1;
			
			// Go through each ship, calculating which flags it has influence over and marking those flags accordingly
			for(shipNo in shipsTable)
			{
				ship = shipsTable[shipNo];
				shipsTeam = ship.team;
				// Sunk ships can't influence flags, so work out if the ship has been sunk
				var sunkShip:Boolean = false;
				var sunkShips:Array = GameInformation.sunkShips;
				for(sunkShipNo in sunkShips)
				{
					if(shipNo == sunkShips[sunkShipNo])
					{
						sunkShip = true;
						break;
					}
				}
				if(!sunkShip)
				{
					switch(ship.shipClass)
					{
						/*
							These loops check whether the flag in question is within the influence range of the ship.
							In constants, there is a list of offsets that are in the influence range, if any of these match the flags position
							then it must be within the ships influence.
							Every bigger ship can influence what a smaller ship can, so just stack them up.
						*/
						
						case 2:
							// War frig
							for(flagNo in flagsArray)
							{
								flag = flagsArray[flagNo];
								for(influenceSquareNo in constants.FRIG_INFLUENCE)
								{									
									influenceSquare = constants.FRIG_INFLUENCE[influenceSquareNo];
									if(flag.xBoardPos == ship.xBoardPos + influenceSquare[X_OFFSET] &&
									   flag.yBoardPos == ship.yBoardPos + influenceSquare[Y_OFFSET])
									{				
										flag.addInfluence(shipsTeam);
									}
								}							
							}
						case 1:
							// War brig
							for(flagNo in flagsArray)
							{
								flag = flagsArray[flagNo];
								for(influenceSquareNo in constants.BRIG_INFLUENCE)
								{
									influenceSquare = constants.BRIG_INFLUENCE[influenceSquareNo];
									if(flag.xBoardPos == ship.xBoardPos + influenceSquare[X_OFFSET] &&
									   flag.yBoardPos == ship.yBoardPos + influenceSquare[Y_OFFSET])
									{
										flag.addInfluence(shipsTeam);
									}
								}							
							}
						case 0:
							// Sloop (there is only one square that a sloop can influence, so there's no need to use any constants)
							for(flagNo in flagsArray)
							{
								flag = flagsArray[flagNo];
								if(flag.xBoardPos == ship.xBoardPos &&
								   flag.yBoardPos == ship.yBoardPos)
								{
									flag.addInfluence(shipsTeam);
								}
							}
					}
				}
			}
			
			// Calculate the number of points based on the status of the flags
			var teamOnePoints:int = 0;
			var teamTwoPoints:int = 0;
			for(flagNo in flagsArray)
			{		
				flag = flagsArray[flagNo];
				if (flag.influence == Flag.TEAM_ONE) {
					teamOnePoints += flag.points;
				} else if (flag.influence == Flag.TEAM_TWO) {
					teamTwoPoints += flag.points;
				}			
			}
			
			// Update the points in the UI
			GameGUI.moveInput.updatePoints(new Array(teamOnePoints, teamTwoPoints));
			
			// Update the flags in the UI
			GameInformation.updateFlags();		
		}
		
		public static function checkEndOfGame() :void
		{
			//Check for the end of the game
			if(GameInformation.endOfGame)
			{
				GameInformation.endGame();				
			}
		}
	}

}