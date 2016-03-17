package kernel.utils
{
	import kernel.configs.ApplicationConfig;
	
	/**
	 * @name 加载器的工具类 主要负责资源的
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 3, 2011 3:23:43 PM
	 */
	public class KernelLoaderResourceUtil
	{
		
		/**
		 * 看开头是不是有remoteRoot路径
		 * @param value
		 * @return
		 *
		 */
		public static function hasResourceRemoteRootPathInStartsWith(str:String):Boolean
		{
			return StringUtil.startsWith(str, resourceRemoteRootPath);
		}
		
		/**
		 * 整理一个路径，将其自动加上远程根目录 ,已经有了就不加了
		 * @return
		 *
		 */
		public static function convertKeyToResourceRemotePath(str:String):String
		{
			//先转换为key
			var key:String = convertResourceRemotePathToKey(str);
			key = ApplicationConfig.LANGUAGE + "/" + key;
			var s:String = ResourcePathRevisionUtil.convertVersionFilePath(key);
			str = ApplicationConfig.RESOURCE_ROOT_PATH + "/" + s;
			/*
			if (!hasResourceRemoteRootPathInStartsWith(str))
			{
			str = getResourceRemotePath(str);
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
		public static function convertResourceRemotePathToKey(str:String):String
		{
			if (hasResourceRemoteRootPathInStartsWith(str))
			{
				str = str.substring(resourceRemoteRootPath.length + 1);
			}
			return str;
		}
		
		
		/**
		 * 根据当前路径 获取 远程地址
		 * @param filePath 当前路径
		 * @return 资源目录的远程根路径+当前路径
		 *
		 */
		public static function getResourceRemotePath(filePath:String):String
		{
			return resourceRemoteRootPath + "/" + filePath;
		}
		
		public static function getVersionString():String
		{
			return String(ApplicationConfig.VERSION.split(".").join(""));
		}
		
		/**
		 * 获取远程的资源目录的根路径
		 * @return
		 *
		 */
		public static function get resourceRemoteRootPath():String
		{
			return ApplicationConfig.RESOURCE_ROOT_PATH + "/" + ApplicationConfig.LANGUAGE;
		}
		
		
		
		public function KernelLoaderResourceUtil()
		{
		}
	}
}