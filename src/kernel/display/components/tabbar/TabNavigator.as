package kernel.display.components.tabbar
{
	
	
	import flash.display.DisplayObject;
	
	import kernel.display.components.container.ViewStack;
	import kernel.events.TabBarEvent;
	import kernel.utils.DataProvider;
	import kernel.utils.ObjectPool;
	
	
	
	/**
	 * 这是一个TabBar和ViewStack的组合应用，背景使用PanelUtils内的方法获得PanelUtils.getAlphaFrame
	 * @author yanghongbin
	 *
	 *   var arr:Array = [{label:"舰队",data:obj,width:50,height:24},
	 * 					{label:"船只",data:obj,width:50,height:24},
	 * 					{label:"其他",data:obj,width:50,height:24}
	 ];
	 */
	public class TabNavigator extends ViewStack
	{
		//上方的tabbar
		private var tabBar:TabBar;
		
		public function TabNavigator()
		{
			super();
		}
		
		override public function set width(value:Number):void
		{
		}
		
		override public function set height(value:Number):void
		{
		}
		
		public function get currentIndex():int
		{
			return tabBar.selectIndex;
		}
		
		public function set Padding(value:int):void
		{
			this.tabBar.btnPadding=value;
		}
		
		public function set tabX(value:int):void
		{
			this.tabBar.x=value;
		}
		
		override protected function init():void
		{
			super.init();
			this.tabBar = new TabBar();
			this.addChildAt(this.tabBar, 0);
			this.tabBar.addEventListener(TabBarEvent.TABBAR_CHANGE, tabChangeHandler, false, 0, true);
		}
		
		protected function tabChangeHandler(e:TabBarEvent):void
		{
			this.selectIndex(e.selectedId);
			var evt:TabBarEvent = new TabBarEvent(TabBarEvent.TABBAR_CHANGE);
			evt.selectedId = e.selectedId;
			evt.data = e.data;
			this.dispatchEvent(evt);
		}
		
		//设置数据源
		public function set dataProvider(dp:DataProvider):void
		{
			this.tabBar.dataProvider = dp;
			layoutChildren();
		}
		
		override public function selectIndex(index:int):void
		{
			if (index >= this.childrenList.length || index < 0)
				return ;
			this.tabBar.selectIndex = index;
			super.selectIndex(index);
		}
		
		override public function selectChild(child:DisplayObject):void
		{
			super.selectChild(child);
			if (this.childrenList.indexOf(child) != -1)
			{
				this.tabBar.selectIndex = this.childrenList.indexOf(child);
			}
		}
		
		/**
		 * 获得tabbutton通过index
		 * @return
		 *
		 */
		public function getTabButtonByIndex(index:int):TabButton
		{
			return this.tabBar.getTabButtonByIndex(index);
		}
		
		override protected function addChildToView(index:int):void
		{
			super.addChildToView(index);
			layoutChildren();
		}
		
		private function layoutChildren():void
		{
			this.childContainer.y = this.tabBar.y + this.tabBar.height - 2;
		}
		
		override public function addSource(child:DisplayObject):void
		{
			super.addSource(child);
			this.selectIndex(0);
		}
		
		override public function dispose():void
		{
			if (this.tabBar.hasEventListener(TabBarEvent.TABBAR_CHANGE))
			{
				this.tabBar.removeEventListener(TabBarEvent.TABBAR_CHANGE, tabChangeHandler);
			}
			ObjectPool.disposeObject(tabBar);
			tabBar = null;
			
			super.dispose();
		}
	}
}