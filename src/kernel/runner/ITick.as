package kernel.runner
{
	
	/**
	 * @name 需要参与游戏循环的实现接口
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 9:55:01 AM
	 */
	public interface ITick
	{
		/**
		 * 循环接口函数
		 * @param delay 两帧时间差，用于精准计时
		 *
		 */
		function onTick(delay:uint):void;
	}
}