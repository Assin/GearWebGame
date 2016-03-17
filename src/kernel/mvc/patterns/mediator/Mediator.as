package kernel.mvc.patterns.mediator
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import kernel.IDispose;
	import kernel.mvc.patterns.context.Context;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 7:17:31 PM
	 */
	public class Mediator implements IDispose
	{
		private var _context:Context;
		
		private var _listenNotifies:Dictionary = new Dictionary();
		
		protected var _view:DisplayObject;
		
		public function Mediator(view:DisplayObject)
		{
			this._view = view;
		}
		
		public function set context(value:Context):void
		{
			_context = value;
		}
		
		/**
		 * 初始化方法，新创建的Mediator会在底层自动调用这个方法
		 *
		 */
		public function init():void
		{
		}
		
		/**
		 * 注册通知
		 * @param notificationName
		 * @param callBack
		 *
		 */
		public function subscribeNotification(notificationName:String, callBack:Function):void
		{
			var array:Array = _listenNotifies[notificationName];
			
			if (array == null)
			{
				_listenNotifies[notificationName] = [callBack];
			} else
			{
				_listenNotifies[notificationName].push(callBack);
			}
			this._context.subscribeNotification(notificationName, callBack);
		}
		
		/**
		 * 取消注册通知
		 * @param notificationName
		 * @param callBack
		 *
		 */
		public function unsubscribeNotification(notificationName:String, callBack:Function):void
		{
			var array:Array = _listenNotifies[notificationName];
			
			if (array != null)
			{
				var callBackIndex:int = array.indexOf(callBack);
				
				if (callBackIndex >= 0)
				{
					array.splice(callBackIndex, 1);
				}
			}
			this._context.unsubscribeNotification(notificationName, callBack);
		}
		
		/**
		 * 发送通知
		 * @param notificationName
		 * @param body
		 * @param type
		 *
		 */
		public function sendNotification(notificationName:String, body:Object = null, type:String = null, ... args):void
		{
			var params:Array = [notificationName, body, type];
			
			if (args != null)
			{
				params = params.concat(args);
			}
			this._context.sendNotification.apply(null, params);
		}
		
		private function unscribeAllNotification():void
		{
			for (var type:String in _listenNotifies)
			{
				var arr:Array = _listenNotifies[type]as Array;
				
				while (arr != null && arr.length)
				{
					this._context.unsubscribeNotification(type, arr.shift());
				}
			}
		}
		
		public function dispose():void
		{
			this.unscribeAllNotification();
			ObjectPool.disposeObject(this._listenNotifies);
			this._listenNotifies = null;
			this._context = null;
			this._view = null;
		}
		
		
	}
}