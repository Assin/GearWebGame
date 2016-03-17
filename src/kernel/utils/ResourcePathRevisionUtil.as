package kernel.utils
{
	import flash.utils.Dictionary;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 20, 2012 11:45:41 AM
	 */
	public class ResourcePathRevisionUtil
	{
		public static var dict:Dictionary = new Dictionary();
		
		public function ResourcePathRevisionUtil()
		{
		}
		
		/**
		 * 解析版本号文本
		 * @param value
		 *
		 */
		public static function resolveRevisionText(value:String):void
		{
			var fileArray:Array = value.split("\n");
			var fileContent:String;
			var tempArray:Array;
			var filePathStr:String;
			var version:String;
			var liteFilePathArray:Array;
			
			for each (fileContent in fileArray)
			{
				tempArray = fileContent.split("|");
				filePathStr = tempArray[0];
				version = tempArray[1];
				liteFilePathArray = filePathStr.split("resource/");
				
				if (liteFilePathArray.length > 1)
				{
					dict[liteFilePathArray[1]] = version;
				} else
				{
					dict[liteFilePathArray[0]] = version;
				}
			}
		}
		
		public static function convertVersionFilePath(value:String):String
		{
			var arr:Array = value.split(".");
			var fileStr:String;
			var ext:String;
			ext = arr[arr.length - 1];
			arr.splice(arr.length - 1, 1);
			fileStr = arr.join(".");
			var versionFile:String;
			var dictVersion:String = dict[value];
			
			if (dictVersion == null || dictVersion == "")
			{
				versionFile = value;
			} else
			{
				versionFile = fileStr + "_" + dictVersion + "." + ext;
			}
			return versionFile;
		}
	}
}