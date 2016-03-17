package kernel.events
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 4:19:35 PM
	 */
	public class ServerEvent extends KernelEvent
	{
		/**
		 * 服务器连接上
		 */
		public static const CONNECTED:String = "connected";
		/**
		 * 服务器断开连接错误
		 */
		public static const DISCONNECTION:String = "disconnection";
		
		public var ip:String;
		public var port:int;
		
		public function ServerEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}
	}
}