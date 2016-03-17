package kernel.display.components
{
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import kernel.IClear;
	import kernel.runner.StageRunner;
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * Dispatched when the AnimateBitmap is finished.
	 *
	 * @eventType flash.events.Event.COMPLETE
	 *
	 * @langversion ActionScript 3.0
	 * @playerversion Flash 9.0
	 */
	[Event(name="complete", type = "flash.events.Event")]
	
	/**
	 *
	 * 该类用来对序列帧图片进行解析并且生成一个动态图片（类似于GIF图片）。
	 * 可以控制动画的播放和停止。该类在生成新的BitmapData时会将原有的
	 * BitmapData彻底清除掉，因此在更改源图像的时候不会消耗更多的内存。
	 *
	 * 2010-3-26
	 * 现在该类可以支持随机或者固定时间间隔播放动画循环了，并且可以设置
	 * 循环完成后是否隐藏动画。并且该类可以从一张图片中读取多个动画，然
	 * 后使用索引分别播放。
	 *
	 * @author yanghongbin
	 *
	 */
	public class AnimateBitmap extends BitmapProxy implements IClear
	{
		protected var _timer:EnterFrameTimer;
		protected var _intervalTimer:EnterFrameTimer;
		
		protected var _cellArray:Array;
		protected var _index:int;
		protected var _bitmapData:BitmapData;
		protected var _cellWidth:Number;
		protected var _cellHeight:Number;
		protected var _fields:Array;
		protected var _frameRate:int;
		protected var _backward:Boolean;
		protected var _hideAfterEnd:Boolean;
		protected var _minInterval:int;
		protected var _maxInterval:int;
		
		protected var _currentField:int = 0;
		protected var _cycles:int = 0;
		protected var _leftCycles:int = 0;
		
		override public function set url(value:String):void
		{
			super.setURL(value);
			updateCellArray();
		}
		
		/**
		 * 获取或设置源图像的BitmapData，设置此属性会导致动画被重置
		 */
		override public function get bitmapData():BitmapData
		{
			return _bitmapData;
		}
		
		override public function set bitmapData(value:BitmapData):void
		{
			_bitmapData = value;
			updateCellArray();
		}
		
		/**
		 * 获取或设置动画显示区域的宽度
		 */
		public function get cellWidth():Number
		{
			return _cellWidth;
		}
		
		public function set cellWidth(value:Number):void
		{
			if (value <= 0)
				return ;
			_cellWidth = value;
			updateCellArray();
		}
		
		/**
		 * 获取或设置动画显示区域的高度
		 */
		public function get cellHeight():Number
		{
			return _cellHeight;
		}
		
		public function set cellHeight(value:Number):void
		{
			if (value <= 0)
				return ;
			_cellHeight = value;
			updateCellArray();
		}
		
		/**
		 * 获取或设置动画的帧频
		 */
		public function get frameRate():int
		{
			return _frameRate;
		}
		
		public function set frameRate(value:int):void
		{
			_frameRate = value;
			updateTimer();
		}
		
		/**
		 * 获取或设置动画的延迟时间，以毫秒记
		 */
		public function get delay():Number
		{
			return (1000 / _frameRate);
		}
		
		public function set delay(value:Number):void
		{
			_frameRate = int(1000 / value);
			updateTimer();
		}
		
		/**
		 * 获取或设置动画播放方向，为true时动画将从末尾向开头播放
		 */
		public function get backward():Boolean
		{
			return _backward;
		}
		
		public function set backward(value:Boolean):void
		{
			_backward = value;
		}
		
		/**
		 * 获取动画是否在播放
		 */
		public function get playing():Boolean
		{
			return _timer.running;
		}
		
		/**
		 * 获取或设置当前的小动画序号
		 */
		public function get currentField():int
		{
			return _currentField;
		}
		
		public function set currentField(value:int):void
		{
			if (value >= 0 && value < _fields.length)
			{
				_currentField = value;
			}
		}
		
		/**
		 * 获取或设置小动画列表
		 */
		public function get fields():Array
		{
			return _fields;
		}
		
		public function set fields(value:Array):void
		{
			_fields = value;
			_currentField = 0;
			reset();
		}
		
		/**
		 * 获取或设置总共的循环次数
		 */
		public function get cycles():int
		{
			return _cycles;
		}
		
		public function set cycles(value:int):void
		{
			_cycles = (value < 0 ? 0 : value);
			resetLeftCycles();
		}
		
		/**
		 * 获取剩余循环次数
		 */
		public function get leftCycles():int
		{
			return _leftCycles;
		}
		
		/**
		 * 获取或设置是否在动画完成后隐藏动画
		 */
		public function get hideAfterEnd():Boolean
		{
			return _hideAfterEnd;
		}
		
		public function set hideAfterEnd(value:Boolean):void
		{
			_hideAfterEnd = value;
		}
		
		/**
		 * 获取或设置循环间隔时间的毫秒最小值
		 */
		public function get minInterval():int
		{
			return _minInterval;
		}
		
		public function set minInterval(value:int):void
		{
			_minInterval = value < 0 ? 0 : value;
		}
		
		/**
		 * 获取或设置循环间隔时间的毫秒最大值
		 */
		public function get maxInterval():int
		{
			return _maxInterval;
		}
		
		public function set maxInterval(value:int):void
		{
			_maxInterval = value < 0 ? 0 : value;
		}
		
		/**
		 * 构造方法
		 * @param bitmapData 源图像的BitmapData
		 * @param cellWidth 元件宽度
		 * @param cellHeight 元件高度
		 * @param fields 小动画列表。可将一张图片分为若干个动画，小动画列表中的数字用来表示每个小动画在帧列表中的位置和帧数
		 * @param cycles 动画循环次数
		 * @param backward 表示动画是否反向播放
		 * @param frameRate 帧频
		 * @param hideAfterEnd 表示是否在动画播放完成时隐藏动画
		 * @param minInterval 动画循环时间间隔毫秒最小值，动画将在minInterval和maxInterval之间产生随机时间间隔
		 * @param maxInterval 动画循环时间间隔毫秒最大值，动画将在minInterval和maxInterval之间产生随机时间间隔
		 */
		public function AnimateBitmap(url:String = null, bitmapData:BitmapData = null, cellWidth:Number = 0, cellHeight:Number = 0,
									  fields:Array = null, cycles:int = 0, backward:Boolean = false, frameRate:int = -1,
									  hideAfterEnd:Boolean = false, minInterval:int = 0, maxInterval:int = 0)
		{
			_cellWidth = cellWidth;
			_cellHeight = cellHeight;
			_fields = (fields == null ? [] : fields);
			this.cycles = cycles;
			_backward = backward;
			_frameRate = (frameRate <= 0 ? StageRunner.getInstance().stage.frameRate : frameRate);
			_hideAfterEnd = hideAfterEnd;
			_minInterval = (minInterval < 0 ? 0 : minInterval);
			_maxInterval = (maxInterval < 0 ? 0 : maxInterval);
			
			init();
			
			if (url != null)
				this.url = url;
			if (bitmapData != null)
				this.bitmapData = bitmapData;
			
			super();
		}
		
		protected function init():void
		{
			initCellArray();
			initTimer();
		}
		
		protected function initTimer():void
		{
			_timer = new EnterFrameTimer(delay);
			_timer.onTimer = timerHandler;
			
			_intervalTimer = new EnterFrameTimer(delay);
			_intervalTimer.repeatCount = 1;
			_intervalTimer.onComplete = intervalTimerCompleteHandler;
		}
		
		protected function initCellArray():void
		{
			_cellArray = [];
			updateCellArray();
		}
		
		protected function timerHandler():void
		{
			var cycleComplete:Boolean = false;
			var arr:Array = getField(_currentField);
			if (arr.length <= 1)
				return ;
			super.bitmapData = arr[_index];
			if (_backward)
			{
				_index = (_index + arr.length - 1) % arr.length;
				if (_index == arr.length - 1)
					cycleComplete = true;
			} else
			{
				_index = (_index + 1) % arr.length;
				if (_index == 0)
					cycleComplete = true;
			}
			// 如果完成一个周期并且循环周期次数有限并且剩余周期次数不为0
			if (cycleComplete && _cycles > 0 && _leftCycles > 0)
			{
				_leftCycles--;
				if (_leftCycles <= 0)
				{
					stop();
					_leftCycles = _cycles;
					// 动画完成，触发事件
					this.dispatchEvent(new Event(Event.COMPLETE));
				}
			}
			// 如果周期完成并且hideAfterEnd属性为true，则隐藏动画
			if (cycleComplete && _hideAfterEnd)
				super.bitmapData = null;
			// 如果周期完成且动画没有完成并且循环延时不为0，则计算出延时并且设置延时响应
			if (cycleComplete && playing && (_minInterval + _maxInterval > 0))
			{
				stop();
				if (_maxInterval < _minInterval)
				{
					var t:Number = _maxInterval;
					_maxInterval = _minInterval;
					_minInterval = t;
				}
				if (_minInterval == _maxInterval)
				{
					_intervalTimer.delay = _minInterval;
				} else
				{
					var interval:int = Math.floor(Math.random() * (_maxInterval - _minInterval)) + _minInterval;
					_intervalTimer.delay = interval;
				}
				_intervalTimer.start();
			}
		}
		
		protected function intervalTimerCompleteHandler():void
		{
			play();
		}
		
		protected function resetLeftCycles():void
		{
			_leftCycles = _cycles;
		}
		
		protected function getField(fieldIndex:int):Array
		{
			var begin:int;
			var end:int;
			
			// 如果前提条件不符合则返回空数组
			if (_cellArray == null || _cellArray.length <= 0 || fieldIndex < 0 || (_fields.length > 0 && fieldIndex > _fields.length -
				1))
			{
				return [];
			}
			// 确定动画帧序列的开始和结尾
			if (_fields == null || _fields.length <= 0)
			{
				// 如果没有定义则返回整个动画帧序列
				begin = 0;
				end = _cellArray.length;
			} else
			{
				// 确定开头序号（包含该项）
				var temp:int = 0;
				for (var i:int = 0; i < fieldIndex; i++)
				{
					temp += _fields[i];
				}
				begin = temp > _cellArray.length - 1 ? _cellArray.length - 1 : temp;
				// 确定结尾序号（不包含该项）
				temp += _fields[fieldIndex];
				end = temp > _cellArray.length ? _cellArray.length : temp;
			}
			
			return _cellArray.slice(begin, end);
		}
		
		protected function updateTimer():void
		{
			_timer.delay = delay;
		}
		
		protected function updateCellArray():void
		{
			if (_bitmapData == null)
				return ;
			var numHorizon:int = int(_bitmapData.width / _cellWidth);
			var numVerticle:int = int(_bitmapData.height / _cellHeight);
			var rect:Rectangle = new Rectangle(0, 0, _cellWidth, _cellHeight);
			var point:Point = new Point(0, 0);
			
			// 遍历数组释放数组中的BitmapData
			while (_cellArray.length > 0)
			{
				BitmapData(_cellArray[0]).dispose();
				_cellArray.shift();
			}
			// 根据源图像分离各帧的图像存入数组
			for (var i:int = 0; i < numVerticle; i++)
			{
				for (var j:int = 0; j < numHorizon; j++)
				{
					var bd:BitmapData = new BitmapData(_cellWidth, _cellHeight, true, 0);
					rect.x = j * cellWidth;
					rect.y = i * cellHeight;
					bd.copyPixels(_bitmapData, rect, point, null, null, true);
					_cellArray.push(bd);
				}
			}
			// 将剩余循环次数重置
			resetLeftCycles();
			// 将帧头重置
			reset();
		}
		
		/**
		 * 开始播放动画
		 */
		public function play():void
		{
			if (!_timer.running)
				_timer.start();
		}
		
		/**
		 * 暂停动画，不重置动画
		 */
		public function pause():void
		{
			if (_timer.running)
				_timer.stop();
		}
		
		/**
		 * 停止动画，并且重置动画到第一帧位置
		 */
		public function stop():void
		{
			if (_timer.running)
				_timer.stop();
			reset();
		}
		
		/**
		 * 返回动画的开头或末尾（根据backward属性而定），不改变动画的播放状态
		 */
		public function reset():void
		{
			var arr:Array = getField(_currentField);
			_index = _backward ? (arr.length - 1) : 0;
			super.bitmapData = _hideAfterEnd ? null : arr[_index];
		}
		
		/**
		 * 清除资源，停止动画，并恢复初始状态
		 */
		override public function clear():void
		{
			_timer.stop();
			_intervalTimer.stop();
			_cellArray.splice(0, _cellArray.length);
			_fields.splice(0, _fields.length);
			_bitmapData = null;
			_backward = false;
			_hideAfterEnd = false;
			_index = 0;
			_cellWidth = 0;
			_cellHeight = 0;
			_frameRate = 0;
			_currentField = 0;
			_cycles = 0;
			_leftCycles = 0;
			_minInterval = 0;
			_maxInterval = 0;
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_timer);
			_timer = null;
			ObjectPool.disposeObject(_intervalTimer);
			_intervalTimer = null;
			ObjectPool.disposeObject(_cellArray);
			_cellArray = null;
			ObjectPool.disposeObject(_bitmapData);
			_bitmapData = null;
			ObjectPool.disposeObject(_fields);
			_fields = null;
			
			super.dispose();
		}
	}
}