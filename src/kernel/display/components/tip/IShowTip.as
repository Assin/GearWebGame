package kernel.display.components.tip
{
	/**
	 * 文件名：IShowTip.as
	 * <p>
	 * 功能：该接口规定了所有可以显示TIP的对象所具有的方法。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-19
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public interface IShowTip
	{
		/**
		 * 通过传入鼠标的全局坐标来获取某个对象的Tip信息
		 * @param x 要显示Tip的横坐标
		 * @param y 要显示Tip的纵坐标
		 * @return Tip的数据信息
		 */
		function getTipValue(x:Number, y:Number):*;
	}
}