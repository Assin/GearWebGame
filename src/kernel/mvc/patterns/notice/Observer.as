package kernel.mvc.patterns.notice
{
	import kernel.IDispose;
	import kernel.mvc.interfaces.INotification;
	import kernel.mvc.interfaces.IObserver;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 8:09:18 PM
	 */
	public class Observer implements IObserver, IDispose
	{
		
		protected var _notifyMethod:Function;
		protected var _notifyContext:*;
		
		
		public function Observer(notifyMethod:Function, notifyContext:*)
		{
			_notifyMethod = notifyMethod;
			_notifyContext = notifyContext;
		}
		
		public function getNotifyMethod():Function
		{
			//子类重写
			return null;
		}
		
		public function notifyObserver(notification:INotification):void
		{
			this.getNotifyMethod().apply(null, [notification]);
		}
		
		public function dispose():void
		{
			_notifyMethod = null;
			_notifyContext = null;
		}
	}
}