package kernel.utils
{
	import kernel.configs.ApplicationConfig;
	
	/**
	 * @name 加载器的工具类 主要负责资源数据的
	 * @explain
	 * @author yanghongbin
	 * @create Mar 8, 2012 2:48:46 PM
	 */
	public class KernelLoaderResourceDataUtil
	{
		
		/**
		 * 看开头是不是有remoteRoot路径
		 * @param value
		 * @return
		 *
		 */
		public static function hasResourceDataRemoteRootPathInStartsWith(str:String):Boolean
		{
			return StringUtil.startsWith(str, resourceDataRemoteRootPath);
		}
		
		/**
		 * 整理一个路径，将其自动加上远程根目录 ,已经有了就不加了
		 * @return
		 *
		 */
		public static function convertKeyToResourceDataRemotePath(str:String):String
		{
			//先转换为key
			var key:String = convertResourceDataRemotePathToKey(str);
			key = ApplicationConfig.RESOURCE_DATA_FOLDER + "/" + key;
			var s:String = ResourcePathRevisionUtil.convertVersionFilePath(key);
			str = ApplicationConfig.RESOURCE_ROOT_PATH + "/" + s;
			/*
			if (!hasResourceDataRemoteRootPathInStartsWith(str))
			{
			str = getResourceDataRemotePath(str);
			}
			*/
			return str;
		}
		
		/**
		 * 整理一个带有远程目录的路径 变为一个 key
		 * @param str
		 * @return
		 *
		 */
		public static function convertResourceDataRemotePathToKey(str:String):String
		{
			if (hasResourceDataRemoteRootPathInStartsWith(str))
			{
				str = str.substring(resourceDataRemoteRootPath.length + 1);
			}
			return str;
		}
		
		
		/**
		 * 根据当前路径 获取 远程地址
		 * @param filePath 当前路径
		 * @return 资源目录的远程根路径+当前路径
		 *
		 */
		public static function getResourceDataRemotePath(filePath:String):String
		{
			return resourceDataRemoteRootPath + "/" + filePath;
		}
		
		/**
		 * 获取远程的数据资源目录的根路径
		 * @return
		 *
		 */
		public static function get resourceDataRemoteRootPath():String
		{
			return ApplicationConfig.RESOURCE_ROOT_PATH + "/" + ApplicationConfig.RESOURCE_DATA_FOLDER;
		}
		
		public function KernelLoaderResourceDataUtil()
		{
		}
	}
}