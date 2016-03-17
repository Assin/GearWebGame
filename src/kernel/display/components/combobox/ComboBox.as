package kernel.display.components.combobox
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextFieldAutoSize;
	
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.button.ImageButton;
	import kernel.display.components.listClass.List;
	import kernel.display.components.listClass.ListEvent;
	import kernel.display.components.text.ITextStyle;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.runner.LogRunner;
	import kernel.runner.StageRunner;
	import kernel.runner.UISkinRunner;
	import kernel.utils.DataProvider;
	import kernel.utils.ObjectPool;
	
	/**
	 * 09-9-09
	 * 下拉菜单组件
	 */
	public class ComboBox extends MouseEffectiveComponent implements ITextStyle
	{
		public static const TYPE_DOWN:int = 1;
		public static const TYPE_UP:int = 2;
		
		private var _bg:ImageButton;
		private var _button:Sprite;
		private var _mask:Shape;
		private var _list:List;
		private var _dataProvider:DataProvider;
		private var _cellHeight:Number = 20;
		private var _textField:TextFieldProxy;
		private var _noteTextField:TextFieldProxy;
		private var _textPadding:Number = -4;
		private var _selectedItem:Object;
		private var _maxLength:int = 8;
		private var _type:int;
		
		public function set text(value:String):void
		{
			_textField.text = value;
//			draw();
		}
		
		public function set color(value:String):void
		{
			this._textField.color = value;
		}
		
		public function set fontFamily(value:String):void
		{
			this._textField.fontFamily = value;
		}
		
		public function set fontSize(value:int):void
		{
			this._textField.fontSize = value;
		}
		
		public function set fontStyle(value:String):void
		{
			this._textField.fontStyle = value;
		}
		
		public function set fontWeight(value:String):void
		{
			this._textField.fontWeight = value;
		}
		
		public function set textAlign(value:String):void
		{
			this._textField.align = value;
		}
		
		/**
		 * 九宫格不支持对容器做拉伸操作，因此必须直接对九宫格对象拉伸
		 * 以下属性修改就是为了对九宫格对象做直接的拉伸操作
		 */
		override public function get width():Number
		{
			return _bg.width;
		}
		
		override public function set width(value:Number):void
		{
			_bg.width = value;
			draw();
		}
		
		override public function get height():Number
		{
			return _bg.height;
		}
		
		override public function set height(value:Number):void
		{
			_bg.height = value;
			draw();
		}
		
		override public function get scaleX():Number
		{
			return _bg.scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			_bg.scaleX = value;
			draw();
		}
		
		override public function get scaleY():Number
		{
			return _bg.scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			_bg.scaleY = value;
			draw();
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if (value)
			{
				_button.addEventListener(MouseEvent.CLICK, toggleList);
			} else
			{
				_button.removeEventListener(MouseEvent.CLICK, toggleList);
			}
		}
		
		/**
		 * 获取选中的项目
		 */
		public function get selectedItem():Object
		{
			return _selectedItem;
		}
		
		public function get selectedIndex():int
		{
			return _list.selectedIndex;
		}
		
		public function set selectedIndex(value:int):void
		{
			_list.selectedIndex = value;
			draw();
		}
		
		public function get allItem():List
		{
			return this._list;
		}
		
		/**
		 * 获取数据
		 */
		public function get dataProvider():DataProvider
		{
			return _list.dataProvider;
		}
		
		/**
		 * 设置数据
		 */
		public function set dataProvider(value:DataProvider):void
		{
			removeAll();
			_dataProvider = value;
			var len:int = _dataProvider.length;
			
			for (var i:int = 0; i < len; i++)
			{
				if (typeof(_dataProvider.getItemAt(i)) == "string")
				{
					_list.addItem(_dataProvider.getItemAt(i));
				} else if (typeof(_dataProvider.getItemAt(i)) == "object")
				{
					_list.addItem(_dataProvider.getItemAt(i));
				} else
				{
					LogRunner.warning("comboBox接受非法数据!!");
				}
			}
			
			if (_dataProvider.length > 0)
			{
				_selectedItem = _dataProvider.getItemAt(0);
				_list.selectedIndex = 0; // 将列表中第一个元素标识为选中
			}
			draw();
		}
		
		/**
		 * 列表的最大长度的行数
		 */
		public function set maxLength(value:int):void
		{
			_maxLength = value;
		}
		
		/**
		 * 显示字符的相对边距
		 */
		public function set textPadding(value:Number):void
		{
			_textPadding = value;
		}
		
		public function get length():int
		{
			return _list.length;
		}
		
		/**
		 * 构造函数
		 * @param	id
		 */
		public function ComboBox(id:int = 0, typeValue:int = ComboBox.TYPE_DOWN)
		{
			super(id);
			_type = typeValue == TYPE_DOWN ? typeValue : TYPE_UP;
			_dataProvider = new DataProvider();
			draw();
		}
		
		public function setType(typeValue:int):void
		{
			_type = typeValue == TYPE_DOWN ? typeValue : TYPE_UP;
			draw();
		}
		
		override protected function init():void
		{
			super.init();
			
			_bg = new ImageButton();
			_bg.bitmapScale9GirdData = UISkinRunner.comboBoxBG;
			addChild(_bg);
			
			_textField = new TextFieldProxy();
			_textField.setTextStyle(9);
			_textField.textAlign = TextFieldAutoSize.NONE;
			_textField.mouseEnabled = false;
			_textField.mask = _mask;
			
			_noteTextField = new TextFieldProxy();
			_noteTextField.mouseEnabled = false;
			_noteTextField.fontSize = 12;
			_noteTextField.mask = _mask;
			
			_mask = new Shape();
			_mask.graphics.beginFill(0x000000, 0);
			_mask.graphics.drawRect(0, 0, 1, 1);
			_mask.graphics.endFill();
			
			_button = new Sprite();
			_button.graphics.beginFill(0x000000, 0);
			_button.graphics.drawRect(_bg.x, _bg.y, 1, 1);
			_button.graphics.endFill();
			_button.addEventListener(MouseEvent.CLICK, toggleList);
			
			_list = new List(this.width - 10, 200, _cellHeight, 0x35553A);
			_list.addEventListener(ListEvent.ITEM_CLICK, listClickHandler);
			
			
			addChild(_mask);
			addChild(_button);
			addChild(_textField);
			addChild(_noteTextField);
			
			StageRunner.getInstance().stage.addEventListener(MouseEvent.CLICK, stageClickHandler);
			
			this.buttonMode = true;
		}
		
		private function stageClickHandler(e:MouseEvent):void
		{
			var p:Point = new Point();
			p.x = mouseX;
			p.y = mouseY;
			var point:Point = this.localToGlobal(p);
			
			if (!this.hitTestPoint(point.x, point.y) && !_list.hitTestPoint(point.x, point.y))
			{
				this.removeList();
				_list.returnToTop();
			}
		}
		
		private function toggleList(e:MouseEvent):void
		{
			if (_list.length > 0)
			{
				if (StageRunner.getInstance().root.contains(_list))
				{
					StageRunner.getInstance().root.removeChild(_list);
				} else
				{
					StageRunner.getInstance().root.addChild(_list);
					_list.x = _bg.x;
					
					if (_type == ComboBox.TYPE_DOWN)
						_list.y = _bg.y + _bg.height;
					else if (_type == ComboBox.TYPE_UP)
						_list.y = _bg.y - _list.listHeight;
					
					//设置list在舞台的位置
					var listpoint:Point = new Point(_list.x, _list.y);
					_list.x = this.localToGlobal(listpoint).x;
					_list.y = this.localToGlobal(listpoint).y;
				}
				// 将滚动条滚动到选中行
				var targetIndex:int;
				
				if (_type == TYPE_DOWN)
				{
					targetIndex = _list.selectedIndex;
				} else
				{
					targetIndex = _list.selectedIndex - (Math.ceil(_list.listHeight / _list.cellHeight) - 1);
					
					if (targetIndex < 0)
						targetIndex = 0;
				}
				_list.scrollToIndex(targetIndex);
			}
		}
		
		private function removeList():void
		{
			if (StageRunner.getInstance().root.contains(_list))
			{
				StageRunner.getInstance().root.removeChild(_list);
			}
			
		}
		
		private function addChildList():void
		{
			if (!StageRunner.getInstance().root.contains(_list))
			{
				StageRunner.getInstance().root.addChild(_list);
			}
		}
		
		/**
		 * 绘制组件
		 */
		private function draw():void
		{
			_mask.x = _bg.x;
			_mask.y = _bg.y;
			_mask.width = _bg.width - 22;
			_mask.height = _bg.height;
			
			_button.x = _bg.x;
			_button.y = _bg.y;
			_button.width = _bg.width;
			_button.height = _bg.height;
			_list.x = _bg.x;
			
			if (_type == ComboBox.TYPE_DOWN)
				_list.y = _bg.y + _bg.height;
			else if (_type == ComboBox.TYPE_UP)
				_list.y = _bg.y - _list.listHeight;
			
			
			this.removeList();
			_list.returnToTop();
			_list.width = _button.width;
			
			if (_list.length > 0)
			{
				var len:int = _list.length;
				
				if (len > _maxLength)
				{
					_list.height = _maxLength * _cellHeight;
				} else
				{
					_list.height = len * _cellHeight;
				}
			}
			
			if (_list.length > 0)
			{
				if (_list.selectedItem == null)
				{
					_textField.htmlText = _list.getItemAt(0).label;
					_noteTextField.htmlText = _list.getItemAt(0).note;
				} else
				{
					_textField.htmlText = _list.selectedItem.label;
					_noteTextField.htmlText = _list.selectedItem.note;
					_selectedItem = _list.selectedItem;
				}
//				_textField.reset();
			}
			_textField.width = _button.width - 2;
			_textField.height = _button.height + 6;
			_textField.x = _button.x + 4;
			_textField.y = _button.y + _button.height / 2 - _textField.textHeight / 2 - 2;
			_noteTextField.x = _button.width - this._noteTextField.width - 18;
			this._noteTextField.y = this._textField.y;
		}
		
		/**
		 * 列表被点击
		 * @param	e
		 */
		private function listClickHandler(e:ListEvent):void
		{
			// 这里本来想把draw()提出来，但是draw()会影响_list.selectedItem属性，因此
			// 不适合提到前面，放到后面也不适合，因为事件触发应该在draw()之后，因此只能这样
			if (_list.selectedItem != _selectedItem)
			{
				draw();
				this.dispatchEvent(new Event(Event.CHANGE));
			} else
			{
				draw();
			}
		}
		
		/**
		 * 添加数据
		 * @param item 要添加的数据
		 */
		public function addItem(item:Object):void
		{
			_list.addItem(item);
			draw();
		}
		
		/**
		 * 在某一位置添加数据
		 * @param	item
		 * @param	index
		 */
		public function addItemAt(item:Object, index:int):void
		{
			_list.addItemAt(item, index);
			draw();
		}
		
		/**
		 * 删除某一项数据
		 * @param	index
		 */
		public function removeItemAt(index:int):void
		{
			_list.removeItemAt(index);
			draw();
		}
		
		/**
		 * 删除所有数据
		 */
		public function removeAll():void
		{
			_list.clear();
			_selectedItem = null;
			_textField.text = "--";
			draw();
		}
		
		override public function clear():void
		{
			super.clear();
			removeAll();
		}
		
		override public function dispose():void
		{
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.CLICK, stageClickHandler);
			
			if (_list.hasEventListener(ListEvent.ITEM_CLICK))
			{
				_list.removeEventListener(ListEvent.ITEM_CLICK, listClickHandler);
			}
			
			if (_button.hasEventListener(MouseEvent.CLICK))
			{
				_button.removeEventListener(MouseEvent.CLICK, toggleList);
			}
			ObjectPool.disposeObject(_bg);
			_bg = null;
			ObjectPool.disposeObject(_button);
			_button = null;
			ObjectPool.disposeObject(_mask);
			_mask = null;
			ObjectPool.disposeObject(_list);
			_list = null;
			ObjectPool.disposeObject(_dataProvider);
			_dataProvider = null;
			ObjectPool.disposeObject(_textField);
			_textField = null;
			ObjectPool.disposeObject(_noteTextField);
			_noteTextField = null;
			ObjectPool.disposeObject(_selectedItem);
			_selectedItem = null;
			
			super.dispose();
		}
	}
}