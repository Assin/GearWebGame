package kernel.display.components.tip.members
{
	import data.ResourcesFileNameType;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	import kernel.display.components.BitmapProxy;
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ObjectPool;

	/**
	 * 给自定义子tip用的tip容器 
	 * @author 雷羽佳 2013.7.11 9：51
	 * 
	 */
	public class ChildTipForCustom extends MouseEffectiveComponent
	{
		private var _imgBG:DisplayObject;
		private var _marginLeft:Number;
		private var _marginRight:Number;
		private var _marginTop:Number;
		private var _marginBottom:Number;
		private var _baseTipCustomDisplay:BaseTipCustomDisplay;
		
		private var _type:int = 0;
		
		public var tipBG:BitmapProxy
		public function get type():int
		{
			return _type;
		}

		public function set type(value:int):void
		{
			_type = value;
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
		
		public function ChildTipForCustom()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			// 背景
			tipBG = new BitmapProxy();
			tipBG.useScale9Grid = true;
			tipBG.setURL(ResourcesFileNameType.BASE_TIPBG_PNG);
			var tipBG9Grid:Rectangle = new Rectangle();
			tipBG9Grid.top = 16;
			tipBG9Grid.bottom = 16;
			tipBG9Grid.left = 16;
			tipBG9Grid.right = 16;
			tipBG.scale9Grid = tipBG9Grid;
			
			_imgBG = tipBG;
			addChild(_imgBG);
			// 子对象容器
			this.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		/**
		 * 获取或设置Tip数据
		 */
		public function set tipVO(value:BaseTipCustomDisplay):void
		{
			// 为数据套一层容器数据再传入，否则会忽略第一层数据显示信息
			_baseTipCustomDisplay = value;
			this.addChild(_baseTipCustomDisplay);
			updateView();
		}
		
		private function updateView():void
		{
			// 更新背景宽高
			_imgBG.width = _marginLeft + _baseTipCustomDisplay.width + _marginRight;
			_imgBG.height = _marginTop + _baseTipCustomDisplay.height + _marginBottom;
			
			if(_imgBG.width <= 32)
			{
				_imgBG.width = 32;
			}
			
			// 设置内容坐标
			_baseTipCustomDisplay.x = _marginLeft;
			_baseTipCustomDisplay.y = _marginTop;
		}
		
		/**
		 * 清除所有子对象
		 */
		override public function clear():void
		{
			super.clear();
			ObjectPool.disposeObject(_baseTipCustomDisplay)
			_baseTipCustomDisplay = null;
		}
		
		override public function dispose():void
		{
			super.dispose();	
			ObjectPool.disposeObject(_imgBG)
			_imgBG = null;
			ObjectPool.disposeObject(_baseTipCustomDisplay)
			_baseTipCustomDisplay = null;	
		}
	}
}