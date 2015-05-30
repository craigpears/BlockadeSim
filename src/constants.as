package {
	
	import com.whirled.game.GameControl;
	
	public class constants
	{
		public static const TEST_MODE:Boolean = false;
		public static const RUN_LOCALLY:Boolean = true;
		
		/* Values */
		public static const SMALL_TILE_SIZE:uint = 10;
		public static const TILE_SIZE:uint = 40;
		public static const NUMBER_OF_TURNS:uint = 60;
		
		/* Command labels */
		public static const CHANGE_TEAM :String = "0";
		public static const CHANGE_SHIP :String = "1";
		public static const CHANGE_JOBBER_LEVEL :String = "2";
		public static const CHANGE_READY :String = "3";
		public static const START_GAME :String = "4";
		public static const DO_ANIMATION :String = "5";
		public static const FINISHED_ANIMATION:String = "6";
		public static const ANIMATIONS_ALL_FINISHED:String = "7";
		public static const PERFORM_ANIMATION:String = "27";
		
		/* Different rotations */
		public static const ROTATION_UP :int = 0;
		public static const ROTATION_RIGHT :int = 90;
		public static const ROTATION_DOWN :int = 180;
		public static const ROTATION_LEFT :int = 270;
		
		/* Messages for the server to record logs */
		public static const CB_HIT :String = "8";
		public static const MADE_CORRECTION :String = "9";
		public static const END_GAME :String = "10";
		
		/* Requests to the server */
		public static const TIME_UP :String = "11";
		public static const DISENGAGE_REQUEST:String = "25";
		
		/* Table names */
		public static const TEAM1_TABLE :String = "12";
		public static const TEAM2_TABLE :String = "13";
		public static const SPECTATOR_TABLE :String = "14";
		public static const TEAMS_TABLE :String = "15";
		public static const SHIP_TYPE_TABLE :String = "16";
		public static const JOBBER_LEVEL_TABLE :String = "17";
		public static const READY_STATE_TABLE :String = "18";
		public static const MOVES_TABLE :String = "19";
		public static const DAMAGE_TABLE :String = "20";
		public static const SINKS_LIST :String = "21";
		public static const MAP:String="22";
		public static const SPAWN_SHIP:String = "23";
		public static const DISENGAGE:String = "24";		
		//Contains all the y values of the ships when they start out
		public static const SHIP_POSITIONS :String = "26";
		
		//The squares relative to the ships that it influencs
		//[xDifference,yDifference]
		public static const BRIG_INFLUENCE :Array = new Array(						 [0,-3],
															  		 [-2,-2],[-1,-2],[0,-2],[1,-2],[2,-2],
															  		 [-2,-1],[-1,-1],[0,-1],[1,-1],[2,-1],																
															  [-3,0],[-2,0], [-1,0], 		[1,0], [2,0], [3,0],															   
															  		 [-2,1], [-1,1], [0,1], [1,1], [2,1],
															  		 [-2,2], [-1,2], [0,2], [1,2], [2,2],
																	 				 [0,3]);
		public static const FRIG_INFLUENCE :Array = new Array([0,-4],[0,4],[4,0],[-4,0],
															  [1,3],[2,3],[3,2],[3,1],[3,-1],[3,-2],[2,-3],[1,-3],
															  [-1,-3],[-2,-3],[-3,-2],[-3,-1],[-3,1],[-3,2],[-2,3],[-1,3]);
		
		public static const RAM_DAMAGE :Array = new Array(0.5,2,3);
		public static const ROCK_DAMAGE :Array = new Array(0.5,1.25,2.5);
		
		//Jobber levels
		public static const WEAK:int = 0;
		public static const NORM:int = 1;
		public static const ELITE:int = 2;
		
		//Ship types
		public static const SLOOP:int = 0;
		public static const BRIG:int = 1;
		public static const FRIG:int = 2;
		
		//Ship max damage
		//Given in terms of small cannonballs
		public static const SLOOP_MAX_DAMAGE:int = 10;
		public static const BRIG_MAX_DAMAGE:int = 25;
		public static const FRIG_MAX_DAMAGE:int = 50;
		
		//Animation constants
		public static const LEFT:int = 0;
		public static const FORWARD:int = 1;
		public static const RIGHT:int = 2;
		public static const DELAYED_FORWARD:int = 3;
		
		//Cannon animation constants
		public static const LEFT_SIDE:int = 0;
		public static const RIGHT_SIDE:int = 1;
		
		public static function convertToConstant(variable:String):int
		{
			switch(variable)
			{
				case "Weak":
					return WEAK;
				case "Normal":
					return NORM;
				case "Elite":
					return ELITE;
				case "Sloop":
					return SLOOP;
				case "Brig":
					return BRIG;
				case "Frig":
					return FRIG;
			}
			
			throw Error("Couldn't convert value to constant");
			return null;
		}
		
	}
}