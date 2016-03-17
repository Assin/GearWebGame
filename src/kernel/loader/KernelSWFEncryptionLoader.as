package kernel.loader
{
	import flash.utils.ByteArray;
	
	import kernel.runner.LogRunner;
	
	import org.gearloader.loader.GSWFLoader;
	
	/**
	 * @name 
	 * @explain
	 * @author yanghongbin
	 * @create Dec 3, 2013
	 */
	public class KernelSWFEncryptionLoader extends GSWFLoader
	{
		public function KernelSWFEncryptionLoader()
		{
			super();
		}
		/**
		 * 彻底重写父类的代码，并且不调用父类的 
		 * 
		 */		
		override protected function executeCompleteAfterHandler():void
		{
			LogRunner.log("开始进行解密:" + url);
			var byteArray:ByteArray = content as ByteArray;
			var bytes:ByteArray = new ByteArray();
			bytes.writeByte(67);
			bytes.writeByte(87);
			bytes.writeByte(83);
			byteArray.position = 21;
			byteArray.readBytes(bytes, 124, byteArray.bytesAvailable - 121);
			byteArray.readBytes(bytes, 3);
			loadBytes(bytes, _context);
		}
	}
}
