package kernel.display.components.text
{
	import flash.text.StyleSheet;
	import flash.text.TextFormat;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.container.ScrollPanel;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：TextArea.as
	 * <p>
	 * 功能：文字域控件，即包含下拉框的文本框
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-9-25
	 * <p>
	 * 作者：yanghongbin
	 */
	public class TextArea extends BaseComponent
	{
		private var _scrollPanel:ScrollPanel;
		private var _textField:TextFieldProxy;
		
		private var _defaultTextFormat:TextFormat;
		private var _defaultFilters:Array;
		
		/**
		 * 获取或设置文字域宽度
		 */
		override public function get width():Number
		{
			return _scrollPanel.width;
		}
		
		override public function set width(value:Number):void
		{
			_textField.width = value;
			_scrollPanel.width = value;
			_scrollPanel.update();
		}
		
		/**
		 * 获取或设置文字域高度
		 */
		override public function get height():Number
		{
			return _scrollPanel.height;
		}
		
		override public function set height(value:Number):void
		{
			_scrollPanel.height = value;
			_scrollPanel.update();
		}
		
		/**
		 * 获取或设置文字域的滤镜列表
		 */
		override public function get filters():Array
		{
			return _textField.filters;
		}
		
		override public function set filters(value:Array):void
		{
			_textField.filters = value;
			_defaultFilters = value;
		}
		
		/**
		 * 获取文本的宽度，以像素为单位。
		 */
		public function get textWidth():Number
		{
			return _textField.textWidth;
		}
		
		/**
		 * 获取文本的高度，以像素为单位。
		 */
		public function get textHeight():Number
		{
			return _textField.textHeight;
		}
		
		/**
		 * 获取或设置文字域内作为文本字段中当前文本的字符串
		 */
		public function get text():String
		{
			return _textField.text;
		}
		
		public function set text(value:String):void
		{
			_textField.text = value;
			_scrollPanel.update();
		}
		
		/**
		 * 获取或设置文字域内包含文本字段内容的 HTML 表示形式
		 */
		public function get htmlText():String
		{
			return _textField.htmlText;
		}
		
		public function set htmlText(value:String):void
		{
			_textField.htmlText = value;
			_scrollPanel.update();
		}
		
		/**
		 * 获取或设置文字域的默认文字样式
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _textField.defaultTextFormat;
		}
		
		public function set defaultTextFormat(value:TextFormat):void
		{
			_textField.defaultTextFormat = value;
			_defaultTextFormat = value;
			_scrollPanel.update();
			_scrollPanel.verticalLineScrollSize = int(_textField.defaultTextFormat.size);
		}
		
		/**
		 * 获取或设置文本的样式表
		 */
		public function get styleSheet():StyleSheet
		{
			return _textField.styleSheet;
		}
		
		public function set styleSheet(value:StyleSheet):void
		{
			_textField.styleSheet = value;
			_scrollPanel.update();
			_scrollPanel.verticalLineScrollSize = int(_textField.defaultTextFormat.size);
		}
		
		/**
		 * 获取或设置文字域是否支持自动换行
		 */
		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
			_scrollPanel.update();
		}
		
		/**
		 * 获取或设置文字域是否支持多行文本显示
		 */
		public function get multiline():Boolean
		{
			return _textField.multiline;
		}
		
		public function set multiline(value:Boolean):void
		{
			_textField.multiline;
			_scrollPanel.update();
		}
		
		/**
		 * 获取或设置文字域的自动大小调整和对齐
		 */
		public function get autoSize():String
		{
			return _textField.autoSize;
		}
		
		public function set autoSize(value:String):void
		{
			_textField.autoSize = value;
			_scrollPanel.update();
		}
		
		/**
		 * 获取定义多行文本字段中的文本行数
		 */
		public function get numLines():int
		{
			return _textField.numLines;
		}
		
		/**
		 * 设置文字域可显示的行数
		 */
		public function set lineNumVerticel(value:int):void
		{
			_scrollPanel.height = int(_textField.defaultTextFormat.size) * value + 4;
		}
		
		public function TextArea(id:int = 0)
		{
			super(id);
		}
		
		override protected function init():void
		{
			super.init();
			
			_textField = new TextFieldProxy();
			_textField.wordWrap = true;
			
			_scrollPanel = new ScrollPanel();
			_scrollPanel.source = _textField;
			_scrollPanel.verticalLineScrollSize = int(_textField.defaultTextFormat.size);
			addChild(_scrollPanel);
		}
		
		override public function clear():void
		{
			super.clear();
			_textField.text = "";
			_textField.reset();
			if (_defaultTextFormat != null)
				_textField.defaultTextFormat = _defaultTextFormat;
			if (_defaultFilters != null)
				_textField.filters = _defaultFilters;
			_scrollPanel.clear();
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_scrollPanel);
			_scrollPanel = null;
			ObjectPool.disposeObject(_textField);
			_textField = null;
			ObjectPool.disposeObject(_defaultTextFormat);
			_defaultTextFormat = null;
			ObjectPool.disposeObject(_defaultFilters);
			_defaultFilters = null;
			
			super.dispose();
		}
	}
}