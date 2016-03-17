package kernel.display.components
{
	import flash.display.Sprite;
	
	import kernel.IDispose;
	import kernel.utils.LayoutUtil;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Dec 4, 2012 3:07:22 PM
	 */
	public class Container extends Sprite implements IDispose, ILayoutable
	{
		
		public function Container()
		{
			super();
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
		}
		
		public function dispose():void
		{
		}
		
		public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layoutContainer(this, layout);
		}
	}
}