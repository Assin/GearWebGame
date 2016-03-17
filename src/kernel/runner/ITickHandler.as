package kernel.runner
{
	
	/**
	 * @name 游戏主循环管理接口
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 9:54:33 AM
	 */
	public interface ITickHandler
	{
		/**
		 * 添加主循环接口
		 * @param ticker 循环对象
		 *
		 */
		function addTicker(ticker:ITick, delay:int = -1):void;
		/**
		 * 移除主循环接口
		 * @param ticker 循环对象
		 *
		 */
		function removeTicker(ticker:ITick):void;
		/**
		 * 判断是否有对应的循环对象
		 * @param ticker 循环对象
		 * @return
		 *
		 */
		function hasTicker(ticker:ITick):Boolean;
	}
}