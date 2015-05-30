package unitTests
{
	
	import game.logic.CollisionMechanics;
	import game.MoveInput;
	import constants;
	import flash.display.Sprite;
	import com.whirled.game.GameControl;	
	import game.Board;
	import game.accessPoints.GameInformation;
	import game.Ship;
	
	public class UnitTests extends Sprite
	{
		protected var testsPassed:int = 0;
		protected var testsFailed:int = 0;
		
		public function UnitTests():void{}
		
		public function runAllTests():void
		{
			collisionMechanicsUnitTests();
			trace("");
			trace("================================");
			trace(testsPassed+" tests passed");
			trace(testsFailed + " tests failed");
			trace("================================");
		}
		
		protected var moveList:Array = new Array(3);
		protected var shipList:Array = new Array();	
		protected var finalShipInformation:Object;
		protected var returnMoveList:Object;
		
		public function assertTrue(result:Boolean):void {
			if (result == true) {
				testsPassed++;
				trace("Passed");
			} else {
				testsFailed++;
				trace("Failed");
			}
		}
		
		public function collisionMechanicsUnitTests():void
		{			
			trace("adding two frigs to the tests");
			shipList.push(new Ship("Frig", 1, "Player 0"));
			shipList.push(new Ship("Frig", 1, "Player 1"));
			shipList.push(new Ship("Frig", 1, "Player 2"));
			
			var board:Board = new Board("Lilac1_1");
			
			const PLAYER_0:int = 0;
			const PLAYER_1:int = 1;
			const PLAYER_2:int = 2;
			
			const TURN_0:int = 0;
			const TURN_1:int = 1;
			const TURN_2:int = 2;
			const TURN_3:int = 3;
			
			const BOARD_LENGTH:int = GameInformation.board.length;
			
			/*Testing that a ship turns left into a rock with a second phase collision*/
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_RIGHT);
			setMoves(PLAYER_0, "L", "X", "X", "X");
			setMoves(PLAYER_1, "X", "X", "X", "X");
			setMoves(PLAYER_2, "X", "X", "X", "X");
			calculateMoves();
			trace("asserting that the ship bumped into the rocks when it went left, and that it is in the correct position");
			assertTrue (returnMoveList[PLAYER_0][TURN_0].getCollisionPhase() == 2
					 && finalShipInformation[PLAYER_0].xBoardPos == 2
					 && finalShipInformation[PLAYER_0].yBoardPos == 1);
			
			/*Testing that a ship turns left into an empty space without a problem */
			setBoardPos(PLAYER_0, 1, 2, constants.ROTATION_RIGHT);			
			setMoves(PLAYER_0, "L", "X", "X", "X");
			calculateMoves();
			
			trace("");			
			trace("asserting that the ship didn't bump when turning  through empty space");
			assertTrue(returnMoveList[PLAYER_0][TURN_0].getCollisionPhase() == 0);
			
			
			trace("");
			trace("asserting that they both bump and neither move when they are in a >< position and both go forwards");			
			setBoardPos(PLAYER_0, 2, 2, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 2, 3, constants.ROTATION_UP);			
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			
			trace("");
			trace("asserting that when they are in a >< position and only the first ship moves, that they move to >X< when of an equal class");
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 4);
			
			
			trace("");
			trace("asserting that when they are in a >< position and only the first ship moves, that they move to X>< when the moving ship is bigger");
			shipList[PLAYER_1] = new Ship("Brig", 1, "Player 1");			
			setBoardPos(PLAYER_1, 2, 3, constants.ROTATION_UP);			
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 3 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 4);
			
			
			trace("");
			trace("asserting that in a ><X position, the ship in the middle can't be shoved if another ship is also claiming that place, and that the ship of concern also encounters a collision");
			shipList[PLAYER_2] = new Ship("Brig", 1, "Player 2");			
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			setMoves(PLAYER_2, "F", "X", "X", "X");
			
			setBoardPos(PLAYER_0, 1, 3, constants.ROTATION_UP);			
			setBoardPos(PLAYER_1, 1, 2, constants.ROTATION_UP);			
			setBoardPos(PLAYER_2, 2, 1, constants.ROTATION_LEFT);			
			calculateMoves();			
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 3 && finalShipInformation[PLAYER_1].xBoardPos == 1 && finalShipInformation[PLAYER_1].yBoardPos == 2);
			
			shipList.pop();
			
			trace("");
			trace("asserting that when they are in a >< position and only the first ship moves, nothing happens if the first ship is smaller, or turning");
			shipList[PLAYER_0] = new Ship("Sloop", 1, "Player 0");			
			setBoardPos(PLAYER_0, 2, 2, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 2, 3, constants.ROTATION_UP);
			
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			setMoves(PLAYER_0, "R", "X", "X", "X");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			setMoves(PLAYER_0, "L", "X", "X", "X");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			
			trace("");
			trace("asserting that when they are in a >< position and only the first ship moves, that nothing happens if there is a rock in the way");
			shipList[PLAYER_1] = new Ship("Brig", 1, "Player 1");			
			setBoardPos(PLAYER_0, 2, 1, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 2, 2, constants.ROTATION_UP);			
			setMoves(PLAYER_0, "X", "X", "X", "X");			
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			calculateMoves();			
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 2);
			
			trace("asserting that when they are in a >< position and only the first ship moves, that nothing happens if there is a ship in the way");
			shipList[PLAYER_2] = new Ship("Brig", 1, "Player 2");			
			setBoardPos(PLAYER_0, 2, 2, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 2, 3, constants.ROTATION_UP);			
			setBoardPos(PLAYER_2, 2, 1, constants.ROTATION_RIGHT);			
			setMoves(PLAYER_2, "X", "X", "X", "X");			
			calculateMoves();
			
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3
															&& shipList[2].xBoardPos == 2 && shipList[2].yBoardPos == 1);
			
			shipList.pop();
			
			trace("");
			trace("asserting that in a >X< position, if both ships try to claim it then neither succeed with the same ship class");
			shipList[PLAYER_0] = new Ship("Sloop", 1, "Player 0");				
			shipList[PLAYER_1] = new Ship("Sloop", 1, "Player 1");			
			setBoardPos(PLAYER_0, 2, 1, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 2, 3, constants.ROTATION_UP);			
			setMoves(PLAYER_0, "R", "X", "X", "X");			
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			setMoves(PLAYER_0, "R", "X", "X", "X");			
			setMoves(PLAYER_1, "L", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "L", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			setMoves(PLAYER_0,"F","X","X","X");
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			trace("asserting that the bigger ship continues as normal in the >X< position");
			shipList[PLAYER_0] = new Ship("Brig", 1, "Player 0");	
			shipList[PLAYER_1] = new Ship("Sloop", 1, "Player 1");			
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 1, 3, constants.ROTATION_UP);			
			setMoves(PLAYER_0, "L", "X", "X", "X");			
			setMoves(PLAYER_1, "F", "X", "X", "X");
			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 1 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			setMoves(PLAYER_0, "R", "X", "X", "X");			
			setMoves(PLAYER_1, "L", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 1 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "L", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 1 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			setMoves(PLAYER_0, "F", "X", "X", "X");			
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 1 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			setMoves(PLAYER_0, "L", "R", "F", "L");			
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			setBoardPos(PLAYER_0,2,1,constants.ROTATION_UP);		
			calculateMoves();
			setBoardPos(PLAYER_0,finalShipInformation[PLAYER_0].xBoardPos,finalShipInformation[PLAYER_0].yBoardPos,finalShipInformation[PLAYER_0].rot);
			setMoves(PLAYER_0, "L", "R", "F", "L");			
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			calculateMoves();
			
			trace("asserting that when a ship turns one space infront of a ship that goes forwards that they don't collide");
			shipList[PLAYER_0] = new Ship("Brig", 1, "Player 0");			
			shipList[PLAYER_1] = new Ship("Brig", 1, "Player 1");				
			setMoves(PLAYER_0, "R", "X", "X", "X");			
			setMoves(PLAYER_1, "F", "X", "X", "X");		
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_RIGHT);			
			setBoardPos(PLAYER_1, 2, 4, constants.ROTATION_UP);			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_0].xBoardPos==2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 3);
			
			trace("checking shooting cannons in open water");			
			setMoves(PLAYER_0, "X", "X", "X", "X", 2, 2);			
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_RIGHT);			
			setBoardPos(PLAYER_1, 30, 0, constants.ROTATION_RIGHT);			
			calculateMoves();
			for(var turnNo:int = 0; turnNo < 4; turnNo++)
			assertTrue(returnMoveList[PLAYER_0][turnNo].getRightCannonsCollisionTime() == 4)
			
			trace("checking that the ship next to the rocks shoots the rocks");
			for (turnNo = 0; turnNo < 4; turnNo++)			
			assertTrue(returnMoveList[PLAYER_0][turnNo].getLeftCannonsCollisionTime() == 1)
			
			setMoves(PLAYER_1, "X", "X", "X", "X", 2, 2);
			setBoardPos(PLAYER_1, 1, 2, constants.ROTATION_RIGHT);
			calculateMoves();
			
			trace("checking that two ships next to each other both shoot each other");
			for (turnNo = 0; turnNo < 4; turnNo++)
			assertTrue(returnMoveList[PLAYER_0][turnNo].getRightCannonsCollisionTime() == 1 && returnMoveList[PLAYER_1][turnNo].getLeftCannonsCollisionTime() == 1)
						
			trace("check that it still works if one of the ships has to move into position");
			setMoves(PLAYER_1,"L","L","F","X",2,2);
			setBoardPos(PLAYER_1,2,4,constants.ROTATION_RIGHT);
			calculateMoves();
			
			for (turnNo = 2; turnNo < 4; turnNo++)			
			assertTrue(returnMoveList[PLAYER_0][turnNo].getRightCannonsCollisionTime() == 1 && returnMoveList[PLAYER_1][turnNo].getRightCannonsCollisionTime() == 1);
					
			trace("");
			trace("all the previous cannon tests with gaps in between");
			trace("");
			trace("checking shooting cannons in open water");
			setMoves(PLAYER_0, "X", "X", "X", "X", 2, 2);			
			setBoardPos(PLAYER_0, 1, 2, constants.ROTATION_RIGHT);			
			setBoardPos(PLAYER_1, 30, 2, constants.ROTATION_RIGHT);			
			calculateMoves();
			for(turnNo = 0; turnNo < 4; turnNo++)
			assertTrue(returnMoveList[PLAYER_0][turnNo].getRightCannonsCollisionTime() == 4)
			
			trace("checking that the ship next to the rocks shoots the rocks");
			for(turnNo = 0; turnNo < 4; turnNo++)
			assertTrue(returnMoveList[PLAYER_0][turnNo].getLeftCannonsCollisionTime() == 2)
			
			setMoves(PLAYER_1, "X", "X", "X", "X", 2, 2);			
			setBoardPos(PLAYER_1, 1, 4, constants.ROTATION_RIGHT);			
			calculateMoves();
			
			trace("checking that two ships next to each other both shoot each other");
			for (turnNo = 0; turnNo < 4; turnNo++)
			assertTrue(returnMoveList[PLAYER_0][turnNo].getRightCannonsCollisionTime() == 2 && returnMoveList[PLAYER_1][turnNo].getLeftCannonsCollisionTime() == 2)
			
			trace("check that it still works if one of the ships has to move into position");
			setMoves(PLAYER_1,"L","L","F","X",2,2);
			setBoardPos(PLAYER_1, 2, 6, constants.ROTATION_RIGHT);
			calculateMoves();
			
			for(turnNo=2; turnNo < 4; turnNo++)
			assertTrue(returnMoveList[PLAYER_0][turnNo].getRightCannonsCollisionTime() == 2 && returnMoveList[PLAYER_1][turnNo].getRightCannonsCollisionTime() == 2);
			
			trace("check that winds dont push you into walls");
			setBoardPos(PLAYER_0,7,1,constants.ROTATION_RIGHT);
			setMoves(PLAYER_0,"X","X","X","X");
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 7 && finalShipInformation[PLAYER_0].yBoardPos == 1);
			
			trace("check that winds/whirlpools dont push you into other ships");
			trace("in a whirlpool");
			setMoves(PLAYER_0, "X", "X", "X", "F");			
			setMoves(PLAYER_1, "X", "X", "X", "L");			
			setBoardPos(PLAYER_0, BOARD_LENGTH - 8, 7, constants.ROTATION_RIGHT);			
			setBoardPos(PLAYER_1, BOARD_LENGTH - 5, 10, constants.ROTATION_UP);			
			calculateMoves();			
			assertTrue(finalShipInformation[PLAYER_1].xBoardPos == BOARD_LENGTH - 7 && finalShipInformation[PLAYER_1].yBoardPos == 9);
			
			
			trace("in a wind");			
			setMoves(PLAYER_0, "X", "X", "X", "F");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			setBoardPos(PLAYER_0, BOARD_LENGTH - 6, 11, constants.ROTATION_UP);			
			setBoardPos(PLAYER_1, BOARD_LENGTH - 5, 10, constants.ROTATION_UP);			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == BOARD_LENGTH - 6 && finalShipInformation[PLAYER_0].yBoardPos == 10);
			
			
			trace("check that if a wind pushes you into a ship that isnt bigger, that they get bumped out of the way");			
			assertTrue(finalShipInformation[PLAYER_1].xBoardPos == BOARD_LENGTH - 4 && finalShipInformation[PLAYER_1].yBoardPos == 10);
			
			
			trace("that if its smaller, nothing happens");			
			shipList[PLAYER_0] = new Ship("Sloop", 1, "Player 0");	
			setMoves(PLAYER_0, "X", "X", "X", "F");			
			setMoves(PLAYER_1, "X", "X", "X", "X");			
			setBoardPos(PLAYER_0, BOARD_LENGTH - 6, 11, constants.ROTATION_UP);			
			setBoardPos(PLAYER_1, BOARD_LENGTH - 5, 10, constants.ROTATION_UP);			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_1].xBoardPos == BOARD_LENGTH - 5 && finalShipInformation[PLAYER_1].yBoardPos == 10);
			
			
			trace("");			
			trace("asserting that when two ships of the same class turn onto the same square they collide");			
			shipList[PLAYER_0] = new Ship("Sloop", 1, "Player 0");			
			shipList[PLAYER_1] = new Ship("Sloop", 1, "Player 1");			
			setMoves(PLAYER_0, "X", "X", "X", "L");
			setMoves(PLAYER_1, "X", "X", "X", "L");
			
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 3, 3, constants.ROTATION_UP);			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 3 && finalShipInformation[PLAYER_1].yBoardPos == 2);
			
			
			trace("");
			trace("asserting that when two ships of a different class turn into the same square, the bigger ship wins");
			shipList[PLAYER_0] = new Ship("Sloop", 1, "Player 0");			
			shipList[PLAYER_1] = new Ship("Brig", 1, "Player 1");			
			setMoves(PLAYER_0, "X", "X", "X", "L");			
			setMoves(PLAYER_1, "X", "X", "X", "L");			
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_DOWN);			
			setBoardPos(PLAYER_1, 3, 3, constants.ROTATION_UP);			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 2);
			
			
			trace("");
			trace("doing a special case test")
			shipList[PLAYER_0] = new Ship("Sloop", 1, "Player 0");			
			shipList[PLAYER_1] = new Ship("Sloop", 1, "Player 1");			
			setMoves(PLAYER_0, "X", "F", "F", "X");			
			setMoves(PLAYER_1, "F", "L", "R", "X");			
			setBoardPos(PLAYER_0, 3, 1, constants.ROTATION_LEFT);			
			setBoardPos(PLAYER_1, 2, 3, constants.ROTATION_UP);			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 1 && finalShipInformation[PLAYER_1].yBoardPos == 1);
			
			
			trace("");
			trace("doing a special case test");			
			shipList[PLAYER_0] = new Ship("Sloop", 1, "Player 0");			
			shipList[PLAYER_1] = new Ship("Sloop", 1, "Player 1");			
			setMoves(PLAYER_0, "L", "X", "X", "X");			
			setMoves(PLAYER_1, "R", "X", "X", "X");			
			setBoardPos(PLAYER_0, 1, 2, constants.ROTATION_RIGHT);			
			setBoardPos(PLAYER_1, 3, 1, constants.ROTATION_LEFT);			
			calculateMoves();			
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 2 && finalShipInformation[PLAYER_0].yBoardPos == 2 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 1);
			
			trace("");
			trace("Checking where one ship rams a rock and the other moves into their square");
			setMoves(PLAYER_0, "L", "X", "X", "X");			
			setMoves(PLAYER_1, "F", "X", "X", "X");			
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_UP);			
			setBoardPos(PLAYER_1, 2, 1, constants.ROTATION_LEFT);			
			calculateMoves();
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 1);
			
			
			
			trace("");
			trace("Checking that a ship that rams a rock in phase one, doesn't affect ships moving in phase two");
			setMoves(PLAYER_0, "R", "X", "X", "X");			
			setMoves(PLAYER_1, "L", "X", "X", "X");			
			setBoardPos(PLAYER_0, 1, 1, constants.ROTATION_UP);			
			setBoardPos(PLAYER_1, 1, 2, constants.ROTATION_RIGHT);			
			calculateMoves();			
			assertTrue(finalShipInformation[PLAYER_0].xBoardPos == 1 && finalShipInformation[PLAYER_0].yBoardPos == 1 && finalShipInformation[PLAYER_1].xBoardPos == 2 && finalShipInformation[PLAYER_1].yBoardPos == 1);
			
				
		}
		
		protected function setMoves(shipNo:int, moveOne:String, moveTwo:String, moveThree:String, moveFour:String, cannonsLeft:int = 0, cannonsRight:int = 0):void
		{
			moveList[shipNo] = new Array([moveOne,  cannonsLeft, cannonsRight],
									     [moveTwo,  cannonsLeft, cannonsRight],
									     [moveThree,cannonsLeft, cannonsRight],
									     [moveFour, cannonsLeft, cannonsRight]);
		}
		
		protected function setBoardPos(shipNo:int, xBoardPos:int, yBoardPos:int, rot:int):void
		{
			shipList[shipNo].xBoardPos = xBoardPos;
			shipList[shipNo].yBoardPos = yBoardPos;
			shipList[shipNo].rot = rot;
		}
		
		protected function calculateMoves():void
		{
			GameInformation.movesTable = moveList;
			GameInformation.shipsTable = shipList;
			var collisionMechanics:CollisionMechanics = new CollisionMechanics();
			returnMoveList = collisionMechanics.calculateMoves(GameInformation.board, GameInformation.shipsTable);
			finalShipInformation = GameInformation.finalCollisionMechanicsShipInformation;
		}
	}
}