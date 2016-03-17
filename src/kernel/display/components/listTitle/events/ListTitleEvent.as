package kernel.display.components.listTitle.events
{
	import flash.events.Event;
	
	public class ListTitleEvent extends Event
	{
		public static const LIST_COLUMN_SORT:String = "listColumnSort";
		
		public var sender:Object;
		public var value:Object;
		public var sortType:int;
		
		public function ListTitleEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}