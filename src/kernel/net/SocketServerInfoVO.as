package kernel.net
{
	
	/**
	 * @name socket服务器的信息
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 2:43:19 PM
	 */
	public class SocketServerInfoVO implements IServerInfoVO
	{
		private var _name:String;
		public var ip:String;
		public var port:int;
		
		public function SocketServerInfoVO()
		{
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function set name(value:String):void
		{
			_name = value;
		}
		
		public function toString():String
		{
			return "Name:" + name + " IP:" + ip + ":" + String(port);
		}
	}
}