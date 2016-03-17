package kernel.display.components.animation
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	import kernel.IDispose;
	
	/**
	 * @name 序列图片信息
	 * @explain
	 * @author yanghongbin
	 * @create Dec 22, 2012 3:47:07 PM
	 */
	public class SerialAnimationBitmapData implements IDispose
	{
		public var name:String;
		public var frameIndex:uint;
		public var frameID:uint;
		public var bitmapData:BitmapData;
		public var offset:Point;
		public var label:String;
		public function SerialAnimationBitmapData()
		{
		}
		
		public function dispose():void
		{
			bitmapData = null;
			offset = null;
			label = null;
		}
	}
}