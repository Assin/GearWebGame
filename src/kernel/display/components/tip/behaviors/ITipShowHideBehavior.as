package kernel.display.components.tip.behaviors
{
	import kernel.display.components.tip.Tip;
	
	/**
	 * 文件名：ITipShowHideBehavior.as
	 * <p>
	 * 功能：该接口规定了Tip显示或隐藏时的行为算法族
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 */
	public interface ITipShowHideBehavior
	{
		/**
		 * 当Tip显示时的行为
		 * @param tip 要被操作的Tip
		 */		
		function show(tip:Tip):void;
		/**
		 * 当Tipt隐藏时的行为
		 * @param tip 要被操作的Tip
		 */		
		function hide(tip:Tip):void;
	}
}