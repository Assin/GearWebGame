package kernel.display.components
{
	
	/**
	 * 文件名：ILayoutable.as
	 * <p>
	 * 功能：所有继承自该接口的类均支持统一布局功能
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-16
	 * <p>
	 * 作者：yanghongbin
	 */
	public interface ILayoutable
	{
		/**
		 * 按照传入的布局数据对显示对象进行布局
		 * @param layout 布局数据
		 */
		function setLayout(layout:LayoutVO):void;
	}
}