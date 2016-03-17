package kernel.runner
{
	import data.GameConfig;
	
	import flash.display.StageDisplayState;
	import flash.system.Capabilities;
	
	import kernel.configs.ApplicationConfig;
	import kernel.data.ServerServiceNameType;
	import kernel.net.HttpRequestParameterVO;
	import kernel.net.HttpServerService;
	import kernel.utils.ExternalUtil;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Oct 25, 2013
	 */
	public class PlatformRunner
	{
		public static const NONE:int = 0;
		/**
		 * gamebox平台ID，对应 application_config中的配置
		 */
		public static const GAMEBOX:int = 3;
		
		/**
		 * 服务器ID,测试服为1001，正式服平台通过URL参数传进来的
		 */
		public static var serverID:String = "1001";
		/**
		 * 游戏类型  12为SH   2013-11-7杨洪斌修改，根据最新的编号
		 */
		public static const gameType:String = "12";
		
		/**
		 * 点击收集信息日志  的 logotype 值。
		 */
		public static const collectInfoLogtype:String = "1";
		
		/**
		 * 资源(Flash)装载日志 的 logotype 值。
		 */
		public static const flashLoadLogtype:String = "2";
		
		/**
		 * 资源(Flash)装载错误日志的 logotype 值。
		 */
		public static const flashLoadErrorLogtype:String = "3";
		
		
		private static var _instance:PlatformRunner;
		
		public static function getInstance():PlatformRunner
		{
			if (_instance == null)
			{
				_instance = new PlatformRunner();
			}
			return _instance;
		}
		
		public function PlatformRunner()
		{
		}
		
		/**
		 * 点击收集信息日志(发送给地址12个参数  , 最后一个是我们自己加的是否是全屏)(调用时传参个数：2个)
		 * @param 第一个参数：stepParam 步骤的代号　(参考策划配表)
		 * @param 第二个参数： stepValue　步骤的值      (参考策划配表)
		 */
		public function collectInfo(stepParam:String , stepValue:String):void
		{
			
			var array:Array = [];
			var p:HttpRequestParameterVO;
			
			//第１个参数：
			p = new HttpRequestParameterVO();
			p.name = "platformId";
			p.value = GAMEBOX.toString();
			array.push(p);
			
			//第2个参数：
			p = new HttpRequestParameterVO();
			p.name = "gametype";
			p.value = gameType;
			array.push(p);
			
			//第3个参数：
			p = new HttpRequestParameterVO();
			p.name = "server";
			p.value = serverID;
			array.push(p);
			
			//第4个参数：
			p = new HttpRequestParameterVO();
			p.name = "logtype";
			p.value = collectInfoLogtype;
			array.push(p);
			
			//第5个参数：
			p = new HttpRequestParameterVO();
			p.name = "guid";
			p.value = GameConfig.userGUID;
			array.push(p);
			
			//第6个参数：
			p = new HttpRequestParameterVO();
			p.name = "username";
			p.value = GameConfig.platformUserAccount;
			array.push(p);
			
			//第7个参数：
			p = new HttpRequestParameterVO();
			p.name = "userid";
			p.value = GameConfig.platformUserID;
			array.push(p);
			
			//第8个参数：参数param代表步骤代号 请参照
			p = new HttpRequestParameterVO();
			p.name = "param";
			p.value = stepParam;
			array.push(p);
			
			//第9个参数：参数value代表对应步骤的值。
			p = new HttpRequestParameterVO();
			p.name = "value";
			p.value = stepValue;
			array.push(p);
			
			//第10个参数：resolution代表分辨率  规则：只能以数字、星号(*)组成。Eg：600*800
			p = new HttpRequestParameterVO();
			p.name = "resolution";
			p.value = Capabilities.screenResolutionX.toString()+"*"+Capabilities.screenResolutionY.toString();
			array.push(p);
			
			//第11个参数：version（版本号）规则：只能以字母、数字、英文下划线（_）、英文点（.）组成。Eg: V1.0_13_0801
			p = new HttpRequestParameterVO();
			p.name = "version";
			p.value = ApplicationConfig.VERSION;
			array.push(p);
			
			//第12个参数： 是否是全屏   "0" 不是全屏，“1“　是全屏。
			p = new HttpRequestParameterVO();
			p.name = "isFullScreen";
			p.value = (StageRunner.getInstance().stage.displayState == StageDisplayState.NORMAL) ? "0" : "1";
			array.push(p);
			
			HttpServerService.getInstance().requestToURL(ServerServiceNameType.HTTP_GAMEBOXLOG, array);
			
		}
		
		
		/**
		 * 资源(Flash)装载日志(发送给地址13个参数)(调用时传参个数：3个参数)
		 * @param 第一个参数：moduleID       代表加载模块ID，(参考配表，程序定的)
		 * @param 第二个参数：moduleLoadStep 代表模块加载顺序  (参考配表，程序定的)
		 * @param 第三个参数：loadTimeLen    代表该模块装载时长，单位为毫秒，例如：202 (程序埋点算出来的)
		 */
		public function flashLoad(moduleID:String , moduleLoadStep:String , loadTimeLen:String):void
		{
					
			var array:Array = [];
			var p:HttpRequestParameterVO;
			
			//第１个参数：
			p = new HttpRequestParameterVO();
			p.name = "platformId";
			p.value = GAMEBOX.toString();
			array.push(p);
			
			//第2个参数：
			p = new HttpRequestParameterVO();
			p.name = "gametype";
			p.value = gameType;
			array.push(p);
			
			//第3个参数：
			p = new HttpRequestParameterVO();
			p.name = "server";
			p.value = serverID;
			array.push(p);
			
			//第4个参数：
			p = new HttpRequestParameterVO();
			p.name = "logtype";
			p.value = flashLoadLogtype;
			array.push(p);
			
			//第5个参数：browser代表浏览器类型，例如：IE7；
			p = new HttpRequestParameterVO();
			p.name = "browser";
			p.value = ExternalUtil.call("userBrowser");
			array.push(p);
			
			//第6个参数：代表操作系统类型，例如：xp；
			p = new HttpRequestParameterVO();
			p.name = "os";
			p.value = Capabilities.os;
			array.push(p);
			
			//第7个参数：代表资源(Flash)版本，例如：10.0.1；
			p = new HttpRequestParameterVO();
			p.name = "flashversion";
			p.value = Capabilities.version;
			array.push(p);
			
			//第8个参数：代表是否为首次加载，(注释：0表示新玩家首次加载，1表示老玩家加载)；
			p = new HttpRequestParameterVO();
			p.name = "firstload";
			p.value = GameConfig.isFirstLogin ? "0" : "1";
			array.push(p);
			
			//第9个参数：代表加载模块ID，说明：module代表加载的模块，每个游戏加载的模块都不一样，所以需要游戏提供一份模块ID和模块名称对应的表。每次有模块加载顺序改变时，日志中loadseq也要相应更新。
			p = new HttpRequestParameterVO();
			p.name = "module";
			p.value = moduleID;
			array.push(p);
			
			//第10个参数：代表模块加载顺序，说明：module代表加载的模块，每个游戏加载的模块都不一样，所以需要游戏提供一份模块ID和模块名称对应的表。每次有模块加载顺序改变时，日志中loadseq也要相应更新。
			p = new HttpRequestParameterVO();
			p.name = "loadseq";
			p.value = moduleLoadStep;
			array.push(p);
			
			
			
			//第11个参数：代表该模块装载时长，单位为毫秒，例如：202
			p = new HttpRequestParameterVO();
			p.name = "timelen";
			p.value = loadTimeLen;
			array.push(p);
			
			//第12个参数：代表当前玩家的uid，即玩家的平台ID
			p = new HttpRequestParameterVO();
			p.name = "userid";
			p.value = GameConfig.platformUserID;
			array.push(p);
			
			//第13个参数：（版本号）规则：只能以字母、数字、英文下划线（_）、英文点（.）组成。Eg: V1.0_13_0801
			p = new HttpRequestParameterVO();
			p.name = "version";
			p.value = ApplicationConfig.VERSION;
			array.push(p);
			
			HttpServerService.getInstance().requestToURL(ServerServiceNameType.HTTP_GAMEBOXLOG, array);
			
		}
		
		
		/**
		 * 资源(Flash)加载错误日志(发送给地址12个参数) (调用时传参个数：2个参数)
		 * @param 第一个参数：loadURL:String    加载资源的路径
		 * @param 第二个参数：loadURLKey:String 程序中使用的资源路径key
		 */
		public function flashLoadError(loadURL:String , loadURLKey:String):void
		{
			
			var array:Array = [];
			var p:HttpRequestParameterVO;
			
			//第１个参数：
			p = new HttpRequestParameterVO();
			p.name = "platformId";
			p.value = GAMEBOX.toString();
			array.push(p);
			
			//第2个参数：
			p = new HttpRequestParameterVO();
			p.name = "gametype";
			p.value = gameType;
			array.push(p);
			
			//第3个参数：
			p = new HttpRequestParameterVO();
			p.name = "server";
			p.value = serverID;
			array.push(p);
			
			//第4个参数：
			p = new HttpRequestParameterVO();
			p.name = "logtype";
			p.value = flashLoadErrorLogtype;
			array.push(p);
			
			//第5个参数：browser代表浏览器类型，例如：IE7；
			p = new HttpRequestParameterVO();
			p.name = "browser";
			p.value = ExternalUtil.call("userBrowser");
			array.push(p);
			
			//第6个参数：代表操作系统类型，例如：xp；
			p = new HttpRequestParameterVO();
			p.name = "os";
			p.value = Capabilities.os;
			array.push(p);
			
			//第7个参数：代表资源(Flash)版本，例如：10.0.1；
			p = new HttpRequestParameterVO();
			p.name = "flashversion";
			p.value = Capabilities.version;
			array.push(p);
			
			//第8个参数：代表是否为首次加载，(注释：0表示新玩家首次加载，1表示老玩家加载)；
			p = new HttpRequestParameterVO();
			p.name = "firstload";
			p.value = GameConfig.isFirstLogin ? "0" : "1";
			array.push(p);
			
			//第9个参数：加载资源的路径
			p = new HttpRequestParameterVO();
			p.name = "loadURL";
			p.value = loadURL;
			array.push(p);
			
			//第10个参数：程序中使用的资源路径key
			p = new HttpRequestParameterVO();
			p.name = "loadURLKey";
			p.value = loadURLKey;
			array.push(p);
			
			//第11个参数：代表当前玩家的uid，即玩家的平台ID
			p = new HttpRequestParameterVO();
			p.name = "userid";
			p.value = GameConfig.platformUserID;
			array.push(p);
			
			//第12个参数：（版本号）规则：只能以字母、数字、英文下划线（_）、英文点（.）组成。Eg: V1.0_13_0801
			p = new HttpRequestParameterVO();
			p.name = "version";
			p.value = ApplicationConfig.VERSION;
			array.push(p);
			
			HttpServerService.getInstance().requestToURL(ServerServiceNameType.HTTP_GAMEBOXLOG, array);
			
		}
		
		
		public function sendLog():void
		{
			//以下是发送事例代码
			var array:Array = [];
			var p:HttpRequestParameterVO;
			p = new HttpRequestParameterVO();
			p.name = "testuser";
			p.value = "yanghongbin";
			array.push(p);
			
			p = new HttpRequestParameterVO();
			p.name = "foo";
			p.value = "fighter";
			array.push(p);
			HttpServerService.getInstance().requestToURL(ServerServiceNameType.HTTP_GAMEBOXLOG, array);
		}
	}
}
