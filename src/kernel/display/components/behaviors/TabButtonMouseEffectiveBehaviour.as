package kernel.display.components.behaviors
{
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.button.ToggleButtonBase;
	import kernel.display.components.tabbar.TabButton;
	import kernel.utils.ColorUtil;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Dec 20, 2012 8:26:21 PM
	 */
	public class TabButtonMouseEffectiveBehaviour implements IComponentMouseEffectBehavior
	{
		
		public function TabButtonMouseEffectiveBehaviour()
		{
		}
		
		public function onClick(component:MouseEffectiveComponent):void
		{
			
		}
		
		public function onMouseDown(component:MouseEffectiveComponent):void
		{
			
		}
		
		public function onMouseOut(component:MouseEffectiveComponent):void
		{
			ColorUtil.deHighLight(component);			
		}
		
		public function onMouseOver(component:MouseEffectiveComponent):void
		{
			if (ToggleButtonBase(component).selected == false)
			{
				ColorUtil.highLight(component);
			}
		}
		
		public function onMouseUp(component:MouseEffectiveComponent, isOver:Boolean):void
		{
			
		}
		
		
	}
}