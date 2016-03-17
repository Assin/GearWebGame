package kernel.utils
{
	import flash.utils.ByteArray;

	/**
	 * @name 字节数组工具类
	 * @explain  字节数组工具类
	 * @author lihuahe
	 * @create 20110802
	 * @modify lihuahe
	 * 		@date 20111014
	 * 		@explain 添加
	 * @modify wanglei
	 * 		@date 20111019
	 * 		@explain 添加 get0ByteArray()方法
	 */
	public class ByteArrayUtils
	{
		public function ByteArrayUtils()
		{
		}
		
		/***
		 * 传入2个byteArray 判断是否相等
		 * @param byte1 第一个字节数组
		 * @param byte2  第二个字节数组 
		 * 
		 * return 相等为true,反之为false
		 * **/
		public static function compare(byte1:ByteArray,byte2:ByteArray):Boolean
		{
			if (byte1 == byte2)
			{
				return true;
			}
			if (byte1 == null || byte2 == null)
			{
				return false;
			}
			if (byte1.length != byte2.length)
			{
				return false;
			}
			byte1.position = 0;
			byte2.position = 0;
			while(byte1.bytesAvailable > 0)
			{
				if (byte1.readUnsignedByte() != byte2.readUnsignedByte())
				{
					byte1.position = 0;
					byte2.position = 0;
					return false;
				}
			}
			byte1.position = 0;
			byte2.position = 0;
			
			return true;
		}
		/**
		 * 打印byteArray所有的字节数
		 * @param byte1
		 * **/
		public static function println(byte1:ByteArray):void
		{
			byte1.position = 0;
			var str:String = "";
			while(byte1.bytesAvailable > 0)
			{
				str += byte1.readUnsignedByte()+",";
			}
			trace(str);
			byte1.position = 0;
		}
		/**
		 * 判断byteArray是否全为0
		 * @param byte1 
		 * **/
		public static function isEmpty(byte1:ByteArray):Boolean
		{
			byte1.position = 0;
			var str:String = "";
			var isEmpty:Boolean = true;
			while(byte1.bytesAvailable > 0)
			{
				if (byte1.readUnsignedByte() != 0)
				{
					isEmpty = false;
					break;
				}
			}
			byte1.position = 0;
			return isEmpty;
		}
		/**
		 * 复制byteArray
		 * @param byte1
		 * **/
		public static function copy(byte1:ByteArray):ByteArray
		{
			byte1.position = 0;
			
			var item:ByteArray = new ByteArray();
			
			byte1.readBytes(item,0,byte1.bytesAvailable);
			byte1.position = 0;
			
			return item;
		}
		/***
		 * 随机生成指定 长度的byteArray，里面随机填充了相应0 -255之间的整数
		 * 
		 * 
		 * @param length 长度
		 * 
		 * 返回指定 长度的byteArray
		 * **/
		public static function getRandomByteArray(length:uint):ByteArray
		{
			
			var by:ByteArray = new ByteArray();
			by.length = length;
			var index:int = 0;
			by.position = 0;
			while(index < length)
			{
				by.writeByte(0xff * Math.random());
				index++;
			}
			
			return by;
		}
		/****
		 * 根据位置索引，查找当前字节流中的bit值
		 * @param byteArray 需要解析的字节流
		 * @param value 位置索引
		 * ****/
		public static function getBitValue(byteArray:ByteArray,value:int):uint
		{
			var startIndex:int = (value + 7) / 8;
			var index:int = value % 8;
			if (index == 0)
			{
				index = 8;
			}
			var unSignByte:uint = 0;
			var bit:uint = 0;
			if (byteArray != null)
			{
				if (startIndex > 0)
				{
					startIndex = startIndex - 1;
				}
				byteArray.position = startIndex;
				unSignByte = byteArray.readUnsignedByte();
				unSignByte = unSignByte >> (8 - index);
				bit = 0x01 & unSignByte;
			}
			byteArray.position = 0;
			return bit;
		}
		/****
		 * 根据位置索引，设置当前字节流中的bit值
		 * @param byteArray 需要解析的字节流
		 * @param value 位置索引
		 * ****/
		public static function setBitValue(byteArray:ByteArray,startIndex:int,value:int):void
		{
			var cacheValue:int = startIndex;
			startIndex = (cacheValue + 7) / 8;
			var index:int = cacheValue % 8;
			if (index == 0)
			{
				index = 8;
			}
			var unSignByte:uint = 0;
			var bit:uint = 0;
			if (byteArray != null)
			{
				if (startIndex > 0)
				{
					startIndex = startIndex - 1;
				}
				byteArray.position = startIndex;
				unSignByte = byteArray.readUnsignedByte();
				var p:uint = 0x01 << (8 - index);
				unSignByte = p | unSignByte;
				byteArray.position -= 1;
				
				byteArray.writeByte(unSignByte);
			}
		}
		
		/**
		 * 生成指定 长度的所有字节为0的byteArray
		 * @param length	长度
		 * @return 			返回指定 长度的byteArray
		 * @author wanglei
		 */
		public static function getZeroByteArray(length:uint):ByteArray
		{
			var by:ByteArray = new ByteArray();
			by.length = length;
			var index:int = 0;
			by.position = 0;
			while(index < length)
			{
				by.writeByte(0);
				index++;
			}
			return by;
		}
	}
}