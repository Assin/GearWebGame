package kernel.display.components.effect
{
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import kernel.IDispose;
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * @name 图像的"闪" 效果,主要在两个颜色之间切换
	 * @explain
	 * @author yanghongbin
	 * @create Apr 25, 2012 3:42:24 PM
	 */
	public class GraphicFlashEffect implements IDispose
	{
		public static const DEFAULT_COLOR_TRANSFORM:ColorTransform = new ColorTransform();
		public static const WHITE_COLOR_TRANSFORM:ColorTransform = new ColorTransform(0, 0, 0, 1, 255, 255, 255, 0);
		public static const BLACK_COLOR_TRANSFORM:ColorTransform = new ColorTransform(0, 0, 0, 1);
		public static const RED_COLOR_TRANSFORM:ColorTransform = new ColorTransform(-1, 0, 0, 1, 255);
		private var defaultColorTransform:ColorTransform;
		private var aColorTransform:ColorTransform;
		private var bColorTransform:ColorTransform;
		private var _onComplete:Function;
		private var isChanged:Boolean;
		private var _target:DisplayObject;
		private var _delay:int;
		private var _repeatCount:int;
		private var timer:EnterFrameTimer;
		private var _queueDestory:Boolean = false;
		
		public function GraphicFlashEffect()
		{
		}
		
		public function get target():DisplayObject
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
		
		public function get repeatCount():int
		{
			return _repeatCount;
		}
		
		public function set repeatCount(value:int):void
		{
			_repeatCount = value;
		}
		
		public function get delay():int
		{
			return _delay;
		}
		
		public function set delay(value:int):void
		{
			_delay = value;
		}
		
		public function set target(value:DisplayObject):void
		{
			if (value == null)
			{
				return ;
			}
			this._target = value
			this.defaultColorTransform = this._target.transform.colorTransform;
		}
		
		public function transformValue(a:ColorTransform, b:ColorTransform):void
		{
			aColorTransform = a;
			bColorTransform = b;
		}
		
		public function play():void
		{
			if (aColorTransform == null || bColorTransform == null || _target == null)
			{
				return ;
			}
			timer = new EnterFrameTimer(this._delay, this._repeatCount);
			timer.onTimer = onTimerHandler;
			timer.onComplete = onTimerCompleteHandler;
			timer.start();
			this.target.transform.colorTransform = bColorTransform;
		}
		
		private function onTimerHandler():void
		{
			if (!this.isChanged)
			{
				this.target.transform.colorTransform = bColorTransform;
			} else
			{
				this.target.transform.colorTransform = aColorTransform;
			}
			this.isChanged = !this.isChanged;
		}
		
		private function onTimerCompleteHandler():void
		{
			this.stop();
			
			if (_queueDestory)
			{
				this.dispose();
			}
		}
		
		public function stop():void
		{
			if (timer != null)
			{
				timer.stop();
				timer.dispose();
				timer = null;
			}
			this.target.transform.colorTransform = defaultColorTransform;
			
			if (this._onComplete != null)
			{
				this._onComplete();
				this._onComplete = null;
			}
			
		}
		
		/**
		 * 播放效果后销毁自身
		 *
		 */
		public function queueDestory():void
		{
			_queueDestory = true;
		}
		
		public function dispose():void
		{
			
			if(_target != null && defaultColorTransform != null)
			{
				this.target.transform.colorTransform = defaultColorTransform;
			}
			
			defaultColorTransform = null;
			aColorTransform = null;
			bColorTransform = null;
			
			_target = null;
			this._onComplete = null;
			
			ObjectPool.disposeObject(timer);
			timer = null;
		}
	}
}