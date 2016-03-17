package kernel.compositecommand
{
	import kernel.operation.AbstractOperation;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 21, 2011 3:54:34 PM
	 */
	public class AbstractCommand extends AbstractOperation implements ICommand
	{
		
		public function AbstractCommand()
		{
		}
		
		public function execute():*
		{
			return null;
		}
	}
}