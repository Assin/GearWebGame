package kernel.display.components.drag
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import kernel.IDispose;
	import kernel.runner.StageRunner;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name 拖拽的管理类
	 * @explain
	 * @author yanghongbin
	 * @create Dec 13, 2012 2:33:45 PM
	 */
	public class DragGroup implements IDispose
	{
		protected var _dragList:Vector.<IDragObject> = new Vector.<IDragObject>();
		//是否在拖拽中
		public var isDragging:Boolean = false;
		//当前拖拽的物体
		public var currentDragObject:IDragObject;
		//当前拖拽的物体的显示
		protected var _currentDragDisplayObject:DisplayObject;
		//当鼠标按下的回调方法
		
		private var _onDragDown:Function;
		//当鼠标抬起的回调方法
		private var _onDragUp:Function;
		//当拖拽完成，不管是找到目标，还是没找到
		private var _onDragComplete:Function;
		//重置拖拽对象的坐标
		private var _onReplaceDragDisplayObject:Function;
		
		//静态变量，用来拖动的时候，不显示 tips用。
		public static var haveDragging:Boolean = false;
		
		public function get onReplaceDragDisplayObject():Function
		{
			return _onReplaceDragDisplayObject;
		}
		
		public function set onReplaceDragDisplayObject(value:Function):void
		{
			_onReplaceDragDisplayObject = value;
		}
		
		public function get onDragComplete():Function
		{
			return _onDragComplete;
		}
		
		public function set onDragComplete(value:Function):void
		{
			_onDragComplete = value;
		}
		
		public function get onDragDown():Function
		{
			return _onDragDown;
		}
		
		public function set onDragDown(value:Function):void
		{
			_onDragDown = value;
		}
		
		
		public function get onDragUp():Function
		{
			return _onDragUp;
		}
		
		public function set onDragUp(value:Function):void
		{
			_onDragUp = value;
		}
		
		public function DragGroup()
		{
		}
		
		public function addItem(dragObject:IDragObject):void
		{
			if (this._dragList.indexOf(dragObject) < 0)
			{
				this.addItemEventListener(dragObject);
				this._dragList.push(dragObject);
			}
		}
		
		protected function addItemEventListener(dragObject:IDragObject):void
		{
			dragObject.addEventListener(MouseEvent.MOUSE_DOWN, onItemMouseDownHandler);
			dragObject.addEventListener(MouseEvent.MOUSE_UP, onItemMouseUPHandler);
		}
		
		protected function removeItemEventListener(dragObject:IDragObject):void
		{
			dragObject.removeEventListener(MouseEvent.MOUSE_DOWN, onItemMouseDownHandler);
			dragObject.removeEventListener(MouseEvent.MOUSE_UP, onItemMouseUPHandler);
		}
		
		protected function onItemMouseDownHandler(e:MouseEvent):void
		{
			var currentTempDragObject:IDragObject = e.currentTarget as IDragObject;
			
			//设置当前拖拽对象
			this.currentDragObject = currentTempDragObject;
			if(this.currentDragObject != null)
				StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
		}
		
		protected function onStageMouseMoveHandler(e:MouseEvent):void
		{
			if (this.isDragging == false && e.buttonDown)
			{
				_currentDragDisplayObject = _onDragDown(this.currentDragObject);
				if (_currentDragDisplayObject == null)
				{
					StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
					return ;
				}
				StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
				DisplayUtil.addChild(this._currentDragDisplayObject, StageRunner.getInstance().stage);
				isDragging = true;
				haveDragging = true;
			}
			if (_currentDragDisplayObject == null)
			{
				StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
				return ;
			}
			_currentDragDisplayObject.x = e.stageX - _currentDragDisplayObject.width / 2;
			_currentDragDisplayObject.y = e.stageY - _currentDragDisplayObject.height / 2;
			if (this._onReplaceDragDisplayObject != null)
			{
				this._onReplaceDragDisplayObject(_currentDragDisplayObject);
			}
		}
		
		protected function onStageMouseUpHandler(e:MouseEvent):void
		{
			if (e.target is IDragObject) 
				this._onDragComplete(this.currentDragObject, e.target as IDragObject);
			else
				this._onDragComplete(this.currentDragObject, null);
			this.reset();
		}
		
		//!!!!!!!!!!!!!!!!!这儿改了  将两个删除事件提前了 防止在进行了down操作 并且 没有进行拖拽操作的时候   依旧检测鼠标的move
		protected function onItemMouseUPHandler(e:MouseEvent):void
		{
			if (isDragging == false)
			{
				StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
				StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
				return ;
			}
			
			var targetDragObject:IDragObject = e.currentTarget as IDragObject;
			
			ObjectPool.disposeObject(this._currentDragDisplayObject);
			this._currentDragDisplayObject = null;
			this._onDragUp(this.currentDragObject, targetDragObject);
			
			isDragging = false;
			haveDragging = false;
		}
		
		/**
		 * 重置，开始下一次拖拽
		 *
		 */
		public function reset():void
		{
			this.isDragging = false;
			haveDragging = false;
			ObjectPool.disposeObject(this._currentDragDisplayObject);
			this._currentDragDisplayObject = null;
			this.currentDragObject = null;
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
		}
		
		public function dispose():void
		{
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStageMouseMoveHandler);
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP, onStageMouseUpHandler);
			for each (var ido:IDragObject in this._dragList)
			{
				this.removeItemEventListener(ido);
			}
			this._dragList = null;
			this.currentDragObject = null;
			
			ObjectPool.disposeObject(this._currentDragDisplayObject);
			this._currentDragDisplayObject = null;
			_onDragDown = null;
			this._onDragUp = null;
			this._onDragComplete = null;
			_onReplaceDragDisplayObject = null;
		}

		public function get dragList():Vector.<IDragObject>
		{
			return _dragList;
		}
		
		
	}
}