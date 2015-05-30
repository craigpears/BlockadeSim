package game.logic 
{
	
	/**
	 * This class is responsible for taking in a set of moves for a turn and calculating what ships and cannonballs will collide.
	 * @author Craig Pears
	 */
	public interface CollisionMechanicsInterface 
	{
		function calculateMoves(board:Object, ships:Object):Object;		
	}
	
}