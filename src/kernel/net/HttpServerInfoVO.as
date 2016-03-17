package kernel.net
{
	
	/**
	 * @name http服务器的信息
	 * @explain
	 * @author yanghongbin
	 * @create Oct 25, 2013
	 */
	public class HttpServerInfoVO implements IServerInfoVO
	{
		private var _name:String;
		public var address:String;
		
		public function HttpServerInfoVO()
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
			return "Name:" + name + " Address:" + address;
		}
	}
}
