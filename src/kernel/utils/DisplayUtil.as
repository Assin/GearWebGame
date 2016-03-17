package kernel.utils
{
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.SimpleButton;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import kernel.runner.StageRunner;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * 文件名：DisplayUtil.as
	 * <p>
	 * 功能：显示工具
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-10
	 * <p>
	 * 作者：Raykid
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class DisplayUtil
	{
		private static var _dragDict:Dictionary;
		private static var _dragTimer:EnterFrameTimer;
		
		public function DisplayUtil()
		{
		}
		
		public static function init():void
		{
			_dragDict = new Dictionary();
			
			_dragTimer = new EnterFrameTimer(1000 / StageRunner.getInstance().stage.frameRate);
			_dragTimer.onTimer = dragTimerHandler;
			_dragTimer.start();
		}
		
		private static function dragTimerHandler():void
		{
			var mouseX:Number = StageRunner.getInstance().stage.mouseX;
			var mouseY:Number = StageRunner.getInstance().stage.mouseY;
			var x:Number;
			var y:Number;
			var bounds:Rectangle;
			
			for each (var obj:Object in _dragDict)
			{
				var displayObject:DisplayObject = obj.displayObject;
				
				if (obj.lockCenter)
				{
					x = mouseX;
					y = mouseY;
					bounds = obj.bounds;
					
					if (bounds != null)
					{
						if (x < bounds.left)
							x = bounds.left;
						
						if (x > bounds.right)
							x = bounds.right;
						
						if (y < bounds.top)
							y = bounds.top;
						
						if (y > bounds.bottom)
							y = bounds.bottom;
					}
					displayObject.x = x;
					displayObject.y = y;
				} else
				{
					x = mouseX + obj.x;
					y = mouseY + obj.y;
					bounds = obj.bounds;
					
					if (bounds != null)
					{
						if (x < bounds.left)
							x = bounds.left;
						
						if (x > bounds.right)
							x = bounds.right;
						
						if (y < bounds.top)
							y = bounds.top;
						
						if (y > bounds.bottom)
							y = bounds.bottom;
					}
					displayObject.x = x;
					displayObject.y = y;
				}
			}
		}
		
		/**
		 * 使显示对象开始跟随鼠标移动
		 * @param displayObject 要跟随鼠标移动的显示对象
		 * @param lockCenter 指定是将可拖动的 显示对象 锁定到鼠标位置中央 (true)，还是锁定到用户首次单击该 显示对象 时所在的点上 (false)
		 * @param bounds 相对于 displayObject 父级的坐标的值，用于指定 displayObject 约束矩形
		 */
		public static function startDrag(displayObject:DisplayObject, lockCenter:Boolean = false, bounds:Rectangle = null):void
		{
			var obj:Object;
			var x:Number = 0;
			var y:Number = 0;
			
			if (!lockCenter)
			{
				var xy:Point = new Point();
				xy.x = displayObject.x;
				xy.y = displayObject.y;
				xy = localToGlobal(xy, displayObject.parent);
				x = xy.x - StageRunner.getInstance().stage.mouseX;
				y = xy.y - StageRunner.getInstance().stage.mouseY;
			}
			
			if (_dragDict[displayObject] != null)
			{
				obj = _dragDict[displayObject];
				obj.lockCenter = lockCenter;
				obj.x = x;
				obj.y = y;
				obj.bounds = bounds;
			} else
			{
				obj = new Object();
				obj.displayObject = displayObject;
				obj.lockCenter = lockCenter;
				obj.x = x;
				obj.y = y;
				obj.bounds = bounds;
				_dragDict[displayObject] = obj;
			}
		}
		
		/**
		 * 停止跟随鼠标
		 * @param displayObject 要停止跟随鼠标移动的显示对象
		 */
		public static function stopDrag(displayObject:DisplayObject):void
		{
			var obj:Object = _dragDict[displayObject];
			
			if (obj == null)
				return ;
			_dragDict[displayObject] = null;
			delete _dragDict[displayObject];
			ObjectPool.clearAndPushPool(obj.bounds);
			ObjectPool.clearAndPushPool(obj);
		}
		
		/**
		 * 添加显示对象
		 * @param child 被添加的显示对象
		 * @param container 添加到的容器对象
		 */
		public static function addChild(child:DisplayObject, container:DisplayObjectContainer):void
		{
			if (child != null && container != null)
			{
				if (container.contains(child) == false)
				{
					container.addChild(child);
				}
			}
		}
		
		/**
		 * 添加显示对象到指定层次
		 * @param child 被添加的显示对象
		 * @param container 添加到的容器对象
		 * @param index 要添加到的显示层次
		 */
		public static function addChildAt(child:DisplayObject, container:DisplayObjectContainer, index:uint):void
		{
			if (index >= 0)
			{
				if (container.numChildren >= index && child != null && container != null)
				{
					container.addChildAt(child, index);
				}
			}
		}
		
		/**
		 * 添加显示对象到指定显示对象下方
		 * @param child 被添加的显示对象
		 * @param container 添加到的容器对象
		 * @param target 目标对象
		 */
		public static function addChildAfter(child:DisplayObject, container:DisplayObjectContainer, target:DisplayObject):void
		{
			for (var i:int = 0; i < container.numChildren; i++)
			{
				if (container.getChildAt(i) == target)
				{
					container.addChildAt(child, i + 1);
					break;
				}
			}
		}
		
		/**
		 * 添加显示对象到指定显示对象上方
		 * @param child 被添加的显示对象
		 * @param container 添加到的容器对象
		 * @param target 目标对象
		 */
		public static function addChildBefore(child:DisplayObject, container:DisplayObjectContainer, target:DisplayObject):void
		{
			for (var i:int = 0; i < container.numChildren; i++)
			{
				if (container.getChildAt(i) == target)
				{
					container.addChildAt(child, i);
					break;
				}
			}
		}
		
		/**
		 * 删除显示对象
		 * @param child 被删除的显示对象
		 * @param container 删除于的容器对象
		 */
		public static function removeChild(child:DisplayObject, container:DisplayObjectContainer):void
		{
			if (child && container && !(container is Loader))
			{
				if (child.parent == container)
				{
					container.removeChild(child);
				}
			}
		}
		
		/**
		 * 传进一个容器对象，会自动清空里面的显示对象
		 * @param container 要清空的容器
		 */
		public static function removeAllChildren(container:DisplayObjectContainer):void
		{
			if (container != null)
			{
				while (container.numChildren > 0)
				{
					container.removeChildAt(0);
				}
			}
		}
		
		/**
		 * 深度清空容器，如果容器内包含有子容器，则将子容器也清空
		 * @param parent 要清空的容器
		 */
		public static function removeAllChildrenDeeply(container:DisplayObjectContainer):void
		{
			if (container != null)
			{
				while (container.numChildren > 0)
				{
					var child:DisplayObjectContainer = container.getChildAt(0)as DisplayObjectContainer;
					
					if (child != null)
					{
						removeAllChildrenDeeply(child);
					} else
					{
						container.removeChildAt(0);
					}
				}
			}
		}
		
		/**
		 * 判断点是否在显示对象上
		 * @param point 要判断的点
		 * @param tester 被判断的对象
		 * @param shapeFlag 是检查对象 (true) 的实际像素，还是检查边框 (false) 的实际像素。
		 * @return 是否碰撞
		 *
		 */
		public static function hitTestPoint(point:Point, tester:DisplayObject, shapeFlag:Boolean = false):Boolean
		{
			if (tester && tester.stage != null)
			{
				return tester.hitTestPoint(point.x, point.y, shapeFlag);
			} else
			{
				return false;
			}
		}
		
		//判断两个显示对象是否重叠
		public static function hitTestObject(displayObject_1:DisplayObject, displayObject_2:DisplayObject):Boolean
		{
			if (displayObject_1 && displayObject_2 && displayObject_1.stage != null && displayObject_2.stage != null)
			{
				return displayObject_1.hitTestObject(displayObject_2);
			} else
			{
				return false;
			}
		}
		
		//判断点是否在某个范围内，两个参数均为全局坐标变量
		public static function hitTestRect(point:Point, rect:Rectangle):Boolean
		{
			if (point.x >= rect.x && point.x <= rect.x + rect.width && point.y >= rect.y && point.y <= rect.y + rect.height)
			{
				return true;
			} else
			{
				return false;
			}
		}
		
		//将点在本地的坐标转换为全局坐标
		public static function localToGlobal(point:Point, container:DisplayObjectContainer):Point
		{
			if (container && container.stage != null)
			{
				var p:Point = new Point(point.x, point.y);
				p = container.localToGlobal(p);
				return new Point(p.x, p.y);
			} else
			{
				return null;
			}
		}
		
		//将点在全局坐标转换为本地的坐标
		public static function globalToLocal(point:Point, container:DisplayObjectContainer):Point
		{
			if (container && container.stage != null)
			{
				var p:Point = new Point(point.x, point.y);
				p = container.globalToLocal(p);
				return new Point(p.x, p.y);
			} else
			{
				return null;
			}
		}
		
		//取得物件在stage的x,y;
		public static function getDisplayObjectStageXY(displayObject:DisplayObject):Point
		{
			if (displayObject && displayObject.stage != null)
			{
				var xy:Point = new Point();
				var point:Point = displayObject.localToGlobal(new Point());
				xy.x = point.x;
				xy.y = point.y;
				return xy;
			}
			return null;
		}
		
		//交换两个显示对象的index
		public static function swapDisplayObject(child1:DisplayObject, child2:DisplayObject):void
		{
			if (child1 != null && child2 != null)
			{
				if (child1.parent != null && child1.parent == child2.parent)
				{
					child1.parent.swapChildren(child1, child2);
				}
			}
		}
		
		/**
		 * 切换显示对象的可见性
		 */
		public static function switchVisible(displayObject:DisplayObject):void
		{
			displayObject.visible = !displayObject.visible;
		}
		
		/**
		 * 将显示对象提到容器的最顶端
		 */
		public static function moveToTop(displayObject:DisplayObject):void
		{
			if (displayObject.parent != null)
			{
				var parent:DisplayObjectContainer = displayObject.parent;
				parent.setChildIndex(displayObject, parent.numChildren - 1);
			}
		}
		
		/**
		 * 判断显示对象是否在容器的最顶端
		 */
		public static function isInTheTop(displayObject:DisplayObject):Boolean
		{
			if (displayObject.parent != null)
			{
				var parent:DisplayObjectContainer = displayObject.parent;
				return (parent.getChildIndex(displayObject) == 0);
			} else
			{
				return false;
			}
		}
		
		/**
		 * 判断结点对象是否在某根结点下的显示列表树里
		 */
		public static function isInDisplayTree(node:DisplayObject, root:DisplayObjectContainer):Boolean
		{
			var parent:DisplayObjectContainer = node.parent;
			
			while (parent != null)
			{
				if (parent == root)
				{
					return true;
				}
				parent = parent.parent;
			}
			return false;
		}
		
		public static function addBg(Bg:Class, x:int, y:int, width:int, height:int, container:DisplayObjectContainer):DisplayObject
		{
			var bg:DisplayObject = new Bg()as DisplayObject;
			bg.x = x;
			bg.y = y;
			bg.width = width;
			bg.height = height;
			addChild(bg, container);
			return bg;
		}
		
		/**
		 * 矩阵布局
		 * @author	Wang_Wei@opi-corp.com
		 * @param items,要布局的显示对象数组
		 * @param col,矩阵列数
		 * @param colWidth,矩阵列宽
		 * @param rowHeight,矩阵行高
		 * @param offsetX,矩阵左上角横坐标偏移
		 * @param offsetY,矩阵左上角纵坐标偏移
		 * @example
		 * 	var ary:Array = [];
		 * 	for(var i:int = 0;i<12;i++){
		 * 		var t:TextField = new TextField();
		 * 		t.width =100;
		 * 		t.height = 21;
		 * 		t.text = String(i);
		 * 		addChild(t);
		 * 		ary.push(t);
		 * 	}
		 * 	matrixLayout(ary,3,100,30);
		 *  ary中的TextField将被布局成如下形式
		 * 	x x x
		 * 	x x x
		 * 	x x x
		 */
		public static function matrixLayout(items:*, col:uint, colWidth:uint, rowHeight:uint, offsetX:int = 0, offsetY:int = 0):void
		{
			if(items is Array || items is Vector.<*>)
			{
				for (var i:int = 0; i < items.length; i++)
				{
					var item:* = items[i];
					item.x = offsetX + colWidth * (i % col);
					item.y = offsetY + rowHeight * Math.floor(i / col);
				}
			}
			
		}
		
		/**
		 * 等列宽列布局
		 * @author	Wang_Wei@opi-corp.com
		 * @param items,要布局的显示对象数组
		 * @param colWidth,矩阵列宽
		 * @param rowHeight,矩阵行高
		 * @param offsetX,矩阵左上角横坐标偏移
		 * @param offsetY,矩阵左上角纵坐标偏移
		 */
		public static function horizontalLayout(item:Array, colWidth:uint, offsetX:int = 0, offsetY:int = 0):void
		{
			matrixLayout(item, item.length, colWidth, 0, offsetX, offsetY);
		}
		
		/**
		 * 等行高行布局
		 * @author	Wang_Wei@opi-corp.com
		 * @param items,要布局的显示对象数组
		 * @param colWidth,矩阵列宽
		 * @param rowHeight,矩阵行高
		 * @param offsetX,矩阵左上角横坐标偏移
		 * @param offsetY,矩阵左上角纵坐标偏移
		 */
		public static function verticalLayout(item:Array, rowHeight:uint, offsetX:int = 0, offsetY:int = 0):void
		{
			matrixLayout(item, 1, 0, rowHeight, offsetX, offsetY);
		}
		
		/**
		 * 等间距行布局
		 * @author	Wang_Wei@opi-corp.com
		 * @param items,要布局的显示对象数组
		 * @param margin,间距
		 * @param offx,矩阵左上角横坐标偏移
		 * @param offy,矩阵左上角纵坐标偏移
		 */
		public static function lineup(items:Array, margin:int, offx:int = 0, offy:int = 0):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				var item:* = items[i];
				item.x = offx;
				item.y = offy;
				offx = item.x + item.width + margin;
			}
		}
		
		/**
		 * 等间距列布局
		 * @author	Wang_Wei@opi-corp.com
		 * @param items,要布局的显示对象数组
		 * @param margin,间距
		 * @param offx,矩阵左上角横坐标偏移
		 * @param offy,矩阵左上角纵坐标偏移
		 */
		public static function rowup(items:Array, margin:int, offx:int = 0, offy:int = 0):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				var item:* = items[i];
				item.x = offx;
				item.y = offy;
				offy = item.y + item.height + margin;
			}
		}
		
		/**
		 * 将obj移动到target的X方位
		 * @param target,参照对象
		 * @param obj,被移动对象
		 * @param side,方位
		 * @param margin,与参照对象的间距
		 */
		private static function toXof(target:DisplayObject, obj:DisplayObject, side:String, margin:int = 0):void
		{
			var x:int = 0;
			var y:int = 0;
			
			switch (side)
			{
				case 'right':
					x = target.x + target.width + margin;
					y = target.y;
					break;
				case 'left':
					x = target.x - obj.width - margin;
					y = target.y;
					break;
				case 'top':
					x = target.x;
					y = target.y - obj.height - margin;
					break;
				case 'bottom':
					x = target.x;
					y = target.y + target.height + margin;
					break;
			}
			obj.x = x;
			obj.y = y;
		}
		
		/**
		 * 将obj移动到target的左边
		 */
		public static function toLeftOf(target:DisplayObject, obj:DisplayObject, margin:int = 0):void
		{
			toXof(target, obj, 'left', margin);
		}
		
		/**
		 * 将obj移动到target的右边
		 */
		public static function toRightOf(target:DisplayObject, obj:DisplayObject, margin:int = 0):void
		{
			toXof(target, obj, 'right', margin);
		}
		
		/**
		 * 将obj移动到target的上边
		 */
		public static function toTopOf(target:DisplayObject, obj:DisplayObject, margin:int = 0):void
		{
			toXof(target, obj, 'top', margin);
		}
		
		/**
		 * 将obj移动到target的下边
		 */
		public static function toBottomOf(target:DisplayObject, obj:DisplayObject, margin:int = 0):void
		{
			toXof(target, obj, 'bottom', margin);
		}
		
		public static const TOPLEFT:String = 'topleft';
		public static const TOPRIGHT:String = 'topright';
		public static const BOTTOMLEFT:String = 'bottomleft';
		public static const BOTTOMRIGHT:String = 'bottomright';
		public static const TOP:String = "top";
		public static const RIGHT:String = "right";
		public static const BOTTOM:String = "bottom";
		public static const LEFT:String = "left";
		
		/**
		 * 将obj移动到container的某个脚落
		 * @param container,容器
		 * @param obj,被移动对象
		 * @param side,角落：TOPLEFT，TOPRIGHT，BOTTOMLEFT，BOTTOMRIGHT
		 * @param offx,横坐标偏移量
		 * @param offy,纵坐标偏移量
		 */
		public static function corner(container:DisplayObjectContainer, obj:DisplayObject, side:String, offx:int = 0, offy:int = 0):void
		{
			var x:int = 0;
			var y:int = 0;
			
			switch (side)
			{
				case 'topleft':
					x = offx;
					y = offy;
					break;
				case 'topright':
					x = container.width - obj.width + offx;
					y = offy;
					break;
				case 'bottomleft':
					x = offx;
					y = container.height - obj.height + offy;
					break;
				case 'bottomright':
					x = container.width - obj.width + offx;
					y = container.height - obj.height + offy;
					break;
			}
			obj.x = x;
			obj.y = y;
		}
		
		public static function innerAlign(target:DisplayObject, obj:DisplayObject, side:String, offx:int = 0, offy:int = 0):void
		{
			var x:int = 0;
			var y:int = 0;
			
			switch (side)
			{
				case 'top':
					x = obj.x + offx;
					y = target.y + offy;
					break;
				case 'right':
					x = target.x + target.width - obj.width + offx;
					y = obj.y + offy;
					break;
				case 'bottom':
					x = obj.x + offx;
					y = target.y + target.height - obj.height + offy;
					break;
				case 'left':
					x = target.x + offx;
					y = obj.y + offy;
					break;
			}
			obj.x = x;
			obj.y = y;
		}
		
		public static function outterAlign(target:DisplayObject, obj:DisplayObject, side:String, offx:int = 0, offy:int = 0):void
		{
			var x:int = 0;
			var y:int = 0;
			
			switch (side)
			{
				case 'top':
					x = obj.x + offx;
					y = target.y - obj.height + offy;
					break;
				case 'right':
					x = target.x + target.width + offx;
					y = obj.y + offy;
					break;
				case 'bottom':
					x = obj.x + offx;
					y = target.y + target.height + offy;
					break;
				case 'left':
					x = target.x - obj.width + offx;
					y = obj.y + offy;
					break;
			}
			obj.x = x;
			obj.y = y;
		}
		
		public static function getGlobalPoint(displayObject:DisplayObject):Point
		{
			if (displayObject == null)
			{
				return null;
			}
			
			if (displayObject.parent == null)
			{
				return null;
			}
			
			return displayObject.parent.localToGlobal(new Point(displayObject.x, displayObject.y));
		}
		
		public static function getGlobalRectangle(displayObject:DisplayObject):Rectangle
		{
			if (displayObject == null)
			{
				return null;
			}
			
			if (displayObject.parent == null)
			{
				return null;
			}
			var rect:Rectangle = displayObject.getBounds(displayObject.parent);
			var point:Point = displayObject.parent.localToGlobal(new Point(displayObject.x, displayObject.y));
			rect.x = point.x;
			rect.y = point.y;
			return rect;
		}
		
		public static function getSimpleButtonGlobalRectangle(displayObject:SimpleButton):Rectangle
		{
			if (displayObject == null)
			{
				return null;
			}
			
			if (displayObject.parent == null)
			{
				return null;
			}
			var point:Point = displayObject.parent.localToGlobal(new Point(displayObject.x, displayObject.y));
			return new Rectangle(point.x, point.y, displayObject.overState.width, displayObject.overState.height);
		}
		
		public static function getChildIndexInParentContainer(value:DisplayObject):int
		{
			var parent:DisplayObjectContainer = value.parent;
			
			if (parent != null)
			{
				return parent.getChildIndex(value);
			}
			return 0;
		}
		
		
		public static function stopAllMovieClip(value:DisplayObject):void
		{
			if (value is DisplayObjectContainer)
			{
				if (value is MovieClip)
				{
					(value as MovieClip).stop();
				}
				
				var childNum:int = (value as DisplayObjectContainer).numChildren;
				
				for (var i:int = 0; i < childNum; i++)
				{
					var child:DisplayObject = (value as DisplayObjectContainer).getChildAt(i);
					stopAllMovieClip(child);
				}
				
			}
		}
		
		public static function playAllMovieClip(value:DisplayObject):void
		{
			if (value is DisplayObjectContainer)
			{
				if (value is MovieClip)
				{
					(value as MovieClip).play();
				}
				
				var childNum:int = (value as DisplayObjectContainer).numChildren;
				
				for (var i:int = 0; i < childNum; i++)
				{
					var child:DisplayObject = (value as DisplayObjectContainer).getChildAt(i);
					playAllMovieClip(child);
				}
				
			}
		}
		
		public static function removeTween(displayObject:DisplayObject):void
		{
			if (!displayObject)
			{
				return ;
			}
			
			TweenLite.killTweensOf(displayObject);
			
			if (!displayObject.parent)
			{
				return ;
			}
			TweenMax.killChildTweensOf(displayObject.parent);
		}
	}
}