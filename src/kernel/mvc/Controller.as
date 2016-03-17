package kernel.mvc
{
	import flash.utils.Dictionary;
	
	import kernel.IDispose;
	import kernel.errors.KernelErrorRunner;
	import kernel.mvc.interfaces.INotification;
	import kernel.mvc.interfaces.IObserver;
	import kernel.mvc.patterns.context.Context;
	import kernel.mvc.patterns.notice.Observer;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 7:14:57 PM
	 */
	public final class Controller implements IDispose
	{
		//<Observer>
		private var _notificationMap:Dictionary;
		private var _context:Context;
		
		public function Controller(context:Context)
		{
			this._context = context;
		}
		
		public function initializeController():void
		{
			this._notificationMap = new Dictionary();
		}
		
		public function registerCommand(notificationName:String, commandClassRef:Class):void
		{
			var observer:* = this._notificationMap[notificationName];
			
			if (observer != null)
			{
				if (observer is Array)
				{
					KernelErrorRunner.getInstance().throwException("注册的Command和某一个注册的Notification名字重复!");
					return ;
				} else if (observer is CommandObserver)
				{
					CommandObserver(observer).dispose();
				}
			}
			this._notificationMap[notificationName] = new CommandObserver(null, commandClassRef, this._context);
		}
		
		public function removeCommand(notificationName:String):void
		{
			var observer:IObserver = this._notificationMap[notificationName];
			
			if (observer != null)
			{
				if (observer is CommandObserver)
				{
					CommandObserver(observer).dispose();
					this._notificationMap[notificationName] = null;
					delete this._notificationMap[notificationName];
				}
			}
		}
		
		
		public function sendNotication(notificationName:String, note:INotification):void
		{
			var observer:* = this._notificationMap[notificationName];
			
			if (observer != null && observer != undefined)
			{
				if (observer is CommandObserver)
				{
					CommandObserver(observer).notifyObserver(note);
				} else if (observer is Array)
				{
					var obArray:Array = observer as Array;
					var size:int = obArray.length;
					var methodObserver:MethodObserver;
					
					while (--size > -1)
					{
						methodObserver = obArray[size];
						methodObserver.notifyObserver(note);
					}
				}
			}
		}
		
		public function subscribeNotification(notificationName:String, method:Function):void
		{
			var methodObserver:IObserver = new MethodObserver(method, null);
			var observerArray:* = this._notificationMap[notificationName];
			
			if (observerArray is CommandObserver)
			{
				KernelErrorRunner.getInstance().throwException("注册的Notification名称和某一个注册的Command重复!");
				return ;
			}
			
			if (observerArray == null)
			{
				this._notificationMap[notificationName] = [methodObserver];
			} else
			{
				if (observerArray is Array)
				{
					var obs:Array = observerArray as Array;
					//如果已经注册过的方法，通知名和方法回调一样，那么不再注册两遍。
					var value:Boolean = false;
					
					for each (var mo:MethodObserver in obs)
					{
						if (mo.getNotifyMethod() == method)
						{
							value = true;
							break;
						}
					}
					
					if (value == false)
					{
						this._notificationMap[notificationName].unshift(methodObserver);
					}
				}
			}
		}
		
		public function unsubscribeNotification(notificationName:String, method:Function):void
		{
			var observer:* = this._notificationMap[notificationName];
			
			if (observer != null)
			{
				if (observer is Array)
				{
					var obArray:Array = observer as Array;
					var size:int = obArray.length;
					var methodObserver:MethodObserver;
					
					for (var i:int = 0; i < size; i++)
					{
						methodObserver = obArray[i];
						
						if (methodObserver.getNotifyMethod() == method)
						{
							methodObserver.dispose();
							obArray.splice(i, 1);
							break;
						}
					}
				}
			}
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_notificationMap);
			_context = null;
			
		}
		
		
	}
}