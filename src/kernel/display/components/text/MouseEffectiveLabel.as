package kernel.display.components.text
{
	import kernel.display.components.MouseEffectiveComponent;
	
	/**
	 * @name 可以有鼠标交互的textfield
	 * @explain
	 * @author yanghongbin
	 * @create Dec 23, 2012 4:56:12 PM
	 */
	public class MouseEffectiveLabel extends MouseEffectiveComponent implements ITextStyle
	{
		private var _textField:TextFieldProxy;
		
		public function MouseEffectiveLabel(id:int = 0, data:* = null, clickHandler:Function = null)
		{
			super(id, data, clickHandler);
			this.hasMouseDownEffect = false;
		}
		
		public function set text(value:String):void
		{
			this._textField.text = value;			
		}
		
		
		public function set color(value:String):void
		{
			this._textField.color = value;
		}
		
		public function set fontFamily(value:String):void
		{
			this._textField.fontFamily = value;
		}
		
		public function set fontSize(value:int):void
		{
			this._textField.fontSize = value;
		}
		
		public function set fontStyle(value:String):void
		{
			this._textField.fontStyle = value;
		}
		
		public function set fontWeight(value:String):void
		{
			this._textField.fontWeight = value;
		}
		
		public function set textAlign(value:String):void
		{
			this._textField.textAlign = value;
		}
		
		public function get txtLabel():TextFieldProxy
		{
			return this._textField;
		}
		
		override protected function init():void
		{
			super.init();
			this._textField = new TextFieldProxy();
			this.addChild(this._textField);
		}
		
		override public function set width(value:Number):void
		{
			this._textField.width = value;
		}
		
		override public function set height(value:Number):void
		{
			this._textField.height = value;
		}
	}
}