package kernel.display.components.tip.behaviors
{
	import kernel.display.components.tip.Tip;
	
	/**
	 * 文件名：DefaultTipShowHideBehavior.as
	 * <p>
	 * 功能：默认的Tip显示隐藏行为算法族，直接修改Tip的visible属性实现显示和隐藏
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 */
	public class DefaultTipShowHideBehavior implements ITipShowHideBehavior
	{
		public function DefaultTipShowHideBehavior()
		{
		}
		
		public function show(tip:Tip):void
		{
			tip.visible = true;
		}
		public function hide(tip:Tip):void
		{
			tip.visible = false;
		}
	}
}