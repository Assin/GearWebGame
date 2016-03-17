package kernel.display.components.scrollbar
{
	
	import flash.events.MouseEvent;
	import flash.utils.setTimeout;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.TwinkleUnit;
	import kernel.display.components.button.ImageButton;
	import kernel.display.components.tip.TipVO;
	import kernel.display.components.tip.members.TipMemberType;
	import kernel.events.ScrollEvent;
	import kernel.runner.LanguageRunner;
	import kernel.runner.StageRunner;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ObjectPool;
	
	import lang.LangType;
	
	
	public class ScrollBar extends BaseComponent
	{
		protected var _pageSize:int = 10;
		protected var _pageScrollSize:int = 0;
		protected var _lineScrollSize:Number = 1;
		protected var _minScrollPosition:int = 0;
		protected var _maxScrollPosition:int = 150;
		protected var _scrollPosition:int = 0;
		protected var _direction:String = ScrollBarDirection.VERTICAL;
		
		protected var _inDrag:Boolean;
		protected var _upArrow:ImageButton; //上箭头
		protected var _downArrow:ImageButton; //下箭头
		protected var _alwaysDownArrow:ImageButton; //始终保持在最低端的箭头
		protected var _block:ImageButton; //滚动条
		protected var _track:ImageButton; //滚动背景
		protected var _currentMouseY:int;
		
		protected var _width:int;
		protected var _height:int;
		protected var _blockTensible:Boolean = false;
		
		protected var _enabled:Boolean = true;
		
		override public function get width():Number
		{
			return _upArrow.width;
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			layoutButtons();
			drawBar();
		}
		
		/**
		 * 获取或设置滑块是否可根据需要进行拉伸
		 */
		public function get blockTensible():Boolean
		{
			return _blockTensible;
		}
		
		public function set blockTensible(value:Boolean):void
		{
			_blockTensible = value;
		}
		
		public function get scrollPosition():int
		{
			return _scrollPosition;
		}
		
		public function set scrollPosition(value:int):void
		{
			setScrollPosition(value, true);
		}
		
		public function get maxScrollPosition():int
		{
			return _maxScrollPosition;
		}
		
		public function set maxScrollPosition(value:int):void
		{
			setScrollProperties(_pageSize, _minScrollPosition, value);
		}
		
		public function get minScrollPosition():int
		{
			return _minScrollPosition;
		}
		
		public function set minScrollPosition(value:int):void
		{
			setScrollProperties(_pageSize, value, _maxScrollPosition);
		}
		
		public function get lineScrollSize():Number
		{
			return _lineScrollSize;
		}
		
		public function set lineScrollSize(value:Number):void
		{
			if (value > 0)
			{
				_lineScrollSize = value;
			}
		}
		
		public function set pageSize(value:int):void
		{
			_pageSize = Math.min(value, _maxScrollPosition - _minScrollPosition);
			drawBar();
		}
		
		private var _alwayDwon:Boolean;
		
		public function ScrollBar(id:int = 0, alwayDwon:Boolean = false)
		{
			super(id);
			_alwayDwon = alwayDwon;
			initButtons();
			layoutButtons();
			drawBar();
		}
		
		protected function initButtons():void
		{
			_blockTensible = UISkinRunner.scrollBarBlockTensible;
			
			_upArrow = new ImageButton(1);
			_upArrow.addEventListener(MouseEvent.MOUSE_DOWN, upArrowMouseDown_handler);
			_downArrow = new ImageButton(2);
			_downArrow.addEventListener(MouseEvent.MOUSE_DOWN, downArrowMouseDown_handler);
			_block = new ImageButton(3);
			_track = new ImageButton(4, trackClickHandler);
			var tipVO:TipVO;
			
			if (_alwayDwon == true)
			{
				_isAlwaysDown = true;
				_alwaysDownArrow = new ImageButton(5, onAlwaysDownHandler);
				_alwaysDownArrow.setImage(UISkinRunner.scrollBarAlwaysDown);
				this.addChild(_alwaysDownArrow);
				sharingUnit = new TwinkleUnit(_alwaysDownArrow);
				
				tipVO = new TipVO();
				tipVO.type = TipMemberType.TEXT;
				tipVO.data = LanguageRunner.getInstance().getLanguage(LangType.BUTTON_TIPS_5);
				_alwaysDownArrow.toolTip = tipVO;
			}
			
			tipVO = new TipVO();
			tipVO.type = TipMemberType.TEXT;
			tipVO.data = LanguageRunner.getInstance().getLanguage(LangType.BUTTON_TIPS_2);
			_downArrow.toolTip = tipVO;
			
			tipVO = new TipVO();
			tipVO.type = TipMemberType.TEXT;
			tipVO.data = LanguageRunner.getInstance().getLanguage(LangType.BUTTON_TIPS_1);
			_upArrow.toolTip = tipVO;
			
			_upArrow.setImage(UISkinRunner.scrollBarUpArrow);
			_downArrow.setImage(UISkinRunner.scrollBarDownArrow);
			_block.setImage(UISkinRunner.scrollBarBlock);
			
			_track.bitmapScale9GirdData = UISkinRunner.scrollBarTrack;
			addChild(_track);
			
			addChild(_block);
			addChild(_downArrow);
			addChild(_upArrow);
			
			_block.addEventListener(MouseEvent.MOUSE_DOWN, onBarDown);
			StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onStageUp);
			StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
		}
		
		private var downArrowMouseDown:Boolean = false;
		
		protected function downArrowMouseDown_handler(event:MouseEvent):void
		{
			downArrowMouseDown = true;
			down();
		}
		
		private function down():void
		{
			if (downArrowMouseDown == true)
			{
				_isAlwaysDown = false;
				setScrollPosition(_scrollPosition + _lineScrollSize);
				setTimeout(down, 50);
			}
		}
		private var upArrowMouseDown:Boolean = false;
		
		protected function upArrowMouseDown_handler(event:MouseEvent):void
		{
			upArrowMouseDown = true;
			up();
		}
		
		private function up():void
		{
			if (upArrowMouseDown == true)
			{
				_isAlwaysDown = false;
				setScrollPosition(_scrollPosition - _lineScrollSize);
				setTimeout(up, 50);
			}
		}
		
		protected function trackClickHandler(e:MouseEvent):void
		{
			var pos:Number = Math.max(0, Math.min(_track.height - _block.height, mouseY - _track.y - _currentMouseY));
			setScrollPosition(pos / (_track.height - _block.height) * (_maxScrollPosition - _minScrollPosition) + _minScrollPosition);
		}
		
		protected function layoutButtons():void
		{
			if (_alwayDwon == true)
			{
				_track.height = _height - _upArrow.height - _downArrow.height - _alwaysDownArrow.height + 1 ;
			} else
			{
				_track.height = _height - _upArrow.height - _downArrow.height + 1;
			}
			_track.x = _upArrow.x + _upArrow.width / 2 - _track.width / 2;
			_track.y = _upArrow.height - 1;
			_track.width = _block.width;
			_block.y = _upArrow.height;
			
			if (_alwayDwon == true)
			{
				_alwaysDownArrow.y = _height - _downArrow.height;
				_downArrow.y = _alwaysDownArrow.y - _downArrow.height;
			} else
			{
				_downArrow.y = _height - _downArrow.height;
			}
		}
		
		protected function onBarDown(event:MouseEvent):void
		{
			_currentMouseY = mouseY - _block.y;
			_inDrag = true;
		}
		
		protected function onStageMove(event:MouseEvent):void
		{
			if (_inDrag)
			{
				_isAlwaysDown = false;
				var pos:Number = Math.max(0, Math.min(_track.height - _block.height, mouseY - _track.y - _currentMouseY));
				setScrollPosition(pos / (_track.height - _block.height) * (_maxScrollPosition - _minScrollPosition) + _minScrollPosition);
			}
		}
		
		protected function onStageUp(event:MouseEvent):void
		{
			_inDrag = false;
			upArrowMouseDown = false;
			downArrowMouseDown = false;
			_currentMouseY = 0;
		}
		
		protected function drawBar():void
		{
			var scrollable:Number = _maxScrollPosition - _minScrollPosition;
			
			if (scrollable <= 0)
			{
				_block.visible = false;
				
			} else
			{
				if (_blockTensible)
				{
					_block.height = Math.max(8, _track.height * (_pageSize / (_pageSize + scrollable)));
				}
				_block.y = _track.y + (_track.height - _block.height) * ((_scrollPosition - _minScrollPosition) / scrollable);
				_block.visible = enabled;
				this.visible = enabled;
			}
		}
		
		
		
		private function onAlwaysDownHandler(event:MouseEvent):void
		{
			_isAlwaysDown = true;
			setScrollPosition(this.maxScrollPosition);
			sharingUnit.stop();
		}
		private var _isAlwaysDown:Boolean = false;
		
		public function update():void
		{
			if (_alwayDwon)
			{
				if (_isAlwaysDown == true)
				{
					setScrollPosition(this.maxScrollPosition);
					sharingUnit.stop();
				} else
				{
					setScrollPosition(scrollPosition);
					sharingUnit.start()
				}
			}
		}
		
		
		private var sharingUnit:TwinkleUnit;
		
		
		
		public function setScrollPosition(newScrollPosition:int, fireEvent:Boolean = true):void
		{
			if (newScrollPosition > maxScrollPosition)
				newScrollPosition = maxScrollPosition;
			
			if (newScrollPosition < minScrollPosition)
				newScrollPosition = minScrollPosition;
			
			var oldPosition:int = _scrollPosition;
			_scrollPosition = Math.min(Math.max(newScrollPosition, _minScrollPosition), _maxScrollPosition);
			
			if (fireEvent)
			{
				this.dispatchEvent(new ScrollEvent(_direction, _scrollPosition - oldPosition, _scrollPosition));
			}
			drawBar();
		}
		
		public function setScrollProperties(pageSize:int, minScrollPosition:int, maxScrollPosition:int, pageScrollSize:int = -1):void
		{
			// 如果传入的最大值不大于最小值，说明内容长度小于显示长度，需要将滚动条归位
			if (maxScrollPosition <= minScrollPosition)
			{
				maxScrollPosition = minScrollPosition;
				pageScrollSize = 0;
			}
			_pageSize = pageSize;
			_minScrollPosition = minScrollPosition;
			_maxScrollPosition = maxScrollPosition;
			
			if (pageScrollSize >= 0)
			{
				_pageScrollSize = pageScrollSize;
			} else
			{
				_pageScrollSize = _scrollPosition;
			}
			_enabled = (_maxScrollPosition > _minScrollPosition);
			setScrollPosition(_pageScrollSize);
			drawBar();
		}
		
		public function resetScrollPosition():void
		{
			setScrollPosition(0);
		}
		
		public function toggleTrack(value:Boolean):void
		{
			_track.visible = value;
		}
		
		override public function dispose():void
		{
			if (_block.hasEventListener(MouseEvent.MOUSE_DOWN))
			{
				_block.removeEventListener(MouseEvent.MOUSE_DOWN, onBarDown);
			}
			
			if (StageRunner.getInstance().stage.hasEventListener(MouseEvent.MOUSE_UP))
			{
				StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUp);
			}
			
			if (StageRunner.getInstance().stage.hasEventListener(MouseEvent.MOUSE_MOVE))
			{
				StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMove);
			}
			
			ObjectPool.disposeObject(_upArrow);
			_upArrow = null;
			ObjectPool.disposeObject(_downArrow);
			_downArrow = null;
			
			if (_alwaysDownArrow != null)
				ObjectPool.disposeObject(_alwaysDownArrow);
			_downArrow = null;
			ObjectPool.disposeObject(_block);
			_block = null;
			ObjectPool.disposeObject(_track);
			_track = null;
			
			super.dispose();
		}
	}
}