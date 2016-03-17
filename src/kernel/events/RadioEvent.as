package kernel.events
{
	
	public class RadioEvent extends KernelEvent
	{
		public static const RADIO_SELECTED:String = "radioSelected";
		public static const RADIO_CREATED:String = "radioCreated";
		
		public function RadioEvent(type:String, sender:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, sender, null, bubbles, cancelable);
		}
		
	}
}