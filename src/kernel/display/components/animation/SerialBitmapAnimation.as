package kernel.display.components.animation
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import kernel.IDispose;
	import kernel.runner.ITick;
	import kernel.runner.StageRunner;
	import kernel.runner.TickRunner;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name 播放一张一张序列图片的位图动画类，继承自sprite
	 * @explain
	 * @author yanghongbin
	 * @create Dec 22, 2012 3:31:48 PM
	 */
	public class SerialBitmapAnimation extends Sprite implements IDispose, ITick
	{
		//位图动画层
		protected var _bitmapAnimationLayer:Sprite;
		/**
		 * 动画播放的层存储  存储bitmap
		 */
		protected var _animationBitmapLayerDict:Dictionary;
		/**
		 * 动画播放的位图信息存放，按照层来当key, 存放SerialAnimationBitmapData数组
		 */
		protected var _animationBitmapDataInfoDict:Dictionary;
		/**
		 * 上一帧显示的动画信息， 按照层来当key, 存放SerialAnimationBitmapData对象
		 */
		protected var _lastAnimationBitmapDataInfoDict:Dictionary;
		//帧速
		private var _frameRate:uint;
		//是否在播放中
		private var _isPlaying:Boolean;
		//当前播放的帧索引 
		private var _currentFrameIndex:int;
		//下一帧播放的帧索引 
		private var _nextFrameIndex:int;
		//总帧数
		private var _totalFrame:int;
		//是否反转动画
		private var _isRolled:Boolean;
		/**
		 * 是否循环播放
		 */
		public var cyclePlayRepeatCount:uint = 0;
		//当前的播放次数
		private var _currentPlayRepeatCount:uint = 0;
		
		//当播放完毕
		private var _onPlayComplete:Function;
		//是否停止到某一帧
		private var _isGotoAndStop:Boolean;
		//播放到某一帧，没有为-1
		private var _playToFrame:int = -1;
		private var _width:Number = 30;
		private var _height:Number = 50;
		private var _onPlayEnterFrame:Function;
		
		/**
		 * 当播放中进行的每帧回调
		 * @return
		 *
		 */
		public function get onPlayEnterFrame():Function
		{
			return _onPlayEnterFrame;
		}
		
		/**
		 * 当播放中进行的每帧回调
		 * @return
		 *
		 */
		public function set onPlayEnterFrame(value:Function):void
		{
			_onPlayEnterFrame = value;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		public function get bitmapAnimationLayer():Sprite
		{
			return _bitmapAnimationLayer;
		}
		
		/**
		 * 当播放完毕
		 */
		public function get onPlayComplete():Function
		{
			return _onPlayComplete;
		}
		
		/**
		 * @private
		 */
		public function set onPlayComplete(value:Function):void
		{
			_onPlayComplete = value;
		}
		
		
		public function SerialBitmapAnimation()
		{
			super();
			init();
		}
		
		/**
		 * 是否反转动画
		 * @return
		 *
		 */
		public function get isRolled():Boolean
		{
			return _isRolled;
		}
		
		/**
		 * 是否反转动画
		 *
		 */
		public function set isRolled(value:Boolean):void
		{
			_isRolled = value;
		}
		
		/**
		 * 总帧数
		 */
		public function get totalFrame():int
		{
			return _totalFrame;
		}
		
		/**
		 * @private
		 */
		public function set totalFrame(value:int):void
		{
			_totalFrame = value;
		}
		
		/**
		 * 下一帧播放的帧索引
		 */
		public function get nextFrameIndex():int
		{
			return (_currentFrameIndex < totalFrame - 1) ? _currentFrameIndex + 1 : 0;
		}
		
		/**
		 * 当前播放的帧索引
		 */
		public function get currentFrameIndex():int
		{
			return _currentFrameIndex;
		}
		
		/**
		 * @private
		 */
		public function set currentFrameIndex(value:int):void
		{
			_currentFrameIndex = value;
		}
		
		/**
		 * 是否在播放中
		 * @return
		 *
		 */
		public function get isPlaying():Boolean
		{
			return _isPlaying;
		}
		
		/**
		 * 帧速 ,每秒播放的帧数量
		 */
		public function get frameRate():uint
		{
			return (_frameRate == 0) ? StageRunner.getInstance().stage.frameRate : _frameRate;
		}
		
		/**
		 * @private
		 */
		public function set frameRate(value:uint):void
		{
			_frameRate = value;
		}
		
		public function init():void
		{
			_bitmapAnimationLayer = new Sprite();
			_bitmapAnimationLayer.mouseChildren = false;
			_bitmapAnimationLayer.mouseEnabled = false;
			addChild(_bitmapAnimationLayer);
			
			_animationBitmapLayerDict = new Dictionary();
			_animationBitmapDataInfoDict = new Dictionary();
			_lastAnimationBitmapDataInfoDict = new Dictionary();
		}
		
		protected function hasAnimationBitmapDataInfoByName(layerName:String):Boolean
		{
			if (_animationBitmapDataInfoDict[layerName] == null)
			{
				return false;
			} else
			{
				return true;
			}
		}
		
		/**
		 * 移出某个层的动画显示
		 * @param layerName
		 *
		 */
		protected function removeAnimationByLayer(layerName:String):void
		{
			if (layerName == "")
			{
				return ;
			}
			var bitmapsInfo:Vector.<SerialAnimationBitmapData> = _animationBitmapDataInfoDict[layerName]as Vector.<SerialAnimationBitmapData>;
			
			if (bitmapsInfo != null)
			{
				ObjectPool.disposeObject(bitmapsInfo);
			}
			_animationBitmapDataInfoDict[layerName] = null;
			delete _animationBitmapDataInfoDict[layerName];
			//重置一下这个层
			addLayer(layerName);
		}
		
		/**
		 * 添加层
		 * @param name
		 *
		 */
		protected function addLayer(name:String):void
		{
			if (name == "")
			{
				return ;
			}
			var bitmap:Bitmap = _animationBitmapLayerDict[name]as Bitmap;
			var childIndex:int = -1;
			
			if (bitmap != null)
			{
				childIndex = _bitmapAnimationLayer.getChildIndex(bitmap);
				DisplayUtil.removeChild(bitmap, _bitmapAnimationLayer);
				bitmap.bitmapData = null;
				ObjectPool.disposeObject(bitmap);
			}
			_animationBitmapLayerDict[name] = null;
			delete _animationBitmapLayerDict[name];
			
			_animationBitmapLayerDict[name] = new Bitmap();
			
			if (childIndex == -1)
			{
				childIndex = _bitmapAnimationLayer.numChildren;
			}
			_bitmapAnimationLayer.addChildAt(_animationBitmapLayerDict[name], childIndex);
		}
		
		/**
		 * 添加动画信息到一个层上
		 * @param layerName
		 * @param animationBitmapDatas
		 *
		 */
		protected function addAnimationBitmapDataToLayer(layerName:String, animationBitmapDatas:Vector.<SerialAnimationBitmapData>):void
		{
			if (layerName == "" || animationBitmapDatas == null)
			{
				return ;
			}
			_animationBitmapDataInfoDict[layerName] = animationBitmapDatas;
		}
		/**
		 * 清空所有层的显示 
		 * 
		 */		
		protected function clearAllLayerBitmapData():void
		{
			for (var dataLayerName:String in _animationBitmapDataInfoDict)
			{
				var bitmapdatasInfo:Vector.<SerialAnimationBitmapData> = _animationBitmapDataInfoDict[dataLayerName]as Vector.<SerialAnimationBitmapData>;
				for each(var sabd:SerialAnimationBitmapData in bitmapdatasInfo)
				{
					sabd.bitmapData = null;
				}
			}
			for (var bitmapLayer:String in _animationBitmapLayerDict)
			{
				var bitmap:Bitmap = _animationBitmapLayerDict[bitmapLayer];
				bitmap.bitmapData = null;
			}
		}
		
		/**
		 * 反转动画
		 *
		 */
		public function rollAnimation():void
		{
			for (var layerName:String in _animationBitmapLayerDict)
			{
				var bitmapdatasInfo:Vector.<SerialAnimationBitmapData> = _animationBitmapDataInfoDict[layerName]as Vector.<SerialAnimationBitmapData>;
				
				if (bitmapdatasInfo == null)
				{
					continue;
				}
				var bitmap:Bitmap = _animationBitmapLayerDict[layerName]as Bitmap;
				
				if (bitmap == null)
				{
					continue;
				}
				var bitmapdataInfo:SerialAnimationBitmapData = bitmapdatasInfo[_currentFrameIndex];
				
				if (_isRolled)
				{
					bitmap.x = bitmapdataInfo.offset.x;
					bitmap.scaleX = 1;
					bitmap.x = bitmapdataInfo.offset.x;
					_isRolled = false;
				} else
				{
					bitmap.x = 0;
					bitmap.scaleX = -1;
					bitmap.x = -bitmapdataInfo.offset.x;
					_isRolled = true;
				}
			}
			
		}
		
		
		/**
		 * 播放
		 * @param frameIndex 播放帧索引  默认从0开始
		 *
		 */
		public function play(frameIndex:int = 0):void
		{
			if (_isPlaying == false)
			{
				_isPlaying = true;
				_currentFrameIndex = frameIndex;
				_currentPlayRepeatCount = 0;
				_isGotoAndStop = false;
				_playToFrame = -1;
				resetLastAnimationBitmapDataInfoDict();
				TickRunner.getInstance().addTicker(this, 1000 / frameRate);
			}
		}
		
		/**
		 * 停止到某一帧
		 * @param frameIndex
		 *
		 */
		public function gotoAndStop(frameIndex:int):void
		{
			if (_isPlaying == false)
			{
				_isPlaying = true;
				_currentFrameIndex = frameIndex;
				_currentPlayRepeatCount = 0;
				_isGotoAndStop = true;
				_playToFrame = -1;
				resetLastAnimationBitmapDataInfoDict();
				TickRunner.getInstance().addTicker(this, 1000 / frameRate);
			}
		}
		
		/**
		 * 播放到某一帧
		 * @param startFrame
		 * @param toFrame
		 *
		 */
		public function playTo(startFrame:int, toFrame:int):void
		{
			if (_isPlaying == false)
			{
				_isPlaying = true;
				_currentFrameIndex = startFrame;
				_currentPlayRepeatCount = 0;
				_isGotoAndStop = false;
				_playToFrame = toFrame;
				resetLastAnimationBitmapDataInfoDict();
				TickRunner.getInstance().addTicker(this, 1000 / frameRate);
			}
		}
		
		public function onTick(delay:uint):void
		{
			if (_isPlaying == false)
			{
				return ;
			}
			refreshCurrentFrameBitmap();
		}
		
		/**
		 * 刷新当前帧图片 
		 * 
		 */		
		protected function refreshCurrentFrameBitmap():void
		{
			for (var layerName:String in _animationBitmapLayerDict)
			{
				var bitmapdatasInfo:Vector.<SerialAnimationBitmapData> = _animationBitmapDataInfoDict[layerName]as Vector.<SerialAnimationBitmapData>;
				
				if (bitmapdatasInfo == null)
				{
					continue;
				}
				var bitmap:Bitmap = _animationBitmapLayerDict[layerName]as Bitmap;
				
				if (bitmap == null)
				{
					continue;
				}
				
				//如果当前要播放的帧，超出了当前的位图序列总帧数，那么跳过，这种情况是，各个部位的动画帧数不一致导致
				if (_currentFrameIndex >= bitmapdatasInfo.length)
				{
					continue;
				}
				var bitmapdataInfo:SerialAnimationBitmapData = bitmapdatasInfo[_currentFrameIndex];
				
				//调用每帧的回调
				if (_onPlayEnterFrame != null)
				{
					_onPlayEnterFrame(bitmapdataInfo);
				}
				
				bitmap.x = bitmapdataInfo.offset.x;
				bitmap.y = bitmapdataInfo.offset.y;
				
				//判断下跟上一帧不一样，那么显示,如果本身就没有，说明是第一帧
				if (_lastAnimationBitmapDataInfoDict[layerName] == null || (_lastAnimationBitmapDataInfoDict[layerName] != null && _lastAnimationBitmapDataInfoDict[layerName].frameID != bitmapdataInfo.frameID))
				{
					if(bitmapdataInfo.bitmapData)
					{
						//如果不为空，再赋值
						bitmap.bitmapData = bitmapdataInfo.bitmapData;
					}
				}
				//设置当前的显示动画信息
				_lastAnimationBitmapDataInfoDict[layerName] = bitmapdataInfo;
				
				try
				{
					if (bitmapdataInfo.bitmapData)
					{
						width = bitmapdataInfo.bitmapData.width;
						height = bitmapdataInfo.bitmapData.height;
					}
				} catch (error:Error)
				{
					
				}
				
				if (_isRolled)
				{
					bitmap.scaleX = -1;
					bitmap.x = bitmapdataInfo.offset.x * -1;
				} else
				{
					bitmap.scaleX = 1;
				}
			}
			
			if (_playToFrame != -1 && _currentFrameIndex == _playToFrame)
			{
				pause();
				invokePlayCompleteCallBack();
				return ;
			}
			
			if (_currentFrameIndex == _totalFrame - 1)
			{
				if (_currentPlayRepeatCount < cyclePlayRepeatCount - 1 && cyclePlayRepeatCount > 0)
				{
					++_currentPlayRepeatCount;
				} else
				{
					if (_currentPlayRepeatCount == cyclePlayRepeatCount - 1 && cyclePlayRepeatCount > 0)
					{
						pause();
						invokePlayCompleteCallBack();
						return ;
					}
				}
			}
			
			if (_isGotoAndStop == false)
			{
				_currentFrameIndex = nextFrameIndex;
			}
		}
		
		/**
		 * 是否暂停  不会从主循环中移除
		 *
		 */
		public function pause():void
		{
			if (_isPlaying == true)
			{
				_isPlaying = false;
			}
		}
		
		/**
		 *  停止播放 会从主循环中移除
		 *
		 */
		public function stop():void
		{
			if (_isPlaying == true)
			{
				_isPlaying = false;
				TickRunner.getInstance().removeTicker(this);
			}
		}
		
		/**
		 * 调用播放完毕回调
		 *
		 */
		protected function invokePlayCompleteCallBack():void
		{
			if (_onPlayComplete != null)
			{
				_onPlayComplete();
			}
		}
		
		protected function resetLastAnimationBitmapDataInfoDict():void
		{
			for (var layerName:String in _lastAnimationBitmapDataInfoDict)
			{
				_lastAnimationBitmapDataInfoDict[layerName] = null;
				delete _lastAnimationBitmapDataInfoDict[layerName];
			}
			_lastAnimationBitmapDataInfoDict = new Dictionary();
		}
		
		public function dispose():void
		{
			TickRunner.getInstance().removeTicker(this);
			stop();
			
			for (var layerName:String in _animationBitmapLayerDict)
			{
				var bitmap:Bitmap = _animationBitmapLayerDict[layerName]as Bitmap;
				
				if (bitmap == null)
				{
					continue;
				}
				DisplayUtil.removeChild(bitmap, _bitmapAnimationLayer);
				bitmap.bitmapData = null;
			}
			ObjectPool.disposeObject(_animationBitmapLayerDict);
			_animationBitmapLayerDict = null;
			ObjectPool.disposeObject(_animationBitmapDataInfoDict);
			_animationBitmapDataInfoDict = null;
			ObjectPool.disposeObject(_lastAnimationBitmapDataInfoDict);
			_lastAnimationBitmapDataInfoDict = null;
			ObjectPool.disposeObject(_bitmapAnimationLayer);
			_bitmapAnimationLayer = null;
			
			_onPlayComplete = null;
			_onPlayEnterFrame = null;
		}
	}
}