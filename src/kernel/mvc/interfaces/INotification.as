package kernel.mvc.interfaces
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 8:02:28 PM
	 */
	public interface INotification
	{
		/**
		 * 消息名字
		 * @return
		 *
		 */
		function get name():String;
		/**
		 * 消息内容
		 * @return
		 *
		 */
		function get body():Object;
		/**
		 * 消息类型
		 * @return
		 *
		 */
		function get type():String;
		/**
		 * 参数数组
		 * @return
		 *
		 */
		function get args():Array;
		function toString():String;
		function clone():INotification;
	}
}