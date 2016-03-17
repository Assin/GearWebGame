package kernel.display.components.behaviors
{
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.utils.ColorUtil;
	
	
	/**
	 * 文件名：DefaultComponentMouseEffectBehavior.as
	 * <p>
	 * 功能：默认的鼠标事件响应算法族，不响应任何鼠标事件
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public class DefaultComponentMouseEffectBehavior implements IComponentMouseEffectBehavior
	{
		
		public function DefaultComponentMouseEffectBehavior()
		{
		}
		
		public function onClick(component:MouseEffectiveComponent):void
		{
			if (component.hasMouseDownEffect)
			{
				component.$superY = component.oldY;
			}
		}
		
		public function onMouseOver(component:MouseEffectiveComponent):void
		{
			if (component.hasMouseDownEffect)
			{
				if (component.isButtonDown)
				{
					component.$superY += 2;
				}
				
				ColorUtil.highLight(component);
			}
		}
		
		public function onMouseOut(component:MouseEffectiveComponent):void
		{
			if (component.hasMouseDownEffect)
			{
				component.$superY = component.oldY;
				ColorUtil.deHighLight(component);
			}
		}
		
		public function onMouseDown(component:MouseEffectiveComponent):void
		{
			if (component.hasMouseDownEffect)
			{
				component.$superY += 2;
			}
		}
		
		public function onMouseUp(component:MouseEffectiveComponent, isOver:Boolean):void
		{
			if (component.hasMouseDownEffect)
			{
				component.$superY = component.oldY;
			}
		}
	}
}