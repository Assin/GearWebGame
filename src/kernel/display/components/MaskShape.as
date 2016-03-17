package kernel.display.components
{
	
	import flash.display.Shape;
	
	import kernel.IDispose;
	
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Dec 1, 2011 6:25:18 PM
	 */
	public class MaskShape extends Shape implements IDispose
	{
		
		public function MaskShape()
		{
			super();
		}
		
		public function drawRect(x:Number, y:Number, width:Number, height:Number, color:uint = 0x000000, alpha:Number = 0):void
		{
			this.graphics.clear();
			this.graphics.beginFill(color, alpha);
			this.graphics.drawRect(x, y, width, height);
			this.graphics.endFill();
		}
		
		public function drawCircle(x:Number, y:Number, r:Number):void
		{
			this.graphics.clear();
			this.graphics.beginFill(0x000000, 0);
			this.graphics.drawCircle(x, y, r);
			this.graphics.endFill();
		}
		
		public function dispose():void
		{
			this.graphics.clear();
		}
		
		
	}
}