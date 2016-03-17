package kernel.mvc
{
	import kernel.IDispose;
	import kernel.mvc.interfaces.INotification;
	import kernel.mvc.patterns.command.Command;
	import kernel.mvc.patterns.context.Context;
	import kernel.mvc.patterns.notice.Observer;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 8:25:48 PM
	 */
	public class CommandObserver extends Observer
	{
		private var _context:Context;
		private var _execCommand:Command
		
		public function CommandObserver(notifyMethod:Function, notifyContext:*, context:Context)
		{
			this._context = context;
			super(notifyMethod, notifyContext);
		}
		
		override public function getNotifyMethod():Function
		{
			_execCommand = new _notifyContext();
			_execCommand.context = _context;
			return _execCommand.execute;
		}
		
		override public function notifyObserver(notification:INotification):void
		{
			super.notifyObserver(notification);
			
			if (_execCommand != null)
			{
				IDispose(notification).dispose();
				_execCommand.dispose();
				_execCommand = null;
			}
		}
		
		override public function dispose():void
		{
			_context = null;
			_execCommand = null;
			super.dispose();
		}
		
	}
}