package kernel.display.components.container
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import kernel.display.components.BaseComponent;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	import kernel.utils.ObjectUtil;
	
	/**
	 * 用于显示一组层叠的子容器中的某一个。当显示其中一个时候其他子容器不显示。
	 * @author yanghongbin
	 *
	 */
	public class ViewStack extends BaseComponent
	{
		//子容器计数
		private var childCount:int = 0;
		//子容器数组
		protected var childrenList:Vector.<DisplayObject> = new Vector.<DisplayObject>();
		//子对象容器
		protected var childContainer:Sprite;
		//当前显示的容器引用
		private var _currentChild:DisplayObject;
		
		public function ViewStack()
		{
			super();
			this.childContainer = new Sprite();
			DisplayUtil.removeAllChildren(this.childContainer);
			this.childContainer.graphics.clear();
			this.addChildAt(this.childContainer, 0);
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
		}
		
		/**
		 *获取当前显示的显示对象的引用
		 * @return
		 *
		 */
		public function get currentChild():DisplayObject
		{
			return this._currentChild;
		}
		
		//添加子显示对象
		public function addSource(child:DisplayObject):void
		{
			this.childrenList.push(child);
			++this.childCount;
		}
		
		//添加一个显示对象到某一个位置
		public function addSourceAt(child:DisplayObject, index:int):void
		{
			this.childrenList[index] = child;
			++childCount;
		}
		
		//删除一个子显示对象 通过编号
		public function removeByIndex(index:int):void
		{
			if (index >= this.childrenList.length || index < 0)
			{
				return ;
			}
			
			if (this.getChildAt(0) == this.childrenList[index])
			{
				this.removeChildAt(0);
				this.addChildToView(0);
			}
			childrenList.splice(index, 1);
			--this.childCount;
		}
		
		//删除一个子显示对象 通过引用
		public function removeByChild(child:DisplayObject):void
		{
			var index:int = this.childrenList.indexOf(child);
			
			if (index == -1)
			{
				return ;
			}
			
			if (this.getChildAt(0) == this.childrenList[index])
			{
				this.removeChildAt(0);
				this.addChildToView(0);
			}
			childrenList.splice(index, 1);
			--this.childCount;
		}
		
		//清除所有
		public function removeAll():void
		{
			ObjectUtil.clearList(childrenList);
			this.removeAllChildren();
			this.childCount = 0;
		}
		
		//通过index值显示一个子显示对象
		public function selectIndex(index:int):void
		{
			if (index >= this.childrenList.length || index < 0)
				return ;
			this.addChildToView(index);
		}
		
		//通过引用显示一个子显示对象
		public function selectChild(child:DisplayObject):void
		{
			var index:int = this.childrenList.indexOf(child);
			
			if (index == -1)
			{
				return ;
			}
			this.addChildToView(index);
		}
		
		//通过index取得显示对象。
		public function getChildByIndex(index:int):DisplayObject
		{
			if (index >= this.childrenList.length || index < 0)
				return null;
			else
				return childrenList[index];
		}
		
		//删除显示对象，添加一个要显示的显示对象，从数组中找出要显示的内容
		protected function addChildToView(index:int):void
		{
			var viewChild:DisplayObject = this.childrenList[index];
			this.removeAllChildren();
			
			if (viewChild != null)
			{
				this._currentChild = viewChild;
				this.childContainer.addChildAt(viewChild, 0);
			}
		}
		
		//清空目前子对象
		protected function removeAllChildren():void
		{
			DisplayUtil.removeAllChildren(this.childContainer);
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_currentChild);
			ObjectPool.disposeObject(childrenList);
			ObjectPool.disposeObject(childContainer);
			childrenList = null;
			childContainer = null;
			_currentChild = null;
			
			super.dispose();
		}
	}
}