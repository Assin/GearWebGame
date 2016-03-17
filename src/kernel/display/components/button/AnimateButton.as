package kernel.display.components.button
{
	
	import kernel.display.components.AnimateBitmap;
	import kernel.display.components.behaviors.DefaultComponentMouseEffectBehavior;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：AnimateButton.as
	 * <p>
	 * 功能：动画按钮，当鼠标悬停时可以显示动画而不是高光
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-10-19
	 * <p>
	 * 作者：yanghongbin
	 */
	public class AnimateButton extends ImageButton
	{
		private var _overAnimate:AnimateBitmap;
		
		/**
		 * 获取或设置鼠标悬停时的动画
		 */
		public function get overAnimate():AnimateBitmap
		{
			return _overAnimate;
		}
		
		public function set overAnimate(value:AnimateBitmap):void
		{
			_overAnimate = value;
		}
		
		public function AnimateButton(id:int = 0, clickHandler:Function = null)
		{
			super(id, clickHandler);
		}
		
		override protected function init():void
		{
			_mouseEffectBehavior = new DefaultComponentMouseEffectBehavior();
			super.init();
		}
		
		override protected function onOverIn():void
		{
			super.onOverIn();
			if (_overAnimate != null)
			{
				_overAnimate.play();
				addChild(_overAnimate);
				_imgBG.visible = false;
			}
		}
		
		override protected function onOverOut():void
		{
			super.onOverOut();
			if (_overAnimate != null)
			{
				_overAnimate.stop();
				removeChild(_overAnimate);
				_imgBG.visible = true;
			}
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_overAnimate);
			_overAnimate = null;
			super.dispose();
		}
	}
}