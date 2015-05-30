package game.logic{
	
	import constants;
	import game.ShipFactory;
	import game.accessPoints.GameInformation;

	public class CollisionMechanics implements CollisionMechanicsInterface
	{
		
		protected var moveList;
		protected var damageTable;
		protected var shipList;
		protected var board;		
		protected var sinkPhase;//So that you can find out the turn in the sink function
		protected var phase, turn;
		
		
		public function CollisionMechanics():void{}
		/*
			This function gets all the relevant tables from the server and replaces them
			with the relevant moves after collision mechanics are taken into account.
		*/
		public function calculateMoves(b:Object, s:Object):Object
		{
			/*
				The ship list contains all the information about the type of ship and the class etc. but not damage.
				Damage is in the damage table
			*/
			board = b;
			// Copy the ships array into the ships list
			shipList = new Array();
			for (var shipNo in s) {
				shipList.push(ShipFactory.copyShip(s[shipNo]));
			}
			// The data that didn't need to get communicated got removed so this needs to be rebuilt
			var tempMoveList = GameInformation.movesTable;
			damageTable = GameInformation.damageTable;
			
			// Expand the moves out
			var noPlayers:int = GameInformation.numberOfShips;
			moveList = new Array();
			for(var player = 0; player < noPlayers; player++)
			{
				moveList.push(new Array());
				for(turn = 0; turn < 4; turn++)
				{
					moveList[player].push(new Move(tempMoveList[player][turn][0], tempMoveList[player][turn][1], tempMoveList[player][turn][2]));
				}
				moveList[player].push(false);
			}
						
			// Cycle through each turn of moves
			for(turn = 0; turn < 4; turn++)
			{				
				phase = 0;
				for(player = 0; player < shipList.length; player++)
				{
					checkRockCollisions(turn,player,1);
					for(var k = 0;k < shipList.length;k++)
					{						
						if(player!=k)
						checkCollisions(turn,player,k,1);								
					}
				}
				//Update all the ship positions
				for(player = 0; player < shipList.length; player++)
				{
					switch(moveList[player][turn].getShoved())
					{
						case "U":
							moveList[player][turn].setMoveType("X");
							shipList[player].yBoardPos = shipList[player].yBoardPos - 1;
							break;
						case "R":
							moveList[player][turn].setMoveType("X");
							shipList[player].xBoardPos = shipList[player].xBoardPos + 1;
							break;
						case "D":
							moveList[player][turn].setMoveType("X");
							shipList[player].yBoardPos = shipList[player].yBoardPos + 1;
							break;
						case "L":
							moveList[player][turn].setMoveType("X");
							shipList[player].xBoardPos = shipList[player].xBoardPos - 1;
							break;
					}
					switch(moveList[player][turn].getMoveType())
					{						
						case "L":
							if(moveList[player][turn].getCollisionPhase() == 0)
							{
								shipList[player].xBoardPos = shipList[player].xBoardPos + mySin(shipList[player].rot);
								shipList[player].yBoardPos = shipList[player].yBoardPos - myCos(shipList[player].rot);
							}
							
							shipList[player].rot = shipList[player].rot - 90;
							if(shipList[player].rot==-90)
							shipList[player].rot=270;
							break;
						case "F":
							if(moveList[player][turn].getCollisionPhase()==0)
							{
								shipList[player].xBoardPos = shipList[player].xBoardPos + mySin(shipList[player].rot);
								shipList[player].yBoardPos = shipList[player].yBoardPos - myCos(shipList[player].rot);
							}
							break;
						case "R":
							if(moveList[player][turn].getCollisionPhase()==0)
							{
								shipList[player].xBoardPos = shipList[player].xBoardPos + mySin(shipList[player].rot);
								shipList[player].yBoardPos = shipList[player].yBoardPos - myCos(shipList[player].rot);
							}
							shipList[player].rot = shipList[player].rot + 90;
							if(shipList[player].rot==360)
							shipList[player].rot=0;
							break;
					}
					
					
				}
				//PHASE 2
				//SHIP-ROCK
				for(player = 0; player < shipList.length; player++)
				{					
					if(moveList[player][turn].getMoveType()!="F")
					{
						if(moveList[player][turn].getCollisionPhase()==0 )
							checkRockCollisions(turn,player,2);
						
					}
				}
				//SHIP-SHIP
				for(player = 0; player < shipList.length; player++)
				{					
					if(moveList[player][turn].getMoveType()!="F")
					{
						for(k = 0; k < shipList.length; k++)
						{						
							if(player != k)
							checkCollisions(turn,player,k,2);
						}
					}
				}
				//Update all the ship positions
				for(player = 0; player < shipList.length; player++)
				{
					switch(moveList[player][turn].getMoveType())
					{						
						case "L":						
						case "R":
							if(moveList[player][turn].getCollisionPhase()==0)
							{
								shipList[player].xBoardPos = shipList[player].xBoardPos + mySin(shipList[player].rot);
								shipList[player].yBoardPos = shipList[player].yBoardPos - myCos(shipList[player].rot);
							}
							break;
					}
				}	
				//PHASE 3
				phase = 1;
				//Add the wind tile actions				
				for(player = 0; player < shipList.length; player++)
				{
					
					moveList[player][turn].setTileAction(board[shipList[player].xBoardPos][shipList[player].yBoardPos].tileMove);
					moveList[player][turn].setTileActionActingRotation(board[shipList[player].xBoardPos][shipList[player].yBoardPos].actingRotation);
				}
				//Needs all the wind moves to be entered before it can check collisions
				for(player = 0; player < shipList.length; player++)
				{					
					switch(moveList[player][turn].getTileAction())
					{
						
						//Rights can never collide with other rights, so just mark everything from the forwards collisions
						case "F":
							if(board[shipList[player].xBoardPos + mySin(moveList[player][turn].getTileActionActingRotation())][shipList[player].yBoardPos - myCos(moveList[player][turn].getTileActionActingRotation())].barrier)
							{
								moveList[player][turn].setTileActionCollisionPhase(1);
								addRockRam(player);
							}						
							for(var secondPlayer = 0; secondPlayer < shipList.length; secondPlayer++)
							{
								if(player!=secondPlayer)
								{
									//both forwards and rights both go into the same square so only two cases are needed
									//one for the other ship moving, and one for them not moving
									var xTarget = shipList[secondPlayer].xBoardPos;
									var yTarget = shipList[secondPlayer].yBoardPos;
									if(moveList[secondPlayer][turn].getTileAction() == "F")
									{
										xTarget = shipList[secondPlayer].xBoardPos + mySin(moveList[secondPlayer][turn].getTileActionActingRotation());
										yTarget = shipList[secondPlayer].yBoardPos - myCos(moveList[secondPlayer][turn].getTileActionActingRotation());																							   
									}
									else if(moveList[secondPlayer][turn].getTileAction() == "R")
									{
										var angle = moveList[secondPlayer][turn].getTileActionActingRotation()
										switch(angle)
										{									
											case 0:
												xTarget++;
												yTarget--;
												break;
											case 180:
												xTarget--;
												yTarget++;
												break;
											case 270:
												xTarget--;
												yTarget--;
												break;
											case 90:									
												xTarget++;
												yTarget++;
												break;
										}
									}
									if(shipList[player].xBoardPos + mySin(moveList[player][turn].getTileActionActingRotation()) == xTarget && shipList[player].yBoardPos - myCos(moveList[player][turn].getTileActionActingRotation()) == yTarget)
									{
										//Check for bumps
										if(moveList[secondPlayer][turn].getTileAction()=="X" && 
										   !board[shipList[secondPlayer].xBoardPos + mySin(moveList[player][turn].getTileActionActingRotation())][shipList[secondPlayer].yBoardPos - myCos(moveList[player][turn].getTileActionActingRotation())].barrier &&
											!(shipList[player].shipClass < shipList[secondPlayer].shipClass))
										{
											//Check no ships are in that square/moving into it
											var collided = false;
											for(var thirdPlayer = 0; thirdPlayer < shipList.length; thirdPlayer++)
											{
												if(thirdPlayer != secondPlayer)
												{
													xTarget = shipList[thirdPlayer].xBoardPos;
													yTarget = shipList[thirdPlayer].yBoardPos;
													
													if(moveList[thirdPlayer][turn].getTileAction() == "F")
													{
														xTarget = shipList[thirdPlayer].xBoardPos + mySin(moveList[thirdPlayer][turn].getTileActionActingRotation());
														yTarget = shipList[thirdPlayer].yBoardPos - myCos(moveList[thirdPlayer][turn].getTileActionActingRotation());																							
													}
													if(shipList[secondPlayer].xBoardPos + mySin(moveList[player][turn].getTileActionActingRotation()) == xTarget && shipList[secondPlayer].yBoardPos - myCos(moveList[player][turn].getTileActionActingRotation()) == yTarget)
													collided = true;
												}
											}
											if(!collided)
											{
												moveList[secondPlayer][turn].setTileAction("F");
												moveList[secondPlayer][turn].setTileActionActingRotation(moveList[player][turn].getTileActionActingRotation());
											}
										}
										moveList[player][turn].setTileActionCollisionPhase(1);
										
										if(moveList[secondPlayer][turn].getTileAction() == "R")
										moveList[secondPlayer][turn].setTileActionCollisionPhase(2);
										
										//Add damage - only add to the k ship if the k ship wasn't going forwards, else it will be added twice
										var goingForwards = false;
										if(moveList[secondPlayer][turn].getTileAction() != "F")
										goingForwards = true;
										addRam(player,secondPlayer,goingForwards);
										
									}
								}
							}
					}
				}
				
				//Update the ship position and rotation from the tile actions
				for(player = 0; player < shipList.length; player++)
				{
					var angleDeg = moveList[player][turn].getTileActionActingRotation();
					
					switch(moveList[player][turn].getTileAction())
					{						
						case "R":								
							shipList[player].xBoardPos = shipList[player].xBoardPos + mySin(angleDeg);
							shipList[player].yBoardPos = shipList[player].yBoardPos - myCos(angleDeg);
								
							shipList[player].rot = shipList[player].rot + 90;
							if(shipList[player].rot==360)
							shipList[player].rot=0;
							
							if(moveList[player][turn].getTileActionCollisionPhase() == 0)
							{
								shipList[player].xBoardPos = shipList[player].xBoardPos + mySin((angleDeg+90)%360);
								shipList[player].yBoardPos = shipList[player].yBoardPos - myCos((angleDeg+90)%360);
							}
							break;
						case "F":
							if(moveList[player][turn].getTileActionCollisionPhase() == 0)
							{
								shipList[player].xBoardPos = shipList[player].xBoardPos + mySin(angleDeg);
								shipList[player].yBoardPos = shipList[player].yBoardPos - myCos(angleDeg);
							}
							break;
					}
				}
				phase = 2;
				//Work out how many spaces until a cannon hits something
				for(player = 0; player < shipList.length; player++)
				{
					//Left cannons
					if(moveList[player][turn].getLeftCannonsFired() > 0)
					moveList[player][turn].setLeftCannonsCollisionTime(checkCannonCollisions(player,
																							 moveList[player][turn].getLeftCannonsFired(),
																							 ((shipList[player].rot-90)+360)%360));
																						   
					//Right cannons
					if(moveList[player][turn].getRightCannonsFired() > 0)
					moveList[player][turn].setRightCannonsCollisionTime(checkCannonCollisions(player,
																							 moveList[player][turn].getRightCannonsFired(),
																							 (shipList[player].rot+90)%360));
				}
			}
			//Add to the moves_table all the expected final positions incase there is a synchronisation error
			moveList.push(new Array(shipList.length));
			for(player = 0; player < shipList.length; player++)
			{
				moveList[shipList.length][player] = new Array(2);
				moveList[shipList.length][player][0] = shipList[player].xBoardPos;//Given in tile co-ordinates
				moveList[shipList.length][player][1] = shipList[player].yBoardPos;//Given in tile co-ordinates
			}
			
			//Reset all the sunken ships damage to 0
			for(player = 0; player < shipList.length; player++)
			{
				if(damageTable[player]==-1)
				damageTable[player]=0;
			}
			
			// Used in unit tests
			GameInformation.finalCollisionMechanicsShipInformation = shipList;
			
			//Return the animation information, causes animation to start
			return moveList;
		}
		protected function addRockRam(player)
		{
			var iClass = shipList[player].shipClass;
			
			damageTable[player]+=constants.ROCK_DAMAGE[iClass];
			if(damageTable[player]>=shipList[player].maxDamage)
			damageTable[player]=shipList[player].maxDamage;//You can't sink on a rock ram
		}
		
		protected function addRam(player, secondPlayer,both:Boolean = false)//in the winds there is only one check, so add damage to both
		//Also ramming a stationary ship causes both to add damage
		//All others will call this function twice to get the same effect
		{
			var playerShipClass:int = shipList[player].shipClass;
			var secondPlayerShipClass:int = shipList[secondPlayer].shipClass;
			
			var friendlyFire:int = 1;
			var teamsTable:Object = GameInformation.teamsTable;
			if(teamsTable[player] == teamsTable[secondPlayer])//Friendly fire
			friendlyFire = 0.5;
			
			if(damageTable[player] != -1)//Don't add damage to an already sunken ship
			damageTable[player]+=constants.RAM_DAMAGE[playerShipClass] * friendlyFire;
			if(both && damageTable[secondPlayer] != -1)//Don't add damage to an already sunken ship
			damageTable[secondPlayer]+=constants.RAM_DAMAGE[playerShipClass] * friendlyFire;
			
			//Check for sinks
			if(damageTable[player]>=shipList[player].maxDamage)
			sink(player);
			if(damageTable[secondPlayer]>=shipList[secondPlayer].maxDamage)
			sink(secondPlayer);			
		}
		
		protected function cbHit(player:int, secondPlayer:int, noCannons:int):void
		{
			if(shipList[player].xBoardPos > 3 && shipList[secondPlayer].xBoardPos > 3 && shipList[player].xBoardPos < 34 && shipList[secondPlayer].xBoardPos < 34)//If you both are outside the safe zone
			{
				var playerShipClass = shipList[player].shipClass;
				var damage;
				if(playerShipClass == 0)
				damage = noCannons;
				else if (playerShipClass == 1)
				damage = noCannons/2*3;
				else
				damage = noCannons*2;
				
				var object = new Object();
				object.hitShip = secondPlayer;
				object.shootingShip = player;
				object.noCannons = noCannons;
				GameInformation..sendMessage(constants.CB_HIT, object);
				
				if(GameInformation.friendlyFire)
				{				
					var teamsTable = GameInformation.teamsTable;
					if(teamsTable[player] == teamsTable[secondPlayer])//Friendly fire
					damage /= 2;
				}
				
				if(damageTable[secondPlayer] != -1)//Don't add more damage to an already sunk ship
				damageTable[secondPlayer] += damage;
				if(damageTable[secondPlayer] >= shipList[secondPlayer].maxDamage)					
				sink(secondPlayer);
			}
		}
		
		protected function sink(ship)
		{
			damageTable[ship] = -1;//Mark the entry to not be updated, will be converted to a 0 at the end
			//i = turn
			moveList[ship][turn].setShipSunk(phase);
			//Remove all of its moves, and set its temps to 0 so it doesn't factor into any collisions
			if(phase < 4)
			{
				moveList[ship][turn].clearCannonsFired();
			}
			for(var player = turn+1; player < 4; player++)
			{
				moveList[ship][player] = new Move("X",0,0);
			}
		}
		
		protected function checkCannonCollisions(ship,noCannons,actingRotation)
		{
			var xBoardPos = shipList[ship].xBoardPos;
			var yBoardPos = shipList[ship].yBoardPos;
			
			for(var tileDistance = 1; tileDistance < 4; tileDistance++)
			{
				for(var player = 0; player < shipList.length; player++)
				{
					if(shipList[player].xBoardPos == xBoardPos + (tileDistance * mySin(actingRotation)) &&
					   shipList[player].yBoardPos == yBoardPos - (tileDistance * myCos(actingRotation)))
					{
						cbHit(ship,player,noCannons);
						return tileDistance;
					}
				}
				if(board[xBoardPos + (tileDistance * mySin(actingRotation))][yBoardPos - (tileDistance * myCos(actingRotation))].cbBarrier)
				return tileDistance;
			}
			return 4;//It never hits anything
		}
		
		protected function checkRockCollisions(turn:int, player:int, phase:int):void
		{
			switch(moveList[player][turn].getMoveType())
			{
				case "X": break;
				case "L": 
				case "F": 
				case "R": 							
					if(board[shipList[player].xBoardPos + mySin(shipList[player].rot)][shipList[player].yBoardPos - myCos(shipList[player].rot)].barrier)
					{
						addRockRam(player);
						moveList[player][turn].setCollisionPhase(phase);//Mark the ship as colliding
					}
					break;
			}
		}
		
		protected function checkCollisions(turn:int, player:int, secondPlayer:int, phase:int)
		{
			if(damageTable[player] == -1 || damageTable[secondPlayer] == -1)//Don't count a sink ship in collision mechanics
			return;
			var myrot:int = shipList[player].rot;
			var myX:int = shipList[player].xBoardPos;
			var myY:int = shipList[player].yBoardPos;
			var opprot = shipList[secondPlayer].rot;
			var oppX:int = shipList[secondPlayer].xBoardPos;
			var oppY:int = shipList[secondPlayer].yBoardPos;								
						
			
			if(moveList[player][turn].getCollisionPhase() == 0)
			{
				if((myX + mySin(myrot) == oppX + mySin(opprot)) &&
				   (myY - myCos(myrot) == oppY - myCos(opprot)) &&
				   (moveList[player][turn].getMoveType() != "X") &&//My move
				   (moveList[secondPlayer][turn].getMoveType() != "X") &&//Opponents move		
				   (moveList[secondPlayer][turn].getCollisionPhase() != 1 || phase != 2) &&
				   (phase==1 || (moveList[player][turn].getMoveType() != "X" && moveList[secondPlayer][turn].getMoveType() != "F")))  //This does not apply when in phase 2, so ignore this collision if that is the case
				{
					addRam(player,secondPlayer);
					//If you aren't bigger than them you can't get the square
					if(shipList[player].shipClass <= shipList[secondPlayer].shipClass)
					{
						moveList[player][turn].setCollisionPhase(phase);
					}
				}
				
				//The second case is that they are both trying to claim each others square
				if((myX + mySin(myrot) == oppX) &&
				   (myY - myCos(myrot) == oppY) &&
				   (oppX + mySin(opprot) == myX) &&
				   (oppY - myCos(opprot) == myY) &&
				   //Forwards should not be included in this for the second phase
				   (
					((moveList[player][turn].getMoveType() != "X") && (moveList[secondPlayer][turn].getMoveType() != "X") && phase==1) ||
					((moveList[player][turn].getMoveType() != "X") && (moveList[secondPlayer][turn].getMoveType() != "X") &&
					 (moveList[player][turn].getMoveType() != "F") && (moveList[secondPlayer][turn].getMoveType() != "F") && phase==2)
				   ))   
				{
					//If you are both moving into each others squares you always bump
					addRam(player,secondPlayer);
					moveList[player][turn].setCollisionPhase(phase);
					
				}
				
				
				//The third case is a ship trying to claim the spot of a stationary ship
				if((myX + mySin(myrot) == oppX) &&
				   (myY - myCos(myrot) == oppY) &&
				   (moveList[player][turn].getMoveType() != "X") &&
				   (moveList[secondPlayer][turn].getMoveType() == "X"))
				{
					//If You are turning, you collide
					if(moveList[player][turn].getMoveType()!="F")
					{
						moveList[player][turn].setCollisionPhase(phase);
					}
					else//You are going forwards
					{									
						//If you are bigger than them, they get shoved and you claim the space with a collision
						if(shipList[player].shipClass > shipList[secondPlayer].shipClass)
						{
							//Other ship gets shoved
							//Check if its safe to bump them! (No rocks/ships in the way)
							if(!board[shipList[secondPlayer].xBoardPos + mySin(shipList[player].rot)][shipList[secondPlayer].yBoardPos - myCos(shipList[player].rot)].barrier)
							{
								//Check no ships are in that square/moving into it
								var collided = false;
								var xTarget, yTarget;
								for(var thirdPlayer = 0; thirdPlayer < shipList.length; thirdPlayer++)
								{
									if(thirdPlayer!=secondPlayer && thirdPlayer!=player)
									{
										xTarget = shipList[thirdPlayer].xBoardPos;
										yTarget = shipList[thirdPlayer].yBoardPos;
										
										if(moveList[thirdPlayer][turn].getMoveType()!="X")
										{
											xTarget = shipList[thirdPlayer].xBoardPos + mySin(shipList[thirdPlayer].rot);
											yTarget = shipList[thirdPlayer].yBoardPos - myCos(shipList[thirdPlayer].rot);																							
										}
										if(shipList[secondPlayer].xBoardPos + mySin(shipList[player].rot) == xTarget && shipList[secondPlayer].yBoardPos - myCos(shipList[player].rot) == yTarget)
										{
											//TODO:Add Damage
											collided = true;
											moveList[thirdPlayer][turn].setCollisionPhase(1);
										}
									}
								}
								if(!collided)
								moveList[secondPlayer][turn].setShoved(getShove(shipList[player].rot));
								else
								moveList[player][turn].setCollisionPhase(phase);
							}
							else
							moveList[player][turn].setCollisionPhase(phase);
						}									
						//If you are the same size as them, they get bumped backwards
						else if(shipList[player].shipClass == shipList[secondPlayer].shipClass)
						{
							moveList[player][turn].setCollisionPhase(phase);
							if(!board[shipList[secondPlayer].xBoardPos + mySin(shipList[player].rot)][shipList[secondPlayer].yBoardPos - myCos(shipList[player].rot)].barrier)
							{
								//Check no ships are in that square/moving into it
								collided = false;
								xTarget, yTarget;
								for(thirdPlayer = 0; thirdPlayer < shipList.length; thirdPlayer++)
								{
									if(thirdPlayer != secondPlayer && thirdPlayer != player)
									{
										xTarget = shipList[thirdPlayer].xBoardPos;
										yTarget = shipList[thirdPlayer].yBoardPos;
										
										if(moveList[thirdPlayer][turn].getMoveType()!="X")
										{
											xTarget = shipList[thirdPlayer].xBoardPos + mySin(shipList[thirdPlayer].rot);
											yTarget = shipList[thirdPlayer].yBoardPos - myCos(shipList[thirdPlayer].rot);																							
										}
										if(shipList[secondPlayer].xBoardPos + mySin(shipList[player].rot) == xTarget && shipList[secondPlayer].yBoardPos - myCos(shipList[player].rot) == yTarget)
										{
											addRam(secondPlayer,thirdPlayer,true);
											collided = true;
											moveList[thirdPlayer][turn].setCollisionPhase(1);
										}
									}
								}
								if(!collided)
								moveList[secondPlayer][turn].setShoved(getShove(shipList[player].rot));
							}
						}
						else{
							//Else you were smaller and no bump occurs, but a collision occurs
							moveList[player][turn].setCollisionPhase(phase);
						}
						
					}
					//The k ship is stationary so it will never be checked
					addRam(player,secondPlayer,true);
				}
				
				//Case for a turning ship turning into a spot occupied by a ship that has gone forwards
				if((myX + mySin(myrot) == oppX) &&
				   (myY - myCos(myrot) == oppY) &&
				   (moveList[player][turn].getMoveType() != "X") &&
				   (moveList[player][turn].getMoveType() != "F") &&
				   (moveList[secondPlayer][turn].getMoveType() == "F") &&
				   phase == 2)
				{
					moveList[player][turn].setCollisionPhase(phase);
					addRam(player,secondPlayer,true);
				}
				
				//Case for trying to claim a square that has been claimed by a ship involved in another collision
				if(phase==2 &&
				   (myX + mySin(myrot) == oppX) &&
				   (myY - myCos(myrot) == oppY) &&
				   (moveList[player][turn].getMoveType() != "X") &&
				   (moveList[player][turn].getMoveType() != "F") &&
				   (moveList[secondPlayer][turn].getCollisionPhase() != 0))
				{
					moveList[player][turn].setCollisionPhase(phase);
					addRam(player,secondPlayer,true);
				}
				
				//Case for a ship trying to claim the square occupied by a ship in phase 0, that hasn't moved at all because of a ram
				if( phase == 1 &&
				   (myX + mySin(myrot) == oppX) &&
				   (myY - myCos(myrot) == oppY) &&
				   (moveList[player][turn].getMoveType() != "X") &&
				   (moveList[secondPlayer][turn].getCollisionPhase() != 0))
				{
					moveList[player][turn].setCollisionPhase(phase);
				}
			}
		}
		
		protected function getShove(rot)
		{
			switch(rot)
			{
				case 0:
					return "U";
				case 90:
					return "R";
				case 180:
					return "D";
				case 270:
				case -90:
					return "L";
			}
		}
		/*
		There are alot of problems with rounding conversions, so defined my own functions to avoid this problem, and had them based in
		degrees to avoid conversion confusion
		*/
		protected function mySin(number:Number):int
		{
			number = (Math.round(number)+360)%360;
			switch(number)
			{
				case 0:
				case 180:
					return 0;					
				case 90:
					return 1;
				case 270:
					return -1;
			}
			return null;
		}
		
		protected function myCos(number:Number):int
		{
			number = (Math.round(number)+360)%360;
			switch(number)
			{
				case 0:
					return 1;
				case 180:
					return -1;					
				case 90:
				case 270:
					return 0;
			}
			return null;
		}
	}
}