package kernel.events
{
	import flash.events.Event;
	
	public class TabBarEvent extends KernelEvent
	{
		public static const TABBAR_CHANGE:String = "tabBarChange";
		
		public var selectedId:int;
		
		public function TabBarEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(TabBarEvent.TABBAR_CHANGE, bubbles, cancelable);
		}
	}
}