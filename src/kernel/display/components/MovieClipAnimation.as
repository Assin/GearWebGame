package kernel.display.components
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import kernel.IDispose;
	import kernel.runner.StageRunner;
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	
	public class MovieClipAnimation extends Sprite implements IDispose
	{
		private var _mc:MovieClip;
		public var frameDataArr:Array = [];
		private var _timer:EnterFrameTimer;
		private var bitmap:Bitmap = new Bitmap();
		private static var NORMAL_PLAY_SPEED:int = -1;
		private var _frameSpeed:int;
		/**结束*/
		private var _reachFrameRecorder:int;
		//开始
		private var _startFrameRecorder:int;
		//当前帧
		private var _currentFrame:int;
		//循环次数
		private var _loopsRecorder:int;
		//循环播放完之后的回调函数
		public var onLoopComplete:Function;
		private var totalFrame:int;
		private var frame:int = 1;
		private var curr:int;
		
		public function MovieClipAnimation(mc:MovieClip, speed:int = -1)
		{
			this._mc = mc;
			NORMAL_PLAY_SPEED = (StageRunner.getInstance().stage == null) ? 30 : StageRunner.getInstance().stage.frameRate;
			frameSpeed = speed;
			this.addChild(bitmap);
			totalFrame = _mc.totalFrames
			this.addEventListener(Event.ENTER_FRAME, pushBitmapData);
		}
		
		private function pushBitmapData(e:Event):void
		{
			if (frame > totalFrame)
			{
				return ;
			}
			
			if (curr == frame || _mc == null)
			{
				return ;
			}
			
			curr = frame;
			_mc.gotoAndStop(frame);
			
			var bitData:BitmapData = new BitmapData(_mc.width, _mc.height, true, 0);
			bitData.draw(_mc);
			frameDataArr.push(bitData);
			
			if (frame == totalFrame)
			{
				this.dispatchEvent(new Event("playOK"))
			}
			frame++;
			
			
		}
		
		private function getMcFrameData():void
		{
			for (var i:int = 1; i <= _mc.totalFrames; i++)
			{
				_mc.gotoAndStop(i);
				var bitData:BitmapData = new BitmapData(_mc.width, _mc.height, true, 0);
				bitData.draw(_mc);
				frameDataArr.push(bitData);
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
		
		
		public function dispose():void
		{
			stop();
			
			if (_mc)
			{
				_mc.stop();
			}
			ObjectPool.disposeObject(frameDataArr);
			frameDataArr = null;
			ObjectPool.disposeObject(bitmap);
			bitmap = null;
			ObjectPool.disposeObject(_mc);
			_mc = null;
			ObjectPool.disposeObject(_timer);
			_timer = null;
			onLoopComplete = null;
			this.removeEventListener(Event.ENTER_FRAME, pushBitmapData);
		}
		
		/**
		 *  @param loop  循环次数
		 * @param start  开始播放
		 * @param end    结束播放
		 *
		 */
		private function playBetween(start:int, end:int, loop:int = -1):void
		{
			if (this._frameSpeed == 0 || loop == 0)
			{
				return ;
			}
			_startFrameRecorder = start;
			_reachFrameRecorder = end;
			_loopsRecorder = loop;
			_currentFrame = _startFrameRecorder;
			//播放
			this._timer.onTimer = onPlayFrame;
			this._timer.start();
		}
		
		
		/**
		 * 定时逐帧播放
		 * @param event
		 *
		 */
		private function onPlayFrame():void
		{
			
			if (this.frameDataArr.length == 0)
			{
				return ;
			}
			
			if (this._currentFrame > this._reachFrameRecorder)
			{
				this._currentFrame--;
			} else
			{
				this._currentFrame++;
			}
			this.bitmap.bitmapData = frameDataArr[_currentFrame - 1]
			
			if (this._currentFrame == this._reachFrameRecorder)
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
			
		}
		
		/**
		 * 从当前位置正序播放
		 *
		 */
		public function play():void
		{
			playBetween(1, this.frameDataArr.length);
		}
		
		/**
		 * 获取当前帧
		 * @return
		 *
		 */
		public function get currentFrame():int
		{
			return this._currentFrame;
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
		
		/**
		 * 定位到指定帧
		 * @param frame
		 *
		 */
		public function gotoAndStop(frame:Object):void
		{
			this.bitmap.bitmapData = frameDataArr[int(frame) - 1]
		}
		
	}
}

