package kernel.mvc.patterns.command
{
	import kernel.IDispose;
	import kernel.mvc.interfaces.ICommand;
	import kernel.mvc.interfaces.INotification;
	import kernel.mvc.patterns.context.Context;
	import kernel.mvc.patterns.mediator.Mediator;
	import kernel.mvc.patterns.proxy.Proxy;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 7:25:04 PM
	 */
	public class Command implements ICommand, IDispose
	{
		internal var _context:Context;
		/**
		 * 是否手动释放
		 */
		protected var isManualDispose:Boolean;
		
		public function Command()
		{
		}
		
		public function set context(value:Context):void
		{
			_context = value;
		}
		
		public function execute(note:INotification):void
		{
			
		}
		
		
		public function getMediator(mediatorClassRef:Class):Mediator
		{
			return this._context.getMediator(mediatorClassRef);
		}
		
		public function getProxy(proxyClassRef:Class):Proxy
		{
			return this._context.getProxy(proxyClassRef);
		}
		
		public function sendNotification(notificationName:String, body:Object = null, type:String = null, ... args):void
		{
			var params:Array = [notificationName, body, type];
			
			if (args != null)
			{
				params = params.concat(args);
			}
			this._context.sendNotification.apply(null, params);
		}
		
		public function registerMediator(mediator:Mediator):void
		{
			this._context.registerMediator(mediator);
		}
		
		public function registerProxy(proxy:Proxy):void
		{
			this._context.registerProxy(proxy);
		}
		
		public function registerCommand(notificationName:String, commandClassRef:Class):void
		{
			this._context.registerCommand(notificationName, commandClassRef);
		}
		
		public function hasMediator(mediatorRef:Class):Boolean
		{
			return this._context.hasMediator(mediatorRef);
		}
		
		public function removeMediator(mediator:Mediator):void
		{
			this._context.removeMediator(mediator);
		}
		
		public function removeProxy(proxy:Proxy):void
		{
			this._context.removeProxy(proxy);
		}
		
		public function hasProxy(proxyRef:Class):Boolean
		{
			return this._context.hasProxy(proxyRef);
		}
		
		public function removeCommand(notificationName:String):void
		{
			this._context.removeCommand(notificationName);
		}
		/**
		 * 手动销毁 
		 * 
		 */		
		public function manualDispose():void{
			this._context = null;
		}
		
		public function dispose():void
		{
			if (this.isManualDispose == false)
			{
				this._context = null;
			}
		}
		
		
	}
}