package kernel.display.components.listClass
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import kernel.IClear;
	import kernel.IDispose;
	import kernel.display.components.container.ScrollPanel;
	import kernel.events.ScrollEvent;
	import kernel.utils.DataProvider;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	public class List extends Sprite implements IClear, IDispose
	{
		internal var _dataProvider:DataProvider;
		
		private var _cellArray:Array;
		internal var _currentCell:ListCell;
		
		private var _scrollPanel:ScrollPanel;
		private var _scrollPanelHeight:int;
		private var _scrollPanelWidth:int;
		
		private var _cellHeight:int;
		
		private var _cellSprite:Sprite;
		
		private var _bgColor:uint;
		
		private var _scrollPanelClass:*;
		
		//private var _renderItem;
		
		public function set scrollPanelClass(value:*):void
		{
			this._scrollPanelClass = value;
		}
		
		public function get dataProvider():DataProvider
		{
			return _dataProvider;
		}
		
		public function List(width:int, height:int, cellHeight:int, bgColor:uint = 0)
		{
			_bgColor = bgColor;
			_cellSprite = new Sprite();
			DisplayUtil.removeAllChildren(_cellSprite);
			_cellSprite.graphics.clear();
			_cellHeight = cellHeight;
			_scrollPanelWidth = width;
			_scrollPanelHeight = height;
			_dataProvider = new DataProvider();
			_cellArray = [];
			initScrollPanel(_scrollPanelClass);
			initBg();
		}
		
		public function get cellHeight():int
		{
			return _cellHeight;
		}
		
		private function initBg():void
		{
			this.graphics.clear();
			this.graphics.beginFill(_bgColor, 0.5);
			this.graphics.drawRect(0, 0, _scrollPanelWidth, _scrollPanelHeight);
			this.graphics.endFill();
		}
		
		private function initScrollPanel(scrollPanelClass:*):void
		{
			_scrollPanel = new ScrollPanel();
			_scrollPanel.width = _scrollPanelWidth;
			_scrollPanel.height = _scrollPanelHeight;
			_scrollPanel.source = _cellSprite;
			_scrollPanel.verticalLineScrollSize = _cellHeight;
			addChild(_scrollPanel);
			_scrollPanel.addEventListener(ScrollEvent.SCROLL, onScroll);
		}
		
		public function get listWidth():Number
		{
			return _scrollPanelWidth;
		}
		
		public function get listHeight():Number
		{
			return _scrollPanelHeight;
		}
		
		override public function set width(value:Number):void
		{
			_scrollPanelWidth = value;
			initBg();
			_scrollPanel.width = value;
			for (var i:String in _cellArray)
			{
				(_cellArray[i]as ListCell).width = value;
			}
		}
		
		override public function set height(value:Number):void
		{
			_scrollPanel.height = value;
			_scrollPanelHeight = value;
			showRows();
			_scrollPanel.update();
			
			hideRows();
			initBg();
			if (value < 50)
			{
				for (var i:String in _cellArray)
				{
					(_cellArray[i]as ListCell).width = _scrollPanelWidth;
				}
			}
		}
		
		private function onScroll(event:*):void
		{
			hideRows();
		}
		
		private function showRows():void
		{
			for (var i:String in _cellArray)
			{
				_cellSprite.addChild(_cellArray[i]);
			}
		}
		
		private function hideRows():void
		{
			return ;
			var top:int = _scrollPanel.verticalScrollPosition - _cellHeight;
			var down:int = _scrollPanel.verticalScrollPosition + _scrollPanelHeight;
			for (var i:String in _cellArray)
			{
				if (_cellArray[i].y > top && _cellArray[i].y < down)
				{
					(_cellArray[i]as ListCell).initListeners();
					_cellSprite.addChild(_cellArray[i]);
				} else
				{
					if (_cellArray[i].parent != null)
					{
						(_cellArray[i]as ListCell).removeListeners();
						_cellSprite.removeChild(_cellArray[i]);
					}
				}
			}
		}
		
		private function refreshList():void
		{
			for (var i:int = 0; i < _cellArray.length; i++)
			{
				_cellArray[i]._index = i;
				_cellArray[i].y = i * _cellHeight;
			}
		}
		
		public function addItem(item:Object):void
		{
			showRows();
			if (item != null)
			{
				_dataProvider.addItem(item);
				
				var cell:ListCell = new ListCell(_cellArray.length, _scrollPanelWidth, _cellHeight, this);
				cell.content = item.label;
				if (item.enable != null)
				{
					cell.enable = item.enable;
				}
				if (item.note != null)
				{
					cell.note = item.note;
				}
				_cellArray.push(cell);
				cell.y = cell._index * _cellHeight;
				_cellSprite.addChild(cell);
				
				_scrollPanel.update();
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			hideRows();
			
		}
		
		public function addItemAt(item:Object, index:int):void
		{
			showRows();
			if (index < 0)
			{
				index = 0;
			}
			_dataProvider.addItemAt(item, index);
			var cell:ListCell = new ListCell(_cellArray.length, _scrollPanelWidth, _cellHeight, this);
			cell.content = item.label;
			if (item.enable != null)
			{
				cell.enable = item.enable;
			}
			if (item.note != null)
			{
				cell.note = item.note;
			}
			var subCellArray:Array = _cellArray.slice(0, index);
			subCellArray.push(cell);
			subCellArray = subCellArray.concat(_cellArray.slice(index, _cellArray.length));
			_cellArray = subCellArray;
			_cellSprite.addChild(cell);
			
			_scrollPanel.update();
			this.dispatchEvent(new Event(Event.CHANGE));
			refreshList();
			hideRows();
			
		}
		
		public function removeItemAt(index:int):void
		{
			showRows();
			if (index >= 0)
			{
				_dataProvider.removeItemAt(index);
				if (_cellArray[index].parent != null)
				{
					_cellSprite.removeChild(_cellArray[index]);
				}
				_cellArray[index].removeListeners()
				_cellArray.splice(index, 1);
				_scrollPanel.update();
				this.dispatchEvent(new Event(Event.CHANGE));
			}
			refreshList();
			hideRows();
		}
		
		public function getItemAt(index:int):Object
		{
			var item:Object = _dataProvider.getItemAt(index);
			if (item.note == null)
			{
				item.note = "";
			}
			return item;
		}
		
		public function get selectedIndex():int
		{
			if (_currentCell != null)
			{
				return _currentCell._index;
			}
			return -1;
		}
		
		public function set selectedIndex(value:int):void
		{
			if (value == -1)
			{
				clearSelection();
			} else
			{
				if (value >= 0 && _cellArray[value] != null)
				{
					(_cellArray[value]as ListCell).showDownState();
					
				} else
				{
					clearSelection();
				}
			}
		}
		
		public function scrollToIndex(index:int):void
		{
			if (index >= 0)
			{
				var subHeight:uint = index * _cellHeight;
				
				var lastHeight:uint = _cellArray.length * _cellHeight - _scrollPanelHeight;
				if (subHeight > lastHeight)
				{
					_scrollPanel.verticalScrollPosition = lastHeight;
				} else
				{
					_scrollPanel.verticalScrollPosition = subHeight;
				}
			}
		}
		
		public function get length():int
		{
			return _dataProvider.length;
		}
		
		public function get selectedItem():Object
		{
			if (_currentCell != null)
			{
				var obj:Object = _dataProvider.getItemAt(_currentCell._index);
				if (obj.note == null)
				{
					obj.note = "";
				}
				return obj;
			}
			return null;
		}
		
		public function clearSelection():void
		{
			if (_currentCell != null)
			{
				_currentCell.clear();
				_currentCell = null;
			}
		}
		
		public function sortItemsOn(fieldName:Object, options:Object = null):void
		{
			
			var arr:Array = _dataProvider.sortOn(fieldName, options);
			clear();
			for (var i:String in arr)
			{
				addItem(arr[i]);
			}
		}
		
		public function returnToTop():void
		{
			_scrollPanel.verticalScrollPosition = 0;
		}
		
		public function clear():void
		{
			showRows();
			for (var i:int = 0; i < _cellArray.length; i++)
			{
				if (_cellArray[i].parent != null)
				{
					_cellSprite.removeChild(_cellArray[i]);
				}
				_cellArray[i].removeListeners()
			}
			_cellArray.length = 0;
			_dataProvider.clear();
			_scrollPanel.update();
			_currentCell = null;
			clearSelection();
			
			_scrollPanel.verticalScrollPosition = 0;
			this.dispatchEvent(new Event(Event.CHANGE));
		}
		
		public function dispose():void
		{
			if (_scrollPanel.hasEventListener(ScrollEvent.SCROLL)) 
			{
				_scrollPanel.removeEventListener(ScrollEvent.SCROLL, onScroll);
			}
			ObjectPool.disposeObject(_dataProvider);
			_dataProvider = null;
			ObjectPool.disposeObject(_cellArray);
			_cellArray = null;
			ObjectPool.disposeObject(_cellSprite);
			ObjectPool.disposeObject(_scrollPanel);
			_scrollPanel = null;
			_cellSprite = null;
			ObjectPool.disposeObject(_scrollPanelClass);
			_dataProvider = null;
		}
	}
}