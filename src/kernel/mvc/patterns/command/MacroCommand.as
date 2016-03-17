package kernel.mvc.patterns.command
{
	import kernel.mvc.interfaces.ICommand;
	import kernel.mvc.interfaces.INotification;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 10:33:37 PM
	 */
	public class MacroCommand extends Command
	{
		private var subCommands:Array;
		
		public function MacroCommand()
		{
			super();
			subCommands = new Array();
			initializeMacroCommand();
		}
		/**
		 * 在这里写入添加execute后要执行的命令 
		 * 
		 */		
		protected function initializeMacroCommand():void
		{
		}
		
		protected final function addSubCommand(commandClassRef:Class):void
		{
			subCommands.push(commandClassRef);
		}
		/**
		 * 如果重写请最后调用这个方法 
		 * @param notification
		 * 
		 */		
		override public function execute(notification:INotification):void
		{
			while (subCommands.length > 0)
			{
				var commandClassRef:Class = subCommands.shift();
				var commandInstance:Command = new commandClassRef();
				commandInstance.context = this._context;
				commandInstance.execute(notification);
				commandInstance.dispose();
			}
		}
	}
}