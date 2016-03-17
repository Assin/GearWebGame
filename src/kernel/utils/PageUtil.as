package kernel.utils
{
	
	/**
	 * @name 分页相关处理
	 * @explain
	 * @author yanghongbin
	 * @create Dec 12, 2012 4:37:17 PM
	 */
	public class PageUtil
	{
		
		public function PageUtil()
		{
		}
		
		/**
		 * 获取Array分页的内容，根据页数
		 * @param collection 数据源
		 * @param currentPage 要获取的页号    从1开始
		 * @param pageItemNum 每页的数量
		 * @return
		 *
		 */
		public static function getPageContentArray(collection:Array, currentPage:int, pageItemNum:int):Array
		{
			var startIndex:int = (currentPage - 1) * pageItemNum;
			var endIndex:int = currentPage * pageItemNum;
			return collection.slice(startIndex, endIndex);
		}
		
		/**
		 * 获取Vector分页的内容，根据页数
		 * @param collection 数据源
		 * @param currentPage 要获取的页号    从1开始
		 * @param pageItemNum 每页的数量
		 * @return
		 *
		 */
		public static function getPageContentVector(collection:Vector.<Object>, currentPage:int, pageItemNum:int):*
		{
			var startIndex:int = (currentPage - 1) * pageItemNum;
			var endIndex:int = currentPage * pageItemNum;
			return collection.slice(startIndex, endIndex);
		}
	}
}