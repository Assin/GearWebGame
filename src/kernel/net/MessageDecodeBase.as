package kernel.net
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @name 消息体解析类
	 * @explain 封装了消息体解析字节数组的方法
	 * @author yanghongbin
	 * @create 2011 Oct 31, 2011 2:40:58 PM
	 */
	public class MessageDecodeBase extends MessageBase
	{
		
		public function MessageDecodeBase()
		{
			super();
		}
		
		protected function packageMessageInfo():void
		{
		}
		
		protected function readUnsignedShort():int
		{
			return this._byteArray.readUnsignedShort();
		}
		
		protected function readDouble():Number
		{
			return this._byteArray.readDouble();
		}
		
		protected function readInt():int
		{
			return this._byteArray.readInt();
		}
		
		protected function readShort():int
		{
			return this._byteArray.readShort();
		}
		
		protected function readFloat():Number
		{
			return this._byteArray.readFloat();
		}
		
		protected function readByte():int
		{
			//返回的同时去掉符号位，可能byte不需要使用负数
			return int(this._byteArray.readByte()) & 0x000000ff;
		}
		
		protected function readByteArray(_length:int):ByteArray
		{
			if (_length < 0)
			{
				return null;
			}
			var ba:ByteArray = new ByteArray();
			ba.endian = Endian.LITTLE_ENDIAN;
			this._byteArray.readBytes(ba, 0, _length);
			ba.position = 0;
			return ba;
		}
		
		/**
		 * 读取8字节的int64类型,返回16进制表示的字符串
		 * @return String
		 */
		protected function readLong():String
		{
			var guid:String = "";
			for (var i:int = 0; i < 8; i++)
			{
				var read:String = this._byteArray.readUnsignedByte().toString(16);
				if (read.length == 1)
				{
					read = "0" + read;
				}
				guid = read + guid;
			}
			return guid;
		}
		
		/**
		 * 读取指定编码格式的定长字符串，默认UTF-8编码格式
		 * @param len 字节长度
		 * @param charSet 编码格式
		 * @return String
		 */
		protected function readString(len:int, charSet:String = "UTF-8"):String
		{
			try
			{
				return this._byteArray.readMultiByte(len, charSet);
			} catch (e:Error)
			{
				return "null";
			}
			return "null";
		}
		
		/**
		 * 读取指定编码格式的变长字符串，默认UTF-8编码格式
		 * @param charSet 编码格式
		 * @return String
		 */
		protected function readLongString(charSet:String = "UTF-8"):String
		{
			try
			{
				var len:uint = this._byteArray.readShort();
				return this._byteArray.readMultiByte(len, charSet);
			} catch (e:Error)
			{
				return "null";
			}
			return "null";
		}
		
		override public function toString():String
		{
			return super.toString();
		}
	}
}
