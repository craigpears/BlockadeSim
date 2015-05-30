package game 
{
	import flash.events.Event;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Craig Pears
	 */
	public class EventsDispatcher 
	{
		static public var dispatcher:Sprite = new Sprite();
		
		public function EventsDispatcher() 
		{
			throw Error("Events Dispatcher is a singleton class that should not be instantiated");
		}
		
		public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
            dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
        public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void {
            dispatcher.removeEventListener(type, listener, useCapture);
        }
        public static function dispatchEvent(event:Event):Boolean {
            return dispatcher.dispatchEvent(event);
        }
        public static function hasEventListener(type:String):Boolean {
            return dispatcher.hasEventListener(type);
        }
		
	}

}