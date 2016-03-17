package kernel.display.components.tip.members
{
	import flash.display.Shape;
	import flash.filters.DropShadowFilter;
	import flash.text.TextFieldAutoSize;
	
	import kernel.display.components.text.TextFieldProxy;

	public class TipMultiTextDisplay extends BaseTipCustomDisplay
	{
		private var MAX_WIDTH:Number = 250;
		public function TipMultiTextDisplay()
		{
			_dropShadow = new DropShadowFilter();
			_dropShadow.color =0x000000;
			_dropShadow.alpha = 0.75;
			_dropShadow.distance = 1;
			_dropShadow.strength = 2;
			_dropShadow.angle = 90;
			
		}
		
		/**
		 * 形如 var textList:Vector.<String> =  ["aaa","bbb","ccc"]
		 * @param data
		 * 
		 */		
		public override function addData(data:*):void
		{
			var textList:Vector.<String> = Vector.<String>(data);
			
			addSpace(10);
			for(var i:int = 0;i<textList.length;i++)
			{
				addText(textList[i]);
				addSpace(4);
			}
			
		}
		
		
		private var _dropShadow:DropShadowFilter;
		
		/**
		 *添加空行 
		 * @param height
		 * 
		 */		
		private function addSpace(height:Number = 3):void
		{
			var _y:Number = 0;
			
			for(var i:int = 0;i<displayList.length;i++)
			{
				if(_y <= displayList[i].y+displayList[i].height)
				{
					_y = displayList[i].y+displayList[i].height;
				}
			}
			
			var space:Shape = new Shape();
			space.graphics.beginFill(0x000000,0);
			space.graphics.drawRect(0,0,MAX_WIDTH,height);
			space.graphics.endFill();
			space.y = _y;
			this.displayList.push(space);
		}
		
		
		public function addText(value:String):void
		{
			var textField:TextFieldProxy = new TextFieldProxy();
			textField.font = "Arial";
			textField.fontSize = 12;
			textField.color = "#cbe4f2";
			textField.filters = [_dropShadow];
			
			textField.multiline = true;
			textField.wordWrap = true;
			
			textField.width = MAX_WIDTH;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = value;
			var _y:Number = 0;
			
			for(var i:int = 0;i<displayList.length;i++)
			{
				if(_y <= displayList[i].y+displayList[i].height)
				{
					_y = displayList[i].y+displayList[i].height;
				}
			}
			
			textField.y = _y;
			textField.x = 4;
			
			this.displayList.push(textField);
		}
	}
}