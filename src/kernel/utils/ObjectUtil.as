package kernel.utils
{
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Dec 2, 2011 10:54:58 AM
	 */
	public final class ObjectUtil
	{
		/**
		 * 对象拷贝,尚未支持深拷贝.需要深拷贝请用clone方法
		 * 用法参考jQuery.extend
		 */
		public static function extend(target:Object, ...args):Object{
			target = target || {};
			var options:Object;
			for(var i:int = 0; i < args.length; i++){
				if((options = args[i]) != null){
					for(var name:String in options){
						var copy:* = options[name];
						
						if(target == copy)
							continue;
						
						target[name] = copy;
					}
				}
			}
			return target;
		}
		/**
		 * 将args中的属性更新到target中
		 * target中和args中相同的属性用后者更新
		 * 
		 * var a:Object = {a:1,b:2};
		 * var b:Object = {a:'abc',c:3};
		 * update(a,b) => {a:'abc',b:2}
		 * update(b,a) => {a:1,c:3}
		 */
		public static function update(target:Object, ...args):Object{
			target = target || {};
			var options:Object;
			for(var i:int = 0; i < args.length; i++){
				if((options = args[i]) != null){
					for(var name:String in options){
						if(target[name]==undefined){
							continue;
						}
						var copy:* = options[name];
						target[name] = copy;
					}
				}
			}
			return target;
		}
		/**
		 * 将args中的属性附加到target中
		 * target中和args中相同的属性用后者更新
		 * 
		 * var a:Object = {a:1,b:2};
		 * var b:Object = {a:'abc',c:3};
		 * update(a,b) => {a:'abc',b:2,c:3}
		 * update(b,a) => {a:1,b:2,c:3}
		 */
		public static function append(target:Object, ...args):Object{
			target = target || {};
			var options:Object;
			for(var i:int = 0; i < args.length; i++){
				if((options = args[i]) != null){
					for(var name:String in options){
						var copy:* = options[name];
						target[name] = copy;
					}
				}
			}
			return target;
		}
		/**
		 * 将数组转换为表.
		 * 数组应该由偶数个值组成,每两个值表示一个键值对.
		 * 此方法用于简化键也为常量的表的定义.
		 * 例:
		 * 		var map:Object = {(int(CONSTANT_NUM)): CONSTANT_STRING, ...}
		 * 可简化为:
		 * 		var map:Object = fromArray([CONSTANT_NUM,CONSTANT_STRING, ...]};
		 */
		public static function fromArray(arr:Array):Object{
			var obj:Object = new Object();
			for(var i:int = 0; i < arr.length; i+=2){
				obj[arr[i]] = arr[i+1];
			}
			return obj;
		}
		
		/**
		 * clone(). deep copying.
		 * The algorithm is borrowed from a common Java programming technique. 
		 * The function creates a deep copy by serializing the array into an instance of the ByteArray class, 
		 * and then reading the array back into a new array. 
		 * This function accepts an object so that it can be used with both indexed arrays and associative arrays
		 * 
		 * CAUTION:
		 * ByteArray readObject() does not work with display objects and other objects that are defined by Flash Player. 
		 * Complex objects that are defined in ActionScript (from simple types) work
		 */
		public static function clone(source:Object):*{
			var myBA:ByteArray = new ByteArray();
		    myBA.writeObject(source);
		    myBA.position = 0;
		    return(myBA.readObject());
		}
		
		/**
		 * 复制一个可视化对象
		 * @param source 需复制的可视化对象
		 * @param autoAdd 是否自动添加对象到source的父层
		 * @return 
		 * <br>注：需在fla中为动画元件添加链接名称
		 */		
		public static function cloneDisplayObject(source:DisplayObject, autoAdd:Boolean = false):DisplayObject
		{
			var clazz:Class = Object(source).constructor;
			var newDisplayObject:DisplayObject = new clazz();
			newDisplayObject.transform  = source.transform;
			newDisplayObject.filters = source.filters;
			newDisplayObject.cacheAsBitmap = source.cacheAsBitmap;
			newDisplayObject.opaqueBackground = source.opaqueBackground;
			if (source.scale9Grid) 
			{
				var rect:Rectangle = source.scale9Grid;
				rect.x /= 20, rect.y /= 20, rect.width /= 20, rect.height /= 20;
				newDisplayObject.scale9Grid = rect;
			}
			if (source.parent && autoAdd) 
			{
				source.parent.addChild(newDisplayObject);
			}
			return newDisplayObject;
		}
		
		/**
		 * 改变obejct的键值
		 * @param src,要改变的对象
		 * @param keyMap,旧键到新键的映射
		 * @example
		 *  var o:Object = {name:'az',age:25};
		 * 	o = rehash(o,{name:'姓名',age:'年龄'});
		 *  o => {'姓名':'az','年龄':25}
		 */
		public static function rehash(src:Object,keyMap:Object):Object
		{
			var result:Object = {};
			for(var oldKey:String in keyMap){
				var newKey:String = keyMap[oldKey];
				if(newKey==null||newKey=="")continue;
				result[newKey] = src[oldKey];
			}
			return result;
		}
		
		/**
		 * 将两个数组合并成一个object，前者为key，后者为value
		 * @example
		 * 	var value:Array = ['az','25','aaaaa'];
		 *	var key:Array = ['name','age'];
		 *	var o:Object = fromKeyValueArray(key,value);
		 *  o => {'name':'az','age':25}
		 */
		public static function combine(key:Array,value:Array):Object
		{
			if(!key||!value)return {};
			return rehash(value,key);
		}
		
		/**
		 * 取出object的所有键值
		 * @example
		 * 	keys({'姓名':'az','年龄':25}) => ['姓名','年龄'}]
		 */
		public static function keys(o:Object):Array
		{
			var result:Array = [];
			if(o==null)return result;
			for(var i:String in o){
				result.push(i);
			}
			if(o is Array){
				return result;
			}else{
				return result.reverse();
			}
		}
		
		/**
		 * 取出object的所有值
		 * @example
		 * 	values({'姓名':'az','年龄':25}) => ['az',25}]
		 */
		public static function values(o:Object):Array
		{
			var result:Array = [];
			if(o==null)return result;
			for(var i:String in o){
				result.push(o[i]);
			}	
			if(o is Array){
				return result;
			}else{
				return result.reverse();
			}
		}
		
		/**
		 * 删除键值为null,undefined的key
		 * @example
		 * 	var ary:* = {a:null,b:0,c:'',d:undefined};
		 *  compact(ary) => {b:0,c:''}
		 */
		public static function compact(o:Object):*
		{
			if(o==null){
				return o;
			}
			for(var i:* in o){
				if(o[i]==null||o[i]==undefined){
					delete o[i];
				}
			}
			return o;
		}
		
		/**
		 * Object格式化
		 * @example
		 * var o:Object = {'关注':'*','名称':'rolan','门派':'2','级别':10};
		 * trace(join(o,"=",","));
		 * 关注=*,级别=10,名称=rolan,门派=2
		 */
		public static function join(o:Object,glue:String=',',separator:String=';'):String
		{
			if(o==null)return 'null';
			var result:Array = [];
			for(var i:* in o){
				result.push(i+glue+o[i]);
			}
			return result.join(separator);
		}
		
		/**
		 * 将object中的所有属性trace出来 
		 * @param object 要trace的对象
		 * @param flag 显示在前面的标示符 - "TraceObjet"
		 * 
		 */		
		public static function traceObject(object:Object, flag:String = "TraceObject"):void {
			var now:Date = new Date();
			
			trace("==========================" + now.hours + ":" + now.minutes + ":" + now.seconds + "." + now.milliseconds + "==========================");
			for(var key:String in object) {
				trace("【" + flag + "】 - " + key + ": " + object[key]);
			}
			trace("===============================================================");
		}
		
		/**
		 * 将数组中的元素trace出来 
		 * @param array 要trace的数组
		 * @param flag 显示在前面的标示符 - "TraceArray"
		 * 
		 */		
		public static function traceArray(array:Array, flag:String = "TraceArray"):void {
			var now:Date = new Date();
			
			trace("==========================" + now.hours + ":" + now.minutes + ":" + now.seconds + "." + now.milliseconds + "==========================");
			for(var i:int = 0; i < array.length; i++) {
				trace("【" + flag + "】 - " + i + ": " + array[i]);
			}
			trace("===============================================================");
		}
		
		/**
		 * 复制数组（浅层复制）
		 * @param array 原数组
		 * @return 复制后的数组
		 */		
		public static function copyArray(array:Array):Array {
			var arr:Array = new Array();
			for each(var item:* in array) {
				arr.push(item);
			}
			return arr;
		}
		
		/**
		 * 复制Object（浅层复制）
		 * @param obj 原Object
		 * @return 复制后的Object
		 */		
		public static function copyObject(obj:Object):Object {
			var temp:Object = new Object();
			for(var name:String in obj) {
				temp[name] = obj[name];
			}
			return temp;
		}
		
		/**
		 * 复制字典（浅层复制）
		 * @param dict 原字典
		 * @return 复制后的字典
		 */		
		public static function cotyDictionary(dict:Dictionary):Dictionary {
			var dictionary:Dictionary = new Dictionary();
			for(var key:* in dict) {
				dictionary[key] = dict[key];
			}
			return dictionary;
		}
		
		/**
		 * 清空数组或向量
		 * @param list 要清空的数组或向量
		 */		
		public static function clearList(list:*):void {
			if(list == null || (!(list is Array) && !(list is Vector.<*>))) return;
			list.splice(0, list.length);
		}
		
		/**
		 * 清空Object中的动态引用
		 * @param obj 要清空引用的Object
		 */		
		public static function clearObject(obj:Object):void {
			if(obj == null) return;
			for(var key:* in obj) {
				obj[key] = null;
				delete obj[key];
			}
		}
	}
}