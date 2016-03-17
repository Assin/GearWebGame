package kernel.display.components.tip.members
{
	import flash.display.BitmapData;
	
	import kernel.display.components.BitmapProxy;
	
	/**
	 * 文件名：TipBitmapProxy.as
	 * <p>
	 * 功能：
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 */
	public class TipBitmapProxy extends BitmapProxy implements ITipMember
	{
		public function TipBitmapProxy(url:String="", bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false)
		{
			super(url, bitmapData, pixelSnapping, smoothing);
		}
		
		public function resetLayout():void
		{
			scaleX = 1;
			scaleY = 1;
		}
	}
}