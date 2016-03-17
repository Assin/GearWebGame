package kernel.utils
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 21, 2011 3:16:50 PM
	 */
	public class ArrayUtil
	{
		/**
		 * 从数组中删除一个元素 
		 * @param array
		 * @param item
		 * 
		 */		
		public static function removeItem(array:Array, item:*):void
		{
			var size:int = array.length;
			var itemIndex:int = array.indexOf(item);
			if (itemIndex >= 0)
			{
				array.splice(itemIndex, 1);
			}
		}
		
		/**
		 * 将数组反序排列  不改变原数组
		 * @param array
		 *
		 */
		public static function reverseArray(array:Array):Array
		{
			var a:Array = [];
			for (var i:int = array.length - 1; i >= 0; i--)
			{
				a.push(array[i]);
			}
			return a;
		}
		
		/**
		 * 从vector中删除
		 * @param vector
		 * @param item
		 *
		 */
		public static function removeItemFromVector(vector:Vector.<Object>, item:*):Vector.<Object>
		{
			var size:int = vector.length;
			for (var i:int = 0; i < size; i++)
			{
				if (item == vector[i])
				{
					vector.splice(i, 1);
					break;
				}
			}
			return vector;
		}
		
		/**
		 * 获得两个数组中相同的部分，组成一个新数组
		 * @param arrayA
		 * @param arrayB
		 * @return
		 *
		 */
		public static function getTheSameItemPushToArray(toArray:Array, arrayA:Array, arrayB:Array):void
		{
			for each (var a:*in arrayA)
			{
				for each (var b:*in arrayB)
				{
					if (a == b)
					{
						toArray.push(a);
					}
				}
			}
		}
		
		public static function vectorToArray(vector:Vector.<Object>):Array
		{
			var array:Array = [];
			for each (var v:Object in vector)
			{
				array.push(v);
			}
			return array;
		}
		
		public function ArrayUtil()
		{
		}
	}
}