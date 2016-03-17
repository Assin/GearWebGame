package kernel.display.components
{
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import kernel.IClear;
	import kernel.IDispose;
	import kernel.display.components.behaviors.DefaultComponentEnableBehavior;
	import kernel.display.components.behaviors.IComponentEnableBehavior;
	import kernel.display.components.group.ISelectGroupItem;
	import kernel.utils.DisplayUtil;
	import kernel.utils.LayoutUtil;
	import kernel.utils.ObjectPool;
	
	
	/**
	 * 文件名：BaseComponent.as
	 * <p>
	 * 功能：所有组件的基类，不可实例化。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public class BaseComponent extends Sprite implements IClear, ILayoutable, ISelectGroupItem, IDispose, IBrightDisplayObject
	{
		/**
		 * 可用性行为族
		 */
		protected var _enableBehavior:IComponentEnableBehavior;
		
		/* 选择组支持 */
		private var _selectable:Boolean = false;
		private var _selected:Boolean = false;
		private var _selectCallback:Function;
		private var _groupName:String;
		private var _brightName:String;
		/**
		 * 组件标识符，可以以此区别不同组件
		 */
		public var id:int;
		/**
		 * 组件中的对象，可以保存任何信息
		 */
		public var data:*;
		
		/**
		 * 获取或设置组件的可用性
		 */
		public function get enabled():Boolean
		{
			return _enableBehavior.getEnabled(this);
		}
		
		public function set enabled(value:Boolean):void
		{
			if(_enableBehavior != null)
			{
				_enableBehavior.setEnabled(this, value);
			}
			
		}
		
		/**
		 * 获取或设置组件的可选择性
		 */
		public function get selectable():Boolean
		{
			return _selectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			_selectable = value;
		}
		
		/**
		 * 获取或设置组件的选择状态
		 */
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			_selected = value;
			
			if (value)
			{
				if (_selectCallback != null)
				{
					_selectCallback(this);
				}
				// 触发选择事件
				dispatchEvent(new Event(Event.SELECT, true, true));
			}
		}
		
		/**
		 * 获取或设置组件的选中回调方法
		 */
		public function get selectedCallback():Function
		{
			return _selectCallback;
		}
		
		public function set selectedCallback(value:Function):void
		{
			_selectCallback = value;
		}
		
		/**
		 * 获取或设置组件的选择组名
		 */
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void
		{
			_groupName = value;
		}
		
		override public function set width(value:Number):void
		{
			if (value == 0)
				return ;
			super.width = value;
		}
		
		override public function set height(value:Number):void
		{
			if (value == 0)
				return ;
			super.height = value;
		}
		
		/**
		 * 实例化BaseComponent类
		 * @param id 标识符，可用于区分不同组件
		 * @param data 可记录任意信息的对象
		 */
		public function BaseComponent(id:int = 0, data:* = null)
		{
			super();
			// 设置不响应Tab事件
			this.tabEnabled = false;
			this.tabChildren = false;
			this.id = id;
			this.data = data;
			init();
		}
		
		/**
		 * 初始化组件，默认注册所有事件
		 */
		protected function init():void
		{
			initListener();
			_enableBehavior = new DefaultComponentEnableBehavior();
			
		}
		
		/**
		 * 注册事件
		 */
		protected function initListener():void
		{
		}
		
		/**
		 * 按照传入的布局数据对组件进行布局，组件默认不对子数据进行布局
		 * @param layout 布局数据
		 */
		public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layout(this, layout);
		}
		
		/**
		 * 清除组件所有状态和信息
		 */
		public function clear():void
		{
			this.enabled = true;
		}
		
		/**
		 * 释放所有内容
		 *
		 */
		public function dispose():void
		{
			ObjectPool.disposeObject(_enableBehavior);
			_enableBehavior = null;
			_selectCallback = null;
			_groupName = null;
			_brightName = null;
			data = null;
		}
		
		public function getBrightRectangle():Rectangle
		{
			return DisplayUtil.getGlobalRectangle(this);
		}
		
		public function get brightName():String
		{
			return _brightName;
		}
		
		public function set brightName(value:String):void
		{
			this._brightName = value;
		}
	}
}