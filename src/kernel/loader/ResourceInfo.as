package kernel.loader
{
	
	/**
	 * @name 资源描述信息VO
	 * @explain
	 * @author yanghongbin
	 * @create Mar 14, 2012 6:48:15 PM
	 */
	public class ResourceInfo
	{
		/**
		 * 路径KEY
		 */
		public var pathKey:String;
		/**
		 * 加载资源的类型 详见<ResourceType>
		 */
		public var type:String;
		
		public function ResourceInfo(_pathKey:String, _type:String)
		{
			this.pathKey = _pathKey;
			this.type = _type;
		}
	}
}