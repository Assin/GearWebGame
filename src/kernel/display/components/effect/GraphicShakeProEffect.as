package kernel.display.components.effect
{
	import flash.display.DisplayObject;
	import flash.utils.getTimer;
	
	import kernel.IDispose;
	import kernel.runner.StageRunner;
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	/**
	 * 震动模块儿 
	 * @author 雷羽佳 2013.11.5 12：32
	 * 
	 */
	public class GraphicShakeProEffect implements IDispose
	{
		//目标
		private var _target:DisplayObject;
		//横向振幅,单位像素
		private var _swingX:Array = [20,0];
		//横向振幅分布比率的数组；有效值为 0 到 1，且必须是以0开始，以1结束，的递增数组。值 0 表示开始震动，1 表示震动结束。 	
		private var _ratiosX:Array = [0,1];
		//纵向振幅,单位像素
		private var _swingY:Array = [20,0];
		//纵向振幅分布比率的数组；有效值为 0 到 1，且必须是以0开始，以1结束，的递增数组。值 0 表示开始震动，1 表示震动结束。 	
		private var _ratiosY:Array = [0,1];
		//震动时长，单位毫秒
		private var _time:Number = 500;
		//震动频率，单位次/秒
		private var _frequency:Number = 60;
		
		
		
		public var onComplete:Function;
		
		
		private var timer:EnterFrameTimer;
		private var _startTime:int;
		private var _currentSwingX:Number;
		private var _currentSwingY:Number;
		private var _currentDirection:int = 1;
		
		private var _startX:Number = NaN;
		private var _startY:Number = NaN;
		
		private var _perShakeTimeStamp:int;
		/**
		 * 震动频率，单位次/秒 ，默认值为60
		 * @return 
		 * 
		 */		
		public function get frequency():Number
		{
			return _frequency;
		}

		public function set frequency(value:Number):void
		{
			_frequency = value;
		}

		/**
		 * 震动时长，单位毫秒 ，默认值为500
		 * @return 
		 * 
		 */		
		public function get time():Number
		{
			return _time;
		}

		public function set time(value:Number):void
		{
			_time = value;
		}
		/**
		 * 纵向振幅分布比率的数组；有效值为 0 到 1，且必须是以0开始，以1结束，的递增数组。值 0 表示开始震动，1 表示震动结束。
		 * <p>
		 * 默认值为[0,1] 
		 * @return 
		 * 
		 */
		public function get ratiosY():Array
		{
			return _ratiosY;
		}

		public function set ratiosY(value:Array):void
		{
			_ratiosY = value;
		}
		/**
		 * 纵向振幅,单位像素。默认值为[20,0] 
		 * @return 
		 * 
		 */
		public function get swingY():Array
		{
			return _swingY;
		}

		public function set swingY(value:Array):void
		{
			_swingY = value;
		}
		/**
		 * 横向振幅分布比率的数组；有效值为 0 到 1，且必须是以0开始，以1结束，的递增数组。值 0 表示开始震动，1 表示震动结束。  
		 * <p>
		 * 默认值为[0,1] 
		 * @return 
		 * 
		 */
		public function get ratiosX():Array
		{
			return _ratiosX;
		}

		public function set ratiosX(value:Array):void
		{
			_ratiosX = value;
		}
		/**
		 * 横向振幅,单位像素。 默认值为[20,0] 
		 * @return 
		 * 
		 */ 
		public function get swingX():Array
		{
			return _swingX;
		}

		public function set swingX(value:Array):void
		{
			_swingX = value;
		}
		/**
		 * 目标 
		 * @return 
		 * 
		 */
		public function get target():DisplayObject
		{
			return _target;
		}

		public function set target(value:DisplayObject):void
		{
			_target = value;
			_startX = _target.x;
			_startY = _target.y;
		}


		public function GraphicShakeProEffect()
		{
			timer = new EnterFrameTimer(1000/StageRunner.getInstance().stage.frameRate);
			
		}
		
		public function play():void
		{
			_startTime = getTimer();
			_perShakeTimeStamp = getTimer();
			_currentSwingX = _swingX[0];
			_currentSwingY = _swingY[0];
			timer.onTimer = startHandler;
			timer.start();
		}
		
		public function stop():void
		{
			timer.stop();
			_target.x = _startX;
			_target.y = _startY;
		}
		
		private function startHandler():void
		{
			var passTime:int = getTimer()-_startTime;
			if(passTime >=_time)
			{
				_target.x = _startX;
				_target.y = _startY;
				finish();
				if(timer != null)
				{
					timer.onTimer = null;
					timer.stop();
				}
			}else
			{
				if(getTimer()-_perShakeTimeStamp>= 1000/_frequency)
				{
					_perShakeTimeStamp = getTimer();
					var currentRatio:Number = passTime/_time;
					var i:int = 0;
					var startRatios:Number;
					var endRatios:Number;
					var startSwing:Number;
					var endSwing:Number;
					
					for(i = 0;i<_ratiosX.length-1;i++)
					{
						if(currentRatio >= _ratiosX[i] && currentRatio<= _ratiosX[i+1])
						{
							startRatios = _ratiosX[i];
							endRatios = _ratiosX[i+1];
							startSwing = _swingX[i];
							endSwing = _swingX[i+1];
							break;
						}
					}
					if(currentRatio <= 1)
						_currentSwingX = ((currentRatio-startRatios)*(endSwing-startSwing))/(endRatios-startRatios)+startSwing;
					
					
					for(i = 0;i<_ratiosY.length-1;i++)
					{
						if(currentRatio >= _ratiosY[i] && currentRatio<= _ratiosY[i+1])
						{
							startRatios = _ratiosY[i];
							endRatios = _ratiosY[i+1];
							startSwing = _swingY[i];
							endSwing = _swingY[i+1];
							break;
						}
					}
					if(currentRatio <= 1)
						_currentSwingY = ((currentRatio-startRatios)*(endSwing-startSwing))/(endRatios-startRatios)+startSwing;
					
					_target.x = _startX + _currentSwingX*_currentDirection;
					_target.y = _startY + _currentSwingY*_currentDirection;
					
					_currentDirection*=-1;
				}
			}
		}
		
		
		private function finish():void	
		{
			stop();
			if(onComplete != null)
			{
				onComplete();
			}
		}
		
		
		public function dispose():void
		{
			ObjectPool.disposeObject(timer);
			timer = null;
			_target = null;
			onComplete = null;
			ObjectPool.disposeObject(_swingX);
			_swingX = null;
			ObjectPool.disposeObject(_swingY);
			_swingY = null;
			ObjectPool.disposeObject(_ratiosX);
			_ratiosX = null;
			ObjectPool.disposeObject(_ratiosY);
			_ratiosY = null;
		}
		
	}
}