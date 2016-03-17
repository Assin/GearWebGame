package kernel.display.components.text
{
	/**
	 * @name 文字样式设置的接口,定义了所有界面样式生成的配置，主要是为了统一一下编辑器和代码类的接口
	 * @explain
	 * @author yanghongbin
	 * @create Dec 6, 2012 11:07:05 AM
	 */
	public interface ITextStyle
	{
		function set text(value:String):void;
		/**
		 * 设置字体颜色 
		 * @param value
		 * 
		 */		
		function set color(value:String):void;
		/**
		 * 设置字体 
		 * @param value
		 * 
		 */		
		function set fontFamily(value:String):void;
		/**
		 * 设置字号 
		 * @param value
		 * 
		 */		
		function set fontSize(value:int):void;
		/**
		 *　设置是否加粗 
		 * @param value
		 * 
		 */		
		function set fontWeight(value:String):void;
		/**
		 * 设置是否斜体 
		 * @param value
		 * @return 
		 * 
		 */		
		function set fontStyle(value:String):void;
		/**
		 * 设置对齐方式 
		 * @param value
		 * 
		 */		
		function set textAlign(value:String):void;
	}
}