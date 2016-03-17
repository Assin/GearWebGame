package kernel.runner
{
	import flash.display.Stage;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * @name 管理主循环心跳
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 9:46:42 AM
	 */
	public class TickRunner implements ITickHandler
	{
		/**
		 * 循环对象字典  用循环对象当KEY
		 */
		private var _tickerList:Array;
		/**
		 *  循环计时器字典
		 */
		private var _timeOutList:Array;
		/**
		 * 上一帧时间
		 */
		private var _prevTime:uint;
		
		private static var _instance:TickRunner;
		
		public static function getInstance():TickRunner
		{
			if (_instance == null)
			{
				_instance = new TickRunner();
			}
			return _instance;
			
		}
		
		public function TickRunner()
		{
			this._tickerList = [];
			this._timeOutList = [];
			_prevTime = getTimer();
		}
		
		/**
		 * 用stage初始化循环
		 * @param stage 舞台对象
		 * @return 用于判断是否初始化成功
		 *
		 */
		public function init(stage:Stage):void
		{
			if (stage)
			{
				stage.addEventListener(Event.ENTER_FRAME, onStageEnterFrameHandler);
			}
		}
		
		public function addTicker(ticker:ITick, delay:int = -1):void
		{
			var last:int = getTimer();
			var tickObject:Object;
			
			if (this.hasTicker(ticker))
			{
				tickObject = getTickObject(ticker);
				tickObject["ticker"] = ticker;
				tickObject["delayTime"] = delay;
				tickObject["lastTime"] = last;
			} else
			{
				tickObject = {ticker:ticker, delayTime:delay, lastTime:last};
				this._tickerList.push(tickObject);
			}
		}
		
		/**
		 * 设置计时器
		 * @param closure
		 * @param delay
		 * @param parameters
		 *
		 */
		public function setTimeOut(closure:Function, delay:Number, ... parameters):void
		{
			if (delay <= 0 && closure != null)
			{
				closure.apply(null, parameters);
				return ;
			}
			var timeOutObject:Object = this.getTimeOut(closure);
			var last:int = getTimer();
			
			if (timeOutObject != null)
			{
				timeOutObject.delayTime = delay;
				timeOutObject.lastTime = last;
				timeOutObject.parameters = parameters;
			} else
			{
				this._timeOutList.push({closure:closure, delayTime:delay, lastTime:last, parameters:parameters});
			}
			
		}
		
		private function getTimeOut(closure:Function):Object
		{
			for each (var key:Object in this._timeOutList)
			{
				if (closure == key["closure"])
				{
					return key;
				}
			}
			return null;
		}
		
		/**
		 *  清除计时器
		 * @param closure
		 *
		 */
		public function clearTimeOut(closure:Function):void
		{
			var length:uint = this._timeOutList.length;
			
			for (var i:int = 0; i < length; i++)
			{
				if (this._timeOutList[i]["closure"] == closure)
				{
					this._timeOutList.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * 获取循环对象
		 * @param ticker
		 * @return
		 *
		 */
		private function getTickObject(ticker:ITick):Object
		{
			for each (var obj:Object in this._tickerList)
			{
				if (obj["ticker"] == ticker)
				{
					return obj;
				}
			}
			return null;
		}
		
		
		public function hasTicker(ticker:ITick):Boolean
		{
			var value:Boolean = false;
			
			for each (var obj:Object in this._tickerList)
			{
				if (obj["ticker"] == ticker)
				{
					value = true;
					break;
				}
			}
			return value;
		}
		
		/**
		 * 删除一个心跳者
		 * @param ticker
		 *
		 */
		public function removeTicker(ticker:ITick):void
		{
			var length:uint = this._tickerList.length;
			
			for (var i:int = 0; i < length; i++)
			{
				if (this._tickerList[i]["ticker"] == ticker)
				{
					this._tickerList[i]["ticker"] = null;
					break;
				}
			}
		}
		
		/**
		 * 循环函数
		 *
		 */
		private function run():void
		{
			var curTime:uint = getTimer();
			var delay:uint = curTime - _prevTime;
			var ticker:ITick = null;
			var closure:Function;
			
			
			
			for each (var key:Object in this._tickerList)
			{
				ticker = key["ticker"]as ITick;
				
				if (ticker == null)
				{
					continue;
				}
				
				if (key["delayTime"] == -1 || curTime - key["lastTime"] >= key["delayTime"])
				{
					ticker.onTick(delay);
					key["lastTime"] = curTime;
				}
			}
			
			for each (key in this._timeOutList)
			{
				closure = key["closure"]as Function;
				
				if (curTime - key["lastTime"] >= key["delayTime"] || key["delayTime"] == -1)
				{
					key["lastTime"] = curTime;
					
					if (closure != null)
					{
						this.clearTimeOut(closure);
						closure.apply(null, key["parameters"]);
					}
				}
			}
			
			_prevTime = curTime;
			
			//清除要删除的
			for each (var removeKey:Object in this._tickerList)
			{
				if (removeKey["ticker"] == null)
				{
					this._tickerList.splice(this._tickerList.indexOf(removeKey), 1);
				}
			}
		}
		
		/**
		 * Stage的EnterFrame事件函数
		 * @param event
		 *
		 */
		private function onStageEnterFrameHandler(e:Event):void
		{
			run();
		}
		
	}
}