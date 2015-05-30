package setup
{
	import flash.display.MovieClip;
	import game.logic.Tile;
	import constants;
	
	public class MapDisplay extends MovieClip
	{
		protected var _mapArray:Array;
		protected var _tileArray:Array;
		
		
		public function MapDisplay(mapArray:Array)
		{
			
			_mapArray = mapArray;
			_tileArray = new Array();
			
			for(var i = 0; i < _mapArray.length; i++)
			{				
				_tileArray.push(new Array());
				for(var j = 0; j < _mapArray[0].length; j++)
				{
					_tileArray[i].push(new TileMC());
					_tileArray[i][j].gotoAndStop(_mapArray[i][j] + 1);
					_tileArray[i][j].scaleX = 0.25;
					_tileArray[i][j].scaleY = 0.25;
					_tileArray[i][j].x = (j * constants.SMALL_TILE_SIZE);
					_tileArray[i][j].y = (i * constants.SMALL_TILE_SIZE);
					addChild(_tileArray[i][j]);				
				}			
			}
		}
	}
}