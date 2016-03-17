package kernel.display.components
{
	import flash.events.MouseEvent;
	
	import kernel.display.components.behaviors.DefaultComponentMouseEffectBehavior;
	import kernel.display.components.behaviors.IComponentMouseEffectBehavior;
	import kernel.display.components.drag.DragGroup;
	import kernel.display.components.tip.IShowTip;
	import kernel.display.components.tip.TipRunner;
	import kernel.display.components.tip.TipVO;
	import kernel.runner.StageRunner;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：MouseEffectiveComponent.as
	 * <p>
	 * 功能：此类使组件可以响应鼠标事件，例如鼠标滑过、单击等。此类不可实例化。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public class MouseEffectiveComponent extends BaseComponent implements IShowTip, IMouseEventBehaviour
	{
		//tips当前状态，显示为true，隐藏为false		
		private var _tipState:Boolean = false;
		
		/**
		 * 表示是否具有鼠标徘徊Tip，即鼠标悬停时显示Tip，否则隐藏Tip，默认显示鼠标徘徊Tip
		 */
		protected var _hasHoverTip:Boolean = true;
		/**
		 * 表示该Tip显示时是否随鼠标移动而移动，默认跟随鼠标移动
		 */
		protected var _isDragTip:Boolean = true;
		/**
		 * 表示组件是否具有鼠标响应操作
		 */
		protected var _hasMouseEffect:Boolean = true;
		
		protected var _mouseEffectBehavior:IComponentMouseEffectBehavior;
		
		protected var _clickHandler:Function;
		
		protected var _doubleClickHandler:Function;
		
		protected var _toolTip:* = null;
		//鼠标是否可点击
		protected var _mouseClickable:Boolean = true;
		//是否可以移入
		protected var _mouseOverable:Boolean;
		//是否可以移出
		protected var _mouseOutable:Boolean;
		//是否可移动
		protected var _mouseMovable:Boolean;
		//使用双击
		protected var _useDoubleClick:Boolean;
		//鼠标是否移到到上面。
		protected var _isMouseOver:Boolean;
		//鼠标是否按下
		protected var _isButtonDown:Boolean;
		
		protected var mouseStageX:Number = 0;
		
		protected var mouseStageY:Number = 0;
		//原始的Y值
		protected var _oldY:Number = -1;
		/**
		 * 是否包含鼠标按下效果 
		 */		
		public var hasMouseDownEffect:Boolean = true; 
		/**
		 * 鼠标是否按下
		 * @return
		 *
		 */
		public function get isButtonDown():Boolean
		{
			return _isButtonDown;
		}
		
		override public function set y(value:Number):void
		{
			super.y = value;
			this._oldY = value;
		}
		
		public function get $superY():Number
		{
			return super.y;
		}
		
		public function set $superY(value:Number):void
		{
			super.y = value;
		}
		
		/**
		 * 本身的Y值，按下后不会改变这个
		 * @return
		 *
		 */
		public function get oldY():Number
		{
			return _oldY;
		}
		
		/**
		 * 本身的Y值，按下后不会改变这个
		 * @return
		 *
		 */
		public function set oldY(value:Number):void
		{
			_oldY = value;
		}
		
		/**
		 * 是否使用双击
		 * @param value
		 *
		 */
		public function get useDoubleClick():Boolean
		{
			return _useDoubleClick;
		}
		
		/**
		 * 是否使用双击
		 * @param value
		 *
		 */
		public function set useDoubleClick(value:Boolean):void
		{
			_useDoubleClick = value;
			this.doubleClickEnabled = value;
			
			if (value)
			{
				this.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickHandler);
			} else
			{
				this.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickHandler);
			}
		}
		
		
		public function get tipState():Boolean
		{
			return this._tipState;
		}
		
		/**
		 * 获取或设置一个布尔值，表示是否具有徘徊Tip
		 */
		public function get hasHoverTip():Boolean
		{
			return _hasHoverTip;
		}
		
		public function set hasHoverTip(value:Boolean):void
		{
			_hasHoverTip = value;
		}
		
		/**
		 * 获取或设置一个布尔值，表示徘徊Tip是否可以跟随鼠标移动
		 */
		public function get isDragTip():Boolean
		{
			return _isDragTip;
		}
		
		public function set isDragTip(value:Boolean):void
		{
			_isDragTip = value;
		}
		
		/**
		 * 获取或设置组件是否具有鼠标响应操作
		 */
		public function get hasMouseEffect():Boolean
		{
			return _hasMouseEffect;
		}
		
		public function set hasMouseEffect(value:Boolean):void
		{
			_hasMouseEffect = value;
		}
		
		/**
		 * 获取或设置Tip数据信息
		 */
		public function get toolTip():*
		{
			return _toolTip;
		}
		
		public function set toolTip(value:*):void
		{
			if (_toolTip is TipVO)
				ObjectPool.disposeObject(_toolTip);
			_toolTip = value;
		}
		
		/**
		 * 设置点击响应回调方法
		 */
		public function set click(value:Function):void
		{
			_clickHandler = value;
		}
		
		/**
		 * 设置双击响应回调方法
		 */
		public function set doubleClick(value:Function):void
		{
			this._doubleClickHandler = value;
		}
		
		/**
		 * 设置鼠标响应算法族
		 */
		public function set mouseEffectBehavior(value:IComponentMouseEffectBehavior):void
		{
			_mouseEffectBehavior = value;
		}
		
		/**
		 * 实例化MouseEffectiveComponent类
		 * @param id 标识符，可用于区分不同组件
		 * @param data 可记录任意信息的对象
		 * @param clickHandler 鼠标单击相应方法
		 */
		public function MouseEffectiveComponent(id:int = 0, data:* = null, clickHandler:Function = null)
		{
			_clickHandler = clickHandler;
			super(id, data);
		}
		
		override protected function init():void
		{
			super.init();
			
			if (_mouseEffectBehavior == null)
				_mouseEffectBehavior = new DefaultComponentMouseEffectBehavior();
		}
		
		override protected function initListener():void
		{
			super.initListener();
			
			this.addEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
			this.addEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			this.addEventListener(MouseEvent.CLICK, clickPrepareHandler);
			StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
		}
		
		/**
		 * 鼠标移入事件响应
		 */
		protected function mouseOverHandler(event:MouseEvent):void
		{
			if (this.enabled && _hasMouseEffect)
			{
				if (event != null)
				{
					_isButtonDown = event.buttonDown;
				}
				_mouseEffectBehavior.onMouseOver(this);
				_isMouseOver = true;
			}
			
			if (hasHoverTip && !DragGroup.haveDragging)
			{
				var tipValue:* = getTipValue(event.stageX, event.stageY);
				mouseStageX = event.stageX;
				mouseStageY = event.stageY;
				
				if (tipValue != null)
				{
					TipRunner.getInstance().showTip(tipValue,isDragTip,this);
					_tipState = true;
					if (isDragTip)
						TipRunner.getInstance().startDrag();
				}
			}
		}
		
		/**
		 *手动更新tips
		 * <p>
		 * lyj
		 */
		public function updateTips():void
		{
			var tmpState:Boolean = _tipState;
			mouseOutHandler(null);
	
			if (hasHoverTip && !DragGroup.haveDragging)
			{
				var tipValue:* = getTipValue(mouseStageX, mouseStageY);
				
				if (tipValue != null)
				{
					//如果更新之前tip是显示状态，则更新之后，依旧显示
					if(tmpState == true )
					{
						TipRunner.getInstance().showTip(tipValue,isDragTip,this);
						_tipState = true;
					}
					
					if (isDragTip)
						TipRunner.getInstance().startDrag();
				}
			}
		}
		
		
		/**
		 * 鼠标移出事件响应
		 */
		protected function mouseOutHandler(event:MouseEvent):void
		{
			if (this.enabled && _hasMouseEffect)
			{
				if (event != null)
				{
					_isButtonDown = event.buttonDown;
				}
				_mouseEffectBehavior.onMouseOut(this);
				_isMouseOver = false;
			}
			
			if (hasHoverTip)
			{
				TipRunner.getInstance().hideTip();
				_tipState = false;
			}
		}
		
		/**
		 * 鼠标按下事件响应
		 */
		protected function mouseDownHandler(event:MouseEvent):void
		{
			if (this.enabled && _hasMouseEffect)
			{
				if (event != null)
				{
					_isButtonDown = event.buttonDown;
				}
				_mouseEffectBehavior.onMouseDown(this);
			}
		}
		
		/**
		 * 鼠标抬起事件响应，此响应是全局响应的
		 */
		protected function mouseUpHandler(event:MouseEvent):void
		{
			if (this.enabled && _hasMouseEffect)
			{
				if (event != null)
				{
					_isButtonDown = event.buttonDown;
				}
				_mouseEffectBehavior.onMouseUp(this, (event.target == this));
			}
		}
		
		private function clickPrepareHandler(event:MouseEvent):void
		{
			if (this.enabled && this.mouseClickable)
			{
				clickHandler(event);
			}
		}
		
		/**
		 * 鼠标单击事件响应
		 */
		protected function clickHandler(event:MouseEvent):void
		{
			if (_hasMouseEffect)
			{
				_mouseEffectBehavior.onClick(this);
			}
			
			if (_clickHandler != null)
			{
				_clickHandler(event);
			}
		}
		
		/**
		 * 双击操作
		 * @param e
		 *
		 */
		protected function onDoubleClickHandler(e:MouseEvent):void
		{
			if (this._doubleClickHandler != null)
			{
				this._doubleClickHandler(e);
			}
		}
		
		public function getTipValue(x:Number, y:Number):*
		{
			return this.toolTip;
		}
		
		public function set mouseClickable(value:Boolean):void
		{
			this._mouseClickable = value;
		}
		
		public function get mouseClickable():Boolean
		{
			return this._mouseClickable;
		}
		
		public function set mouseMovable(value:Boolean):void
		{
			this._mouseMovable = value;
		}
		
		public function get mouseMovable():Boolean
		{
			return this._mouseMovable;
		}
		
		public function set mouseOutable(value:Boolean):void
		{
			this._mouseOutable = value;
		}
		
		public function get mouseOutable():Boolean
		{
			return this._mouseOutable;
		}
		
		public function set mouseOverable(value:Boolean):void
		{
			this._mouseOverable = value;
		}
		
		public function get mouseOverable():Boolean
		{
			return this._mouseOverable;
		}
		
		public function onMouseClick():void
		{
		}
		
		public function onMouseDown():void
		{
		}
		
		public function onMouseMove():void
		{
		}
		
		public function onMouseOut():void
		{
		}
		
		public function onMouseOver():void
		{
		}
		
		public function onMouseUp():void
		{
			
		}
		
		override public function clear():void
		{
			super.clear();
		}
		
		override public function dispose():void
		{
			if (TipRunner.getInstance().currentTipOwner != null && TipRunner.getInstance().currentTipOwner == this)
			{
				TipRunner.getInstance().hideTip();
				_tipState = false;
			}
			
			_mouseEffectBehavior = null;
			this.removeEventListener(MouseEvent.ROLL_OVER, mouseOverHandler);
			this.removeEventListener(MouseEvent.ROLL_OUT, mouseOutHandler);
			this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDownHandler);
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUpHandler);
			this.removeEventListener(MouseEvent.CLICK, clickPrepareHandler);
			this.removeEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClickHandler);
			ObjectPool.disposeObject(this._toolTip);
			this._toolTip = null;
			
			this.click = null;
			this._clickHandler = null;
			this.doubleClick = null;
			this.useDoubleClick = false;
			super.dispose();
		}
		
		public function get isMouseOver():Boolean
		{
			return _isMouseOver;
		}
		
	}
}