package kernel.loader
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import org.gearloader.loader.GSWFLoader;
	
	/**
	 * @name 用于加载英雄动作动画打包pswf资源的加载器
	 * @explain
	 * @author yanghongbin
	 * @create Dec 5, 2013
	 */
	public class KernelPackageSWFLoader extends GSWFLoader
	{
		private var _customLoader:Loader;
		public var bitmapSWFArray:Array = [];
		private var _pswfLength:int;
		private var _customLoaderArray:Array = [];
		
		public function KernelPackageSWFLoader()
		{
			super();
		}
		
		/**
		 * 彻底重写父类的代码，并且不调用父类的
		 *
		 */
		override protected function executeCompleteAfterHandler():void
		{
			var byteArray:ByteArray = content as ByteArray;
			var swfByteArrayList:Array = [];
			
			while (byteArray.bytesAvailable != 0)
			{
				var size:int = byteArray.readInt();
				var swfByteArray:ByteArray = new ByteArray;
				byteArray.readBytes(swfByteArray, 0, size);
				swfByteArray.position = 0;
				swfByteArrayList.push(swfByteArray);
			}
			_pswfLength = swfByteArrayList.length;
			
			for each (var swfba:ByteArray in swfByteArrayList)
			{
				_customLoader = new Loader();
				_customLoaderArray.push(_customLoader);
				_customLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCustomLoaderCompelteHandler);
				_customLoader.loadBytes(swfba);
			}
		}
		
		private function onCustomLoaderCompelteHandler(e:Event):void
		{
			e.target.removeEventListener(Event.COMPLETE, onCustomLoaderCompelteHandler);
			bitmapSWFArray.push(e.target.content);
			
			if (_pswfLength == bitmapSWFArray.length)
			{
				executeLoaderCompleteAfterHandler();
			}
		}
		
		override public function dispose():void
		{
			if (_customLoader)
			{
				_customLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCustomLoaderCompelteHandler);
				_customLoader.unload();
				_customLoader = null;
			}
			
			for each (var loader:Loader in _customLoaderArray)
			{
				loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onCustomLoaderCompelteHandler);
				loader.unload();
				loader = null;
			}
			_customLoaderArray = null;
			
			for each (var c:*in bitmapSWFArray)
			{
				if (c is Loader)
				{
					Loader(c).unload();
				}
			}
			bitmapSWFArray = null;
			super.dispose();
		}
		
		
	}
}
