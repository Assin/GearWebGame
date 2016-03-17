package kernel.display.components.progressbar
{
	import kernel.display.components.text.TextFieldProxy;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name 带有文本框显示的进度条
	 * @explain
	 * @author yanghongbin
	 * @create Dec 3, 2012 2:36:18 PM
	 */
	public class ProgressBarTextField extends ProgressBar
	{
		protected var _textField:TextFieldProxy;
		
		public function ProgressBarTextField()
		{
			super();
		}
		
		protected function initTextField():void
		{
			this._textField = new TextFieldProxy();
			_textField.textColor = 0xffffff;
			_textField.fontWeight = "bold";
			this.addChild(this._textField);
		}
		
		protected function layoutTextField():void
		{
			this._textField.x = this._bg.x + this._bg.width / 2 - this._textField.textWidth / 2;
			this._textField.y = this._bg.y + (this._bg.height - this._textField.textHeight)/2-2;
		}
		
		public function set label(value:String):void
		{
			if (this._textField != null)
			{
				this._textField.text = value;
				layoutTextField();
			}
		}
		
		public function get label():String
		{
			if (this._textField == null)
			{
				return "";
			} else
			{
				return this._textField.text;
			}
		}
		
		public function set textVisiable(value:Boolean):void
		{
			this._textField.visible = value;
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(this._textField);
			this._textField = null;
			super.dispose();
		}
	}
}