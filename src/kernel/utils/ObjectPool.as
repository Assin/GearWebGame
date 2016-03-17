package kernel.utils
{
	
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import kernel.IClear;
	import kernel.IDispose;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Dec 2, 2011 10:54:58 AM
	 */
	public class ObjectPool
	{
		private static var _pool:Dictionary = new Dictionary();
		
		public function ObjectPool()
		{
			super();
		}
		
		public static function disposePool():void{
			disposeObject(_pool);
		}
		
		/**
		 * 从对象池里取出一个对象
		 * @param cls 对象所属的类型，可以是一个Class，也可以是对象类型的完全限定名
		 * @return 取出的对象
		 */		
		public static function borrow(cls:*):* {
			if(cls == null) return;
			var instance:*;
			if(cls is String) {
				if(_pool[cls] != null && _pool[cls].length > 0){
					instance = _pool[cls].pop();
				} else {
					var newClass:Class = getDefinitionByName(cls) as Class;
					instance = new newClass();
				}
			} else if(cls is Class) {
				var className:String = getQualifiedClassName(cls);
				if(_pool[className] !=  null && _pool[className].length > 0) {
					instance = _pool[className].pop();
				} else {
					instance = new cls();
				}
			}
			return instance;
		}
		/**
		 * 调用IDispose接口的 dispose方法 
		 * @param obj
		 * 
		 */		
		public static function disposeObject(obj:*):void{
			if(obj == null)
			{
				return;
			}
			//先判断是否是显示对象，如果是，先从他的父级别移除
			if(obj is DisplayObject)
			{
				DisplayObject(obj).filters = null;
				DisplayUtil.removeChild(obj as DisplayObject, (obj as DisplayObject).parent);
				TweenLite.killTweensOf(obj);
				TweenMax.killChildTweensOf(DisplayObject(obj).parent);
			}
			//随后判断他是不是dispose
			if(obj is IDispose)
			{
				IDispose(obj).dispose();
			}
			else if(obj is BitmapData)
			{
				BitmapData(obj).dispose();
			}
			else if(obj is Bitmap)
			{
				Bitmap(obj).smoothing = false;
				if(Bitmap(obj).bitmapData!=null)
				{
					Bitmap(obj).bitmapData.dispose();
				}
			}
			else if(obj is Shape)
			{
				Shape(obj).graphics.clear();
			}
			else if(obj is DisplayObjectContainer)
			{
				if (obj is MovieClip) 
				{
					MovieClip(obj).stop();
					MovieClip(obj).scaleX = 1;
				}
				else
				{
					while(DisplayObjectContainer(obj).numChildren)
					{
						disposeObject(DisplayObjectContainer(obj).getChildAt(0));
					}
				}
			}
			else if(obj is Array || obj is Vector.<*>)
			{
				for (var i:int = 0; i < obj.length; i++) 
				{
					disposeObject(obj[i]);
					obj[i] = null;
				}
			}
			else if(obj is Dictionary)
			{
				var keyArray:Array = [];
				for (var key:* in obj) 
				{
					keyArray.push(key);
				}
				for each(var keyObject:* in keyArray)
				{
					disposeObject(obj[keyObject]);
					obj[keyObject] = null;
					delete obj[keyObject];
				}
				keyArray = null;
			}else if(obj is ByteArray)
			{
				ByteArray(obj).clear();
			}
			
		}
		
		/**
		 * 将对象推进对象池里
		 * @param obj 要推进池里的对象
		 */		
		public static function clearAndPushPool(obj:*,pushPool:Boolean = false):void {
			if(obj == null) return;
			var className:String = getQualifiedClassName(obj);
			if(_pool[className] == null) _pool[className] = [];
			if(_pool[className].indexOf(obj) >= 0) return;
			
			if(obj is IClear) {
				obj.clear();
			}
			if(obj is DisplayObject) {
				obj.x = 0;
				obj.y = 0;
			}
			if(obj is Array || obj is Vector.<*>) {
				ObjectUtil.clearList(obj);
			}
			ObjectUtil.clearObject(obj);
			if(pushPool)
			{
				_pool[className].push(obj);
			}
		}
		/**
		 * 将数组或向量中的对象全部推入对象池中。该方法并不回收数组或向量本身
		 * @param list 要清空的数组或向量
		 */		
		public static function clearList(list:*,pushPool:Boolean = false):void {
			if(list == null || (!(list is Array) && !(list is Vector.<*>))) return;
			while(list.length > 0) {
				clearAndPushPool(list.pop(),pushPool);
			}
		}
		/**
		 * 将数组中的对象全部推入对象池中，并且如果其内容也是一个数组，则先对该内容调用该方法然后回收该内容。该方法并不回收数组本身
		 * @param list 要清空的数组
		 */		
		public static function clearListDeeply(list:*):void {
			if(list == null || !(list is Array) || !(list is Vector.<*>)) return;
			while(list.length > 0) {
				var item:* = list.pop();
				if(item is Array) clearListDeeply(item);
				clearAndPushPool(item);
			}
		}
		/**
		 * 将Object中的动态对象全部推入对象池中，并且删除对象中的引用。该方法并不回收Object本身
		 * @param obj 要清空的Object
		 */		
		public static function clearObject(obj:Object):void {
			if(obj == null) return;
			for(var key:* in obj) {
				var item:* = obj[key];
				obj[key] = null;
				delete obj[key];
				clearAndPushPool(item);
			}
		}
	}
}