package kernel.display.components
{
	import kernel.utils.LayoutUtil;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create May 28, 2013
	 */
	public class MouseEffectiveContainer extends MouseEffectiveComponent
	{
		
		public function MouseEffectiveContainer(id:int = 0, data:* = null, clickHandler:Function = null)
		{
			super(id, data, clickHandler);
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
		}
		
		override public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layoutContainer(this, layout);
		}
	}
}
