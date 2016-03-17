package kernel.utils
{
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	
	import kernel.display.components.ILayoutable;
	import kernel.display.components.LayoutVO;
	
	/**
	 * 文件名：LayoutUtil.as
	 * <p>
	 * 功能：负责提供布局的相关操作
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：Sep 7, 2010
	 * <p>
	 * 作者：Hongbin.Yang
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class LayoutUtil
	{
		
		public function LayoutUtil()
		{
		}
		
		public static function layout(displayObject:DisplayObject, layoutVO:LayoutVO):void
		{
			displayObject.x = layoutVO.x;
			displayObject.y = layoutVO.y;
			displayObject.width = layoutVO.width;
			displayObject.height = layoutVO.height;
		}
		
		public static function layoutContainer(container:DisplayObjectContainer, layoutVO:LayoutVO):void
		{
			container.x = layoutVO.x;
			container.y = layoutVO.y;
			container.width = layoutVO.width;
			container.height = layoutVO.height;
			
			// 布局面板内组件
			var children:Dictionary = layoutVO.children;
			if (children != null)
			{
				for (var key:String in children)
				{
					var layoutable:ILayoutable = container[key]as ILayoutable;
					if (layoutable != null)
					{
						layoutable.setLayout(children[key]);
					}
				}
			}
		}
	}
}