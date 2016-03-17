package kernel.net
{
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @name 
	 * @explain
	 * @author yanghongbin
	 * @create Nov 15, 2012 11:32:02 AM
	 */
	public class ServerByteArray extends ByteArray
	{
		/**
		 * 最大的未压缩数据大小 
		 */		
		public static const MAX_UNCOMPRESS_LENGTH:int = 128;
		public function ServerByteArray()
		{
			super();
			this.endian = Endian.LITTLE_ENDIAN;
		}
	}
}