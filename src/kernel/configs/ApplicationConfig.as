package kernel.configs
{
	import flash.utils.Dictionary;
	
	import kernel.net.HttpServerInfoVO;
	import kernel.net.SocketServerInfoVO;
	import kernel.utils.StringUtil;
	
	/**
	 * @name 程序的基本配置信息存储
	 * @explain
	 * @author yanghongbin
	 * @create Oct 26, 2012 6:11:51 PM
	 */
	public class ApplicationConfig
	{
		/**
		 * 版本号
		 */
		public static var VERSION:String = "";
		/**
		 * 资源根路径
		 */
		public static var RESOURCE_ROOT_PATH:String = "";
		/**
		 * 资源目录中的共用数据目录名
		 */
		public static var RESOURCE_DATA_FOLDER:String = "data";
		/**
		 * 使用的语言
		 */
		public static var LANGUAGE:String = "";
		/**
		 * 主配置文件路径
		 */
		public static const CONFIG_PATH:String = "config/application_config.xml";
		/**
		 * 是否DEBUG调试
		 */
		public static var DEBUG:Boolean = false;
		/**
		 * 是否输出LOG
		 */
		public static var LOG_OUTPUT:Boolean = false;
		/**
		 * socket连接服务器的列表
		 */
		public static var SOCKET_SERVER_LIST:Vector.<SocketServerInfoVO> = new Vector.<SocketServerInfoVO>();
		/**
		 * http服务器的列表
		 */
		public static var HTTP_SERVER_LIST:Vector.<HttpServerInfoVO> = new Vector.<HttpServerInfoVO>();
		/**
		 * 对应平台  没有写0
		 */
		public static var PLATFORM:int;
		/**
		 * 初始化加载资源列表
		 * key 队列的名字，在配置文件中写
		 * value 数组,存放这个队列的内容
		 */
		public static var INIT_LOAD_RESOURCE_LIST:Dictionary = new Dictionary();
		/**
		 * 布局信息XML
		 */
		public static var LAYOUT_DAT_XML:XML;
		/**
		 * 配置数据object
		 */
		public static var DATA_SHEETS_DAT:Object;
		
		/**
		 * 充值地址
		 */
		public static var PAY_ADDRESS:String;
		
		/**
		 * 服务端时区
		 */
		public static var SEVER_ZONE:int;
//		public static var GAME_TASK_SERVER_ADDRESS:String = "";
		
		public function ApplicationConfig()
		{
		}
		
		public static function resolve(config:XML):void
		{
			VERSION = config.child("version").toString();
			RESOURCE_ROOT_PATH = config.child("ResourcesRootPath").toString();
			LANGUAGE = config.child("Language").toString();
			PLATFORM = int(config.child("platform"))
			DEBUG = int(config.child("debug")) == 1 ? true : false;
			LOG_OUTPUT = int(config.child("log")) == 1 ? true : false;
			
			//socket服务器列表解析
			for each (var socketServerItem:XML in config.child("socketServerList").child("serverIP"))
			{
				var socketServerInfoVO:SocketServerInfoVO = new SocketServerInfoVO();
				socketServerInfoVO.name = String(socketServerItem.@name);
				socketServerInfoVO.ip = String(socketServerItem.@ip);
				socketServerInfoVO.port = int(socketServerItem.@port);
				SOCKET_SERVER_LIST.push(socketServerInfoVO);
			}	
			
			//http服务器列表解析
			for each (var httpServerItem:XML in config.child("httpServerList").child("http"))
			{
				var httpServerInfoVO:HttpServerInfoVO = new HttpServerInfoVO();
				httpServerInfoVO.name = String(httpServerItem.@name).toLowerCase();
				httpServerInfoVO.address = String(httpServerItem.@address);
				HTTP_SERVER_LIST.push(httpServerInfoVO);
			}
			
			//客服系统服务器ip初始化
//			GAME_TASK_SERVER_ADDRESS = config.gameTaskServer.http.@address;
			
			//充值地址
			PAY_ADDRESS = config.payAddress.http.@address;
			
			
			//加载资源解析
			for each (var loadQueue:XML in config.child("loadList").child("queue"))
			{
				var queueName:String = loadQueue.@name;
				var queueArray:Array = [];
				var fileTempName:String = "";
				var filePath:String = "";
				var fileType:String = "";
				var urlArray:Array;
				var url:String = "";
				
				for each (var fileXML:XML in loadQueue.child("file"))
				{
					fileTempName = fileXML.toString();
					fileTempName = StringUtil.replace(fileTempName, "${Language}", LANGUAGE);
					filePath = fileXML.@path;
					fileType = String(fileXML.@type).toLowerCase();
					filePath = StringUtil.replace(filePath, "${ResourcesRootPath}", RESOURCE_ROOT_PATH);
					filePath = StringUtil.replace(filePath, "${Language}", LANGUAGE);
					
					if (filePath == "")
					{
						urlArray = [fileTempName];
					} else
					{
						urlArray = [filePath, fileTempName];
					}
					url = urlArray.join("/");
					queueArray.push({name:fileTempName, path:filePath, url:url, type:fileType});
				}
				INIT_LOAD_RESOURCE_LIST[queueName] = queueArray
			}
		}
		
		public static function getLoadFileTypeByFileName(target:Array, name:String):String
		{
			for each (var file:Object in target)
			{
				if (file["name"] == name)
				{
					return file["type"];
				}
			}
			return "";
		}
	}
}