package kernel.display.components
{
	import flash.utils.Dictionary;
	
	/**
	 * 文件名：LayoutVO.as
	 * <p>
	 * 功能：该类负责保存布局所需的数据
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-16
	 * <p>
	 * 作者：yanghongbin
	 */
	public class LayoutVO
	{
		/**
		 * 横坐标
		 */
		public var x:Number;
		/**
		 * 纵坐标坐标
		 */
		public var y:Number;
		/**
		 * 宽度
		 */
		public var width:Number;
		/**
		 * 高度
		 */
		public var height:Number;
		/**
		 * 子数据，键名必须和组件名完全相同。如果没有子数据则为null
		 */
		public var children:Dictionary = null;
		
		public function LayoutVO()
		{
		}
	}
}