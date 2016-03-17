package kernel.display.components.input
{
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.behaviors.InputMouseEffectBehavior;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.runner.StageRunner;
	import kernel.utils.ObjectPool;
	import kernel.utils.StringUtil;
	
	/**
	 * 文件名：Input.as
	 * <p>
	 * 功能：Input.defaultText 就是默认值、初始值，每次reset()后显示的值；<p>
	 * 		Input.clickText 就是第一次焦点进入后改变的值，如果不设或设为null则不改变原有值，焦点进入过一次以后再进入就不更改text值，直到reset()后第一次焦点进入；<p>
	 * 		Input.backgroundText 是背景文字，比如“请输入商会名称”这种就可以用backgroundText，当且仅当输入框文字为空且焦点移出时显示，颜色是灰色。<p>
	 * 		Input.maxBytes 区别于Input.maxChars，前者返回和设置的是字节长度，即中文字符算作2个长度，后者使用的是TextField.maxChars自带的功能。<p>
	 * 		Input.reset() 可以直接将text还原成默认值，并且设置第一次进入改变为clickText的值，不用每次手动赋值，一般用在更新后需要显示初始值的情况。<p>
	 * 		Input.clear() 是将文本值为空。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：
	 * <p>
	 * 作者：yanghongbin
	 */
	public class Input extends MouseEffectiveComponent
	{
		protected var _changeHandler:Function;
		protected var _enterHandler:Function;
		protected var _textField:TextFieldProxy;
		
		protected var _firstFocus:Boolean = true;
		protected var _borderColor:int = 0;
		protected var _maxBytes:int = 0;
		protected var _isShowingBGText:Boolean = true;
		protected var _useHand:Boolean = false;
		protected var _backgroundText:String;
		protected var _clickText:String;
		protected var _defaultText:String;
		protected var _isDefaultState:Boolean = true;
		protected var _align:String = TextFormatAlign.LEFT;
		protected var _borderChange:Boolean = true;
		protected var _focusSensitive:Boolean = true;
		protected var _displayAsPassword:Boolean = false;
		
		protected var _lastInput:String;
		protected var _restrictRegExp:RegExp;
		
		protected var _multiline:Boolean;

		protected var _wordWrap:Boolean;

		private var _textCache:String = "";

		
		/**
		 * 私有属性，设置背景文字的显示
		 */
		protected function set isShowingBGText(value:Boolean):void
		{
			_isShowingBGText = value;
			
			if (value && _backgroundText != null)
			{
				_textField.displayAsPassword = false;
				_textField.htmlText = "<font color='#999999'>" + _backgroundText + "</font>";
			} else
			{
				_textField.reset();
				_textField.displayAsPassword = _displayAsPassword;
				_textField.htmlText = _textField.text;
			}
			refreshAlign();
		}
		
		/**
		 * 一个布尔值，表示文本字段是否自动换行。如果 wordWrap 的值为 true，则该文本字段自动换行；如果值为 false，则该文本字段不自动换行。默认值为 false。 
		 * @return 
		 * 
		 */		
		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
		}
		
		
		/**
		 * 表示字段是否为多行文本字段。如果值为 true，则文本字段为多行文本字段；如果值为 false，则文本字段为单行文本字段。在类型为 TextFieldType.INPUT 的字段中，multiline 值将确定 Enter 键是否创建新行（如果值为 false，则将忽略 Enter 键）。如果将文本粘贴到其 multiline 值为 false 的 TextField 中，则文本中将除去新行。 
		 * @return 
		 * 
		 */		
		public function get multiline():Boolean
		{
			
			return _textField.multiline;
		}
		
		public function set multiline(value:Boolean):void
		{
			_textField.multiline = value;
		}
		
		/**
		 * 获取或设置文字有变化时的回调方法
		 */
		public function get change():Function
		{
			return _changeHandler;
		}
		
		public function set change(value:Function):void
		{
			_changeHandler = value;
		}
		
		
		
		/**
		 * 获取或设置当组件获取焦点时按下回车键时的回调方法
		 */
		public function get enter():Function
		{
			return _enterHandler;
		}
		
		public function set enter(value:Function):void
		{
			_enterHandler = value;
		}
		
		/**
		 * 获取或设置是否第一次获得焦点
		 */
		public function get firstFocus():Boolean
		{
			return _firstFocus;
		}
		
		public function set firstFocus(value:Boolean):void
		{
			_firstFocus = value;
		}
		
		/**
		 * 获取或设置输入框高度
		 */
		override public function get height():Number
		{
			return _textField.height;
		}
		
		override public function set height(value:Number):void
		{
			_textField.height = value;
		}
		
		/**
		 * 获取或设置输入框宽度
		 */
		override public function get width():Number
		{
			return _textField.width;
		}
		
		override public function set width(value:Number):void
		{
			_textField.width = value;
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			_textField.backgroundColor = value ? 0xffffff : 0xaaaaaa;
			_textField.selectable = value;
			this.focusSensitive = value;
		}
		
		/**
		 * 获取或设置输入框文本
		 */
		public function get text():String
		{
			if (_isShowingBGText)
				return "";
			return _textField.text;
		}
		
		public function set text(value:String):void
		{
			_textField.text = value;
			_lastInput = value;
			refreshAlign();
			isShowingBGText = false;
		}
		
		/**
		 * 获取或设置输入框HTML文本
		 */
		public function get htmlText():String
		{
			if (_isShowingBGText)
				return "";
			return _textField.htmlText;
		}
		
		public function set htmlText(value:String):void
		{
			_textField.htmlText = value;
			_lastInput = value;
			refreshAlign();
			isShowingBGText = false;
		}
		
		/**
		 * 获取或设置用户输入的最大字符数(不区分单双字节字符)，为0则不做限制
		 */
		public function get maxChars():int
		{
			return _textField.maxChars;
		}
		
		public function set maxChars(value:int):void
		{
			_textField.maxChars = value;
		}
		
		/**
		 * 获取或设置用户输入的最大字节数（双字节字符算作2个字节位置），为0则不做限制
		 */
		public function get maxBytes():int
		{
			return _maxBytes;
		}
		
		public function set maxBytes(value:int):void
		{
			_maxBytes = value;
			
			// 如果已经超长则立即截断
			if (_maxBytes > 0)
			{
				var str:String = _textField.text;
				
				while (StringUtil.length(str) > _maxBytes)
				{
					str = str.substr(0, str.length - 1);
				}
				text = str;
			}
		}
		
		/**
		 * 获取或设置输入框限制字符
		 */
		public function get restrict():String
		{
			return _textField.restrict;
		}
		
		public function set restrict(value:String):void
		{
			_textField.restrict = value;
		}
		
		/**
		 * 获取或设置输入限制正则表达式，如果设置了该属性则当用户输入时检验是否符合正则表达式，不符合将忽略该次输入
		 */
		public function get restrictRegExp():RegExp
		{
			return _restrictRegExp;
		}
		
		public function set restrictRegExp(value:RegExp):void
		{
			_restrictRegExp = value;
		}
		
		/**
		 * 获取或设置是否显示边框
		 */
		public function get border():Boolean
		{
			return _textField.border;
		}
		
		public function set border(value:Boolean):void
		{
			_textField.border = value;
		}
		
		/**
		 * 获取或设置边框颜色
		 */
		public function get borderColor():uint
		{
			return _borderColor;
		}
		
		public function set borderColor(value:uint):void
		{
			_borderColor = value;
			_textField.borderColor = value;
		}
		
		/**
		 * 获取或设置当鼠标悬停的时候是否使边框颜色发生变化
		 */
		public function get borderChange():Boolean
		{
			return _borderChange;
		}
		
		public function set borderChange(value:Boolean):void
		{
			_borderChange = value;
		}
		
		/**
		 * 获取或设置是否显示背景
		 */
		public function get background():Boolean
		{
			return _textField.background;
		}
		
		public function set background(value:Boolean):void
		{
			_textField.background = value;
		}
		
		/**
		 * 获取或设置背景颜色
		 */
		public function get backgroundColor():uint
		{
			return _textField.backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void
		{
			_textField.backgroundColor = value;
		}
		
		/**
		 * 获取或设置文本为空且文本框没有焦点时显示的文字
		 */
		public function get backgroundText():String
		{
			return _backgroundText;
		}
		
		public function set backgroundText(value:String):void
		{
			_backgroundText = (value == null ? "" : value);
			isShowingBGText = true;
		}
		
		/**
		 * 获取或设置默认状态下第一次点击时要填入的文本
		 */
		public function get clickText():String
		{
			return _clickText;
		}
		
		public function set clickText(value:String):void
		{
			_clickText = value;
		}
		
		/**
		 * 获取或设置默认显示的文本
		 */
		public function get defaultText():String
		{
			return _defaultText;
		}
		
		public function set defaultText(value:String):void
		{
			_defaultText = value;
			
			if (_isDefaultState && value != null)
			{
				text = value;
				isShowingBGText = false;
			}
		}
		
		/**
		 * 获取或设置鼠标悬停时是否显示小手图标
		 */
		public function get useHand():Boolean
		{
			return _useHand;
		}
		
		public function set useHand(value:Boolean):void
		{
			_useHand = value;
		}
		
		/**
		 * 设置输入框对齐方式
		 */
		public function set align(value:String):void
		{
			_align = value;
			refreshAlign();
		}
		
		/**
		 * 获取输入框中字符数
		 */
		public function get length():int
		{
			return _textField.length;
		}
		
		/**
		 * 获取输入框实体
		 */
		public function get textField():TextFieldProxy
		{
			return _textField;
		}
		
		/**
		 * 获取或设置是否响应焦点事件
		 */
		public function get focusSensitive():Boolean
		{
			return _focusSensitive;
		}
		
		public function set focusSensitive(value:Boolean):void
		{
			_focusSensitive = value;
		}
		
		/**
		 * 获取或设置是否显示为密码形式
		 */
		public function get displayAsPassword():Boolean
		{
			return _displayAsPassword;
		}
		
		public function set displayAsPassword(value:Boolean):void
		{
			_displayAsPassword = value;
			_textField.displayAsPassword = (!_isShowingBGText && _displayAsPassword);
		}
		
		/**
		 * 获取或设置文本字号
		 */
		public function get fontSize():int
		{
			return _textField.fontSize;
		}
		
		public function set fontSize(value:int):void
		{
			_textField.fontSize = value;
		}
		
		/**
		 * 获取或设置文本颜色
		 */
		public function get fontColor():uint
		{
			return _textField.fontColor;
		}
		
		public function set fontColor(value:uint):void
		{
			_textField.fontColor = value;
		}
		/**
		 * 获取或设置文本行间距
		 */
		public function get leading():uint
		{
			return _textField.leading;
		}
		
		public function set leading(value:uint):void
		{
			_textField.leading = value;
		}
		
		
		public function set fontFamily(value:String):void
		{
			_textField.fontFamily = value;
		}
		
		public function set color(value:String):void
		{
			_textField.color = value;
		}
		
		/**
		 * 字符之间均匀分配的空间量
		 */
		public function get letterSpacing():int
		{
			return _textField.letterSpacing;
		}
		
		public function set letterSpacing(value:int):void
		{
			_textField.letterSpacing = value;
		}
		
		/**
		 * 初始化
		 * @param id 标识符，可用于区分不同组件
		 * @param data 可记录任意信息的对象
		 * @param clickHandler 鼠标单击相应方法
		 * @param changeHandler 文本有改变时执行的方法
		 * @param enterHandler 当输入框拥有焦点时按下"Enter"时执行的方法
		 */
		public function Input(id:int = 0, clickHandler:Function = null, changeHandler:Function = null, enterHandler:Function = null)
		{
			super(id, null, clickHandler);
			_changeHandler = changeHandler;
			_enterHandler = enterHandler;
			this.hasHoverTip = false;
		}
		
		override protected function init():void
		{
			initTextField();
			super.init();
			_mouseEffectBehavior = new InputMouseEffectBehavior();
		}
		
		protected function initTextField():void
		{
			_textField = new TextFieldProxy();
			_textField.mouseEnabled = true;
			this.text = ""
			_textField.fontColor = 0;
			_textField.leading = 0;
			_textField.multiline = false;
			_textField.width = 100;
			_textField.height = 18;
			_textField.alwaysShowSelection = false;
			_textField.autoSize = TextFieldAutoSize.NONE;
			_textField.type = TextFieldType.INPUT;
			_textField.selectable = true;
			_textField.border = true;
			_textField.borderColor = 0;
			_textField.background = true;
			_textField.backgroundColor = 0xffffff;
			addChild(_textField);
		}
		
		override protected function initListener():void
		{
			super.initListener();
			
			_textField.addEventListener(Event.CHANGE, textChangeHandler);
			_textField.addEventListener(FocusEvent.FOCUS_IN, textFocusInHandler);
			_textField.addEventListener(FocusEvent.FOCUS_OUT, textFocusOutHandler);
			_textField.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
		}
		

		protected function textChangeHandler(e:Event):void
		{
			var changed:Boolean = false;
			// 验证输入长度
			if (maxBytes > 0)
			{
//				var str:String = _textField.text;
//				while (StringUtil.length(str) > maxBytes)
//				{
//					str = str.substr(0, str.length - 1);
//				}
//				_textField.text = str;
//				e.preventDefault();
//				changed = true;
				var str:String = _textField.text;
				if(StringUtil.length(str) > maxBytes)
				{
					var selectBegin:int = _textField.selectionBeginIndex;
					var selectEnd:int = _textField.selectionEndIndex;
					var len:int = str.length-_textCache.length;
					selectBegin -= len;
					selectEnd -= len;
					_textField.text = _textCache;
					_textField.setSelection(selectBegin,selectEnd);	
				}
				e.preventDefault();
				changed = true;
			}
			
			
			
			// 验证输入限制
			if (_restrictRegExp != null)
			{
				if (!_restrictRegExp.test(_textField.text))
				{
					_textField.text = _lastInput;
					e.preventDefault();
					changed = true;
				}
			}
			_lastInput = _textField.text;
			
			if (changed)
			{
				refreshAlign();
				isShowingBGText = false;
			}
			
			if (_changeHandler != null)
				_changeHandler(e);
			
			_textCache = _textField.text;
		}
		
		protected function textFocusInHandler(e:FocusEvent):void
		{
			if (!_focusSensitive)
				return ;
			
			if (_isShowingBGText)
			{
				htmlText = "";
				_isShowingBGText = false;
			}
			_firstFocus = true;
			
			if (_isDefaultState && _clickText != null)
			{
				_isDefaultState = false;
				text = _clickText;
			}
		}
		
		protected function textFocusOutHandler(e:FocusEvent):void
		{
			if (!_focusSensitive)
				return ;
			isShowingBGText = (_textField.text == "");
		}
		
		protected function keyDownHandler(e:KeyboardEvent):void
		{
			if (StageRunner.getInstance().stage.focus == _textField)
			{
				if (e.keyCode == Keyboard.ENTER && _enterHandler != null)
				{
					_enterHandler(e);
				}
			}
		}
		
		protected function refreshAlign():void
		{
			var tf:TextFormat = _textField.getTextFormat();
			tf.align = _align;
			_textField.setTextFormat(tf);
			
			tf = _textField.defaultTextFormat;
			tf.align = _align;
			_textField.defaultTextFormat = tf;
		}
		
		override public function clear():void
		{
			super.clear();
			_textField.text = "";
		}
		
		override public function dispose():void
		{
			if (_textField != null)
			{
				if (_textField.hasEventListener(Event.CHANGE))
				{
					_textField.removeEventListener(Event.CHANGE, textChangeHandler);
				}
				
				if (_textField.hasEventListener(FocusEvent.FOCUS_IN))
				{
					_textField.removeEventListener(FocusEvent.FOCUS_IN, textFocusInHandler);
				}
				
				if (_textField.hasEventListener(FocusEvent.FOCUS_OUT))
				{
					_textField.removeEventListener(FocusEvent.FOCUS_OUT, textFocusOutHandler);
				}
				
				if (_textField.hasEventListener(KeyboardEvent.KEY_DOWN))
				{
					_textField.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				}
			}
			_changeHandler = null;
			_enterHandler = null;
			ObjectPool.disposeObject(_textField);
			_textField = null;
			_restrictRegExp = null;
			super.dispose();
		}
		
		/**
		 * 选中指定范围内的文本
		 * @param beginIndex 要选中的文本的起始索引，默认为第一个字符
		 * @param endIndex 要选中的文本的结束索引，默认为最后一个字符
		 */
		public function setSelection(beginIndex:int = 0, endIndex:int = -1):void
		{
			if (_isShowingBGText || !this.enabled)
				return ;
			var end:int = endIndex == -1 ? _textField.length : endIndex;
			_textField.setSelection(beginIndex, end);
		}
		
		/**
		 * 设置焦点
		 */
		public function setFocus():void
		{
			StageRunner.getInstance().stage.focus = _textField;
		}
		
		/**
		 * 重置，将文本替换为默认文本，并且启动第一次点击时更换文本的功能
		 */
		public function reset():void
		{
			if (_defaultText != null)
				text = _defaultText;
			else if (_backgroundText != null)
				isShowingBGText = true;
			else
				htmlText = "";
			_isDefaultState = true;
		}
	}
}
