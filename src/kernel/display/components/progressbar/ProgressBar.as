package kernel.display.components.progressbar
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.utils.DisplayUtil;
	import kernel.utils.GraphicsUtil;
	import kernel.utils.ObjectPool;
	
	
	/**
	 * @name 进度条基类
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 30, 2011 9:24:13 AM
	 */
	public class ProgressBar extends MouseEffectiveComponent
	{
		protected var _bg:DisplayObject;
		protected var _bar:DisplayObject;
		protected var _barMask:DisplayObject;
		protected var _max:Number;
		protected var _progress:Number;
		/**
		 * 进度条与背景之间的宽度差距
		 */
		protected var barWidthGap:Number;
		/**
		 * 进度条与背景之间的高度差距
		 */		
		protected var barHeightGap:Number;
		/**
		 * 进度条上方点
		 */
		protected var barTop:Number;
		
		protected var _onComplete:Function;
		
		public function get progress():Number
		{
			return _progress;
		}
		
		
		public function get onComplete():Function
		{
			return _onComplete;
		}
		
		public function set onComplete(value:Function):void
		{
			_onComplete = value;
		}
		
		
		override protected function init():void
		{
			super.init();
			this._bg = new Shape();
			var bg:Shape = this._bg as Shape;
			GraphicsUtil.drawRect(bg.graphics, 0, 0, 1, 1, 0xff0000, 1);
			this.addChild(this._bg);
			
			this._bar = new Shape();
			var bar:Shape = this._bar as Shape;
			GraphicsUtil.drawRect(bar.graphics, 0, 0, 1, 1, 0x0000ff, 1);
			this.addChild(this._bar);
			
			barWidthGap = this._bg.width - this._bar.width;
			barHeightGap = this._bg.height - this._bar.height;
			barTop = 2;
			
			this._barMask = new Shape();
			var barMask:Shape = this._barMask as Shape;
			GraphicsUtil.drawRect(barMask.graphics, 0, 0, 1, 1, 0x000000, 1);
			this.addChild(this._barMask);
			this._bar.mask = this._barMask;
			
			this.hasMouseDownEffect = false;
		}
		
		
		
		public function set max(value:Number):void
		{
			_max = value;
		}
		
		public function set progress(value:Number):void
		{
			_progress = value;
			if (_progress > _max)
			{
				_progress = _max;
			}
			if (_progress < 0)
			{
				_progress = 0;
			}
			if (_progress == _max)
			{
				if (_onComplete != null)
				{
					_onComplete();
				}
			}
			this.updateView();
		}
		
		protected function updateView():void
		{
			var prop:Number = _progress / _max;
			_barMask.width = (this._bg.width - barWidthGap) * prop;
		}
		
		override public function set height(value:Number):void
		{
			this._bg.height = value;
			this.layoutUI();
		}
		
		override public function get height():Number
		{
			return this._bg.height;
		}
		
		override public function get width():Number
		{
			return this._bg.width;
		}
		
		
		override public function set width(value:Number):void
		{
			this._bg.width = value;
			this.layoutUI();
		}
		
		
		
		protected function layoutUI():void
		{
			this._barMask.x = this._bar.x = this._bg.x + barWidthGap / 2;
			this._barMask.y = this._bar.y = this._bg.y + barTop;
			this._barMask.height = this._bar.height = this._bg.height - barHeightGap;
		}
		
		public function ProgressBar()
		{
			super();
		}
		
		override public function dispose():void
		{
			DisplayUtil.removeAllChildren(this);
			ObjectPool.disposeObject(_bg);
			_bg = null;
			ObjectPool.disposeObject(_bar);
			_bar = null;
			TweenLite.killTweensOf(_barMask);
			ObjectPool.disposeObject(_barMask);
			_barMask = null;
			barWidthGap = 0;
			barHeightGap = 0;
			_max = 0;
			_progress = 0;
			_onComplete = null;
			
			super.dispose();
		}
		
		
	}
}