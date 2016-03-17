package kernel.display.components
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.utils.Dictionary;
	
	import kernel.IDispose;
	import kernel.utils.ObjectPool;

	public class MovieClipTimeLine implements IDispose
	{
		private var _frameMethodsDic:Dictionary
		
		public function MovieClipTimeLine()
		{
		}

		/**
		 * 回调当前位置的所有方法
		 * @param event
		 * 
		 */		
		public function findMethodsFromFrame(currentFrame:int):void
		{
			if (_frameMethodsDic && _frameMethodsDic[currentFrame] != null) 
			{
				var cloneVec:Vector.<Function> = (_frameMethodsDic[currentFrame] as Vector.<Function>);
				if (cloneVec.length < 1) 
				{
					return;
				}
				for (var i:int = cloneVec.length; i > 0; i--) 
				{
					(cloneVec[i-1]as Function)(_mcProxy);
				}
			}
		}

		private var _mcProxy:MovieClipProxy;
		/**
		 * 在指定帧位置添加方法
		 * @param frame
		 * @param fun
		 * 
		 */		
		public function addMethod(frame:int, fun:Function , mcProxy:MovieClipProxy):void
		{
			_mcProxy = mcProxy;
			if (_frameMethodsDic == null) 
			{
				_frameMethodsDic = new Dictionary();
			}
			
			if (_frameMethodsDic[frame] == null) 
			{
				_frameMethodsDic[frame] = new Vector.<Function>();
				(_frameMethodsDic[frame] as Vector.<Function>).push(fun);
			}
			else if ((_frameMethodsDic[frame] as Vector.<Function>).indexOf(fun) < 0) 
			{
				(_frameMethodsDic[frame] as Vector.<Function>).unshift(fun);
			}
		}
		
		
		/**
		 * 从指定位置移除方法
		 * @param frame
		 * @param fun
		 * 
		 */		
		public function removeMethod(frame:int, fun:Function):void
		{
			if (_frameMethodsDic[frame] != null) 
			{
				var vec:Vector.<Function> = _frameMethodsDic[frame] as Vector.<Function>;
				var len:int = vec.length;
				for(var i:uint = 0; i < len; i++)
				{
					if(vec[i] == fun)
					{
						vec.splice(i,1);
						return;
					}
				}
			}
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_frameMethodsDic);
			_frameMethodsDic = null;
		}
		
	}
}