package kernel.display.components.tip.members
{
	
	import kernel.IClear;
	import kernel.display.components.tip.TipVO;
	
	/**
	 * 文件名：ITipContainer.as
	 * <p>
	 * 功能：该接口规定了作为Tip相关容器所应具有的方法
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 */
	public interface ITipContainer extends IClear
	{
		/**
		 * 设置Tip信息
		 */		
		function set tipVO(value:TipVO):void;
	}
}