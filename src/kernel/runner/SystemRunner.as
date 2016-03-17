package kernel.runner
{
	import flash.events.UncaughtErrorEvent;
	import flash.net.LocalConnection;
	import flash.system.Capabilities;
	
	import kernel.configs.ApplicationConfig;
	import kernel.errors.KernelErrorRunner;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Oct 30, 2012 6:22:04 PM
	 */
	public class SystemRunner
	{
		private static var _instance:SystemRunner;
		
		public static function getInstance():SystemRunner
		{
			if (_instance == null)
			{
				_instance = new SystemRunner();
			}
			return _instance;
			
		}
		
		public function SystemRunner()
		{
		}
		
		/**
		 * 初始化
		 *
		 */
		public function init():void
		{
			//检测在application_config.xml中是否设置了DEBUG
			if (!ApplicationConfig.DEBUG)
			{
				StageRunner.getInstance().stage.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtErrorHandler);
			}
		}
		
		private function onUncaughtErrorHandler(e:UncaughtErrorEvent):void
		{
			LogRunner.error("[SystemRunner UncaughtError]：" + e.text);
		}
		
		/**
		 * 强制垃圾回收
		 */
		public static function gc():void
		{
			try
			{
				new LocalConnection().connect('SH');
				new LocalConnection().connect('SH');
			} catch (e:Error)
			{
				KernelErrorRunner.getInstance().throwException("system GC error!");
			}
		}
		
		/**
		 * 获得flashpayer版本号数组，0位置是大版本号，1位置是小版本号  如[11,3];
		 * @return
		 *
		 */
		public static function getFlashPlayerVersionArray():Array
		{
			var result:Array = [];
			var version:String = Capabilities.version;
			var v:String = version.split(" ")[1];
			var vArray:Array = v.split(",");
			result.push(int(vArray[0]));
			result.push(int(vArray[1]));
			return result;
		}
	}
}