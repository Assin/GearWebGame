package kernel.display.components
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import kernel.utils.ObjectPool;
	
	/**
	 * 透明区域不响应鼠标事件
	 * @author Administrator
	 *
	 */
	public class InteractiveContainer extends MouseEffectiveComponent // Sprite implements IDispose
	{
		/**item列表*/
		private var _interactiveItemList:Vector.<IInteractiveItem>;
		/**当前item*/
		private var _interactiveItem:IInteractiveItem;
		/**用于判断非透明区域的滑入滑出*/
		protected var _bitmapHitList:Array = new Array();
		
		protected var _buttonModeCache:Number = NaN;
		
		public function get interactiveItemList():Vector.<IInteractiveItem>
		{
			return _interactiveItemList;
		}
		
		
		public function InteractiveContainer(id:int=0, data:*=null, clickHandler:Function=null)
		{
			super(id, data, clickHandler);
		}
		
		/**
		 * 添加检测元素
		 * @param item
		 *
		 */
		public function addItem(item:IInteractiveItem):void
		{
			this._interactiveItem = item;
			
			if (this._interactiveItemList == null)
			{
				this._interactiveItemList = new Vector.<IInteractiveItem>();
			}
			this._interactiveItemList.push(this._interactiveItem);
			enableInteractivePNG(this._interactiveItem as Sprite);
			_bitmapHitList.push(false);
		}
		
		/**
		 * 移除一个元素
		 * @param item
		 *
		 */
		public function removeItem(item:IInteractiveItem):void
		{
			var index:int = this._interactiveItemList.indexOf(item);
			
			if (index != -1)
			{
				deactivateMouseTrap(item as Sprite);
				this._interactiveItemList[index] = null;
				this._interactiveItemList.splice(index, 1);
				this._bitmapHitList.splice(index, 1);
			}
		}
		
		public function disableInteractivePNG(item:Sprite):void
		{
			deactivateMouseTrap(item);
			removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
			(this._interactiveItem as Sprite).mouseEnabled = true;
			setButtonModeCache(true);
		}
		
		public function enableInteractivePNG(item:Sprite):void
		{
			disableInteractivePNG(item);
			
			if (hitArea != null)
				return ;
			activateMouseTrap(item);
		}
		
		// -== Private Methods ==-
		
		
		protected function activateMouseTrap(item:Sprite):void
		{
			item.addEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent, false, 10000, true);
			item.addEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent, false, 10000, true);
			item.addEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent, false, 10000, true);
		}
		
		protected function deactivateMouseTrap(item:Sprite):void
		{
			item.removeEventListener(MouseEvent.MOUSE_OVER, captureMouseEvent);
			item.removeEventListener(MouseEvent.MOUSE_OUT, captureMouseEvent);
			item.removeEventListener(MouseEvent.MOUSE_MOVE, captureMouseEvent);
		}
		
		
		protected function captureMouseEvent(event : Event):void
		{
			if (event.type == MouseEvent.MOUSE_OVER)
			{
				// The buttonMode state is cached then disabled to avoid a cursor flicker
				// at the movieclip bounds. Reenabled when bitmap is hit.
				setButtonModeCache();
				event.target.mouseEnabled = false;
				
				if (!hasEventListener(Event.ENTER_FRAME))
				{
					addEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds, false, 10000, true); // activates bitmap hit & exit tracking
				}
				trackMouseWhileInBounds(); // important: Immediate response, and sets _bitmapHit to correct state for event suppression.
			}
			
			if (!_bitmapHitList[_interactiveItemList.indexOf(event.target as IInteractiveItem)])
			{
				event.stopImmediatePropagation();
			}
		}
		
		
		protected function trackMouseWhileInBounds(event:Event=null):void
		{
			var flag:Boolean = true;
			
			for (var i:int = 0; i < this._interactiveItemList.length; i++)
			{
				if (this._interactiveItemList[i].bitmapHitTest() != _bitmapHitList[i])
				{
					_bitmapHitList[i] = !_bitmapHitList[i];
					
					// Mouse is now on a nonclear pixel based on alphaTolerance. Reenable mouse events.
					if (_bitmapHitList[i])
					{
						deactivateMouseTrap(this._interactiveItemList[i]as Sprite);
						setButtonModeCache(true, true);
						(this._interactiveItemList[i]as Sprite).mouseEnabled = true; // This will trigger rollOver & mouseOver events
					}
						
						// Mouse is now on a clear pixel based on alphaTolerance. Disable mouse events but .
					else if (!_bitmapHitList[i])
					{
						(this._interactiveItemList[i]as Sprite).mouseEnabled = false; // This will trigger rollOut & mouseOut events
					}
				}
				
				// When mouse exits this MovieClip's bounds, end tracking & restore all.
				if (this._interactiveItemList[i].isOutBounds() == true)
				{
					setButtonModeCache(true);
					activateMouseTrap(this._interactiveItemList[i]as Sprite);
				} else
				{
					flag = false;
				}
			}
			
			if (flag) //不在任意item内(含透明)
			{
				removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
				
				for (var j:int = 0; j < this._interactiveItemList.length; j++)
				{
					(this._interactiveItemList[j]as Sprite).mouseEnabled = true;
				}
				
			}
		}
		
		protected function setButtonModeCache(restore:Boolean=false, retain:Boolean=false):void
		{
			if (restore)
			{
				if (_buttonModeCache == 1)
					buttonMode = true;
				
				if (!retain)
					_buttonModeCache = NaN;
				return ;
			}
			_buttonModeCache = (buttonMode == true ? 1 : 0);
			buttonMode = false;
		}
		
		override public function dispose():void
		{
			if (_interactiveItemList)
			{
				for (var i:int = 0; i < _interactiveItemList.length; i++)
				{
					if(_interactiveItemList[i])
					{
						deactivateMouseTrap(_interactiveItemList[i]as Sprite);
					}
				}
			}
			
			removeEventListener(Event.ENTER_FRAME, trackMouseWhileInBounds);
			ObjectPool.disposeObject(_interactiveItemList);
			_interactiveItemList = null;
			ObjectPool.disposeObject(_interactiveItem);
			_interactiveItem = null;
			ObjectPool.disposeObject(_bitmapHitList);
			_interactiveItemList = null;
			super.dispose();
		}
		
		//		public function get interactivePngActive() : Boolean {
		//			return _interactivePngActive;
		//		}
		
		// Excluded from documentation for simplicity, a note is provided under disableInteractivePNG.
		
		//		override public function set hitArea(value : Sprite) : void {
		//			if (value!=null && super.hitArea==null) {
		//				disableInteractivePNG();
		//			}
		//			else if (value==null && super.hitArea!=null) {
		//				enableInteractivePNG();
		//			}
		//			super.hitArea = value;
		//		}
		
		// Excluded from documentation for simplicity, a note is provided under disableInteractivePNG.
		
		//		override public function set mouseEnabled(enabled : Boolean) : void {
		//			if (isNaN(_buttonModeCache)==false) { // indicates that mouse has entered clip bounds.
		//				disableInteractivePNG();
		//			}
		//			super.mouseEnabled = enabled;
		//		}
		
	}
}