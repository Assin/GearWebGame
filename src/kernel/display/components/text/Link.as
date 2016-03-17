package kernel.display.components.text
{
	
	import flash.events.TextEvent;
	import flash.text.StyleSheet;
	
	/**
	 * 可以点击有链接的文本框组建
	 * @author yanghongbin
	 *
	 */
	public class Link extends TextFieldProxy
	{
		private var _linkHandler:Function;
		private var _regLink:RegExp = /^<a href='event:link'>(.*)<\/a>$/;
		
		override public function set text(value:String):void
		{
			super.text = value;
			super.htmlText = "<a href='event:link'>" + this.htmlText + "</a>";
		}
		
		override public function get htmlText():String
		{
			var res:Object
			var html:String = super.htmlText;
			if(html != ""&&_regLink)
				res = _regLink.exec(html);
			if (res == null)
				return html;
			else
				return res[1];
		}
		
		override public function set htmlText(value:String):void
		{
			if (value == null || value == "")
			{
				super.htmlText = "";
			} else
			{
				super.htmlText = "<a href='event:link'>" + value + "</a>";
			}
		}
		
		override public function set color(value:String):void
		{
			var style:StyleSheet = this.styleSheet;
			style.setStyle("color", value);
		}
		
		override public function set fontFamily(value:String):void
		{
			var style:StyleSheet = this.styleSheet;
			style.setStyle("fontFamily", value);
		}
		
		override public function set fontSize(value:int):void
		{
			var style:StyleSheet = this.styleSheet;
			style.setStyle("fontSize", value);
		}
		
		
		override public function set fontWeight(value:String):void
		{
			var style:StyleSheet = this.styleSheet;
			style.setStyle("fontWeight", value);
		}
		
		
		/**
		 * 设置鼠标点击事件相应方法
		 */
		public function set link(value:Function):void
		{
			_linkHandler = value;
		}
		
		public function Link(text:String = "", linkFunction:Function = null, color:uint = 0x0165ff, size:int = 12, bold:Boolean = false,
							 italic:Boolean = false, isAutoSize:Boolean = false, align:String = "left", selectable:Boolean = false,
							 letterSpacing:int = 0, filter:Boolean = false, filterColor:Number = 0x000000, filterBold:int = 1)
		{
			super();
			
			// 设置样式列表
			var style:StyleSheet = new StyleSheet();
			style.parseCSS("a{color:#FFCA12;text-decoration:underline;font-size:" + String(size) + "} a:hover{color:#FFFFFF;text-decoration:underline;}");
			this.styleSheet = style;
			
			this.text = text;
			
			this.mouseEnabled = true;
			// 注册事件
			addEventListener(TextEvent.LINK, linkHandler);
		}
		
		private function linkHandler(event:TextEvent):void
		{
			if (_linkHandler != null)
			{
				_linkHandler(event);
			}
		}
		
		override public function dispose():void
		{
			this._linkHandler = null;
			this._regLink = null;
			removeEventListener(TextEvent.LINK, linkHandler);
			super.dispose();
		}
		
		
	}
}