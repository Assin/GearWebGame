package kernel.display.components.tip.members
{
	
	/**
	 * 文件名：ITipMember.as
	 * <p>
	 * 功能：该接口规定了Tip的Member应具有的方法
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 */
	public interface ITipMember
	{
		/**
		 * 将Member宽度和高度恢复成为默认宽度，方便Tip生成总体宽度和高度
		 */		
		function resetLayout():void;
	}
}