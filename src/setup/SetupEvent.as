package setup{
  
    import flash.events.Event;
	
    public class SetupEvent extends Event {
		
        public static  const MAP_CHANGE:String = "Map Change";
  
        public function SetupEvent(type:String) {
            super(type);
        }
    }  
}