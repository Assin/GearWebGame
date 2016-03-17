package kernel.display.components.container
{
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.scrollbar.ScrollBar;
	import kernel.display.components.scrollbar.ScrollBarDirection;
	import kernel.events.ScrollEvent;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	
	public class ScrollPanel extends BaseComponent
	{
		public static const SCROLL_BAR_LEFT:String = "scrollBarLeft";
		public static const SCROLL_BAR_RIGHT:String = "scrollBarRight";
		
		protected var _contentScrollRect:Rectangle;
		protected var _contentWidth:int;
		protected var _contentHeight:int;
		protected var _availableHeight:int;
		protected var _availableWidth:int;
		protected var _height:int = 100;
		protected var _width:int = 100;
		
		/**手动设置显示的宽度**/
		protected var _showWidth:int = -1;
		
		protected var _contentPadding:int = 0;
		protected var _contentClip:Sprite;
		protected var _source:DisplayObject;
		/**鼠标响应区域 优化鼠标滚轮**/
		protected var _background:Sprite;
		private var _mouseContent:Sprite;
		protected var _verticalPageScrollSize:int = -1;
		
		protected var _vScrollBar:ScrollBar;
		private var _styleType:String;
		private var _contentScrollRectOffset:int = 0;
		private var _alwayDwon:Boolean;
		
		private var _scrollBarOffsetHeight:Number = 0;
		
		
		/**进度条，显示/隐藏的回调函数**/
		private var _scrollBarVisibleCallBack:Function;
		
		public function set scrollBarVisibleCallBack( value:Function ):void
		{
			this._scrollBarVisibleCallBack = value;
		}
		
		
		/**
		 *  滚动矩形范围的偏移量
		 */
		public function get contentScrollRectOffset():int
		{
			return _contentScrollRectOffset;
		}
		
		/**
		 * @private
		 */
		public function set contentScrollRectOffset(value:int):void
		{
			_contentScrollRectOffset = value;
		}
		
		
		public function get styleType():String
		{
			return _styleType;
		}
		
		public function set styleType(value:String):void
		{
			_styleType = value;
			
			if (_styleType == SCROLL_BAR_LEFT)
			{
				_vScrollBar.x = 0;
				_contentClip.x = _vScrollBar.width;
			} else if (_styleType == SCROLL_BAR_RIGHT)
			{
				_vScrollBar.x = width;
				_contentClip.x = 0;
			}
		}
		
		
		
		public function get vScrollBar():ScrollBar
		{
			return _vScrollBar;
		}
		
		public function set vScrollBar(value:ScrollBar):void
		{
			_vScrollBar = value;
		}
		
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			drawLayout();
			verticalScrollPosition = maxVerticalScrollPosition;
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			drawLayout();
		}
		
		public function set showWidth( value:Number ):void
		{
			this._showWidth = value;
			drawLayout();
		}
		
		
		public function get verticalScrollPosition():int
		{
			return _vScrollBar.scrollPosition;
		}
		
		public function set verticalScrollPosition(value:int):void
		{
			_vScrollBar.setScrollPosition(value);
		}
		
		public function get source():DisplayObject
		{
			return _source;
		}
		
		public function set source(value:DisplayObject):void
		{
			clear();
			_source = value;
			DisplayUtil.addChild(_source, _contentClip);
			update();
		}
		
		public function get verticalLineScrollSize():Number
		{
			return _vScrollBar.lineScrollSize;
		}
		
		public function set verticalLineScrollSize(value:Number):void
		{
			_vScrollBar.lineScrollSize = value;
		}
		
		public function get maxVerticalScrollPosition():int
		{
			return _vScrollBar.maxScrollPosition;
		}
		
		public function get minVerticalScrollPosition():int
		{
			return _vScrollBar.minScrollPosition;
		}
		
		public function ScrollPanel(alwayDwon:Boolean = false)
		{
			_alwayDwon = alwayDwon;
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			_mouseContent = new Sprite;
			_mouseContent.graphics.beginFill(0xffffff, 0);
			_mouseContent.graphics.drawRect(0,0,10,10);
			_mouseContent.graphics.endFill();
			addChild(_mouseContent);
			
			_contentClip = new Sprite();
			addChild(_contentClip);
			
			_vScrollBar = new ScrollBar(0, _alwayDwon);
			_vScrollBar.addEventListener(ScrollEvent.SCROLL, onScroll);
			addChild(_vScrollBar);
			_styleType = SCROLL_BAR_RIGHT;
			this.addEventListener(MouseEvent.MOUSE_WHEEL, wheelHandler);
		}
		
		protected function wheelHandler(event:MouseEvent):void
		{
			if (!_vScrollBar.visible)
				return ;
			_vScrollBar.scrollPosition -= (event.delta < 0 ? -1 : 1) * _vScrollBar.lineScrollSize;
			setVerticalScrollPosition(_vScrollBar.scrollPosition);
			dispatchEvent(new ScrollEvent(ScrollBarDirection.VERTICAL, event.delta, _vScrollBar.scrollPosition));
		}
		
		protected function onScroll(event:ScrollEvent):void
		{
			if (!_vScrollBar.visible)
				return ;
			setVerticalScrollPosition(event.position);
		}
		
		private function setContentSize(width:int, height:int):void
		{
			_contentWidth = width;
			_contentHeight = height;
		}
		
		
		/**
		 * 滚动条高度的增量， 用于使得滚动条多出来一段用的 ！！！！！！！！！
		 * @return
		 *
		 */
		public function get scrollBarOffsetHeight():Number
		{
			return _scrollBarOffsetHeight;
		}
		
		public function set scrollBarOffsetHeight(value:Number):void
		{
			_scrollBarOffsetHeight = value;
			update();
		}
		
		private var _scrollBarOffsetY:Number = 0;
		
		/**
		 *滚动条纵向位置的偏移量。配合 scrollBarOffsetHeight使用的！！！！！！！！！
		 * @return
		 *
		 */
		public function get scrollBarOffsetY():Number
		{
			return _scrollBarOffsetY;
		}
		
		public function set scrollBarOffsetY(value:Number):void
		{
			_scrollBarOffsetY = value;
			update();
		}
		
		
		private function drawLayout():void
		{
			calculateAvailableSize();
			resetBackground();
			
			if (_styleType == SCROLL_BAR_LEFT)
			{
				_vScrollBar.x = 0;
				_contentClip.x = _vScrollBar.width;
			} else if (_styleType == SCROLL_BAR_RIGHT)
			{
				_vScrollBar.x = width;
				_contentClip.x = 0;
			}
			
			_vScrollBar.height = _availableHeight + _scrollBarOffsetHeight;
			_vScrollBar.setScrollProperties(_availableHeight, 0, _contentHeight - _availableHeight, _verticalPageScrollSize);
			_vScrollBar.visible = (_contentHeight > _height);
			
			if( _scrollBarVisibleCallBack != null )
			{
				_scrollBarVisibleCallBack.call( this ,  _vScrollBar.visible);
			}
			
			_vScrollBar.y = _scrollBarOffsetY;
			var contentScrollRect:Rectangle;
			
			if (_contentClip.scrollRect)
			{
				contentScrollRect = _contentClip.scrollRect;
				contentScrollRect.height = _availableHeight;
				contentScrollRect.width = _availableWidth;
			} else
			{
				contentScrollRect = new Rectangle();
				contentScrollRect.x = 0;
				contentScrollRect.y = _contentScrollRectOffset;
				contentScrollRect.width = _availableWidth;
				contentScrollRect.height = _availableHeight - _contentScrollRectOffset;
			}
			_contentClip.scrollRect = contentScrollRect;
		}
		
		private function resetBackground():void
		{
			if (_background)
			{
				_background.width = width;
				_background.height = height;
			}
			
			if (_mouseContent)
			{
				_mouseContent.width = width;
				_mouseContent.height = height;
			}
		}
		
		private function calculateAvailableSize():void
		{
			
			if( _showWidth != -1 )
			{
				_availableWidth = _showWidth;
			}
			else
			{
				_availableWidth = width - 2 * _contentPadding;
			}
			
			_availableHeight = height - 2 * _contentPadding;
			
		}
		
		private function setVerticalScrollPosition(scrollPos:int):void
		{
			var contentScrollRect:Rectangle = _contentClip.scrollRect;
			
			if (contentScrollRect == null)
				return ;
			contentScrollRect.y = scrollPos + _contentScrollRectOffset;
			_contentClip.scrollRect = contentScrollRect;
		}
		
		public function setSource(value:DisplayObject):void
		{
			this.source = value;
		}
		
		public function update():void
		{
			
			if (_contentClip.numChildren > 0)
			{
				var child:DisplayObject = _contentClip.getChildAt(0);
				setContentSize(child.width, child.height);
			}
			drawLayout();
			_vScrollBar.update();
		}
		
		override public function clear():void
		{
			super.clear();
			DisplayUtil.removeAllChildren(_contentClip);
			_source = null;
			_vScrollBar.visible = false;
		}
		
		override public function dispose():void
		{
			if (_vScrollBar.hasEventListener(ScrollEvent.SCROLL))
			{
				_vScrollBar.removeEventListener(ScrollEvent.SCROLL, onScroll);
			}
			
			ObjectPool.disposeObject(_contentScrollRect);
			ObjectPool.disposeObject(_vScrollBar);
			ObjectPool.disposeObject(_source);
			ObjectPool.disposeObject(_contentClip);
			ObjectPool.disposeObject(_background);
			ObjectPool.disposeObject(_mouseContent);
			_contentScrollRect = null;
			_vScrollBar = null;
			_contentClip = null;
			_source = null;
			_background = null;
			_mouseContent = null;
			
			_scrollBarVisibleCallBack = null;
			
			super.dispose();
		}
	}
}