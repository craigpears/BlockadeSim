package game.logic
{
	
	public class Move
	{

		/*
			Old array indices:
			Each sub part is:
			0 - Standard move
			1 - Used to mark collisions for normal moves, signals which phase a collision occured in
			2 - Used to indicate a shove			
			3 - Tile actions
			4 - The acting rotation of the tile action
			5 - Used to mark collisions for the tile actions
			6 - Cannons to the left side			
			7 - Cannons to the right side
			8 - Spaces until the cannons to the left hit something
			9 - Spaces until the cannons to the right hit something
			10 - whether the ship sinks or not
			11 - Phase that it sank in
			Fifth item - Whether an update has occured in this turn or not(used in resetting moves)
		*/
		protected var _moveType:String;
		protected var _collisionPhase:int = 0;
		protected var _shoved:String = "X";
		protected var _tileAction:String = "X";
		protected var _tileActionActingRotation:int;
		protected var _tileActionCollisionPhase:int = 0;
		protected var _leftCannonsFired:int = 0;
		protected var _rightCannonsFired:int = 0;
		protected var _leftCannonsCollisionTime:int;
		protected var _rightCannonsCollisionTime:int;
		protected var _shipSunk:Boolean = false;
		protected var _sinkPhase:int;
		
		public function Move(moveType:String, leftCannonsFired:int, rightCannonsFired:int) 
		{
			_moveType = moveType;
			_leftCannonsFired = leftCannonsFired;
			_rightCannonsFired = rightCannonsFired;
		}
		
		public function setMoveType(moveType:String){ _moveType = moveType;}
		public function setCollisionPhase(phase:int){ _collisionPhase = phase;}
		public function setShoved(shoved:String){ _shoved = shoved;}
		public function setTileAction(tileAction:String){ _tileAction = tileAction;}
		public function setTileActionActingRotation(actingRotation:int){ _tileActionActingRotation = actingRotation;}
		public function setTileActionCollisionPhase(collisionPhase:int){ _tileActionCollisionPhase = collisionPhase;}
		public function setLeftCannonsCollisionTime(time:int){ _leftCannonsCollisionTime = time;}
		public function setRightCannonsCollisionTime(time:int){ _rightCannonsCollisionTime = time;}
		
		public function getMoveType(){ return _moveType;}
		public function getCollisionPhase(){ return _collisionPhase;}
		public function getShoved(){ return _shoved;}
		public function getTileAction(){ return _tileAction;}
		public function getTileActionActingRotation(){ return _tileActionActingRotation;}
		public function getTileActionCollisionPhase(){ return _tileActionCollisionPhase;}
		public function getLeftCannonsFired(){ return _leftCannonsFired;}
		public function getRightCannonsFired(){ return _rightCannonsFired;}
		public function getLeftCannonsCollisionTime(){ return _leftCannonsCollisionTime;}
		public function getRightCannonsCollisionTime(){ return _rightCannonsCollisionTime;}
		public function getShipSunk(){ return _shipSunk;}
		public function getSinkPhase(){ return _sinkPhase;}
		
		public function clearCannonsFired()
		{
			_leftCannonsFired = 0;
			_rightCannonsFired = 0;
		}
		
		public function setShipSunk(phase:int)
		{
			_shipSunk = true;
			_sinkPhase = phase;
		}
	}	
}
