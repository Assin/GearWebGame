package kernel.display.components
{
	/**
	 * 
	 * @author Administrator
	 * 
	 */	
	public interface IInteractiveItem
	{
		/**
		 * 位图鼠标点透明检测
		 * @return 
		 * 
		 */		
		function bitmapHitTest():Boolean;
		
		/**
		 * 鼠标是否出界了（含透明区域）
		 * @return 
		 * 
		 */		
		function isOutBounds():Boolean;
		
	}
}