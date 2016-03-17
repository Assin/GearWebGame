package kernel.display.components.renderlist
{
	import kernel.display.components.group.SelectGroup;
	
	public class BaseRendererVO
	{
		/**
		 * Renderer的类型引用，方便RenderList进行反射
		 */
		public var rendererClass:Class;
		/**
		 * 是否可选
		 */
		public var selectable:Boolean = false;
		/**
		 * 是否被选中
		 */
		public var selected:Boolean = false;
		/**
		 * 选择模式，默认为单选
		 */
		public var selectType:int = SelectGroup.SINGLE_SELECT;
		/**
		 * 表示该Renderer在RenderList中的索引值
		 */
		public var index:int = -1;
		
		public function BaseRendererVO(rendererClass:Class)
		{
			this.rendererClass = rendererClass;
		}
	}
}