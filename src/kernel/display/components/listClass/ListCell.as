package kernel.display.components.listClass
{
	
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	import kernel.display.components.text.TextFieldProxy;
	import kernel.utils.ColorUtil;
	import kernel.utils.ObjectPool;
	
	
	public class ListCell extends BaseListCell
	{
		internal var _isClick:Boolean;
		private var _defaultColor:uint = 0x000000;
		private var _highLightColor:uint = 0xfff48f;
		private var _clickBgColor:uint = 0xfff48f;
		internal var _index:int;
		private var _drawWidth:int;
		private var _enable:Boolean;
		
		internal var _owner:List;
		
		//1.2.3版本新增，为了适应 委任的需求  如(2小时 VIP)，这里这个TF只是为了存放VIP这样的一个类似与解释说明的文字，不会因为ENABEL而变色
		private var _noteTf:TextField;
		private var _note:String;
		
		
		private var _textAlign:String;
		
		public function ListCell(index:int, width:int, height:int, owner:List, textAlign:String = TextFieldAutoSize.CENTER)
		{
			_index = index;
			_drawWidth = width;
			_height = height;
			_owner = owner;
			leftPadding = 2;
			super(index, 0, width, height, textAlign);
			this.enable = true;
			initListeners();
			drawBg();
		}
		
		//设置解释文字值，同时设置显示
		public function set note(value:String):void
		{
			
			this._note = value;
			
			if (this._noteTf != null)
			{
				this._noteTf.htmlText = value;
			} else
			{
				this._noteTf = new TextFieldProxy();
				this._noteTf.mouseEnabled = false;
				this._noteTf.htmlText = value;
			}
			
			if (!this.contains(this._noteTf))
				this.addChild(this._noteTf);
			this.updateNoteTf();
		}
		
		public function get note():String
		{
			return this._note;
		}
		
		override protected function resetTextFeild():void
		{
			this.updateNoteTf();
			super.resetTextFeild();
		}
		
		private function updateNoteTf():void
		{
			if (this._noteTf == null)
			{
				this._noteTf = new TextFieldProxy();
				this._noteTf.mouseEnabled = false;
				
				if (!this.contains(this._noteTf))
					this.addChild(this._noteTf);
			}
			this._noteTf.x = this._drawWidth - this._noteTf.width;
		}
		
		override public function set width(value:Number):void
		{
			setWidth(value);
			_drawWidth = value;
			drawBg();
			
			if (this._isClick)
			{
				drawClickBg();
			}
		}
		
		internal function initListeners():void
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		internal function removeListeners():void
		{
			this.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.removeEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			this.removeEventListener(MouseEvent.CLICK, onClick);
		}
		
		private function drawHighLight():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, _gridColor);
			this.graphics.beginFill(_highLightColor, 0.35);
			this.graphics.drawRect(0, 0, _drawWidth, _height - 1);
			this.graphics.endFill();
		}
		
		override protected function drawBg():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, _gridColor);
			
			if (_bgBitmapData != null)
			{
				this.graphics.beginBitmapFill(_bgBitmapData, null, true);
			}else
			{
				this.graphics.beginFill(_defaultColor, 0.3);
			}
			this.graphics.drawRect(0, 0, _drawWidth, _height - 1);
			this.graphics.endFill();
		}
		
		private function clearBg():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, _gridColor);
			
			if (_bgBitmapData != null)
			{
				this.graphics.beginBitmapFill(_bgBitmapData, null, true);
			} else
			{
				this.graphics.beginFill(_defaultColor, 0.3);
			}
			this.graphics.drawRect(0, 0, _drawWidth, _height - 1);
			this.graphics.endFill();
		}
		
		private function drawClickBg():void
		{
			this.graphics.clear();
			this.graphics.lineStyle(1, _gridColor);
			this.graphics.beginFill(_clickBgColor,0.35);
			this.graphics.drawRect(0, 0, _drawWidth, _height - 1);
			this.graphics.endFill();
		}
		
		private function onMouseOver(event:MouseEvent):void
		{
			event.stopPropagation();
			drawHighLight();
			this._textField.setTextStyle(10);
		}
		
		private function onMouseOut(event:MouseEvent):void
		{
			event.stopPropagation();
			clearBg();
			this._textField.setTextStyle(11);
			if (_isClick)
			{
				drawClickBg();
			}
		}
		
		override public function clear():void
		{
			this._isClick = false;
			this.clearBg();
		}
		
		private function onClick(event:MouseEvent):void
		{
			showDownState();
			_owner.dispatchEvent(new ListEvent(ListEvent.ITEM_CLICK, false, false, this._index, _owner._dataProvider.getItemAt(_index)));
		}
		
		internal function showDownState():void
		{
			if (_owner._currentCell != null && _owner._currentCell != this)
			{
				_owner._currentCell.clear();
			}
			drawHighLight();
			_owner._currentCell = this;
			this._isClick = true;
		}
		
		//1.2.3新增
		public function set enable(value:Boolean):void
		{
			this._enable = value;
			
			if (value == true)
			{
				this.initListeners();
				ColorUtil.deFadeColor(this._textField);
			} else
			{
				this.removeListeners();
				ColorUtil.fadeColor(this._textField);
			}
			
		}
		
		override public function dispose():void
		{
			//			ObjectPool.disposeObject(_owner);
			_owner = null;
			ObjectPool.disposeObject(_noteTf);
			_noteTf = null;
			
			if (this.hasEventListener(MouseEvent.MOUSE_OVER) && this.hasEventListener(MouseEvent.MOUSE_OUT) && this.hasEventListener(MouseEvent.CLICK))
			{
				removeListeners();
			}
			super.dispose();
		}
	}
}