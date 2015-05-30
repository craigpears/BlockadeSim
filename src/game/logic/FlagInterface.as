package game.logic 
{
	
	/**
	 * This class provides the logical representation of a Flag.
	 * @author Craig Pears
	 */
	public interface FlagInterface 
	{
		function addInfluence(teamNo:int):void;
		function resetInfluence():void;
		function get influence():int;			
		function get tile():Tile;			
		function get points():int;
		function get yBoardPos():int;
		function get xBoardPos():int;
	}
	
}