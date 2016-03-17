package kernel.display.components.checkbox
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormatAlign;
	
	import kernel.data.FontNameType;
	import kernel.display.components.BitmapProxy;
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.text.ITextStyle;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ObjectPool;
	
	/**
	 * 09-9-10
	 * 多选框组件
	 */
	public class CheckBox extends MouseEffectiveComponent implements ITextStyle
	{
		protected var _imgBG:BitmapProxy;
		protected var _imgHook:BitmapProxy;
		private var _txtContent:TextFieldProxy;
		
		private var _text:String = "";
		private var _padding:Number = 4;
		private var _maxWidth:int;
		public function set text(value:String):void
		{
			_txtContent.text = value;
		}
		
		
		public function set maxWidth(value:int):void
		{
			this._maxWidth = value;
		}
		
		public function set color(value:String):void
		{
			this._txtContent.color = value;
		}
		
		public function set fontFamily(value:String):void
		{
			this._txtContent.fontFamily = value;
		}
		
		public function set fontSize(value:int):void
		{
			this._txtContent.fontSize = value;
		}
		
		
		public function set worldTrap(value:Boolean):void
		{
			this._txtContent.wordWrap = value;
		}
		
		public function set contentWidth(value:Number):void
		{
			this._txtContent.width = value;
		}
		
		public function set fontStyle(value:String):void
		{
			this._txtContent.fontStyle = value;
		}
		
		public function set fontWeight(value:String):void
		{
			this._txtContent.fontWeight = value;
		}
		
		public function set textAlign(value:String):void
		{
			this._txtContent.textAlign = value;
		}
		
		
		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
		}
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			_imgHook.visible = value;
		}
		
		/**
		 * 获取或设置CheckBox中的文本
		 */
		public function get label():String
		{
			return _text;
		}
		
		public function set label(value:String):void
		{
			_text = value;
			updateView();
		}
		
		/**
		 * 
		 */
		public function get imgHook():BitmapProxy
		{
			return this._imgHook;
		}
		
		public function get imgBG():BitmapProxy
		{
			return this._imgBG;
		}
		
		public function CheckBox(id:int = 0, clickHandler:Function = null)
		{
			super(id, clickHandler);
			this._txtContent.fontColor = 0xffffff;
			this._txtContent.font = FontNameType.ARIAL;
		}
		
		override protected function init():void
		{
			mouseEffectBehavior = UISkinRunner.checkBoxMouseEffectBehavior;
			this.buttonMode = true;
			
			super.init();
			
			_imgBG = new BitmapProxy(UISkinRunner.checkBoxBG);
			_imgBG.addEventListener(Event.COMPLETE, loadCompleteHandler);
			addChild(_imgBG);
			
			_imgHook = new BitmapProxy(UISkinRunner.checkBoxSelectedBG);
			_imgHook.visible = false;
			_imgHook.addEventListener(Event.COMPLETE, loadCompleteHandler);
			_imgHook.x = _imgBG.x + _imgBG.width / 2 - _imgHook.width / 2;
			_imgHook.y = _imgBG.y + _imgBG.height / 2 - _imgHook.height / 2;
			addChild(_imgHook);
			
			_txtContent = new TextFieldProxy()
			_txtContent.wordWrap = false;
			_txtContent.mouseEnabled = false;
			addChild(_txtContent);
			
			updateView();
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			toggle();
			super.clickHandler(event);
		}
		
		private function loadCompleteHandler(event:Event):void
		{
			event.target.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			updateView();
		}
		
		protected function updateView():void
		{
			_txtContent.text = _text;
		   
			if (_maxWidth!=0) 
			{
				if (_txtContent.width>_maxWidth) 
				{   
					_txtContent.width=this._maxWidth;
					_txtContent.multiline=true;
					_txtContent.wordWrap=true;
				}else
				{
					_txtContent.width=0;
					_txtContent.multiline=false;
					_txtContent.wordWrap=false;
				}
			}
			
			_txtContent.x = _padding * 2 + _imgBG.width;
			_txtContent.y = _imgBG.y + (_imgBG.height - _txtContent.height) / 2;
		}
		
		/**
		 * 切换CheckBox的选中状态
		 */
		public function toggle():void
		{
			selected = !selected;
		}
		
		/**
		 * 设置标签的样式类型
		 * @param style 样式类型
		 */
		public function setLabelStyle(style:int):void
		{
			_txtContent.setStyle(style);
		}
		
		override public function clear():void
		{
			super.clear();
			this.label = "";
		}
		
		override public function dispose():void
		{
			if(_imgBG != null)
			if (_imgBG.hasEventListener(Event.COMPLETE))
			{
				_imgBG.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			}
			if(_imgHook != null)
			if (_imgHook.hasEventListener(Event.COMPLETE))
			{
				_imgHook.removeEventListener(Event.COMPLETE, loadCompleteHandler);
			}
			ObjectPool.disposeObject(_imgBG);
			ObjectPool.disposeObject(_imgHook);
			ObjectPool.disposeObject(_txtContent);
			_imgBG = null;
			_imgHook = null;
			_txtContent = null;
			super.dispose();
		}

	}
}