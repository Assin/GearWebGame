package kernel.display.components.behaviors
{
	import kernel.IDispose;
	import kernel.display.components.BaseComponent;
	
	
	/**
	 * 文件名：IComponentEnableBehavior.as
	 * <p>
	 * 功能：组件可用性接口算法族，可以扩展此接口并通过赋值给组件以改变组件的可用性。
	 * 		 默认实现是当组件不可用时置灰。该接口可在客户程序中实现并使用。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public interface IComponentEnableBehavior extends IDispose
	{
		/**
		 * 获取可用性状态
		 * @param component 触发该操作的组件实例
		 */
		function getEnabled(component:BaseComponent):Boolean;
		/**
		 * 设置可用性状态
		 * @param component 触发该操作的组件实例
		 * @param value 可用性
		 */
		function setEnabled(component:BaseComponent, value:Boolean):void;
	}
}