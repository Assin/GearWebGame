package kernel.display.components.behaviors
{
	import kernel.display.components.MouseEffectiveComponent;
	
	
	/**
	 * 文件名：IComponentMouseEffectBehavior.as
	 * <p>
	 * 功能：实现该接口的类可以规定组件在响应鼠标各状态时的表现行为。
	 * 		 默认实现是当鼠标悬停时高光显示，当鼠标未悬停或者鼠标在
	 * 		 组件上按下时去掉高光显示。该接口可在客户程序中实现并使用。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public interface IComponentMouseEffectBehavior
	{
		/**
		 * 鼠标单击时的响应
		 * @param component 要进行操作的组件
		 */
		function onClick(component:MouseEffectiveComponent):void;
		/**
		 * 鼠标悬停时的响应
		 * @param component 要进行操作的组件
		 */
		function onMouseOver(component:MouseEffectiveComponent):void;
		/**
		 * 鼠标离开时的响应
		 * @param component 要进行操作的组件
		 */
		function onMouseOut(component:MouseEffectiveComponent):void;
		/**
		 * 鼠标按下时的响应
		 * @param component 要进行操作的组件
		 */
		function onMouseDown(component:MouseEffectiveComponent):void;
		/**
		 * 鼠标抬起时的响应
		 * @param component 要进行操作的组件
		 * @param isOver 鼠标是否在组件上
		 */
		function onMouseUp(component:MouseEffectiveComponent, isOver:Boolean):void;
	}
}