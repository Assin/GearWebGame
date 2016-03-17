package kernel.display.panel
{
	import flash.text.TextField;
	
	import kernel.display.components.button.BaseButton;
	import kernel.display.components.text.TextFieldProxy;
	
	/**
	 * @name 默认的面板初始化行为类
	 * @explain
	 * @author yanghongbin
	 * @create Dec 4, 2012 2:05:17 PM
	 */
	public class DefaultPanelInitBehavior implements IPanelInitBehavior
	{
		private var _panel:PanelBase;
		
		public function DefaultPanelInitBehavior(panel:PanelBase)
		{
			_panel = panel;
		}
		
		public function setTitleTextStyle(title:TextFieldProxy):void
		{
			
		}
		
		public function layoutTitle(title:TextField):void
		{
			
		}
		
		public function layoutCloseButton(btn:BaseButton):void
		{
			
		}
		
		public function onCloseButtonClicked():void
		{
		}
		
		public function dispose():void
		{
			_panel = null;
		}
		
		public function layoutHelpButton(btn:BaseButton):void
		{
		}
		
	}
}