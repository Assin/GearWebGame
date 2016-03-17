package kernel.events
{
	import flash.events.Event;
	
	
	/**
	 * @name 基本事件
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 21, 2011 10:34:29 AM
	 */
	public class KernelEvent extends Event
	{
		private var _sender:Object;
		private var _data:Object;
		
		
		
		/**
		 * 获取事件的触发者
		 */
		public function get sender():*
		{
			return _sender;
		}
		
		public function set data(value:Object):void
		{
			_data = value;
		}
		
		/**
		 * 获取事件的自定义数据信息
		 */
		public function get data():Object
		{
			return _data;
		}
		
		public function KernelEvent(type:String, sender:Object = null, dataParam:Object = null, bubbles:Boolean = false,
									cancelable:Boolean = false)
		{
			_sender = sender;
			_data = (dataParam == null ? {} : dataParam);
			super(type, bubbles, cancelable);
		}
		
		public override function clone():Event
		{
			var evt:KernelEvent = new KernelEvent(type, sender, data, bubbles, cancelable);
			return evt;
		}
	}
}