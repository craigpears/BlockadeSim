package game
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import game.logic.Flag;
	import game.logic.Tile;
	import game.accessPoints.GameInformation;
	
	public class Board extends Sprite
	{
		protected var boardTiles:Array;
		
		public function Board(mapName:String = null):void 
		{
			var _mapArray:Array = GameInformation.getMapArray(mapName);
			//The x and the y values are the wrong way round so flip the array!
			var tempArray:Array = new Array();
			for (var i:int = 0; i < _mapArray[0].length; i++)
			{
				tempArray.push(new Array());
				for(var j:int = 0; j < _mapArray.length; j++)
				{
					tempArray[i].push(_mapArray[j][i]);
				}
			}
			_mapArray = tempArray;
			// The logical representation
			var board:Array = new Array();
			// The graphical representation
			boardTiles = new Array();
			for(i = 0; i < _mapArray.length; i++)
			{				
				board.push(new Array());
				boardTiles.push(new Array());
				for(j = 0; j < _mapArray[0].length; j++)
				{
					board[i].push(new Tile(_mapArray[i][j]));
					
					// Add the tile graphic to the board
					var tileMC:TileMC = new TileMC();
					tileMC.x = (i * constants.TILE_SIZE);
					tileMC.y = (j * constants.TILE_SIZE);
					tileMC.gotoAndStop(_mapArray[i][j] + 1);
					addChild(tileMC);	
					
					// Add the tile graphic to the array
					boardTiles[i].push(tileMC);
					
					switch(_mapArray[i][j])
					{
						case 10:							
						case 11:
						case 12:
							GameInformation.addFlag(new Flag(i,j,board[i][j]));
					}
				}			
			}
			GameInformation.boardTiles = boardTiles;
			GameInformation.board = board;
			this.rotation = 45;	
			this.addEventListener(MouseEvent.MOUSE_DOWN,drag);
			this.addEventListener(MouseEvent.MOUSE_UP,noDrag);
		}
		
		public function centerViewOnShip(disengaged:Boolean = false):void
		{
			//Put your ship in the middle of the screen
			this.x = 200+(GameInformation.myShip.yBoardPos*28.8);//28.8=half the tile width/height when rotated
			this.y = 150-(GameInformation.myShip.yBoardPos*28.8);
			if(disengaged)//Move to the other side of the board)
			{
				this.x -= 800;
				this.y -= 900;
			}
		}
		
		public function displayShip(ship:Ship):void
		{
			this.addChild(ship);
		}
		
		public function hideShip(ship:Ship):void
		{
			this.removeChild(ship);
		}

		protected function drag(evt:MouseEvent):void
		{
			this.startDrag();
		}
		
		protected function noDrag(evt:MouseEvent):void
		{
			this.stopDrag();
		}
	}
	
}
