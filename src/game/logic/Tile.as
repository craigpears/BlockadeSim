package game.logic
{
	public class Tile
	{
		protected var _barrier:Boolean = false;
		protected var _cbBarrier:Boolean = false;
		protected var _type:uint;
		
		//The rotation that the move caused by this tile acts in
		protected var _actingRotation:int = 0;
		//The move that is caused by moving onto this tile
		protected var _move:String = "X";
		
		protected var _points:uint = 0;
		protected var _safeZone:Boolean = false;
		
		public function Tile(tileNo:uint):void
		{
			/* Each number corresponds to a particular tile */
			/*
				0 = Empty
				1 = Large Rock 
				2 = North wind
				3 = East Wind
				4 = South Wind
				5 = West Wind
				6 = TL Whirlpool
				7 = TR Whirlpool
				8 = BL Whirlpool
				9 = BR Whirlpool
				10 = One Point Flag
				11 = Two Point Flag
				12 = Three Point Flag
				13 = Small Rock
				14 = Safe Zone
			*/
			_type = tileNo;
			
			switch(tileNo)
			{
				case 0:
					break;
				case 1:
					_barrier = true;
					_cbBarrier = true;
					break;
				case 2:
					_move = "F";
					_actingRotation = 0;
					break;
				case 3:
					_move = "F";
					_actingRotation = 90;
					break;
				case 4:
					_move = "F";
					_actingRotation = 180;
					break;
				case 5:
					_move = "F";
					_actingRotation = 270;
					break;
				case 6:
					_move = "R";
					_actingRotation = 90;
					break;
				case 7:
					_move = "R";
					_actingRotation = 180;
					break;
				case 8:
					_move = "R";
					_actingRotation = 0;
					break;
				case 9:
					_move = "R";
					_actingRotation = 270;
					break;
				case 10:
					_points = 1;
					break;
				case 11:
					_points = 2;
					break;
				case 12:
					_points = 3;
					break;
				case 13:
					_barrier = true;
					break;
				case 14:
					_safeZone = true;
					break;			
			}
			
		}
		
		public function get barrier():Boolean{return _barrier;}
		public function get cbBarrier():Boolean{return _cbBarrier;}
		public function get tileMove():String{return _move;}
		public function get actingRotation():int{return _actingRotation;}
		public function get tileType():uint{return _type;}
		public function get safeZone():Boolean{return _safeZone;}
		public function get points():int{return _points;}
		
		
	}
}