package game.logic 
{
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class Flag implements FlagInterface
	{
		protected var _xBoardPos:int;
		protected var _yBoardPos:int;
		protected var _points:int;
		protected var _tile:Tile;
		protected var _influence:int;		
		
		public static const NONE:int = 0;
		public static const TEAM_ONE:int = 1;
		public static const TEAM_TWO:int = 2;
		public static const BOTH_TEAMS:int = 3;
		
		/**
		 * Constructor for the Flag class
		 * @param	xPos The x board position of the flag
		 * @param	yPos The y board position of the flag
		 * @param	_tile The Tile that represents this flag
		 */
		public function Flag(xPos:int, yPos:int, tile:Tile) 
		{
			// Get the number of points from the tile
			_points = tile.points;
			_tile = _tile;
			_xBoardPos = xPos;
			_yBoardPos = yPos;
			_influence = NONE;
		}
		
		/**
		 * Mark this flag as being influenced by a team
		 * @param	teamNo The team number that is influencing this flag
		 */
		public function addInfluence(teamNo:int):void
		{
			switch(_influence) {
				case NONE:
					_influence = teamNo;
					break;
				case TEAM_ONE:
					if (teamNo == TEAM_TWO) {
						_influence = BOTH_TEAMS;
					}
					break;
				case TEAM_TWO:
					if (teamNo == TEAM_ONE) {
						_influence = BOTH_TEAMS;
					}
					break;
				case BOTH_TEAMS:
					break;
			}
		}
		
		/**
		 * Resets the flags influence
		 */
		public function resetInfluence():void {
			_influence = NONE;
		}
		
		/**
		 * Returns the influence status of this flag, defined in terms of constants (see class constants)
		 */
		public function get influence():int 
		{
			return _influence;
		}
		
		/**
		 * Returns the tile that represents this flag in the GUI
		 */
		public function get tile():Tile 
		{
			return _tile;
		}
			
		/**
		 * Returns the number of points this flag has
		 */
		public function get points():int 
		{
			return _points;
		}
		
		/**
		 * Returns the y board position of this flag
		 */
		public function get yBoardPos():int 
		{
			return _yBoardPos;
		}
				
		/**
		 * Returns the x board position of this flag
		 */
		public function get xBoardPos():int 
		{
			return _xBoardPos;
		}
		
	}

}