package kernel.display.components.tabbar
{
	
	import flash.events.MouseEvent;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.button.ToggleButtonBase;
	import kernel.events.TabBarEvent;
	import kernel.utils.DataProvider;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * 按钮条组件
	 * 使用方法如下：
	 * var arr:Array = [{label:"舰队",data:obj,width:50,height:24},
	 * 					{label:"船只",data:obj,width:50,height:24},
	 * 					{label:"其他",data:obj,width:50,height:24}
	 ];
	 var dataprovider:DataProvider = new DataProvider(arr);
	 tabBar = new TabBar();
	 tabBar.dataProvider = dataprovider;
	 tabBar.addEventListener(TabBarEvent.TABBAR_CHANGE,changeHandler);
	 addChild(tabBar);
	 */
	public class TabBar extends BaseComponent
	{
		protected var _dataProvider:DataProvider;
		protected var _btnArr:Array = [];
		protected var _selectedItem:Object;
		protected var _btnWidth:Number = 50;
		protected var _btnPadding:Number = 0; //控制间距
		protected var _selectedID:int = 0;
		
		public function get btnPadding():Number
		{
			return _btnPadding;
		}

		public function set btnPadding(value:Number):void
		{
			_btnPadding = value;
		}

		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
		}
		
		/**
		 * 获取数据
		 */
		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}
		
		/**
		 * 设置数据
		 */
		public function set dataProvider(value:DataProvider):void
		{
			_dataProvider = value;
			draw();
		}
		
		/**
		 * 获取或设置当前选中项的ID
		 */
		public function get selectedID():int
		{
			return _selectedID;
		}
		
		public function set selectedID(value:int):void
		{
			var oldChild:ToggleButtonBase = _btnArr[_selectedID];
			if (oldChild)
			{
				oldChild.selected = true;
				_selectedID = value;
				_selectedItem = _dataProvider.getItemAt(value);
				drawLayout();
				
				var evt:TabBarEvent = new TabBarEvent(TabBarEvent.TABBAR_CHANGE);
				evt.selectedId = _selectedID;
				evt.data = _selectedItem;
				dispatchEvent(evt);
			}
		}
		
		/**
		 * 获取或设置选择标签的索引，与selected属性不同的是设置该属性不会触发TABBAR_CHANGE事件
		 */
		public function get selectIndex():int
		{
			return _selectedID;
		}
		
		public function set selectIndex(value:int):void
		{
			var oldChild:ToggleButtonBase = _btnArr[_selectedID];
			if (oldChild)
			{
				oldChild.selected = true;
				_selectedID = value;
				_selectedItem = _dataProvider.getItemAt(value);
				drawLayout();
			}
		}
		
		/**
		 *  构造函数
		 *
		 */
		public function TabBar()
		{
			super();
		}
		
		private function clickHander(e:MouseEvent):void
		{
			var id:int = e.currentTarget.id;
			if (id != _selectedID)
			{
				_selectedItem = _dataProvider.getItemAt(id);
				_selectedID = id;
				drawLayout();
				
				var evt:TabBarEvent = new TabBarEvent(TabBarEvent.TABBAR_CHANGE);
				evt.selectedId = _selectedID;
				evt.data = _selectedItem;
				dispatchEvent(evt);
			}
		}
		
		private var _customTabButton:Class;

		public function get customTabButton():Class
		{
			return _customTabButton;
		}

		public function set customTabButton(value:Class):void
		{
			_customTabButton = value;
		}

		
		protected function createTabButton():ToggleButtonBase
		{
			return new TabButton() as ToggleButtonBase;
		}
		
		protected function createCustomTabButton():ToggleButtonBase
		{
			return new _customTabButton() as ToggleButtonBase;
		}
		
		private function draw():void
		{
			ObjectPool.clearList(_btnArr);
			var len:int = _dataProvider.length;
			if (len > 0)
			{
				for (var i:int = 0; i < len; i++)
				{
					if (_dataProvider.getItemAt(i) != null)
					{
						var obj:Object = _dataProvider.getItemAt(i);
						var btnWidth:Number;
						var btnHeight:Number;
						if (obj.width != null)
						{
							btnWidth = obj.width;
						} else
						{
							btnWidth = 86;
						}
						if (obj.height != null)
						{
							btnHeight = obj.height;
						} else
						{
							btnHeight = 24;
						}
						var btn:ToggleButtonBase
						if(_customTabButton != null)
						{
							btn = createCustomTabButton();
						}else
						{
							btn = createTabButton();		
						}
						btn.id = i;
						btn.width = btnWidth;
						btn.height = btnHeight;
						btn.label = obj.label;
						btn.click = clickHander;
						_btnArr.push(btn);
					}
				}
				if (_dataProvider.length > 0)
				{
					_selectedItem = _dataProvider.getItemAt(0);
					_selectedID = 0;
				}
			}
			drawLayout();
		}
		
		private function drawLayout():void
		{
			DisplayUtil.removeAllChildren(this);
			var len:int = _btnArr.length;
			var currentX:Number = 0;
			for (var i:int = 0; i < len; i++)
			{
				if (_btnArr[i] != null)
				{
					var btn:ToggleButtonBase = _btnArr[i];
					btn.x = currentX;
					currentX = currentX + btn.width + _btnPadding;
					addChild(btn);
					if (i == _selectedID)
					{
						btn.selected = true;
					} else
					{
						btn.selected = false;
					}
				}
			}
		}
		/**
		 * 获得tabbutton通过index 
		 * @return 
		 * 
		 */		
		public function getTabButtonByIndex(index:int):TabButton{
			for each(var btn:TabButton in this._btnArr)
			{
				if(btn.id == index)
				{
					return btn;
				}
			}
			return null;
		}
		
		/**
		 * 更改某个标签的文字
		 * @param index 要更改的标签的索引
		 * @param value 要更改的文字
		 */
		public function updateTitle(index:int, value:String):void
		{
			TabButton(_btnArr[index]).label = value;
		}
		
		/**
		 * 重置TabBar
		 */
		public function reset():void
		{
			this.selectedID = 0;
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_dataProvider);
			_dataProvider = null;
			ObjectPool.disposeObject(_btnArr);
			_btnArr = null;
			ObjectPool.disposeObject(_selectedItem);
			_selectedItem = null;
			
			super.dispose();
		}
	}
}