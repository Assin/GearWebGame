package kernel.display.components
{
	import flash.display.FrameLabel;
	import flash.display.MovieClip;
	
	import kernel.IDispose;
	import kernel.runner.StageRunner;
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * MovieClip控制类
	 * @author Administrator
	 *
	 */
	public class MovieClipProxy implements IDispose
	{
		private var _mc:MovieClip;
		private var _frameSpeed:int;
		private var _timer:EnterFrameTimer;
		private var _mcLabels:Array;
		private var _timeLine:MovieClipTimeLine;
		/**用于记录到达帧*/
		private var _reachFrameRecorder:int;
		private var _startFrameRecorder:int;
		private var _loopsRecorder:int;
		
		public function set mc(value:MovieClip):void
		{
			this._mc = value;
			this._mc.gotoAndStop(1);
			this._mcLabels = mc.currentLabels.concat();
			this._timeLine = new MovieClipTimeLine();
		}
		
		public var onLoopComplete:Function;
		private static var NORMAL_PLAY_SPEED:int = -1;
		
		/**
		 * MovieClip控制器
		 * @param mc 需操作的mc
		 * @param speed 播放速度
		 *
		 */
		public function MovieClipProxy(mc:MovieClip, speed:int = -1)
		{
			NORMAL_PLAY_SPEED = (StageRunner.getInstance().stage == null) ? 30 : StageRunner.getInstance().stage.frameRate;
			
			if (mc)
			{
				this._mc = mc;
				this._mc.gotoAndStop(1);
				this._mcLabels = mc.currentLabels.concat();
				this._timeLine = new MovieClipTimeLine();
			}
			frameSpeed = speed;
		}
		
		/**
		 * 从当前帧查找方法并回调
		 *
		 */
		private function findMethodsFromCurrent():void
		{
			this._timeLine.findMethodsFromFrame(this._mc.currentFrame);
		}
		
		/**
		 * 定位到指定帧
		 * @param frame
		 *
		 */
		public function gotoAndStop(frame:Object):void
		{
			this._mc.gotoAndStop(frame);
			findMethodsFromCurrent();
		}
		
		/**
		 * 从指定帧处开始播放
		 * @param frame
		 *
		 */
		public function gotoAndPlay(frame:Object):void
		{
			frame = labelToFrame(frame);
			playBetween(frame, this._mc.totalFrames);
		}
		
		/**
		 * 获取便签在所有便签数组中的索引
		 * @param str
		 * @return
		 *
		 */
		private function getLabelIndex(str:String):int
		{
			for (var i:int = 0; i < _mcLabels.length; i++)
			{
				if (this._mcLabels[i].name == str)
				{
					return this._mcLabels[i];
				}
			}
			return -1;
		}
		
		/**
		 * 从指定始位置播放到指定终位置
		 * @param startFrame 指定始位置
		 * @param reachFrame 指定终位置
		 * @param loops 播放次数,-1无限循环,0不播放,1播放1次。。。类推
		 * @param startCurrent 是否从当前的位置开始播放。
		 */
		public function playBetween(startFrame:Object, reachFrame:Object, loops:int = 1, startCurrent:Boolean = false):void
		{
			if (startFrame == null || reachFrame == null || this._frameSpeed == 0 || loops == 0)
			{
				return ;
			}
			//转换便签为帧
			startFrame = labelToFrame(startFrame);
			reachFrame = labelToFrame(reachFrame);
			//记录全局信息
			this._startFrameRecorder = int(startFrame);
			this._reachFrameRecorder = int(reachFrame);
			this._loopsRecorder = loops;
			
			if (this._mc)
			{
				//指针移到指定始位置
				if (startFrame != this._mc.currentFrame && !startCurrent)
				{
					this._mc.gotoAndStop(startFrame);
				}
				
				//播放
				this._timer.onTimer = onPlayFrame;
				this._timer.start();
			}
		}
		
		/**
		 * 定时逐帧播放
		 * @param event
		 *
		 */
		private function onPlayFrame():void
		{
			findMethodsFromCurrent();
			
			if (this._mc == null)
			{
				return ;
			}
			
			if (this._mc.currentFrame == this._reachFrameRecorder)
			{
				this._timer.stop();
				
				if (this._loopsRecorder == -1)
				{
					playBetween(this._startFrameRecorder, this._reachFrameRecorder, -1);
				} else if (this._loopsRecorder > 0)
				{
					this._loopsRecorder -= 1;
					playBetween(this._startFrameRecorder, this._reachFrameRecorder, this._loopsRecorder);
				}
				
				if (this._loopsRecorder == 0 && onLoopComplete != null)
				{
					onLoopComplete();
				}
				return ;
			}
			
			if (this._mc.currentFrame > this._reachFrameRecorder)
			{
				this._mc.prevFrame();
			} else
			{
				this._mc.nextFrame();
			}
		}
		
		/**
		 * 转变标签为帧
		 * @param value
		 * @return
		 *
		 */
		private function labelToFrame(value:Object):int
		{
			if (value is String)
			{
				var index:int = getLabelIndex(String(value));
				var frameNum:int;
				
				if (index != -1)
				{
					frameNum = (this._mcLabels[index]as FrameLabel).frame;
					return frameNum;
				}
				return 1;
			} else if (value is Number)
			{
				if (int(value) < 1)
				{
					return 1;
				}
				
				if (int(value) > this._mc.totalFrames)
				{
					return this._mc.totalFrames;
				}
				return int(value);
			} else
				return 1;
		}
		
		/**
		 * 从当前位置正序播放
		 *
		 */
		public function play():void
		{
			playBetween(this._mc.currentFrame, this._mc.totalFrames);
		}
		
		/**
		 * 暂停播放
		 *
		 */
		public function stop():void
		{
			if (this._timer)
			{
				this._timer.stop();
				this._timer.onTimer = null;
			}
		}
		
		/**每一帧播放速度, -1为默认速度*/
		public function set frameSpeed(value:int):void
		{
			if (value < -1)
			{
				value = -1;
			}
			_frameSpeed = value;
			
			if (value != -1)
			{
				_frameSpeed = 1000 / value;
			}
			ObjectPool.disposeObject(_timer);
			
			if (this._frameSpeed > 0)
			{
				this._timer = new EnterFrameTimer(this._frameSpeed);
			} else if (this._frameSpeed == -1)
			{
				this._timer = new EnterFrameTimer(1000 / NORMAL_PLAY_SPEED);
			}
		}
		
		/**
		 * 在指定帧位置添加方法
		 * @param frame
		 * @param fun
		 *
		 */
		public function addMethod(frame:Object, fun:Function):void
		{
			frame = labelToFrame(frame);
			this._timeLine.addMethod(int(frame), fun, this);
		}
		
		/**
		 * 从指定位置移除方法
		 * @param frame
		 * @param fun
		 *
		 */
		public function removeMethod(frame:Object, fun:Function):void
		{
			frame = labelToFrame(frame);
			this._timeLine.removeMethod(int(frame), fun);
		}
		
		/**
		 * 获取当前帧
		 * @return
		 *
		 */
		public function get currentFrame():int
		{
			return this._mc.currentFrame;
		}
		
		/**
		 * 取得它指向的mc
		 */
		public function get mc():MovieClip
		{
			return this._mc;
		}
		
		
		public function dispose():void
		{
			stop();
			
			if (_mc)
			{
				_mc.stop();
			}
			ObjectPool.disposeObject(_timer);
			ObjectPool.disposeObject(_timeLine);
			ObjectPool.disposeObject(_mcLabels);
			_mc = null;
			_timer = null;
			_timeLine = null;
			_mcLabels = null;
			onLoopComplete = null;
		}
		
	}
}