package kernel.display.components.tip
{
	
	import flash.display.DisplayObject;
	
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.tip.members.ITipContainer;
	import kernel.display.components.tip.members.TipContainer;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：Tip.as
	 * <p>
	 * 功能：Tip显示对象
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class Tip extends MouseEffectiveComponent implements ITipContainer
	{
		private var _imgBG:DisplayObject;
		private var _childrenContainer:TipContainer;
		
		private var _marginLeft:Number;
		private var _marginRight:Number;
		private var _marginTop:Number;
		private var _marginBottom:Number;
		
		/**
		 * 获得TipContainer 
		 * @return 
		 * 
		 */		
		public function get childrenContainer():TipContainer
		{
			return _childrenContainer;
		}

		/**
		 * 获取或设置最大宽度
		 */
		public function get maxWidth():Number
		{
			return _childrenContainer.maxWidth;
		}
		
		public function set maxWidth(value:Number):void
		{
			_childrenContainer.maxWidth = value;
		}
		
		/**
		 * 获取或设置左边距
		 */
		public function get marginLeft():Number
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void
		{
			_marginLeft = value;
		}
		
		/**
		 * 获取或设置右边距
		 */
		public function get marginRight():Number
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void
		{
			_marginRight = value;
		}
		
		/**
		 * 获取或设置上边距
		 */
		public function get marginTop():Number
		{
			return _marginTop;
		}
		
		public function set marginTop(value:Number):void
		{
			_marginTop = value;
		}
		
		/**
		 * 获取或设置底边距
		 */
		public function get marginBottom():Number
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void
		{
			_marginBottom = value;
		}
		
		/**
		 * 隐藏背景图 
		 * 
		 */		
		public function hideBG():void
		{
			_imgBG.visible = false;
		}
		/**
		 * 显示背景图 
		 * 
		 */		
		public function showBG():void
		{
			_imgBG.visible = true;
		}
		
		/**
		 * 获取或设置Tip数据
		 */
		public function set tipVO(value:TipVO):void
		{
			// 为数据套一层容器数据再传入，否则会忽略第一层数据显示信息
			var tipVO:TipVO = new TipVO();
			var children:Array = [];
			children.push(value);
			tipVO.children = children;
			_childrenContainer.tipVO = tipVO;
			updateView();
		}
		
		/**
		 * Tip显示对象
		 */
		public function Tip()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			// 背景
			_imgBG = UISkinRunner.tipBG;
			addChild(_imgBG);
			// 子对象容器
			_childrenContainer = new TipContainer();
			addChild(_childrenContainer);
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		private function updateView():void
		{
			// 更新背景宽高
			_imgBG.width = _marginLeft + _childrenContainer.width + _marginRight;
			_imgBG.height = _marginTop + _childrenContainer.height + _marginBottom;
			
			if(_imgBG.width <= 32)
			{
				_imgBG.width = 32;
			}
			
			// 设置内容坐标
			_childrenContainer.x = _marginLeft;
			_childrenContainer.y = _marginTop;
		}
		
		/**
		 * 清除所有子对象
		 */
		override public function clear():void
		{
			super.clear();
			_childrenContainer.clear();
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_imgBG);
			_imgBG = null;
			ObjectPool.disposeObject(_childrenContainer);
			_childrenContainer = null;
			
			super.dispose();
		}
	}
}