package kernel.display.components.behaviors
{
	import kernel.display.components.BaseComponent;
	import kernel.utils.ColorUtil;
	
	/**
	 * 文件名：DefaultComponentEnableBehavior.as
	 * <p>
	 * 功能：默认的组件可用性算法族，当不可用时置灰组件
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public class DefaultComponentEnableBehavior implements IComponentEnableBehavior
	{
		private var _enabled:Boolean = true;
		
		public function getEnabled(component:BaseComponent):Boolean
		{
			return _enabled;
		}
		
		public function setEnabled(component:BaseComponent, value:Boolean):void
		{
			if (value && !_enabled)
			{
				ColorUtil.deFadeColor(component);
			} else if (!value && _enabled)
			{
				ColorUtil.deHighLight(component);
				ColorUtil.fadeColor(component);
			}
			_enabled = value;
		}
		
		public function DefaultComponentEnableBehavior()
		{
		}
		
		public function dispose():void
		{
			
		}
		
	}
}