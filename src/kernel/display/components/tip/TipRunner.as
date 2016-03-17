package kernel.display.components.tip
{
	
	import flash.geom.Rectangle;
	
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.display.components.tip.behaviors.DefaultTipShowHideBehavior;
	import kernel.display.components.tip.behaviors.ITipShowHideBehavior;
	import kernel.display.components.tip.members.TipMemberType;
	import kernel.runner.LayerRunner;
	import kernel.runner.StageRunner;
	import kernel.utils.DisplayUtil;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * 文件名：TipRunner.as
	 * <p>
	 * 功能：Tip管理者，负责管理Tip相关逻辑。当Tip跟随鼠标移动时是不会自动隐藏的
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class TipRunner
	{
		private static var instance:TipRunner;
		
		private var _lastSeconds:Number;
		private var _offsetX:Number;
		private var _offsetY:Number;
		private var _dragging:Boolean = false;
		
		private var _maxWidth:Number;
		private var _marginLeft:Number;
		private var _marginRight:Number;
		private var _marginTop:Number;
		private var _marginBottom:Number;
		
		private var _showHideBehavior:ITipShowHideBehavior;
		private var _tip:Tip;
		private var _hideTimer:EnterFrameTimer;
		
		private var _timer:EnterFrameTimer;
		
		private var _currentTipOwner:MouseEffectiveComponent;

		public function get currentTipOwner():MouseEffectiveComponent
		{
			return _currentTipOwner;
		}

		
		public function get marginBottom():Number
		{
			return _marginBottom;
		}

		public function get marginTop():Number
		{
			return _marginTop;
		}

		public function get marginRight():Number
		{
			return _marginRight;
		}

		public function get marginLeft():Number
		{
			return _marginLeft;
		}

		public function get maxWidth():Number
		{
			return _maxWidth;
		}

		public static function getInstance():TipRunner
		{
			if (instance == null)
			{
				instance = new TipRunner();
			}
			return instance;
		}
		
		
		
		private function get tip():Tip
		{
			if (_tip == null)
			{
				_tip = new Tip();
				_tip.maxWidth = _maxWidth;
				_tip.marginLeft = _marginLeft;
				_tip.marginRight = _marginRight;
				_tip.marginTop = _marginTop;
				_tip.marginBottom = _marginBottom;
				_tip.visible = false;
				//所有tip禁用鼠标事件
				LayerRunner.getInstance().tipLayer.mouseEnabled = false;
				
				LayerRunner.getInstance().tipLayer.addChild(_tip);
			}
			return _tip
		}
		
		/**
		 * 获取Tip是否正在跟随鼠标移动
		 */
		public function get dragging():Boolean
		{
			return _dragging;
		}
		
		/**
		 * 设置Tip的显示隐藏行为算法族
		 */
		public function set showHideBehavior(value:ITipShowHideBehavior):void
		{
			_showHideBehavior = value;
		}
		
		public function TipRunner()
		{
		}
		
		/**
		 * 初始化
		 * @param lastSeconds Tip显示之后持续的秒数
		 * @param maxWidth 最大显示宽度，当宽度大于这个值时将会强制调整其子对象的width属性
		 * @param offsetX 鼠标跟随时的横坐标偏移量
		 * @param offsetY 鼠标跟随时的纵坐标偏移量
		 */
		public function init(lastSeconds:Number, maxWidth:Number, offsetX:Number, offsetY:Number, marginLeft:Number, marginRight:Number,
							 marginTop:Number, marginBottom:Number):void
		{
			if (_showHideBehavior == null)
				_showHideBehavior = new DefaultTipShowHideBehavior();
			
			_lastSeconds = lastSeconds;
			_offsetX = offsetX;
			_offsetY = offsetY;
			
			_maxWidth = maxWidth;
			_marginLeft = marginLeft;
			_marginRight = marginRight;
			_marginTop = marginTop;
			_marginBottom = marginBottom;
			
			_hideTimer = new EnterFrameTimer(1000);
			_hideTimer.onComplete = hideHandler;
			
			_timer = new EnterFrameTimer(1000/StageRunner.getInstance().stage.frameRate);
			_timer.onTimer = startDrag;
		}
		
		private function updateLayout():void
		{
			tip.x = StageRunner.getInstance().stage.mouseX + _offsetX;
			tip.y = StageRunner.getInstance().stage.mouseY + _offsetY;
		}
		
		private function hideAfter(seconds:Number):void
		{
			if (dragging)
				return ;
			_hideTimer.stop();
			_hideTimer.reset();
			_hideTimer.delay = int(seconds * 1000);
			_hideTimer.start();
		}
		
		private function hideHandler():void
		{
			if (dragging)
				return ;
			_showHideBehavior.hide(tip);
		}
		
		
		/**
		 * 通过传入的TipVO来显示Tip
		 * @param value 传入的数据，通常是TipVO的实例，但也可以是字符串
		 * @param drag 是否启用拖曳
		 */
		public function showTip(value:*, drag:Boolean = false,owner:MouseEffectiveComponent = null):void
		{
			if (value == null)
				return ;
			if (value is String)
			{
				if (value == "")
					return ;
				var tipVO:TipVO = new TipVO();
				tipVO.type = TipMemberType.TEXT;
				tipVO.data = value;
				tip.tipVO = tipVO;
			} else if (value is TipVO)
			{
				tip.tipVO = value;
				
			} else
			{
				return ;
			}
			_currentTipOwner = owner;
			
			tip.showBG();
			updateLayout();
			
			//郭鑫全屏
			if (tip.x > StageRunner.getInstance().gameRightX - tip.width)
			{
				tip.x = StageRunner.getInstance().gameRightX - tip.width;
				
			}
			if (tip.y > StageRunner.getInstance().gameBottomY - tip.height)
			{
				tip.y = StageRunner.getInstance().gameBottomY - tip.height;
			}
			
			_showHideBehavior.show(tip);
			
			if(tip.childrenContainer.isShowBG == true)
			{
				tip.showBG();
			}else
			{
				tip.hideBG();
			}
			
			
			if (drag)
			{
				_dragging = true;
				_timer.start();
			}
			else
				hideAfter(_lastSeconds);
		}
		
		/**
		 * 强制立即隐藏Tip，不进行判断
		 */
		public function hideTip():void
		{
			stopDrag();
			_hideTimer.stop();
			if (_tip != null)
			{
				_showHideBehavior.hide(tip);
				_currentTipOwner = null;
			}
		}
		
		
		/**
		 * 使Tip开始跟随鼠标
		 */
		public function startDrag():void
		{
			updateLayout();
			
			tip.x = StageRunner.getInstance().stage.mouseX+_offsetX;
			tip.y = StageRunner.getInstance().stage.mouseY+_offsetY;
			
			//郭鑫全屏：
			if (tip.x > StageRunner.getInstance().gameRightX - tip.width)
			{
				tip.x = StageRunner.getInstance().stage.mouseX -tip.width- _offsetX;
				changeCustomTipPos("left");
			}else
			{
				changeCustomTipPos("right");
			}
			if (tip.y > StageRunner.getInstance().gameBottomY - tip.height)
			{
				tip.y = StageRunner.getInstance().gameBottomY - tip.height;
			}
			
		}
		
		

		//修改自定义Tip的左右
		private function changeCustomTipPos(pos:String):void
		{
			
			if(tip.childrenContainer.customDisplayContainer != null)
			{

				if(tip.childrenContainer.customDisplayContainer.currentPos  != pos)
				{
					
					tip.childrenContainer.customDisplayContainer.currentPos = pos;
					tip.childrenContainer.customDisplayContainer.posChangeHandler(pos);	
				}
			}
		}
		
		
		
		/**
		 * 使Tip停止跟随鼠标
		 */
		public function stopDrag():void
		{
			if (_tip == null)
			{
				return ;
			}
			DisplayUtil.stopDrag(tip);
			hideAfter(_lastSeconds);
			_dragging = false;
			_timer.stop();
		}
	}
}