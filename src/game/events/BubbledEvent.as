package game.events{
  
    import flash.events.Event;
	
	/**
	 * This class is responsible for facilitating the passing of events generated in the UI, up through to the logic layers.
	 * @author Craig Pears
	 */
    public class BubbledEvent extends Event {
		
        public static const CANNON_CHANGE:String = "Cannon Change";
		public static const AUTO_MOVES_TOGGLE:String = "Auto moves toggle";
		public static const SET_GENERATION:String = "Set generation";
		
		public var bubbledEvent:Event;
		
        public function BubbledEvent(type:String, evt:Event) {
            super(type);
			bubbledEvent = evt;
        }
    }  
}