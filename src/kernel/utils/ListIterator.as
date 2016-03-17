package kernel.utils
{
	/**
	 *
	 * 实现了IIterator接口的迭代器，专门用于数组的通用迭代器
	 */	
	public class ListIterator implements IIterator
	{
		private var _items				: *;
		private var _currentIndex		: int;

		public function get hasNext():Boolean
		{
			return (_currentIndex < _items.length);
		}
		
		public function ListIterator(items:*)
		{
			if(items == null || (!(items is Array) && !(items is Vector.<*>))) throw new TypeError("Param type must be Array or Vector.");
			_items = items;
			_currentIndex = 0;
		}
		
		public function next():*
		{
			return _items[_currentIndex ++];
		}
	}
}