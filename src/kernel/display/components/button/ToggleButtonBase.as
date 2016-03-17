package kernel.display.components.button
{
	import flash.geom.Rectangle;
	
	import kernel.display.components.group.ISelectGroupItem;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：ToggleButton.as
	 * <p>
	 * 功能：
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：Aug 18, 2010
	 * <p>
	 * 作者：Hongbin.Yang
	 */
	public class ToggleButtonBase extends Button implements ISelectGroupItem
	{
		protected var _down:*;
		protected var _up:*;
		private var _padding:int;
		
		public function ToggleButtonBase(id:int = 0, label:String = "", clickHandler:Function = null)
		{
			super(id, label, clickHandler);
		}
		
		override protected function init():void
		{
			super.init();
			this._imgBG.useScale9Grid = true;
			switchBG(false);
			var rect:Rectangle = new Rectangle();
			rect.top = 10;
			rect.bottom = 9;
			rect.left = 10;
			rect.right = 11;
			this._imgBG.scale9Grid = rect;
			_padding = UISkinRunner.buttonPadding * 2 + 10;
		}
		
		protected function switchBG(isDown:Boolean):void
		{
			if (isDown)
				setImage(_down);
			else
				setImage(_up);
		}
		
		/**
		 * 设置ToggleButton的按下和抬起时的皮肤
		 * @param down 按下的皮肤
		 * @param up 抬起的皮肤
		 */
		public function setSkin(down:*, up:*):void
		{
			_down = down;
			_up = up;
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_down);
			_down = null;
			ObjectPool.disposeObject(_up);
			_up = null;
			super.dispose();
		}
	}
}