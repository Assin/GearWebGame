package kernel.events
{
	import flash.events.Event;
	
	public class NumberInputChangeEvent extends Event
	{
		public var number:Number = 0;
		public var max:Number = 0;
		public var min:Number = 0;
		
		public static const CHANGE:String = "numberChange";
		
		public function NumberInputChangeEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
		
	}
}