package kernel.errors
{
	
	
	/**
	 * @name 错误管理者
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 12:44:38 PM
	 */
	public class KernelErrorRunner
	{
		private static var _instance:KernelErrorRunner;
		
		public static function getInstance():KernelErrorRunner
		{
			if (_instance == null)
			{
				_instance = new KernelErrorRunner();
			}
			return _instance;
		}
		
		public function throwException(value:String):void
		{
			var error:KernelError = new KernelError(value);
			throw error;
		}
	}
}