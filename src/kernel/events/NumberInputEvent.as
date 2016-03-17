package kernel.events
{
	
	
	public class NumberInputEvent extends KernelEvent
	{
		public static const INPUT_OUT_OF_RANGE:String = "inputOutOfRange";
		
		public function NumberInputEvent(type:String, sender:*, data:* = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, sender, data, bubbles, cancelable);
		}
	}
}