package kernel.display.components.renderlist
{
	
	import flash.display.Sprite;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.container.ScrollPanel;
	import kernel.display.components.group.SelectGroup;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * RenderList使用数据驱动方式显示数据，这是这个组件最大的好处之一。同时内置了一次创建多次
	 * 更新，以及自动排版功能，所有子类基本无需考虑内存消耗问题，只需在clear()方法中写好适当的操作。
	 * <p>写一个Renderer，只需要重写它的initView()、updateView()、clear()三个方法即可
	 * 根据需要可重写createBg()方法，其他方法可以不变 。
	 *
	 * <p><b>原作者：</b>Saber
	 * <p><b>后续开发者：</b>yanghongbin
	 */
	public class RenderList extends BaseComponent
	{
		private var _datas:Array;
		
		private var _scrollPanel:ScrollPanel;
		
		private var _bgSprite:Sprite;
		private var _rendererSprite:Sprite;
		private var _rendererList:Array;
		
		private var _listWidth:uint;
		private var _listHeight:uint;
		private var _itemNumHorizontal:int = 0;
		private var _itemNumVertical:int = 0;
		
		private var _selectGroup:SelectGroup;
		
		override public function set width(value:Number):void
		{
			if (value <= 0)
				return ;
			_listWidth = value;
			drawLayout();
		}
		
		override public function set height(value:Number):void
		{
			if (value <= 0)
				return ;
			_listHeight = value;
			drawLayout();
		}
		
		/**
		 * 获取当前选中的Renderer，如果没有选中或者不允许选中则返回null
		 * 注：该属性只用于单选模式
		 */
		public function get currentRenderer():BaseRenderer
		{
			var renderer:BaseRenderer = _selectGroup.currentItem as BaseRenderer;
			if (renderer == null || !renderer.value.selectable)
				return null;
			return renderer;
		}
		
		/**
		 * 获取当前选中的Renderer的集合，如果没有选中或者不允许选中则返回null
		 */
		public function get currentRenderers():Array
		{
			return _selectGroup.currentItems;
		}
		
		/**
		 * 获取当前选中Renderer的value值，如果没有选中或者不允许选中则返回null。
		 * 注：该属性只用于单选模式
		 */
		public function get currentValue():BaseRendererVO
		{
			var renderer:BaseRenderer = currentRenderer;
			return renderer == null ? null : renderer.value;
		}
		
		/**
		 * 获取当前选中的所有Renderer的value集合，如果没有选中或者不允许选中则返回null
		 */
		public function get currentValues():Array
		{
			var arr:Array = [];
			var renderers:Array = currentRenderers;
			for each (var renderer:BaseRenderer in renderers)
			{
				arr.push(renderer.value);
			}
			return arr;
		}
		
		/**
		 * 获取或设置一次纵向滚动的像素数
		 */
		public function get verticalLineScrollSize():Number
		{
			return _scrollPanel.verticalLineScrollSize;
		}
		
		public function set verticalLineScrollSize(value:Number):void
		{
			_scrollPanel.verticalLineScrollSize = value;
		}
		
		/**
		 * 获取或设置RenderList中横向盛放的最大Renderer数
		 */
		public function get itemNumHorizontal():int
		{
			return _itemNumHorizontal;
		}
		
		public function set itemNumHorizontal(value:int):void
		{
			_itemNumHorizontal = value;
			drawLayout();
		}
		
		/**
		 * 获取或设置RenderList中纵向盛放的最大Renderer数
		 */
		public function get itemNumVertical():int
		{
			return _itemNumVertical;
		}
		
		public function set itemNumVertical(value:int):void
		{
			_itemNumVertical = value;
			drawLayout();
		}
		
		/**
		 * 设置选择组
		 */
		public function set group(group:SelectGroup):void
		{
			group.transferItems(_selectGroup);
			ObjectPool.clearAndPushPool(_selectGroup);
			_selectGroup = group;
		}
		
		/**
		 * 初始化RenderList
		 * @param width RenderList的宽度
		 * @param height RenderList的高度
		 * @param data 初始数据
		 */
		public function RenderList(width:uint = 0, height:uint = 0, data:Array = null)
		{
			super();
			_listWidth = width;
			_listHeight = height;
			_datas = data;
			init();
			updateView();
		}
		
		override protected function init():void
		{
			super.init();
			_selectGroup = new SelectGroup();
			_rendererList = [];
			_rendererSprite = new Sprite();
			DisplayUtil.removeAllChildren(_rendererSprite);
			_rendererSprite.graphics.clear();
			addChild(_rendererSprite);
			createScrollPanel();
		}
		
		private function createScrollPanel():void
		{
			_scrollPanel = new ScrollPanel();
			_scrollPanel.width = _listWidth;
			_scrollPanel.height = _listHeight;
			_scrollPanel.source = _rendererSprite;
			addChild(_scrollPanel);
		}
		
		private function createRenderer():void
		{
			if (_datas != null)
			{
				var length:uint = _datas.length;
				ObjectPool.clearList(_rendererList);
				for (var i:uint = 0; i < length; i++)
				{
					var listVo:BaseRendererVO = _datas[i]as BaseRendererVO;
					// 从池中获取一个Renderer实例
					var renderer:BaseRenderer = new listVo.rendererClass();
					renderer.update(listVo);
					// 设置选择性
					if (listVo.selectable)
					{
						_selectGroup.addItem(renderer);
					}
					renderer.selected = listVo.selected;
					
					_rendererSprite.addChild(renderer);
					_rendererList.push(renderer);
				}
			}
			if (_rendererList.length > 0)
			{
				_scrollPanel.verticalLineScrollSize = _rendererList[0].height + 2;
			}
			drawLayout();
			_scrollPanel.update();
		}
		
		private function drawLayout():void
		{
			if (_rendererList == null || _rendererList.length <= 0)
				return ;
			var renderer:BaseRenderer = _rendererList[0]as BaseRenderer;
			if (_itemNumHorizontal > 0)
			{
				_listWidth = _itemNumHorizontal * renderer.width + 5;
			}
			if (_itemNumVertical > 0)
			{
				_listHeight = _itemNumVertical * (renderer.height + 2) - 2; // 加2减2均是为了防止滚动时出现微小的位移
			}
			// 设置滚动窗口大小
			_scrollPanel.width = _listWidth;
			_scrollPanel.height = _listHeight;
			// 校正renderer位置
			var accumulatorX:Number = 1;
			var accumulatorY:Number = 1;
			var maxY:Number = 0;
			for (var i:int = 0; i < _rendererList.length; i++)
			{
				renderer = _rendererList[i]as BaseRenderer;
				var numPerRow:int = _listWidth / renderer.width;
				if (numPerRow < 1)
					numPerRow = 1;
				renderer.x = accumulatorX;
				renderer.y = accumulatorY;
				if (renderer.height > maxY)
					maxY = renderer.height;
				// 累加横纵坐标
				if (i % numPerRow >= numPerRow - 1)
				{
					accumulatorX = 1;
					accumulatorY += (maxY + 2);
					maxY = 0;
				} else
				{
					accumulatorX += (renderer.width + 2);
				}
			}
		}
		
		private function setSelectGroup():void
		{
			// 设置RenderList的选择模式，只根据第一个数据判断，如果为空则默认为单选模式
			var listVo:BaseRendererVO = _datas[0]as BaseRendererVO;
			_selectGroup.currentType = (listVo == null ? SelectGroup.SINGLE_SELECT : listVo.selectType);
		}
		
		private function clearSelectGroup():void
		{
			for each (var renderer:BaseRenderer in _rendererList)
			{
				_selectGroup.removeItem(renderer);
			}
		}
		
		private function removeAllItem():void
		{
			_scrollPanel.verticalScrollPosition = 0;
			while (_rendererList.length > 0)
			{
				var temp:BaseRenderer = _rendererList.pop()as BaseRenderer;
				_rendererSprite.removeChild(temp);
				ObjectPool.clearAndPushPool(temp);
			}
			_scrollPanel.update();
		}
		
		private function updateView():void
		{
			if (_datas == null)
				return ;
			_scrollPanel.verticalScrollPosition = 0;
			clearSelectGroup();
			setSelectGroup();
			removeAllItem();
			createRenderer();
		}
		
		/**
		 * 更新数据
		 * @param datas 所有RendererVO的数组
		 */
		public function update(datas:Array):void
		{
			var value:BaseRendererVO;
			// 将原数据中的index置为-1，表示已经不在显示列表中
			for each (value in _datas)
			{
				value.index = -1;
			}
			// 修改列表
			ObjectPool.clearList(_datas, true);
			ObjectPool.clearAndPushPool(_datas);
			_datas = datas;
			// 将当前值列表中所有数据的index设置为其在RenderList中的索引值
			for (var i:int = 0; i < _datas.length; i++)
			{
				value = _datas[i]as BaseRendererVO;
				if (value == null)
				{
					_datas.splice(i, 1);
				} else
				{
					value.index = i;
				}
			}
			updateView();
		}
		
		public function getDataProvider():Array
		{
			return _datas;
		}
		
		public function getRendererAt(index:int):BaseRenderer
		{
			return _rendererList[index];
		}
		
		public function getRenders():Array
		{
			return _rendererList;
		}
		
		public function resetSelection():void
		{
			if (currentRenderer != null)
				currentRenderer.selected = false;
		}
		
		public function selectRenderer(index:int):void
		{
			var renderer:BaseRenderer = getRendererAt(index);
			if (renderer != null)
				renderer.selected = true;
		}
		
		override public function clear():void
		{
			super.clear();
			removeAllItem();
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_datas);
			_datas = null;
			ObjectPool.disposeObject(_scrollPanel);
			_scrollPanel = null;
			ObjectPool.disposeObject(_bgSprite);
			_bgSprite = null;
			ObjectPool.disposeObject(_rendererSprite);
			_rendererSprite = null;
			ObjectPool.disposeObject(_rendererList);
			_rendererList = null;
			ObjectPool.disposeObject(_selectGroup);
			_selectGroup = null;
			
			super.dispose();
		}
	}
}