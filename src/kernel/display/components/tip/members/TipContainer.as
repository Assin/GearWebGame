package kernel.display.components.tip.members
{
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import kernel.IDispose;
	import kernel.display.components.tip.TipVO;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：TipContainer.as
	 * <p>
	 * 功能：Tip中专用的容器
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 */
	public class TipContainer extends Sprite implements ITipMember, ITipContainer,IDispose
	{
		private var _placeHolder:Shape;
		
		private var _maxWidth:Number = Number.MAX_VALUE;
		private var _tipVO:TipVO;
		
		private var _isShowBG:Boolean = true;

		public function get isShowBG():Boolean
		{
			return _isShowBG;
		}

		public function get customDisplayContainer():BaseTipCustomDisplay
		{
			return _CustomDisplayContainer;
		}
		
		

		public function get maxWidth():Number
		{
			return _maxWidth;
		}
		
		public function set maxWidth(value:Number):void
		{
			_maxWidth = value;
			updateLayout();
		}
		
		public function set tipVO(value:TipVO):void
		{
			_tipVO = value;
			updateView();
		}
		
		public function TipContainer()
		{
			super();
			init();
		}
		
		private function init():void
		{
			_placeHolder = new Shape();
			_placeHolder.graphics.beginFill(0, 0);
			_placeHolder.graphics.drawRect(0, 0, 1, 1);
			_placeHolder.graphics.endFill();
		}
		
		private function updateLayout():void
		{
			resetLayout();
			var width:Number = Math.min(this.width, _maxWidth);
			// 更新子对象宽度
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:DisplayObject = getChildAt(i);
				// 如果宽度不足以显示子对象则隐藏子对象
				child.visible = (width > child.x);
				// 如果子对象可见，并且宽度比子对象正常比例小则适当缩放子对象
				if (child.visible)
				{
					var more:Number;
					if (width < child.x + child.width)
					{
						more = child.x + child.width - width;
						child.width -= more;
					}
				}
			}
		}
		
		private function updateView():void
		{
			clear();
			// 首先调整自身的位置
			this.x = _tipVO.x;
			this.y = _tipVO.y;
			// 生成子对象并更新显示
			if (_tipVO.children != null)
			{
				var lastChild:DisplayObject;
				for (var i:int = 0; i < _tipVO.children.length; i++)
				{
					var childVO:TipVO = _tipVO.children[i];
					// 生成子对象
					var child:DisplayObject = TipMemberFactory.createMember(childVO.type, childVO.data)as DisplayObject;
				
					if (child == null)
						continue;
					// 调整位置
					
					if (childVO.isRelativeX && lastChild != null)
					{
						child.x = lastChild.x + lastChild.width + childVO.x
					} else
					{
						child.x = childVO.x;
					}
					
					if (childVO.isRelativeY && lastChild != null)
					{
						child.y = lastChild.y + lastChild.height + childVO.y;
					} else
					{
						child.y = childVO.y;
					}
					// 如果不是叶子节点则继续递归更新
					if (child is ITipContainer   && !(childVO.data is CustomDisplayVO))
					{
						ITipContainer(child).tipVO = childVO;
					}
					
					if((child as TipContainer) != null)
					{
						if((child as TipContainer).customDisplayContainer != null)
						{
							_CustomDisplayContainer = (child as TipContainer).customDisplayContainer;
							_isShowBG = (child as TipContainer).isShowBG;	
						}
					}else
					{
						_isShowBG = true;
					}
					
					
					// 添加到显示列表中
					addChild(child);
					// 更新上一个子节点引用
					lastChild = child;
				}
			}
			updateLayout();
		}
		

		
		
		//自定义显示的对象
		private var _CustomDisplayContainer:BaseTipCustomDisplay;
		/**
		 * 添加一个displayObject的对象；
		 * Lei Yujia
		 * @param data
		 * @param renderRectangle
		 * @param isShowBG 是否显示背景图
		 */		
		public function renderCustomDisplay(container:BaseTipCustomDisplay,data:*,bg:Boolean):void
		{
			_isShowBG = bg;
			_CustomDisplayContainer = container;
			_CustomDisplayContainer.addData(data);
			_CustomDisplayContainer.render(); 
			addChild(_CustomDisplayContainer);
			
		}
		
		
		
		public function resetLayout():void
		{
			for (var i:int = 0; i < numChildren; i++)
			{
				var child:ITipMember = getChildAt(i)as ITipMember;
				if (child != null)
					child.resetLayout();
			}
		}
		
		public function clear():void
		{
			DisplayUtil.removeChild(_placeHolder, this);
			while (this.numChildren > 0)
			{
				ObjectPool.disposeObject(this.getChildAt(0));
			}
			addChild(_placeHolder);
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_tipVO);
			_tipVO = null;
			_CustomDisplayContainer.dispose();
			
		}
	}
}