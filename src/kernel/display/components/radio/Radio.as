package kernel.display.components.radio
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import kernel.display.components.BitmapProxy;
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.events.RadioEvent;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ColorUtil;
	import kernel.utils.ObjectPool;
	
	public class Radio extends MouseEffectiveComponent
	{
		protected var _label:TextFieldProxy;
		protected var _view:DisplayObject;
		protected var _selectedView:DisplayObject;
		
		
		
		override public function set enabled(able:Boolean):void
		{
			super.enabled = able;
			
			if (able)
			{
				ColorUtil.deFadeColor(_view);
				ColorUtil.deFadeColor(_selectedView);
			} else
			{
				ColorUtil.fadeColor(_view);
				ColorUtil.deHighLight(_view);
				ColorUtil.fadeColor(_selectedView);
				ColorUtil.deHighLight(_selectedView);
			}
		}
		
		public function getLabel():TextFieldProxy
		{
			return _label;
		}
		
		public function get label():String
		{
			return _label.text;
		}
		
		public function set label(value:String):void
		{
			_label.htmlText = value;
			this.layoutText();
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
		}
		
		public function set color(value:String):void
		{
			_label.color = value;
		}
		
		public function set fontFamily(value:String):void
		{
			_label.fontFamily = value;
		}
		
		public function set fontSize(value:int):void
		{
			_label.fontSize = value;
		}
		
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			updateView();
		}
		
		public function Radio(id:int = 0, label:String = "", selected:Boolean = false)
		{
			super(id);
			this.label = label;
			this.selected = selected;
			// 触发事件
			var evt:RadioEvent = new RadioEvent(RadioEvent.RADIO_CREATED, this);
			dispatchEvent(evt);
		}
		
		override protected function init():void
		{
			super.init();
			initShape();
			initText();
			this.buttonMode = true;
			this.mouseEnabled = true;
			this.mouseChildren = true;
		}
		
		private function initShape():void
		{
			_view = new BitmapProxy(UISkinRunner.radioBG);
			addChild(_view);
			
			_selectedView = new BitmapProxy(UISkinRunner.radioSelectedBG);
			addChild(_selectedView);
			
			updateView();
		}
		
		protected function initText():void
		{
			_label = new TextFieldProxy();
			_label.fontColor = 0xffffff;
			addChild(_label);
		}
		
		protected function layoutText():void
		{
			if (_label == null || _view == null)
			{
				return ;
			}
			_label.x = _view.x + _view.width + 2;
			_label.y = _view.y + _view.height / 2 - _label.textHeight / 2 - 2;
		}
		
		
		
		protected function updateView():void
		{
			if (this.selected)
			{
				_view.visible = false;
				_selectedView.visible = true;
			} else
			{
				_view.visible = true;
				_selectedView.visible = false;
			}
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
			
			if (!this.enabled)
				return ;
			setSelected(true);
		}
		
		/**
		 * 改变选中状态并且触发事件
		 *
		 * @param value 是否选择
		 */
		public function setSelected(value:Boolean):void
		{
			var changed:Boolean = (this.selected != value);
			selected = value;
			
			// 触发事件
			if (changed)
			{
				var evt:RadioEvent = new RadioEvent(RadioEvent.RADIO_SELECTED, this, true, true);
				evt.data.id = id;
				evt.data.label = label;
				evt.data.group = groupName;
				evt.data.value = value;
				dispatchEvent(evt);
			}
		}
		
		override public function clear():void
		{
			super.clear();
			this.selectable = true;
			this.selected = false;
			this.enabled = true;
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_label);
			_label = null;
			ObjectPool.disposeObject(_view);
			_view = null;
			ObjectPool.disposeObject(_selectedView);
			_selectedView = null;
			
			super.dispose();
		}
	}
}