package kernel.mvc.interfaces
{
	/**
	 * @name 
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 8:27:56 PM
	 */
	public interface ICommand
	{
		function execute(note:INotification):void;
	}
}