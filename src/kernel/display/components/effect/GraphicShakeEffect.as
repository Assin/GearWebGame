package kernel.display.components.effect
{
	import flash.display.DisplayObject;
	
	import kernel.IDispose;
	import kernel.utils.ObjectPool;
	import kernel.utils.RandomUtil;
	import kernel.utils.timer.EnterFrameTimer;
	
	public class GraphicShakeEffect implements IDispose
	{
		private var startX:Number;
		private var startY:Number;
		
		private var timer:EnterFrameTimer;
		private var delayTimer:EnterFrameTimer;
		private var shakeTimer:EnterFrameTimer;
		private var _target:DisplayObject; //目标
		private var _delay:int; //延迟
		private var _time:int; //每次抖动时间
		private var _repeatCount:int = 1; //重复次数
		private var _para:Number = 5; //抖动幅度
		private var _onComplete:Function;
		
		/**
		 * 使用到纵向
		 */
		public var useToVertical:Boolean = true;
		/**
		 * 使用到横向
		 */
		public var useToHorizontal:Boolean = true;
		
		public function GraphicShakeEffect()
		{
		}
		
		
		
		public function play():void
		{
			if (_target == null)
			{
				return ;
			}
			
			timer = new EnterFrameTimer(this._time, 1); //控制一次抖动时间
			shakeTimer = new EnterFrameTimer(1, 0); //抖动
			delayTimer = new EnterFrameTimer(this._time + this._delay, this._repeatCount); //抖动次数
			timer.onComplete = onOneShakeHandler;
			shakeTimer.onTimer = onTimerHandler;
			delayTimer.onTimer = onStartShakeHandler;
			delayTimer.onComplete = onEndHandler;
			delayTimer.start();
			timer.start();
			shakeTimer.start();
			
		}
		
		private function onOneShakeHandler():void
		{
			shakeTimer.stop();
			getTarget().x = startX;
			getTarget().y = startY;
		}
		
		private function onStartShakeHandler():void
		{
			timer.start();
			shakeTimer.start();
		}
		
		private function onEndHandler():void
		{
			stop();
			
			if (this._onComplete != null)
			{
				this._onComplete();
			}
		}
		
		
		private function onTimerCompleteHandler():void
		{
			getTarget().x = startX;
			getTarget().y = startY;
			stop();
			dispose();
		}
		
		private function onTimerHandler():void
		{
			if (this.useToHorizontal)
			{
				getTarget().x = RandomUtil.integer(startX - _para, startX + _para + 1);
			}
			
			if (this.useToVertical)
			{
				getTarget().y = RandomUtil.integer(startY - _para, startY + _para + 1);
			}
		}
		
		public function stop():void
		{
			timer.stop();
			shakeTimer.stop();
			delayTimer.stop();
			getTarget().x = startX;
			getTarget().y = startY;
		}
		
		
		/**
		 * 得到抖动目标
		 */
		private function getTarget():DisplayObject
		{
			return _target;
		}
		
		public function get onComplete():Function
		{
			return _onComplete;
		}
		
		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}
		
		public function get para():Number
		{
			return _para;
		}
		
		public function set para(value:Number):void
		{
			_para = value;
		}
		
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void
		{
			_repeatCount = value;
		}
		
		public function get time():int
		{
			return _time;
		}
		
		public function set time(value:int):void
		{
			_time = value;
		}
		
		public function get delay():int
		{
			return _delay;
		}
		
		public function set delay(value:int):void
		{
			_delay = value;
		}
		
		public function get target():DisplayObject
		{
			return _target;
		}
		
		public function set target(value:DisplayObject):void
		{
			if (value == null)
			{
				return ;
			}
			this._target = value;
			this.startX = getTarget().x;
			this.startY = getTarget().y;
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(timer);
			timer = null;
			ObjectPool.disposeObject(delayTimer);
			delayTimer = null;
			ObjectPool.disposeObject(shakeTimer);
			shakeTimer = null
			_target = null;
			_onComplete = null;
		}
	}
}