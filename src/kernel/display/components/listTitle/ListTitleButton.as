package kernel.display.components.listTitle
{
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	import kernel.display.components.button.Button;
	import kernel.display.components.listTitle.events.ListTitleEvent;
	import kernel.display.components.listTitle.vo.ListTitleVO;
	import kernel.display.components.listTitle.vo.SortType;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ObjectPool;
	
	public class ListTitleButton extends Button
	{
		private var _arrowUp:Bitmap;
		private var _arrowDown:Bitmap;
		
		private var _sortType:int = SortType.NONE;
		private var _currentSortType:int = SortType.NONE;
		private var _value:Object;
		
		/**
		 * 获取或设置可排序状态
		 */
		public function get sortType():int
		{
			return _sortType;
		}
		
		public function set sortType(value:int):void
		{
			_sortType = value;
			updateSortType();
		}
		
		/**
		 * 获取或设置当前排序状态
		 */
		public function get currentSortType():int
		{
			return _currentSortType
		}
		
		public function set currentSortType(value:int):void
		{
			_currentSortType = value;
			updateSortType();
		}
		
		/**
		 * 设置按钮的选中状态
		 */
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			if (!value)
				reset();
		}
		
		public function ListTitleButton(id:int = 0)
		{
			super(id);
		}
		
		override protected function init():void
		{
			_mouseEffectBehavior = UISkinRunner.listTitleMouseEffectBehavior;
			super.init();
			setImage(UISkinRunner.listTitleBG);
			initArrows();
		}
		
		private function initArrows():void
		{
			// 上箭头
			_arrowUp = new Bitmap();
			_arrowUp.bitmapData = UISkinRunner.listTitleArrow;
			_arrowUp.scaleX = 0.5;
			_arrowUp.scaleY = -0.5;
			_arrowUp.y = 9;
			addChild(_arrowUp);
			// 下箭头
			_arrowDown = new Bitmap();
			_arrowDown.bitmapData = UISkinRunner.listTitleArrow;
			_arrowDown.width = 8;
			_arrowDown.height = 8;
			_arrowDown.y = 10;
			addChild(_arrowDown);
			
			updateSortType();
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			super.clickHandler(event);
			var typesAllow:Array = [];
			if ((_sortType & SortType.UPWARDS) > 0)
				typesAllow.push(SortType.UPWARDS);
			if ((_sortType & SortType.DOWNWARDS) > 0)
				typesAllow.push(SortType.DOWNWARDS);
			
			if (typesAllow.length <= 0)
			{
				_currentSortType = SortType.NONE;
			} else
			{
				var index:int = typesAllow.indexOf(_currentSortType);
				_currentSortType = typesAllow[(index + 1) % typesAllow.length];
				
				// 设置选中状态
				this.selected = true;
				// 派发事件
				var evt:ListTitleEvent = new ListTitleEvent(ListTitleEvent.LIST_COLUMN_SORT, true);
				evt.sender = this;
				evt.value = _value;
				evt.sortType = _currentSortType;
				dispatchEvent(evt);
			}
			updateSortType();
		}
		
		private function updateSortType():void
		{
			// 设置上箭头的位置和可见性
			_arrowUp.x = width - _arrowUp.width - 5;
			_arrowUp.visible = ((_sortType & SortType.UPWARDS) > 0);
			if ((_currentSortType & SortType.UPWARDS) > 0)
			{
				_arrowUp.bitmapData = UISkinRunner.listTitleArrow;
			} else
			{
				_arrowUp.bitmapData = UISkinRunner.listTitleArrowNo;
			}
			// 设置下箭头的位置和可见性
			_arrowDown.x = width - _arrowDown.width - 5;
			_arrowDown.visible = ((_sortType & SortType.DOWNWARDS) > 0);
			if ((_currentSortType & SortType.DOWNWARDS) > 0)
			{
				_arrowDown.bitmapData = UISkinRunner.listTitleArrow;
			} else
			{
				_arrowDown.bitmapData = UISkinRunner.listTitleArrowNo;
			}
		}
		
		public function update(value:ListTitleVO):void
		{
			if (value == null)
				return ;
			_value = value.value;
			this.width = value.width
			this.label = value.label;
			this.sortType = value.sortType;
		}
		
		public function reset():void
		{
			_currentSortType = SortType.NONE;
			updateSortType();
		}
		
		override public function clear():void
		{
			_currentSortType = SortType.NONE;
			this.sortType = SortType.NONE;
			this.label = "";
			_value = null;
		}
		override public function dispose():void
		{
			ObjectPool.disposeObject(_arrowUp);
			_arrowUp = null;
			ObjectPool.disposeObject(_arrowDown);
			_arrowDown = null;
			_value = null;
			
			super.dispose();
		}
	}
}