package kernel.display.components.button
{
	
	import kernel.display.components.text.ITextStyle;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.utils.ObjectPool;
	
	import utils.TextMapperUtil;
	
	/**
	 * 文件名：Button.as
	 * <p>
	 * 功能：有文字 有底图的按钮
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public class Button extends ImageButton implements ITextStyle
	{
		protected var _txtLabel:TextFieldProxy;
		
		protected var _paddingX:int = 18;
		protected var _paddingY:int = 0;
		protected var _marginHorizontal:Number = 0;
		protected var _marginVertical:Number = 0;
		
		
		public function get txtLabel():TextFieldProxy
		{
			return _txtLabel;
		}

		public function set color(value:String):void
		{
			this._txtLabel.color = value;
		}
		
		public function set fontFamily(value:String):void
		{
			this._txtLabel.fontFamily = value;
		}
		
		public function set fontSize(value:int):void
		{
			this._txtLabel.fontSize = value;
		}
		
		public function set fontStyle(value:String):void
		{
			this._txtLabel.fontStyle = value;
		}
		
		public function set fontWeight(value:String):void
		{
			this._txtLabel.fontWeight = value;
		}
		
		public function set textAlign(value:String):void
		{
			this._txtLabel.textAlign = value;
		}
		
		private var _width:Object = null
		
		override public function set width(value:Number):void
		{
			super.width = value;
			_width = value;
			updateLableLocation();
		}
		protected var _height:Object = null;
		
		override public function set height(value:Number):void
		{
			super.height = value;
			_height = value;
			updateLableLocation();
		}
		
		public function set text(value:String):void
		{
			_txtLabel.text = value;
			updateLableLocation();
		}
		
		
		/**
		 * 获取或设置按钮的标签文字
		 */
		public function get label():String
		{
			return _txtLabel.text;
		}
		
		public function set label(value:String):void
		{
			_txtLabel.text = value;
			updateLableLocation();
		}
		
		/**
		 * 设置文本的样式
		 * @param value
		 *
		 */
		public function setTextStyle(value:int):void
		{
			TextMapperUtil.mapTextField(value, this._txtLabel);
		}
		
		/**
		 * 实例化TextButton类
		 * @param id 标识符，可用于区分不同组件
		 * @param label 要显示在按钮上的文字
		 * @param clickHandler 鼠标单击相应方法
		 */
		public function Button(id:int = 0, label:String = "", clickHandler:Function = null)
		{
			super(id, clickHandler);
			this.label = label;
			this.mouseChildren = false;
		}
		
		override protected function init():void
		{
			super.init();
			initLabel();
			//			_padding = UISkinRunner.buttonPadding * 2;
			//			_padding = 3 * 2;
			updateLableLocation();
		}
		
		override protected function initBG():void
		{
			super.initBG();
		}
		
		/**
		 * 初始化按钮的标签
		 */
		protected function initLabel():void
		{
			_txtLabel = new TextFieldProxy();
			_txtLabel.setStyle(1);
			_txtLabel.mouseEnabled = false;
			addChild(_txtLabel);
		}
		
		override public function setImage(image:String, onComplete:Function = null):void
		{
			if(image == null || image == "")
			{
				return;
			}
			super.setImage(image, onComplete);
			updateLableLocation();
		}
		
		private function imgLoadCompleteHandler():void
		{
			updateLableLocation();
		}
		
		/**
		 *设置按钮文字的样式
		 * @param style
		 *
		 */
		public function setLabelStyle(style:int):void
		{
			this._txtLabel.setStyle(style);
		}
		
		protected function updateLableLocation():void
		{
			if (this.label != "")
			{
				if (_width == null)
				{
					if (_txtLabel.textWidth + _paddingX > super.width)
					{
						super.width = _txtLabel.textWidth + _paddingX;
					}
				} else
				{
					if (_txtLabel.textWidth + _paddingX > Number(_width))
					{
						super.width = _txtLabel.textWidth + _paddingX;
					} else
					{
						super.width = Number(_width);
					}
				}
				
				if (_height == null)
				{
					if (_txtLabel.textHeight + _paddingY > super.height)
					{
						super.height = _txtLabel.textHeight + _paddingY;
					}
				} else
				{
					if (_txtLabel.textHeight + _paddingY > Number(_height))
					{
						super.height = _txtLabel.textHeight + _paddingY;
					} else
					{
						super.height = Number(_height);
					}
				}
			}
			
			if (_txtLabel.defaultTextFormat.bold)
			{
				_txtLabel.x = (this.width - _txtLabel.textWidth) / 2 + this._marginHorizontal;
				_txtLabel.y = (this.height - _txtLabel.textHeight) / 2 + this._marginVertical;
			} else
			{
				_txtLabel.x = (this.width - _txtLabel.textWidth) / 2 - 2 + this._marginHorizontal;
				_txtLabel.y = (this.height - _txtLabel.textHeight) / 2 - 3 + this._marginVertical;
			}
		}
		
		override public function clear():void
		{
			super.clear();
			_txtLabel.text = "";
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_txtLabel);
			_txtLabel = null;
			super.dispose();
		}
		
		public function get marginHorizontal():Number
		{
			return _marginHorizontal;
		}
		
		public function set marginHorizontal(value:Number):void
		{
			_marginHorizontal = value;
		}
		
		public function get marginVertical():Number
		{
			return _marginVertical;
		}
		
		public function set marginVertical(value:Number):void
		{
			_marginVertical = value;
		}
		
		
	}
}
