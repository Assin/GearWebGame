package kernel.runner
{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	
	import kernel.display.components.BitmapProxyScale9GirdData;
	import kernel.display.components.behaviors.IComponentMouseEffectBehavior;
	
	/**
	 * 文件名：SkinRunner.as
	 * <p>
	 * 功能：负责管理基础组件的皮肤
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：Aug 25, 2010
	 * <p>
	 * 作者：Hongbin.Yang
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class UISkinRunner
	{
		// Tip
		public static var tipBG:DisplayObject;
		
		// Button
		public static var buttonBG:Class;
		public static var buttonPadding:int;
		public static var buttonMouseEffectBehavior:IComponentMouseEffectBehavior;
		
		// CheckBox
		public static var checkBoxBG:String;
		public static var checkBoxSelectedBG:String;
		public static var checkBoxMouseEffectBehavior:IComponentMouseEffectBehavior;
		
		// ComboBox
		public static var comboBoxBG:BitmapProxyScale9GirdData;
		
		// ScrollBar
		public static var scrollBarUpArrow:String;
		public static var scrollBarDownArrow:String;
		public static var scrollBarBlock:String;
		public static var scrollBarTrack:BitmapProxyScale9GirdData;
		public static var scrollBarBlockTensible:Boolean;
		public static var scrollBarAlwaysDown:String;
		
		// TabBar
		public static var tabBarUp:*;
		public static var tabBarDown:*;
		
		// CharTabBar 聊天专用！
		public static var tabBarUpForChat:*;
		public static var tabBarDownForChat:*;
		
		// TreeView
		public static var treeViewNoBranchIcon:String;
		public static var treeViewNodeOpenIcon:String;
		public static var treeViewNodeCloseIcon:String;
		
		// RadioButton
		public static var radioBG:String;
		public static var radioSelectedBG:String;
		
		// ListTitle
		public static var listTitleBG:Class;
		public static var listTitleArrow:BitmapData;
		public static var listTitleArrowNo:BitmapData;
		public static var listTitleMouseEffectBehavior:IComponentMouseEffectBehavior;
		
		//BaseDropMenu
		public static var BaseDropMenuButton:BitmapProxyScale9GirdData;
		public static var BaseDropMenuTextBG:BitmapProxyScale9GirdData;
		public static var BaseDropMenuTextHover:BitmapProxyScale9GirdData;
		
		public function UISkinRunner()
		{
		}
		
		public static function setBaseDropMenuSkin(button:BitmapProxyScale9GirdData,TextBG:BitmapProxyScale9GirdData,TextHover:BitmapProxyScale9GirdData):void
		{
			BaseDropMenuButton = button;
			BaseDropMenuTextBG = TextBG;
			BaseDropMenuTextHover = TextHover;
		}
		
		
		public static function setTipSkin(bg:DisplayObject):void
		{
			tipBG = bg;
		}
		
		public static function setButtonSkin(bg:Class, padding:int, mouseEffectBehavior:IComponentMouseEffectBehavior):void
		{
			buttonBG = bg;
			buttonPadding = padding;
			buttonMouseEffectBehavior = mouseEffectBehavior;
		}
		
		public static function setCheckBoxSkin(bg:String, selectedBg:String, mouseEffectBehavior:IComponentMouseEffectBehavior):void
		{
			checkBoxBG = bg;
			checkBoxSelectedBG = selectedBg;
			checkBoxMouseEffectBehavior = mouseEffectBehavior;
		}
		
		public static function setComboBoxSkin(bg:BitmapProxyScale9GirdData):void
		{
			comboBoxBG = bg;
		}
		
		public static function setScrollBarSkin(up:String, down:String, block:String, alwaysDown:String,track:BitmapProxyScale9GirdData, blockTensible:Boolean):void
		{
			scrollBarUpArrow = up;
			scrollBarDownArrow = down;
			scrollBarBlock = block;
			scrollBarAlwaysDown = alwaysDown;
			scrollBarTrack = track;
			scrollBarBlockTensible = blockTensible;
		}
		
		public static function setTabBarSkin(up:*, down:*):void
		{
			tabBarUp = up;
			tabBarDown = down;
		}
		
		public static function setTabBarForChatSkin(up:*, down:*):void
		{
			tabBarUpForChat = up;
			tabBarDownForChat = down;
		}
		
		
		public static function setTreeViewSkin(noBranch:String, openIcon:String, closeIcon:String):void
		{
			treeViewNoBranchIcon = noBranch;
			treeViewNodeOpenIcon = openIcon;
			treeViewNodeCloseIcon = closeIcon;
		}
		
		public static function setRadioSkin(selectedBg:String, bg:String):void
		{
			radioSelectedBG = selectedBg;
			radioBG = bg;
		}
		
		public static function setListTitleSkin(bg:Class, arrow:String, arrowNo:String, mouseEffectBehavior:IComponentMouseEffectBehavior):void
		{
			listTitleBG = bg;
			ResourcesRunner.getInstance().getBitmapData(arrow, function(bd:BitmapData):void
			{
				listTitleArrow = bd;
			});
			ResourcesRunner.getInstance().getBitmapData(arrowNo, function(bd:BitmapData):void
			{
				listTitleArrowNo = bd;
			});
			listTitleMouseEffectBehavior = mouseEffectBehavior;
		}
	}
}