package kernel.events
{
	
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import kernel.utils.ArrayUtil;
	
	
	/**
	 * @name 单例之间派发者
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Dec 19, 2011 10:45:21 AM
	 */
	public class KernelEventDispatcher extends EventDispatcher
	{
		private var _listenFunctions:Array;
		
		private static var _instance:KernelEventDispatcher;
		
		public static function getInstance():KernelEventDispatcher
		{
			if (_instance == null)
			{
				_instance = new KernelEventDispatcher();
			}
			return _instance;
			
		}
		
		public function KernelEventDispatcher(target:IEventDispatcher = null)
		{
			super(target);
			this._listenFunctions = [];
		}
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0,
												  useWeakReference:Boolean = false):void
		{
			this._listenFunctions.push(listener);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}
		
		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			ArrayUtil.removeItem(this._listenFunctions, listener);
			super.removeEventListener(type, listener, useCapture);
		}
		
		
	}
}