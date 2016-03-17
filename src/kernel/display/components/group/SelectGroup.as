package kernel.display.components.group
{
	import com.adobe.crypto.MD5;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import kernel.IClear;
	import kernel.IDispose;
	import kernel.utils.IIterator;
	import kernel.utils.ListIterator;
	import kernel.utils.ObjectPool;
	
	/**
	 * 用来管理所有实现了ISelectGroupItem的类实例，允许它们在组内
	 * 进行单选或者多选操作，当ISelectGroupItem需要触发单选或多选
	 * 操作时必须调用ISelectGroupItem.selectedCallback。
	 *
	 * @author yanghongbin
	 */
	public class SelectGroup extends EventDispatcher implements IClear,IDispose
	{
		/**
		 * 选择类型常量
		 */
		public static const SINGLE_SELECT:int = 1; // 单选(默认)
		public static const MULTI_SELECT:int = 2; // 多选
		protected var _groupName:String;
		protected var _itemList:Array;
		protected var _currentType:int = SINGLE_SELECT;
		protected var _currentIndex:int = -1;
		protected var _callbackLock:Boolean = false;
		
		/**
		 * 获取或设置当前模式
		 */
		public function get currentType():int
		{
			return _currentType;
		}
		
		public function set currentType(value:int):void
		{
			// 判断是否在范围内，不在则默认使用单选模式
			if (value != SINGLE_SELECT && value != MULTI_SELECT)
				value = SINGLE_SELECT;
			_currentType = value;
		}
		
		/**
		 * 获取组内选项个数
		 */
		public function get length():int
		{
			return _itemList.length;
		}
		
		/**
		 * 获取所有选项
		 */
		public function get allItems():Array
		{
			return _itemList;
		}
		
		/**
		 * 获取或设置当前选中项的索引，非单选模式下返回-1
		 */
		public function get currentIndex():int
		{
			if (_currentType != SINGLE_SELECT)
				return -1;
			return _currentIndex;
		}
		
		public function set currentIndex(id:int):void
		{
			_currentIndex = id;
		}
		
		/**
		 * 获取当前选中项，非单选模式下返回null
		 */
		public function get currentItem():ISelectGroupItem
		{
			if (_currentType != SINGLE_SELECT)
				return null;
			if (_currentIndex < 0)
				return null;
			return _itemList[_currentIndex];
		}
		
		/**
		 * 获取当前选中项的数组
		 */
		public function get currentItems():Array
		{
			var arr:Array = [];
			for each (var item:ISelectGroupItem in _itemList)
			{
				if (item.selected)
					arr.push(item);
			}
			return arr;
		}
		
		/**
		 * 构造方法
		 *
		 * @param type 模式类型，单选或者多选
		 */
		public function SelectGroup(type:int = SelectGroup.SINGLE_SELECT)
		{
			_currentType = type;
			rename();
			_itemList = [];
		}
		
		protected function selectedCallback(item:ISelectGroupItem):void
		{
			// 如果不是选中状态，则不作处理
			if (!item.selected)
				return ;
			// 如果不属于本组则不做处理
			var temp:Object = item.groupName.split(_groupName)[1];
			if (temp == null)
				return ;
			// 如果是单选模式
			if (_currentType == SINGLE_SELECT)
			{
				_currentIndex = int(temp);
				for (var i:int = 0; i < _itemList.length; i++)
				{
					if (i != _currentIndex)
						_itemList[i].selected = false;
				}
			} else 
				// 如果是多选模式
				if (_currentType == MULTI_SELECT)
				{
					// 留空，因为多选不需要改变任何状态
				}
			// 如果是非锁定状态则触发事件
			if (!_callbackLock)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		protected function getNextIdleIndex():int
		{
			var index:int;
			for (var i:int = 0; i < _itemList.length; i++)
			{
				if (_itemList[i] == null)
				{
					break;
				}
			}
			index = i;
			return index;
		}
		
		/**
		 * 为选择组重新起名
		 */
		public function rename():void
		{
			var oldName:String = _groupName;
			_groupName = MD5.hash(Math.random().toString() + Math.random().toString() + Math.random().toString() + Math.random().toString() +
				Math.random().toString());
			// 如果有旧组名则将组员的组名全部改为现在的名称
			if (oldName != null && oldName != "")
			{
				for each (var item:ISelectGroupItem in _itemList)
				{
					var index:int = int(item.groupName.split(oldName)[1]);
					item.groupName = _groupName + index;
				}
			}
		}
		
		/**
		 * 添加对象
		 *
		 * @param item 要添加的对象
		 */
		public function addItem(item:ISelectGroupItem):void
		{
			var index:int = getNextIdleIndex();
			item.selected = false;
			item.groupName = _groupName + index;
			item.selectedCallback = selectedCallback;
			_itemList[index] = item;
		}
		
		/**
		 * 删除对象
		 *
		 * @param item 要删除的对象
		 */
		public function removeItem(item:ISelectGroupItem):void
		{
			var index:int = getItemIndex(item);
			// 如果不属于本组则不做处理
			if (index < 0)
				return ;
			if (index == _currentIndex)
				_currentIndex = -1;
			item.selectedCallback = null;
			item.groupName = "";
			_itemList.splice(index, 1);
		}
		
		/**
		 * 确认选项是否包含在组里
		 *
		 * @param item 要确认的选项
		 * @return 是否包含
		 */
		public function contains(item:ISelectGroupItem):Boolean
		{
			if (item == null || item.groupName == null)
				return false;
			var temp:Object = item.groupName.split(_groupName)[1];
			return (temp != null);
		}
		
		/**
		 * 获取选项在组内的索引，如果不在组内则返回-1
		 *
		 * @param item 选项
		 * @return 组内索引
		 */
		public function getItemIndex(item:ISelectGroupItem):int
		{
			if (!contains(item))
				return -1;
			var temp:Object = item.groupName.split(_groupName)[1];
			return int(temp);
		}
		
		/**
		 * 根据索引获取对象
		 *
		 * @param index 对象在组内的索引
		 * @return 对象
		 */
		public function getItemAt(index:int):ISelectGroupItem
		{
			return _itemList[index];
		}
		
		/**
		 * 选择当前可选的第一个选项，调用该方法会首先请出所有已选
		 * 该方法只对单选模式有效，其他模式不作任何处理
		 */
		public function selectFirstSelectable():void
		{
			if (currentType != SelectGroup.SINGLE_SELECT)
				return ;
			
			reset();
			_callbackLock = true;
			var iterator:IIterator = this.createIterator();
			while (iterator.hasNext)
			{
				var item:ISelectGroupItem = iterator.next()as ISelectGroupItem;
				if (item.selectable)
				{
					item.selected = true;
					break;
				}
			}
			_callbackLock = false;
		}
		
		/**
		 * 获取一个一次性迭代器
		 */
		public function createIterator():IIterator
		{
			return new ListIterator(_itemList);
		}
		
		/**
		 * 将传入的选择组中的选择对象全部转移至本选择组中
		 * @param group 要被迁移对象的选择组
		 */
		public function transferItems(group:SelectGroup):void
		{
			var iterator:IIterator = group.createIterator();
			while (iterator.hasNext)
			{
				addItem(iterator.next());
			}
			group.clear();
		}
		
		/**
		 * 将所有选项置为未选中状态
		 */
		public function reset():void
		{
			for each (var item:ISelectGroupItem in _itemList)
			{
				item.selected = false;
			}
			_currentIndex = -1;
		}
		
		/**
		 * 从组中清除所有选项
		 */
		public function clear():void
		{
			while (_itemList.length > 0)
			{
				var temp:ISelectGroupItem = _itemList[0] as ISelectGroupItem;
				if (temp == null)
				{
					_itemList.splice(0, 1);
				} else
				{
					temp.selectedCallback = null;
					temp.groupName = "";
					_itemList.splice(0, 1);
				}
			}
			reset();
		}
		
		public function dispose():void
		{
			//只清除引用即可,无需销毁
			_itemList = null;
		}
	}
}