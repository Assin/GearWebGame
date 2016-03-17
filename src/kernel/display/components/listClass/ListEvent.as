package kernel.display.components.listClass
{
	import flash.events.Event;
	
	public class ListEvent extends Event
	{
		
		public static const ITEM_CLICK:String = "listItemClick";
		
		protected var _index:int;
		
		protected var _item:Object;
		
		public function ListEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, index:int = -1, item:Object = null)
		{
			super(type, bubbles, cancelable);
			_index = index;
			_item = item;
		}
		
		public function get index():int
		{
			return _index;
		}
		
		public function get item():Object
		{
			return _item;
		}
		
		override public function toString():String
		{
			return formatToString("ListEvent", "type", "bubbles", "cancelable", "index", "item");
		}
		
		
		override public function clone():Event
		{
			return new ListEvent(type, bubbles, cancelable, _index, _item);
		}
		
	}
}