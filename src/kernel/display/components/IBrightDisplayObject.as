package kernel.display.components
{
	import flash.geom.Rectangle;
	
	/**
	 * 高亮显示的显示对象接口，用于教学指引里使用
	 * @author yanghongbin
	 *
	 */
	public interface IBrightDisplayObject
	{
		/**
		 * 获取该对象高亮矩形
		 * @return
		 *
		 */
		function getBrightRectangle():Rectangle;
		/**
		 * 指引物体名，需要开发的时候手动注册填入
		 * @return
		 *
		 */
		function get brightName():String;
		/**
		 * 指引物体名，需要开发的时候手动注册填入
		 * @return
		 *
		 */
		function set brightName(value:String):void;
	}
}