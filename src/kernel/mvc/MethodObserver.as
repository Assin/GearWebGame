package kernel.mvc
{
	import kernel.mvc.patterns.notice.Observer;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 8:25:37 PM
	 */
	public class MethodObserver extends Observer
	{
		
		public function MethodObserver(notifyMethod:Function, notifyContext:*)
		{
			super(notifyMethod, notifyContext);
		}
		
		override public function getNotifyMethod():Function
		{
			return this._notifyMethod;
		}
		
	}
}