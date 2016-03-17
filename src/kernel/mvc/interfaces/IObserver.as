package kernel.mvc.interfaces
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 8:25:09 PM
	 */
	public interface IObserver
	{
		function notifyObserver(notification:INotification):void;
	}
}