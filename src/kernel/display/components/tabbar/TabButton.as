package kernel.display.components.tabbar
{
	import flash.geom.Rectangle;
	
	import kernel.display.components.behaviors.TabButtonMouseEffectiveBehaviour;
	import kernel.display.components.button.ToggleButtonBase;
	import kernel.runner.UISkinRunner;
	import kernel.utils.ColorUtil;
	
	/**
	 * 文件名：BaseTabButton.as
	 * <p>
	 * 功能：
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：Aug 18, 2010
	 * <p>
	 * 作者：Hongbin.Yang
	 */
	public class TabButton extends ToggleButtonBase
	{
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			if (value)
			{
				this.setTextStyle(53);
			} else
			{
				this.setTextStyle(52);
			}
			this._imgBG.useScale9Grid = true;
			switchBG(value);
			var rect:Rectangle = new Rectangle();
			rect.top = 10;
			rect.bottom = 14;
			rect.left = 40;
			rect.right = 36;
			this._imgBG.scale9Grid = rect;
			
			this.updateLableLocation();
		}
		
		public function TabButton(id:int = 0, label:String = "", clickHandler:Function = null)
		{
			super(id, label, clickHandler);
			this.marginVertical = 1;
		}
		
		override protected function init():void
		{
			this._mouseEffectBehavior = new TabButtonMouseEffectiveBehaviour();
			setSkin(UISkinRunner.tabBarDown, UISkinRunner.tabBarUp);
			
			super.init();
		}
		
		override public function set enabled(value:Boolean):void
		{
			super.enabled = value;
			
			if (value)
			{
				ColorUtil.deFadeColor(this);
			} else
			{
				ColorUtil.fadeColor(this, 0.4, 0.4, 0.4);
			}
		}
		
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}