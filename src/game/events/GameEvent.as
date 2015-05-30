package game.events{
  
    import flash.events.Event;
	
	/**
	 * This class has the same responsibilities as the standard Event class, as well as defining some constants for event types.
	 * @author Craig Pears
	 */
    public class GameEvent extends Event {
		
        public static const ANIM_DONE:String = "Animation Done";
		public static const SINK_ANIM_DONE:String = "Sink Anim Done";
  
        public function GameEvent(type:String) {
            super(type);
        }
    }  
}