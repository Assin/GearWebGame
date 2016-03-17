package kernel.data
{
	
	/**
	 * @name 位置常量，主要是几种方向的数字表示
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Sep 8, 2011 4:27:47 PM
	 */
	public class DirectionType
	{
		/**
		 * 无方向
		 */
		public static const NONE:int = 0;
		/**
		 * 上
		 */
		public static const TOP:int = 1;
		/**
		 * 右上角
		 */
		public static const RIGHT_TOP_CORNER:int = 2;
		/**
		 * 右
		 */
		public static const RIGHT:int = 4;
		/**
		 * 右下角
		 */
		public static const RIGHT_BOTTOM_CORNER:int = 8;
		/**
		 * 下
		 */
		public static const BOTTOM:int = 16;
		/**
		 * 左下角
		 */
		public static const LEFT_BOTTOM_CORNER:int = 32;
		/**
		 * 左
		 */
		public static const LEFT:int = 64;
		/**
		 * 左上角
		 */
		public static const LEFT_TOP_CORNER:int = 128;
		
		/**
		 * 上，右
		 */
		public static const TOP_RIGHT:int = TOP | RIGHT;
		/**
		 * 右，下
		 */
		public static const RIGHT_BOTTOM:int = RIGHT | BOTTOM;
		/**
		 * 下，左
		 */
		public static const BOTTOM_LEFT:int = BOTTOM | LEFT;
		/**
		 * 左，上
		 */
		public static const LEFT_TOP:int = LEFT | TOP;
		
		/**
		 * 上，右，左
		 */
		public static const TOP_RIGHT_LEFT:int = TOP | RIGHT | LEFT;
		/**
		 * 上，右，下
		 */
		public static const TOP_RIGHT_BOTTOM:int = TOP | RIGHT | BOTTOM;
		/**
		 * 右，下，左
		 */
		public static const RIGHT_BOTTOM_LEFT:int = RIGHT | BOTTOM | LEFT;
		/**
		 * 上，下，左
		 */
		public static const TOP_BOTTOM_LEFT:int = TOP | BOTTOM | LEFT;
		
		/**
		 * 左，右
		 */
		public static const LEFT_RIGHT:int = LEFT | RIGHT;
		/**
		 * 上下
		 */
		public static const TOP_BOTTOM:int = TOP | BOTTOM;
		
		/**
		 * 左上角，右上角
		 */
		public static const LEFT_TOP_CORNER_RIGHT_TOP_CORNER:int = LEFT_TOP_CORNER |
			RIGHT_TOP_CORNER;
		/**
		 * 左下角，右下角
		 */
		public static const LEFT_BOTTOM_CORNER_RIGHT_BOTTOM_CORNER:int = LEFT_BOTTOM_CORNER |
			RIGHT_BOTTOM_CORNER;
		
		/**
		 * 直角的坐标全方向 比如 上，下，左，右拼成
		 */
		public static const ALL_90:int = TOP | RIGHT | BOTTOM | LEFT;
		/**
		 * 斜角的坐标全方向 比如 左上，右上，左下，右下拼成
		 */
		public static const ALL_45:int = RIGHT_TOP_CORNER | RIGHT_BOTTOM_CORNER |
			LEFT_BOTTOM_CORNER | LEFT_TOP_CORNER;
		
		
		
		public function DirectionType()
		{
		}
	}
}