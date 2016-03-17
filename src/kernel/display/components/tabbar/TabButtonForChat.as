package kernel.display.components.tabbar
{
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
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
	public class TabButtonForChat extends ToggleButtonBase
	{
		private var filterArr:Array;
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			
			if (value)
			{
				this.marginVertical = 1;
				this.marginHorizontal = 2;
				this._txtLabel.color = "#ffffff";
				this._txtLabel.fontSize = 12;
				_txtLabel.filters = filterArr;
			} else
			{
				this.marginVertical = 1;
				this.marginHorizontal = 2;
				this._txtLabel.color = "#ffffff";
				this._txtLabel.fontSize = 12;
				_txtLabel.filters = filterArr;
			}
			this._imgBG.useScale9Grid = true;
			switchBG(value);
			var rect:Rectangle = new Rectangle();
			rect.top = 5;
			rect.bottom = 5;
			rect.left = 5;
			rect.right = 5;
			this._imgBG.scale9Grid = rect;
			
			this.updateLableLocation();
		}
		
		public function TabButtonForChat(id:int = 0, label:String = "", clickHandler:Function = null)
		{
			super(id, label, clickHandler);
			this.marginVertical = 1;
		}
		
		override protected function init():void
		{
			this._mouseEffectBehavior = new TabButtonMouseEffectiveBehaviour();
			setSkin(UISkinRunner.tabBarDownForChat, UISkinRunner.tabBarUpForChat);
			super.init();
			
			filterArr = new Array();
			var glow1:GlowFilter = new GlowFilter();
			glow1.blurX = 2;
			glow1.blurY = 2;
			glow1.color = 0x151513;
			glow1.strength = 15;
			filterArr.push(glow1);
			
			var shadow:DropShadowFilter = new DropShadowFilter();
			shadow.distance = 0;
			shadow.color = 0x000000;
			shadow.blurX = 2;
			shadow.blurY = 2;
			filterArr.push(shadow);
			
			//var glow2:GlowFilter = new GlowFilter();
			//glow2.blurX = 2;
			//glow2.blurY = 2;
			//glow2.color = 0xffffff;
			//glow2.inner = true;
			//filterArr.push(glow2);
			
			
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