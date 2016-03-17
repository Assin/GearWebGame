package kernel.utils
{
	import kernel.IClear;
	import kernel.IDispose;
	
	public class DataProvider implements IClear,IDispose
	{
		private var _datas:Array;
		
		public function get length():uint
		{
			return _datas.length;
		}
		
		public function DataProvider(value:* = null)
		{
			if (value == null)
			{
				_datas = new Array();
			} else
			{
				_datas = getData(value);
			}
		}
		
		private function getData(value:*):Array
		{
			var retArr:Array;
			if (value is Array)
			{
				var arr:Array = value as Array;
				if (arr.length > 0)
				{
					if (arr[0]is String || arr[0]is Number)
					{
						retArr = new Array();
						// convert to object array.
						for (var i:uint = 0; i < arr.length; i++)
						{
							var o:Object = new Object();
							o.label = arr[i].toString();
							o.data = arr[i];
							retArr.push(o);
						}
						return retArr;
					}
				}
				return value.concat();
			} else if (value is DataProvider)
			{
				return DataProvider(value).toArray();
			} else if (value is XML)
			{
				var xml:XML = value as XML;
				retArr = new Array();
				var nodes:XMLList = xml.*;
				for each (var node:XML in nodes)
				{
					var obj:Object = new Object();
					var attrs:XMLList = node.attributes();
					for each (var attr:XML in attrs)
					{
						obj[attr.localName()] = attr.toString();
					}
					var propNodes:XMLList = node.*;
					for each (var propNode:XML in propNodes)
					{
						if (propNode.hasSimpleContent())
						{
							obj[propNode.localName()] = propNode.toString();
						}
					}
					retArr.push(obj);
				}
				return retArr;
			} else
			{
				throw new TypeError("Error: Type Coercion failed: cannot convert " + value + " to Array or DataProvider.");
				return null;
			}
		}
		
		private function checkIndex(index:int, maximum:int):void
		{
			if (index > maximum || index < 0)
			{
				throw new RangeError("DataProvider index (" + index + ") is not in acceptable range (0 - " + maximum + ")");
			}
		}
		
		public function sortOn(fieldName:Object, options:Object = null):*
		{
			var returnValue:Array = _datas.sortOn(fieldName, options);
			return returnValue;
		}
		
		public function getItemAt(index:uint):Object
		{
			checkIndex(index, _datas.length - 1);
			return _datas[index];
		}
		
		public function addItemAt(item:Object, index:uint):void
		{
			checkIndex(index, _datas.length);
			ObjectPool.clearObject(_datas.splice(index, 0, item));
		}
		
		public function removeItemAt(index:uint):void
		{
			checkIndex(index, _datas.length - 1);
			var arr:Array = _datas.splice(index, 1);
			arr = [];
		}
		
		public function addItem(item:Object):void
		{
			_datas.push(item);
		}
		
		public function toArray():Array
		{
			return _datas;
		}
		
		public function clear():void
		{
			ObjectUtil.clearList(_datas);
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_datas);
			_datas = null;
		}
	}
}