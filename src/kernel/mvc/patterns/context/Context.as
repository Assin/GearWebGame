package kernel.mvc.patterns.context
{
	import kernel.IDispose;
	import kernel.mvc.Controller;
	import kernel.mvc.Model;
	import kernel.mvc.View;
	import kernel.mvc.patterns.mediator.Mediator;
	import kernel.mvc.patterns.notice.Notification;
	import kernel.mvc.patterns.proxy.Proxy;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 7:14:40 PM
	 */
	public class Context implements IDispose
	{
		private var _model:Model;
		private var _view:View;
		private var _controller:Controller;
		
		public function Context()
		{
			this.initialize();
		}
		
		public function initialize():void
		{
			this._model = new Model(this);
			this._model.initializeModel();
			
			this._view = new View(this);
			this._view.initializeView();
			
			this._controller = new Controller(this);
			this._controller.initializeController();
		}
		
		public function getMediator(mediatorClassRef:Class):Mediator
		{
			return this._view.getMediator(mediatorClassRef);
		}
		
		public function getProxy(proxyClassRef:Class):Proxy
		{
			return this._model.getProxy(proxyClassRef);
		}
		
		public function subscribeNotification(notificationName:String, method:Function):void
		{
			this._controller.subscribeNotification(notificationName, method);
		}
		
		public function sendNotification(notificationName:String, body:Object = null, type:String = null, ... args):void
		{
			this._controller.sendNotication(notificationName, new Notification(notificationName, body, type, args));
		}
		
		public function unsubscribeNotification(notificationName:String, method:Function):void
		{
			this._controller.unsubscribeNotification(notificationName, method);
		}
		
		public function registerMediator(mediator:Mediator):void
		{
			this._view.registerMediator(mediator);
		}
		
		public function registerProxy(proxy:Proxy):void
		{
			this._model.registerProxy(proxy);
		}
		
		public function registerCommand(notificationName:String, commandClassRef:Class):void
		{
			this._controller.registerCommand(notificationName, commandClassRef);
		}
		
		public function hasMediator(mediatorRef:Class):Boolean
		{
			return this._view.hasMediator(mediatorRef);
		}
		
		public function removeMediator(mediator:Mediator):void
		{
			this._view.removeMediator(mediator);
		}
		
		public function removeProxy(proxy:Proxy):void
		{
			this._model.removeProxy(proxy);
		}
		
		public function hasProxy(proxyRef:Class):Boolean
		{
			return this._model.hasProxy(proxyRef);
		}
		
		public function removeCommand(notificationName:String):void
		{
			this._controller.removeCommand(notificationName);
		}
		
		public function startup():void
		{
			
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_model);
			_model = null;
			ObjectPool.disposeObject(_view);
			_view = null;
			ObjectPool.disposeObject(_controller);
			_controller = null;
		}
		
		
	}
}