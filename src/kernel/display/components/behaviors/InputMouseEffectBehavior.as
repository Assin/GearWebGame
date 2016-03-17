package kernel.display.components.behaviors
{
	
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.input.Input;
	
	/**
	 * 文件名：InputMouseEffectBehavior.as
	 * <p>
	 * 功能：专门为Input组件设计的鼠标事件算法族
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public class InputMouseEffectBehavior implements IComponentMouseEffectBehavior
	{
		
		public function InputMouseEffectBehavior()
		{
		}
		
		public function onClick(component:MouseEffectiveComponent):void
		{
			var input:Input = Input(component);
			if (input.firstFocus)
			{
				input.firstFocus = false;
				input.setSelection();
			}
		}
		
		public function onMouseOver(component:MouseEffectiveComponent):void
		{
			var input:Input = Input(component);
			if (input.borderChange && input.enabled)
			{
				input.textField.borderColor = 0xcc0000;
			}
		}
		
		public function onMouseOut(component:MouseEffectiveComponent):void
		{
			var input:Input = Input(component);
			if (input.borderChange && input.enabled)
			{
				input.textField.borderColor = input.borderColor;
			}
		}
		
		public function onMouseDown(component:MouseEffectiveComponent):void
		{
		}
		
		public function onMouseUp(component:MouseEffectiveComponent, isOver:Boolean):void
		{
		}
	}
}