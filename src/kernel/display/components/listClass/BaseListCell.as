package kernel.display.components.listClass
{
	import flash.display.BitmapData;
	import flash.text.TextFormat;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.utils.MaskUtil;
	import kernel.utils.ObjectPool;
	
	
	public class BaseListCell extends BaseComponent
	{
		
		internal var _height:int = 25;
		internal var _width:int = 80;
		public var leftPadding:int = 0;
		public var topPadding:int = 0;
		private var _textAlign:String;
		protected var _content:String = "";
		protected var _textField:TextFieldProxy;
		//		protected var _gridColor:uint=0x666666;
		protected var _gridColor:uint = 0x424342; //1.2.3版本更新边框颜色为 暗黄色
		protected var _textColor:uint = 0xFFFFFF;
		protected var _bgBitmapData:BitmapData;
		
		internal var _row:int;
		internal var _column:int;
		
		private var _isLast:Boolean;
		
		public static var textFormat:TextFormat = new TextFormat();
		
		public function BaseListCell(row:int, column:int, width:int, height:int, textAlign:String, isLast:Boolean = false)
		{
			this._row = row;
			this._column = column;
			this._height = height;
			this._width = width;
			this._textAlign = textAlign;
			this._isLast = isLast;
			
			MaskUtil.setRectMouseArea(this,0,0,_width,_height);
		}
		
		override protected function init():void
		{
			super.init();
			drawTextField();
			//			drawBg();
		}
		
		protected function drawTextField():void
		{
			if (_textField == null)
			{
				_textField = new TextFieldProxy();
			}
			_textField.mouseEnabled = false;
			_textField.mouseWheelEnabled = false;
			_textField.x = 0;
			_textField.textAlign = _textAlign;
			_textField.fontColor = _textColor;
			_textField.setTextStyle(11);
			_textField.height = _height;
			if (topPadding != 0)
			{
				_textField.y = topPadding;
			} else
			{
				_textField.y = (_height - _textField.height) / 2;
			}
			
			if (_content)
			{
				_textField.htmlText = _content;
			}
			_textField.selectable = false;
			addChild(_textField);
		}
		
		protected function resetTextFeild():void
		{
			if (_isLast)
			{
				_textField.width = _width - 8;
			} else
			{
				_textField.width = _width;
			}
			//			_textField.setTextFormat(textFormat);
		}
		
		protected function drawBg():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, _gridColor);
			if (_bgBitmapData != null)
			{
				this.graphics.beginBitmapFill(_bgBitmapData, null, true);
			}
			this.graphics.drawRect(0, 0, _width, _height);
			this.graphics.endFill();
		}
		
		public function setWidth(value:int):void
		{
			this._width = value;
			drawBg();
			drawTextField();
			resetTextFeild();
		}
		
		public function getWidth():int
		{
			return this._width;
		}
		
		public function getHeight():int
		{
			return this._height;
		}
		
		
		
		public function set content(value:String):void
		{
			this._content = value;
			if (value == null)
			{
				value = "";
			}
			this._textField.htmlText = value;
			resetTextFeild();
		}
		
		public function get content():String
		{
			return this._content;
		}
		
		public function get text():String
		{
			return this._textField.text;
		}
		
		public function set gridColor(value:uint):void
		{
			this._gridColor = value;
			drawBg();
		}
		
		public function set bgBitmapData(value:BitmapData):void
		{
			this.bgBitmapData = value;
			drawBg();
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_textField);
			_textField = null;
			ObjectPool.disposeObject(_bgBitmapData);
			_bgBitmapData = null;
			ObjectPool.disposeObject(textFormat);
			textFormat = null;
			
			super.dispose();
		}
	}
}