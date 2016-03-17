package kernel.display.components.text
{
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import kernel.IClear;
	import kernel.IDispose;
	import kernel.data.FontNameType;
	import kernel.display.components.ILayoutable;
	import kernel.display.components.LayoutVO;
	import kernel.runner.ITick;
	import kernel.runner.TickRunner;
	import kernel.utils.ColorUtil;
	import kernel.utils.FiltersUtil;
	import kernel.utils.LayoutUtil;
	
	import utils.TextMapperUtil;
	
	
	/**
	 * 文件名：CoreTextField.as
	 * <p>
	 * 功能：作为常规TextField的替代品，可以在游戏开始的时候为该类设置样式，
	 * 		 然后在游戏中每次生成新的实例都会是这个样式
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class TextFieldProxy extends TextField implements IClear, ILayoutable, IDispose, ITextStyle , ITick
	{
		private var _style:int = 0;
		private var _styleSheet:StyleSheet;
		private var _fontColor:uint;
		private var _fontSize:int;
		private var _defaultTextFormat:TextFormat;
		private var _font:String;
		private var _letterSpacing:int;
		private var _leading:int;
		private var _glow:GlowFilter;
		private var _glowable:Boolean;
		private var _underline:Boolean;
		
		
		private var _speed:int = 1;
		/**用于记录公告每次移动的scrollh*/
		private var _scrollBase:int = -1;
		/**延迟计数*/
		private var _delay:int = _speed;	
		
		public var hasMarquee:Boolean;
		
		private var _maxWidth:Number = NaN;
		
		
		public function get underline():Boolean
		{
			return _underline;
		}

		public function set underline(value:Boolean):void
		{
			_underline = value;
			var format:TextFormat = this.defaultTextFormat;
			format.underline = _underline;
			_defaultTextFormat = format;
			this.defaultTextFormat = _defaultTextFormat;
			this.setTextFormat(format);
		}

		public function get glowable():Boolean
		{
			return _glowable;
		}
		
		public function set glowable(value:Boolean):void
		{
			_glowable = value;
			
			if (value == true)
			{
				if (this.glow == null)
				{
					this.glow = FiltersUtil.getNormalTextFieldGlowFilter();
					
				}
				
				if (this.filters != null && this.filters.length > 0)
				{
					var f:Array = this.filters;
					f.push(this.glow);
					this.filters = f;
				} else
				{
					this.filters = [this.glow];
				}
			} else
			{
				this.glow = null;
				this.filters = [];
			}
		}
		
		public function get glow():GlowFilter
		{
			return _glow;
		}
		
		public function set glow(value:GlowFilter):void
		{
			_glow = value;
			
			if (value == null)
			{
				this._glowable = false;
			} else
			{
				this._glowable = true;
			}
		}
		
		public function set color(value:String):void
		{
			this.fontColor = ColorUtil.colorStringToColorHex(value);
		}
		
		public function set fontFamily(value:String):void
		{
			this.font = value;
		}
		
		public function set fontStyle(value:String):void
		{
			if (value == "italic")
			{
				this.italic = true;
			}
		}
		
		public function set fontWeight(value:String):void
		{
			if (value == "bold")
			{
				this.bold = true;
			}
		}
		
		public function set align(value:String):void
		{
			if (value == null)
			{
				return ;
			}
			var format:TextFormat = this.defaultTextFormat;
			format.align = value;
			_defaultTextFormat = format;
			
			if (this.styleSheet == null)
			{
				this.defaultTextFormat = _defaultTextFormat;
				this.setTextFormat(format);
			}
		}
		
		public function set textAlign(value:String):void
		{
			if (value == null)
			{
				return ;
			}
			this.autoSize = value;
		}
		
		/**
		 * 文本字体
		 * @return
		 *
		 */
		public function get font():String
		{
			return _font;
		}
		
		/**
		 * 文本字体
		 * @return
		 *
		 */
		public function set font(value:String):void
		{
			var format:TextFormat = this.defaultTextFormat;
			_font = value;
			format.font = value;
			_defaultTextFormat = format;
			this.defaultTextFormat = _defaultTextFormat;
			this.setTextFormat(format);
		}
		
		/**
		 * 字符之间均匀分配的空间量
		 * @return
		 *
		 */
		public function get letterSpacing():int
		{
			return _letterSpacing;
		}
		
		/**
		 * 字符之间均匀分配的空间量
		 * @return
		 *
		 */
		public function set letterSpacing(value:int):void
		{
			_letterSpacing = value;
			var format:TextFormat = this.defaultTextFormat;
			format.letterSpacing = _letterSpacing;
			_defaultTextFormat = format;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		/**
		 * 获取或设置文本是否为粗体
		 */
		public function get bold():Boolean
		{
			return this.defaultTextFormat.bold;
		}
		
		public function set bold(value:Boolean):void
		{
			var format:TextFormat = this.defaultTextFormat;
			format.bold = value;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		/**
		 * 获取或设置文本是否为斜体
		 */
		public function get italic():Boolean
		{
			return this.defaultTextFormat.italic;
		}
		
		public function set italic(value:Boolean):void
		{
			var format:TextFormat = this.defaultTextFormat;
			format.italic = value;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		/**
		 * 获取或设置文本字号
		 */
		public function get fontSize():int
		{
			return _fontSize;
		}
		
		public function set fontSize(value:int):void
		{
			var format:TextFormat = this.defaultTextFormat;
			_fontSize = value;
			format.size = value;
			_defaultTextFormat = format;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}
		
		/**
		 * 获取或设置文本颜色
		 */
		public function get fontColor():uint
		{
			return _fontColor;
		}
		
		public function set fontColor(value:uint):void
		{
			var format:TextFormat = this.defaultTextFormat;
			_fontColor = value;
			format.color = value;
			_defaultTextFormat = format;
			this.defaultTextFormat = _defaultTextFormat;
			this.setTextFormat(format);
		}
		
		
		
		override public function set styleSheet(value:StyleSheet):void
		{
			super.styleSheet = value;
			_styleSheet = value;
		}
		
		public function TextFieldProxy()
		{
			super();
			this.mouseEnabled = false;
			this.tabEnabled = false;
			this.autoSize = TextFieldAutoSize.LEFT;
			this.selectable = false;
			if(FontNameType.NORMAL_FONT_1001 != "")
			{
				this.font = FontNameType.NORMAL_FONT_1001;
			}
		}
		
		/**
		 * 设置文本的样式
		 * @param value
		 *
		 */
		public function setTextStyle(value:int):void
		{
			TextMapperUtil.mapTextField(value, this);
		}
		
		/**
		 * 设置样式类型
		 * @param style 样式类型，即在配置文件中样式的索引
		 */
		public function setStyle(style:int):void
		{
			_style = style;
			reset();
		}
		
		/**
		 * 按照传入的布局数据对组件进行布局，组件默认不对子数据进行布局
		 * @param layout 布局数据
		 */
		public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layout(this, layout);
		}
		
		/**
		 * 恢复到初始格式
		 */
		public function reset():void
		{
			
			if (_defaultTextFormat != null)
			{
				if (this.styleSheet == null)
				{
					this.setTextFormat(_defaultTextFormat)
					this.defaultTextFormat = _defaultTextFormat;
				}
			}
		}
		
		public function clear():void
		{
			this.text = "";
			this.autoSize = TextFieldAutoSize.LEFT;
			this.selectable = false;
		}
		
		
		private function checkTick():void
		{
			
			if( !hasMarquee )
			{
				return;	
			}
			
			TickRunner.getInstance().removeTicker(this);
			
			if (this.textWidth > this.width && this.width > 0) 
			{
				super.text = "     " + super.text + "     ";
				_scrollBase = -1;
				TickRunner.getInstance().addTicker(this);
			}
			else
			{
				TickRunner.getInstance().removeTicker(this);
			}
		}
		
		
		
		public function onTick(delay:uint):void
		{
			if (_delay != 0) 
			{
				_delay--;
				return;
			}
			_delay = _speed;
			var tempScrollH:int = this.scrollH;
			this.scrollH = 1 * _scrollBase;
			_scrollBase --;
			if (tempScrollH == this.scrollH) //scrollH不再变化时表示到头，将i置为初始值-1，以便循环
			{
				_scrollBase = -1;
			}
		}
		
		public function get speed():int
		{
			return _speed;
		}
		
		public function set speed(value:int):void
		{
			_speed = value;
		}
		
		
		/**
		 *  更新作用的最大宽度。暂不支持htmltext。且本方法将会改变文本text 
		 * 
		 */		
		public function updateMaxWidth():void
		{	
			if( isNaN( _maxWidth ) == false )
			{
				
				if( this.textWidth  > _maxWidth)
				{
					var textStr:String = this.text;
					var lastStr:String = "...";
					
					var showStr:String;
					var index:int = 0;
					
					for( var i:int = 0 ; i < textStr.length ; i++ )
					{
						index = i;
						showStr = textStr.slice(0 , index)+lastStr;
						
						this.text = showStr;
						
						if(this.textWidth >= _maxWidth)
						{
							break;
						}
						
					}
					
					var endIndex:int = index - 1;
					if(endIndex < 0)
					{
						endIndex = 0;
					}
					showStr = textStr.slice(0 , endIndex)+lastStr;
					this.text = showStr;
					
				}
				
			}
			
			
		}
		
		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		/**
		 * 设置为nan则不支持最大宽度，设置成数值，则将接近最大宽度的地方显示成...。暂不支持htmltext。且本方法将会改变文本text 
		 * @param value
		 * 
		 */		
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
		}
		
		
		public function dispose():void
		{
			TickRunner.getInstance().removeTicker(this);
			this.text = "";
			this._styleSheet = null;
			this._defaultTextFormat = null;
			this._glow = null;
			this.filters = [];
		}

		/**一个整数，表示行与行之间的垂直间距*/
		public function get leading():int
		{
			return _leading;
		}

		/**
		 * @private
		 */
		public function set leading(value:int):void
		{
			_leading = value;
			var format:TextFormat = this.defaultTextFormat;
			format.leading = _leading;
			_defaultTextFormat = format;
			this.defaultTextFormat = format;
			this.setTextFormat(format);
		}

	}
}