package kernel.display.components.renderlist
{
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getQualifiedClassName;
	
	import kernel.IClear;
	import kernel.display.components.LayoutVO;
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.group.ISelectGroupItem;
	import kernel.utils.ColorUtil;
	import kernel.utils.LayoutUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * RenderList使用数据驱动方式显示数据，这是这个组件最大的好处之一。同时内置了一次创建多次
	 * 更新，以及自动排版功能，所有子类基本无需考虑内存消耗问题，只需在clear()方法中写好适当的操作。
	 * <p>写一个Renderer，只需要重写它的initView()、updateView()、clear()三个方法即可
	 * 根据需要可重写initBG()方法，其他方法可以不变 。
	 *
	 * @author yanghongbin
	 */
	public class BaseRenderer extends MouseEffectiveComponent implements ISelectGroupItem, IClear
	{
		
		protected var _width:Number = -1;
		protected var _height:Number = -1;
		
		protected var _bg:Sprite;
		
		protected var _listVO:BaseRendererVO;
		
		public function get value():BaseRendererVO
		{
			return _listVO;
		}
		
		public function get valueTypeName():String
		{
			return getQualifiedClassName(_listVO.rendererClass);
		}
		
		override public function get width():Number
		{
			return (_width < 0 ? super.width : _width);
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
		}
		
		override public function get height():Number
		{
			return (_height < 0 ? super.height : _height);
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
		}
		
		override public function get selectable():Boolean
		{
			if (_listVO == null)
				return false;
			return _listVO.selectable;
		}
		
		override public function set selectable(value:Boolean):void
		{
			// 覆盖原有方法，因为Renderer本身不需要设置可选择性，其选择性是根据数据得来的
		}
		
		override public function set selected(value:Boolean):void
		{
			selectedBehavior(value);
			super.selected = value;
		}
		
		public function BaseRenderer()
		{
			super();
		}
		
		override protected function init():void
		{
			initBG();
			initView();
			super.init();
		}
		
		/**
		 *
		 * 创建背景
		 *
		 */
		protected function initBG():void
		{
			_bg = new Sprite();
			addChild(_bg);
		}
		
		/**
		 *
		 * 初始化Renderer的时候调用，负责创建其表现（UI），只执行一次
		 *
		 */
		protected function initView():void
		{
			// 等待子类完善
		}
		
		override protected function initListener():void
		{
			this.addEventListener(MouseEvent.CLICK, clickHandler);
		}
		
		/**
		 *
		 * 更新界面操作，当数据被替换时用来对现有界面进行更新的操作
		 *
		 */
		protected function updateView():void
		{
			// 等待子类完善
		}
		
		protected function selectedBehavior(selected:Boolean):void
		{
			if (selected)
			{
				ColorUtil.highLight(this);
				ColorUtil.addColorRing(_bg);
			} else
			{
				ColorUtil.deHighLight(this);
				ColorUtil.removeColorRing(_bg);
			}
		}
		
		protected function selectResponse():void
		{
			this.selected = true;
		}
		
		override protected function clickHandler(e:MouseEvent):void
		{
			super.clickHandler(e);
			if (_listVO.selectable)
			{
				selectResponse();
			}
		}
		
		/**
		 * 使用传入的数据更新Renderer
		 *
		 * @param value 最新的数据
		 */
		public function update(value:BaseRendererVO):void
		{
			_listVO = value;
			this.buttonMode = value.selectable;
			if (value != null)
			{
				updateView();
			}
		}
		
		override public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layoutContainer(this, layout);
		}
		
		/**
		 *
		 * 清除操作，当Renderer被回收的时候执行，类似于C++中类的析构方法。
		 *
		 * 如果Renderer中存在例如Timer等需要进行善后处理的对象，则请在该
		 * 方法中执行其善后方法，如Timer.stop()等。
		 *
		 */
		override public function clear():void
		{
			this.selected = false;
			_width = -1;
			_height = -1;
		}
		
		override public function dispose():void
		{
			if (this.hasEventListener(MouseEvent.CLICK)) 
			{
				this.removeEventListener(MouseEvent.CLICK, clickHandler);
			}
			
			ObjectPool.disposeObject(_bg);
			_bg = null;
			ObjectPool.disposeObject(_listVO);
			_listVO = null;
			
			super.dispose();
		}
	}
}