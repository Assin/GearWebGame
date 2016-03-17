package kernel.mvc.patterns.proxy
{
	import flash.utils.Dictionary;
	
	import kernel.IDispose;
	import kernel.mvc.patterns.context.Context;
	import kernel.net.IMessageBase;
	import kernel.net.IServerService;
	import kernel.net.SocketServerService;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 7:23:20 PM
	 */
	public class Proxy implements IDispose
	{
		private var _context:Context;
		private var _socketServerService:IServerService;
		
		public function Proxy()
		{
			_socketServerService = SocketServerService.getInstance();
		}
		
		public function set context(value:Context):void
		{
			_context = value;
		}
		
		protected function sendNotification(notificationName:String, body:Object = null, type:String = null, ... args):void
		{
			var params:Array = [notificationName, body, type];
			
			if (args != null)
			{
				params = params.concat(args);
			}
			this._context.sendNotification.apply(null, params);
		}
		
		protected function subscribe(messageID:int, callBack:Function):void
		{
			this._socketServerService.subscribe(messageID, callBack);
		}
		
		protected function unsubscribe(messageID:int, callBack:Function):void
		{
			this._socketServerService.unsubscribe(messageID, callBack);
		}
		
		protected function request(message:IMessageBase, serverName:String = ""):void
		{
			this._socketServerService.request(message, serverName);
		}
		
		public function init():void
		{
			
		}
		
		public function dispose():void
		{
			this._context = null;
			this._socketServerService = null;
		}
	}
}