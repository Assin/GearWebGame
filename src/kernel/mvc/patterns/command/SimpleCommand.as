package kernel.mvc.patterns.command
{
	import kernel.mvc.interfaces.INotification;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 10:34:48 PM
	 */
	public class SimpleCommand extends Command
	{
		
		public function SimpleCommand()
		{
			super();
		}
		/**
		 * 如果重写请最后调用 
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			
		}
	}
}