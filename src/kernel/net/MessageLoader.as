package kernel.net
{
	import flash.net.URLLoader;
	
	import kernel.IDispose;

	/**
	 * http用的loader 
	 * @author Administrator
	 * 
	 */	
	public class MessageLoader extends URLLoader implements IDispose
	{
		private var _message:IHttpMessageBase;
		public function MessageLoader()
		{
			
		}
		
		public function get message():IHttpMessageBase
		{
			return _message;
		}
		
		public function set message(value:IHttpMessageBase):void
		{
			_message = value;
		}
		
		public function dispose():void
		{
			_message = null;
			this.close();
		}
	}
}