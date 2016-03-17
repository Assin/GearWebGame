package kernel.display.panel
{
	import flash.text.TextField;
	
	import kernel.IDispose;
	import kernel.display.components.button.BaseButton;
	import kernel.display.components.text.TextFieldProxy;
	
	/**
	 * @name 初始化面板行为接口
	 * @explain
	 * @author yanghongbin
	 * @create Dec 4, 2012 2:04:08 PM
	 */
	public interface IPanelInitBehavior extends IDispose
	{
		
		/**
		 * 设置标题文字的样式
		 */
		function setTitleTextStyle(title:TextFieldProxy):void;
		/**
		 * 对面板标题进行布局
		 */
		function layoutTitle(title:TextField):void;
		/**
		 * 对面板的关闭按钮进行布局
		 */
		function layoutCloseButton(btn:BaseButton):void;
		
		/**
		 * 对面板的帮助按钮进行布局
		 */
		function layoutHelpButton(btn:BaseButton):void;
		/**
		 * 当关闭按钮被点击时的行为
		 */
		function onCloseButtonClicked():void;
	}
}