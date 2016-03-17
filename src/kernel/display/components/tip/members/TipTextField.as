package kernel.display.components.tip.members
{
	import kernel.data.FontNameType;
	import kernel.display.components.text.TextFieldProxy;
	
	/**
	 * 文件名：TipTextField.as
	 * <p>
	 * 功能：
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class TipTextField extends TextFieldProxy implements ITipMember
	{
		override public function set scaleX(value:Number):void {
			wordWrap = true;
			super.scaleX = value;
		}
		override public function set scaleY(value:Number):void {
			wordWrap = true;
			super.scaleY = value;
		}
		override public function set width(value:Number):void {
			wordWrap = true;
			super.width = value;
		}
		override public function set height(value:Number):void {
			wordWrap = true;
			super.height = value;
		}
		
		public function TipTextField()
		{
			super();
			this.fontColor = 0xffffff;
			this.font = FontNameType.NORMAL_FONT_1001;
		}
		
		public function resetLayout():void
		{
			// 将文本恢复成单行
			wordWrap = false;
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}