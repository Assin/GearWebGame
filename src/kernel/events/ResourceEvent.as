package kernel.events
{
	
	/**
	 * @name 资源事件
	 * @explain 
	 * @author yanghongbin
	 * @create 2011 Dec 19, 2011 10:41:21 AM
	 */	
	public class ResourceEvent extends KernelEvent
	{
		/**
		 * 加载完毕  
		 */		
		public static const LOAD_COMPLETE:String = "loadComplete";
		
		/**
		 * 加载完毕的资源KEY 
		 */		
		public var resourceKey:String = "";
		public function ResourceEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}