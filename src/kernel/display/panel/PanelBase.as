package kernel.display.panel
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import kernel.IDispose;
	import kernel.display.components.ILayoutable;
	import kernel.display.components.LayoutVO;
	import kernel.display.components.button.BaseButton;
	import kernel.display.components.button.ImageButton;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.runner.StageRunner;
	import kernel.utils.DisplayUtil;
	import kernel.utils.LayoutUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name 面板的基类
	 * @explain
	 * @author yanghongbin
	 * @create Dec 4, 2012 2:03:16 PM
	 */
	public class PanelBase extends Sprite implements IDispose, ILayoutable
	{
		protected var _initBehavior:IPanelInitBehavior;
		protected var _bgContainer:Sprite;
		protected var _imgBG:DisplayObject;
		protected var _txtTitle:TextFieldProxy;
		protected var _btnClose:BaseButton;
		protected var _btnHelp:BaseButton;
		
		protected var _panelID:int;
		protected var _title:String = "";
		protected var _width:Number = 0;
		protected var _height:Number = 0;
		protected var _draggable:Boolean = false;
		protected var _dragEnableObjects:Array = [];
		
		protected var _onClose:Function;
		
		private var _onClick:Function;
		
		private var _onOpenEffectComplete:Function;
		
		private var _onMouseDown:Function
		public function get onOpenEffectComplete():Function
		{
			return _onOpenEffectComplete;
		}
		
		public function set onOpenEffectComplete(value:Function):void
		{
			_onOpenEffectComplete = value;
		}
		
		public function get draggable():Boolean
		{
			return _draggable;
		}
		
		public function get imgBG():DisplayObject
		{
			return this._imgBG;
		}
		
		public function set draggable(value:Boolean):void
		{
			_draggable = value;
			
			if (this._draggable)
			{
				this._bgContainer.addEventListener(MouseEvent.CLICK, mouseClickHandler);
//				this._bgContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this._bgContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			} else
			{
				this._bgContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
//				this._bgContainer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this._bgContainer.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			}
		}
		
		
		public function get btnClose():BaseButton
		{
			return _btnClose;
		}
		
		public function get btnHelp():BaseButton
		{
			return _btnHelp;
		}
		
		
		public function get onClick():Function
		{
			return _onClick;
		}
		
		public function set onClick(value:Function):void
		{
			_onClick = value;
		}
		
		public function get onMouseDown():Function
		{
			return _onMouseDown;
		}
		
		public function set onMouseDown(value:Function):void
		{
			_onMouseDown = value;
		}
		
		
		public function PanelBase(panelID:int)
		{
			super();
			_panelID = panelID;
			init();
		}
		
		public function get onClose():Function
		{
			return _onClose;
		}
		
		public function set onClose(value:Function):void
		{
			_onClose = value;
		}
		
		/**
		 * 获取或设置面板宽度
		 */
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set width(value:Number):void
		{
			if (value <= 0)
				return ;
			_width = value;
			updateBasicLayout();
		}
		
		/**
		 * 获取或设置面板高度
		 */
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set height(value:Number):void
		{
			if (value <= 0)
				return ;
			_height = value;
			updateBasicLayout();
		}
		
		public function get panelID():int
		{
			return _panelID;
		}
		
		/**
		 * 获取或设置标题
		 */
		public function get title():String
		{
			return _title;
		}
		
		public function set title(value:String):void
		{
			_title = value;
			_txtTitle.text = (_title == null ? "" : _title);
			if(_title != null && _initBehavior != null)
			{
				_initBehavior.layoutTitle(_txtTitle);
			}
		}
		
		/**
		 * 初始化面板，在调用该方法前请先设置_initBehavior的值
		 */
		protected function init():void
		{
			if (_initBehavior == null)
				_initBehavior = new DefaultPanelInitBehavior(this);
			// 初始化UI
			initUI();
			// 初始化事件
			initListener();
		}
		
		protected function initUI():void
		{
			this._bgContainer = new Sprite();
			this.addChild(this._bgContainer);
			initBG();
			initTitle();
			
			// 初始化帮助按钮
			_btnHelp= new ImageButton();
			_btnHelp.visible=false;
			
			// 初始化关闭按钮
			_btnClose = new ImageButton();
			_btnClose.click = closeHandler;
			// 设置可以相应鼠标拖曳功能的对象
			_dragEnableObjects.push(this._bgContainer);
		}
		
		protected function initBG():void
		{
			_imgBG = createBG();
			_width = _imgBG.width;
			_height = _imgBG.height;
			this._bgContainer.addChild(_imgBG);
		}
		
		protected function initTitle():void
		{
			_txtTitle = new TextFieldProxy();
			_initBehavior.setTitleTextStyle(_txtTitle);
		}
		
		protected function initButtons():void
		{
			addChild(_txtTitle);
			//因为关闭按钮在所有面板UI的最上面，所以这么做。在编辑器中生成的类的构造里最后调用这个函数
			addChild(_btnClose);
			addChild(_btnHelp);
		}
		
		protected function initListener():void
		{
			this._bgContainer.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			if (this._draggable)
			{
				this._bgContainer.addEventListener(MouseEvent.CLICK, mouseClickHandler);
				this._bgContainer.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
				StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			}
		}
		
		private function mouseClickHandler(event:MouseEvent):void
		{
			if (this._draggable)
			{
				if (this.onClick != null)
				{
					this.onClick(this);
				}
			}
		}
		
		
		
		protected function mouseDownHandler(event:MouseEvent):void
		{
			
			if (this.onMouseDown != null)
			{
				this.onMouseDown(this);
			}
			
			if (_draggable)
			{
				var isOn:Boolean = false;
				var p:Point = new Point();
				p.x = event.stageX;
				p.y = event.stageY;
				
				for each (var obj:DisplayObject in _dragEnableObjects)
				{
					if (DisplayUtil.hitTestPoint(p, obj))
					{
						isOn = true;
						break;
					}
				}
				
				if (isOn)
				{
					var rect:Rectangle = new Rectangle();
					//郭鑫全屏：
					rect.top = StageRunner.getInstance().gameTopY;
					rect.left = StageRunner.getInstance().gameLeftX;
					rect.right = StageRunner.getInstance().gameRightX - this.width;
					rect.bottom = StageRunner.getInstance().gameBottomY - this.height;
					DisplayUtil.startDrag(this, false, rect);
				}
			}
		}
		
		protected function mouseUpHandler(event:MouseEvent):void
		{
			DisplayUtil.stopDrag(this);
		}
		
		private function onStageMouseUpHandler(e:MouseEvent):void
		{
			DisplayUtil.stopDrag(this);
		}
		
		protected function closeHandler(event:MouseEvent):void
		{
			_initBehavior.onCloseButtonClicked();
			this._onClose();
		}
		
		protected function createBG():DisplayObject
		{
			// 留给子类完善
			// 创建一个面板背景
			return null;
		}
		
		/**
		 * 调整面板基础UI的位置以适应新布局
		 */
		protected function updateBasicLayout():void
		{
			// 布局背景图
			_imgBG.width = _width;
			_imgBG.height = _height;
			
			// 布局标题文字框
			_txtTitle.text = (_title == null ? "" : _title);
			_initBehavior.layoutTitle(_txtTitle);
			
			// 布局关闭按钮
			_initBehavior.layoutCloseButton(_btnClose);
			// 布局帮助按钮
			_initBehavior.layoutHelpButton(_btnHelp);
			
		}
		
		/**
		 * 面板开启的动作
		 */
		protected function openBehavior(callBack:Function):void
		{
		}
		
		/**
		 * 面板关闭的动作
		 */
		protected function closeBehavior():void
		{
		}
		
		
		
		public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layoutContainer(this, layout);
		}
		
		/**
		 * 开启面板，该方法规定了面板开启时的行为
		 */
		public function open():void
		{
			openBehavior(this._onOpenEffectComplete);
		}
		
		
		
		/**
		 * 关闭面板，该方法规定了面板关闭时的行为
		 */
		public function close():void
		{
			closeBehavior();
		}
		
		public function dispose():void
		{
			if (this._bgContainer != null)
			{
				this._bgContainer.removeEventListener(MouseEvent.CLICK, mouseClickHandler);
				this._bgContainer.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
				this._bgContainer.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			}
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			ObjectPool.disposeObject(_initBehavior);
			_initBehavior = null;
			ObjectPool.disposeObject(this._bgContainer);
			this._bgContainer = null;
			ObjectPool.disposeObject(_imgBG);
			_imgBG = null;
			ObjectPool.disposeObject(_txtTitle);
			_txtTitle = null;
			ObjectPool.disposeObject(_btnHelp);
			_btnHelp = null;
			ObjectPool.disposeObject(_btnClose);
			_btnClose = null;
			_title = "";
			ObjectPool.disposeObject(_dragEnableObjects);
			_dragEnableObjects = null;
			_onClose = null;
			_onClick = null;
		}
	}
}