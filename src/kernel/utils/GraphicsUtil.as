package kernel.utils
{
	import flash.display.Graphics;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Dec 2, 2011 10:54:58 AM
	 */
	public class GraphicsUtil
	{
		
		public static function drawRect(graphics:Graphics, x:Number, y:Number, width:Number, height:Number, color:uint = 0x000000,
										alpha:Number = 1):void
		{
			graphics.beginFill(color, alpha);
			graphics.drawRect(x, y, width, height);
			graphics.endFill();
		}
		
		public function GraphicsUtil()
		{
		}
	}
}