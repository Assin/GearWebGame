package kernel.display.components
{
	
	/**
	 * 高亮指引的委托，通常给获取BrightDisplayObject对象的算法封装类 使用的接口
	 * @author yanghongbin
	 *
	 */
	public interface IBrightDelegate
	{
		/**
		 * 获取BrightDisplayObject对象的方法
		 * @param returnFunction
		 *
		 */
		function getBrightDisplayObjectFunction(brightName:String, returnFunction:Function):void;
	}
}