package kernel.utils.timer
{
	
	import flash.events.EventDispatcher;
	import flash.utils.getTimer;
	
	import kernel.IDispose;
	import kernel.runner.ITick;
	import kernel.runner.TickRunner;
	
	/**
	 * @name 运用EnterFrame的Timer,由TickRunner来驱动他的运作
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 21, 2011 10:34:29 AM
	 */
	public class EnterFrameTimer extends EventDispatcher implements ITimer, ITick, IDispose
	{
		private var _currentCount:int;
		private var _delay:int;
		private var _repeatCount:int;
		private var _running:Boolean;
		
		private var _startTime:int; //起始时间
		private var _currentTime:int; //当前时间
		private var _onTimer:Function;
		private var _onComplete:Function;
		
		
		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}
		
		public function set onTimer(value:Function):void
		{
			_onTimer = value;
		}
		
		
		public function get currentCount():int
		{
			return _currentCount;
		}
		
		public function get delay():int
		{
			return _delay;
		}
		
		public function set delay(value:int):void
		{
			_delay = value;
		}
		
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void
		{
			_repeatCount = value;
		}
		
		public function get running():Boolean
		{
			return _running;
		}
		
		public function EnterFrameTimer(delay:int, repeatCount:int = 0)
		{
			_delay = delay;
			_repeatCount = repeatCount;
		}
		
		private function invokeTimerCallBack():void
		{
			if (this._onTimer != null)
			{
				this._onTimer.call();
			}
		}
		
		private function run():void
		{
			_startTime += _delay;
			this.invokeTimerCallBack();
		}
		
		public function reset():void
		{
			_currentCount = 0;
			_startTime = getTimer();
		}
		
		public function start():void
		{
			_startTime = getTimer();
			_running = true;
			TickRunner.getInstance().addTicker(this);
		}
		
		public function stop():void
		{
			if (_running)
			{
				_running = false;
				TickRunner.getInstance().removeTicker(this);
			}
		}
		
		public function onTick(delay:uint):void
		{
			this.step();
		}
		
		
		public function step():void
		{
			if (_running)
			{
				_currentTime = getTimer();
				
				if (_currentTime - _startTime >= _delay)
				{
					var times:int = Math.floor((_currentTime - _startTime) / _delay);
					
					for (var i:int = 0; i < times; i++)
					{
						_currentCount++;
						
						if (_repeatCount > 0 && _repeatCount <= _currentCount)
						{
							stop();
							run();
							
							if (this._onComplete != null)
							{
								this._onComplete.call();
							}
							this.invokeTimerCallBack();
						} else
						{
							run();
						}
					}
				}
			}
		}
		
		public function dispose():void
		{
			TickRunner.getInstance().removeTicker(this);
			this.stop();
			_onTimer = null;
			_onComplete = null;
		}
		
		
	}
}