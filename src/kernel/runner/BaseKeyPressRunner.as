package kernel.runner
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;

	/**
	 *基本按键管理，如得到是否正在按shift键 
	 * @author 雷羽佳 2013.3.6 10：31
	 * 
	 */	
	public class BaseKeyPressRunner
	{
		
		private static var _instance:BaseKeyPressRunner;
		public static function getInstance():BaseKeyPressRunner
		{
			if (_instance == null)
			{
				flag = false;
				_instance = new BaseKeyPressRunner();
				flag = true;
			}
			return _instance;
		}
		
		private static var flag:Boolean = true;
		public function BaseKeyPressRunner()
		{
			if(flag == true)
				throw new Error("不得通过实例化得到BaseKeyPressRunner，需要通过getInstance方法获得实例");
		}
		
		private var _stage:Stage;
		private var _enterCallBackDict:Dictionary;
		public function init(stage:Stage):void
		{
			_stage = stage;
			_enterCallBackDict = new Dictionary();
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown_handler);
			_stage.addEventListener(KeyboardEvent.KEY_UP,keyUp_handler);
		}
		
		
		private var _shiftKey:Boolean = false;

		/**
		 * 指示 Shift 功能键是处于活动状态 (true) 还是非活动状态 (false)。
		 */
		public function get shiftKey():Boolean
		{
			return _shiftKey;
		}

		private var _altKey:Boolean = false;

		/**
		 * 在 Windows 中，指示 Alt 键是处于活动状态 (true) 还是非活动状态 (false)；在 Mac OS 中，指示 Option 键是否处于活动状态。
		 */
		public function get altKey():Boolean
		{
			return _altKey;
		}

		private var _ctrlKey:Boolean = false;

		/**
		 *在 Windows 和 Linux 中，指示 Ctrl 键是处于活动状态 (true) 还是非活动状态 (false)；在 Mac OS 中，指示 Ctrl 键或 Command 键是否处于活动状态。 
		 */
		public function get ctrlKey():Boolean
		{
			return _ctrlKey;
		}

		
		protected function keyUp_handler(event:KeyboardEvent):void
		{
			_stage.addEventListener(KeyboardEvent.KEY_DOWN,keyDown_handler);
			_shiftKey = event.shiftKey;
			_altKey = event.altKey;
			_ctrlKey = event.ctrlKey;
		}
		
		protected function keyDown_handler(event:KeyboardEvent):void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_DOWN,keyDown_handler);
			_shiftKey = event.shiftKey;
			_altKey = event.altKey;
			_ctrlKey = event.ctrlKey;
			
			//回车键
			if(event.keyCode == 13)
			{
				for each(var obj:Object in _enterCallBackDict)
				{
					if(obj.enable == true)
					{
						obj.callBack();
					}
				}
			}
		}		
		
		/**
		 * 注册一个回车键的回调 
		 * @param name
		 * @param callBack
		 * 
		 */		
		public function registerEnterCallBack(name:String,callBack:Function):void
		{
			if(_enterCallBackDict[name] == null)
			{
				_enterCallBackDict[name] = {callBack:callBack,enable:true}
			}else
			{
				throw new Error("回车键回调注册的名字重复！")
			}
		}
		
		/**
		 * 删除某个回车回调 
		 * @param name
		 * 
		 */		
		public function unregisterEnterCallBack(name:String):void
		{
			_enterCallBackDict[name] = null;
			delete _enterCallBackDict[name];
		}
		
		/**
		 * 使某个回车回调失效
		 * @param name
		 * 
		 */		
		public function disableEnterCallBack(name:String):void
		{
			var obj:Object = _enterCallBackDict[name];
			if(obj == null)
			{
				throw new Error("回车键回调名字未注册！")
			}else
			{
				obj.enable = false;
			}
		}
		/**
		 * 是某个回车回调奏效
		 * @param name
		 * 
		 */		
		public function enableEnterCallBack(name:String):void
		{
			var obj:Object = _enterCallBackDict[name];
			if(obj == null)
			{
				throw new Error("回车键回调名字未注册！")
			}else
			{
				obj.enable = true;
			}
		}
		
	}
}