package kernel.display.components
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	
	import kernel.IDispose;
	import kernel.utils.ColorUtil;
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * 控制一个显示对象闪烁用的
	 * @author 雷羽佳 2013.3.14 12：56
	 *
	 */
	public class TwinkleUnit implements IDispose
	{
		
		private var _target:DisplayObject;
		private var _timer:EnterFrameTimer;
		
		private var _color:uint;
		private var _diffuse:Number;
		private var _strength:Number;
		private var _alpha:Number;
		
		private var _time:int = 0;
		
		public var onComplete:Function;
		
		/**
		 *  控制一个显示对象闪烁用的
		 * @param target 发光目标
		 * @param color 发光颜色
		 * @param diffuse 发光漫反射
		 * @param strength 发光强度
		 * @param alhpa 发光透明度
		 * @param time 循环一次的时间
		 *
		 */
		public function TwinkleUnit(target:DisplayObject, color:uint = 0xcccc00, diffuse:Number = 3, strength:Number = 6, alhpa:Number = 1, time:int = 1000)
		{
			_target = target;
			_timer = new EnterFrameTimer(30);
			_timer.onTimer = share;
			
			_color = color;
			_diffuse = diffuse;
			_strength = strength;
			_alpha = alhpa;
			_time = time;
			
			_step = (Math.PI * 2) / time * 30;
		}
		
		private var _isStart:Boolean = false;
		
		public function get isStart():Boolean
		{
			return _isStart;
		}
		
		
		public function start():void
		{
			if (_isStart == false)
			{
				_isStart = true;
				_timer.start();
			}
		}
		
		private var highLightTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 30, 30, 30, 0);
		private var highLightTransform2:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		private var i:Number = 0;
		private var value:Number;
		
		private var _step:Number = 0;
		
		private function share():void
		{
			value = (Math.sin(i) + 1) / 2;
			i = i + _step;
			
			
			highLightTransform.redOffset = value * 60;
			highLightTransform.blueOffset = value * 60;
			highLightTransform.greenOffset = value * 60;
			_target.transform.colorTransform = highLightTransform;
			_target.filters = [];
			ColorUtil.addColorRing(_target, _color, value * _diffuse, value * _strength, value * _alpha);
		}
		
		public function stop():void
		{
			_timer.stop();
			_isStart = false;
			ColorUtil.removeColorRing(_target);
			_target.transform.colorTransform = highLightTransform2;
			
			if (onComplete != null)
			{
				onComplete();
			}
		}
		
		public function dispose():void
		{
			this._target = null;
			ObjectPool.disposeObject(this._timer);
			this._timer = null;
			highLightTransform = null;
			highLightTransform2 = null;
		}
		
		
	}
}