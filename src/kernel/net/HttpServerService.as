package kernel.net
{
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	
	
	import kernel.configs.ApplicationConfig;
	import kernel.data.ServerServiceNameType;
	
	
	/**
	 * @name http服务器服务,http地址请求等
	 * @explain
	 * @author yanghongbin
	 * @create Oct 25, 2013
	 */
	public class HttpServerService implements IServerService
	{
		private static var _instance:HttpServerService;
		
		/**
		 * 连接集合
		 */
		private var connectorList:Vector.<IServerConnector>
		/**
		 * 消息回调集合
		 */
		private var _messageCallBackMap:Dictionary;
		/**
		 * 获得消息类的方法
		 */
		private var _messageClassCallBack:Function;
		
		private var _initMessageVariablesDict:Dictionary;
		
		public static function getInstance():HttpServerService
		{
			if (_instance == null)
			{
				_instance = new HttpServerService();
			}
			return _instance;
			
		}
		
		public function HttpServerService()
		{
		}
		
		public function init():void
		{
			this._messageCallBackMap = new Dictionary();
			_initMessageVariablesDict = new Dictionary();
			if (connectorList == null)
			{
				this.connectorList = new Vector.<IServerConnector>();
				
				for each (var httpServerInfoVO:IServerInfoVO in ApplicationConfig.HTTP_SERVER_LIST)
				{
					this.addConnector(httpServerInfoVO);
				}
			}
		}
		
		public function set messageClassCallBack(value:Function):void
		{
			this._messageClassCallBack = value;
			for each (var socketServerConnector:IServerConnector in connectorList)
			{
				socketServerConnector.getMessageClassCallBack = this.messageClassCallBack;
			}
		}
		
		public function get messageClassCallBack():Function
		{
			return this._messageClassCallBack;
		}
		
		public function addConnector(value:IServerInfoVO):void
		{
			var httpServerConnector:IServerConnector = new HttpServerConnector(value);
			httpServerConnector.getMessageClassCallBack = this.messageClassCallBack;
			httpServerConnector.onResponseCallBack = responseHttp;
			connectorList.push(httpServerConnector);
		
		}
		
		public function startupConnectorByName(name:String):void
		{
			if (name == null || name == "")
			{
				return ;
			}
			var connector:IServerConnector = this.getConnectorByName(name);
			
			if (connector != null)
			{
				connector.init();
			}
		}
		
		public function closeConnectorByName(name:String):void
		{
			if (name == null || name == "")
			{
				return ;
			}
			var connector:IServerConnector = this.getConnectorByName(name);
			
			if (connector != null)
			{
				connector.close();
			}
		}
		
		public function getConnectorByName(name:String):IServerConnector
		{
			for each (var connector:IServerConnector in this.connectorList)
			{
				if (connector.name == name)
				{
					return connector;
				}
			}
			return null;
		}
		
		public function request(messageBase:IMessageBase, serverName:String = ""):void
		{

		}
		
		public function requestTo(messageBase:IMessageBase, toURL:String, serverName:String):void
		{
		}
		
		public function response(messageBase:IMessageBase, serverName:String):void
		{
		}
		
		public function subscribe(messageCode:int, callback:Function):void
		{

		}
		
		public function unsubscribe(messageCode:int, callback:Function):void
		{
		}
		
		/**
		 * 设置是否log的对应关系 
		 * @param serverName
		 * @param messageType
		 * @param isLog
		 * 
		 */		
		public function setIsLog(serverName:String,messageType:String,isLog:Boolean):void
		{
			var httpServerConnector:HttpServerConnector = this.getConnectorByName(serverName)as HttpServerConnector;
			if(httpServerConnector!= null)
			{
				httpServerConnector.setIsLog(messageType,isLog);
			}
		}
		
		/**
		 * 请求到一个服务器，并且带有参数
		 * @param serverName
		 * @param paramsObj
		 *
		 */
		public function requestToURL(serverName:String, paramsArray:Array, onResponseCallBack:Function = null, method:String = URLRequestMethod.GET):void
		{
			var httpServerConnector:HttpServerConnector = this.getConnectorByName(serverName)as HttpServerConnector;
			httpServerConnector.requestByURLParameters(paramsArray, onResponseCallBack, method);
			
		}
		/**
		 * 发送消息 
		 * @param messageBase 消息
		 * @param serverName
		 * 
		 */
		public function requestHttp(messageBase:IHttpMessageBase, serverName:String = ""):void
		{
			if (serverName == "")
			{
				serverName = ServerServiceNameType.GAME_TASK;
			}
			var connector:IServerConnector = this.getConnectorByName(serverName);
			if (connector != null)
			{
				if(connector is HttpServerConnector)
				{
					if(_initMessageVariablesDict[serverName] != null)
					{
						messageBase.setInitVariables(_initMessageVariablesDict[serverName]);
					}
					HttpServerConnector(connector).requestHttp(messageBase);
				}
			}
		}
		
		public function setInitMessageVariables(initMessageVariables:IInitMessageVariables):void
		{
			_initMessageVariablesDict[initMessageVariables.serverName] = initMessageVariables;
		}
		
		public function responseHttp(messageBase:IHttpMessageBase, serverName:String):void
		{
			this.invokeMessageCallBack(messageBase);
		}
		
		/**
		 * 调用消息返回的方法回调
		 * @param messageBase
		 *
		 */
		private function invokeMessageCallBack(messageBase:IHttpMessageBase):void
		{
			var messageType:String = messageBase.messageType;
			var callbacks:Array = this._messageCallBackMap[messageType];
			if (callbacks != null)
			{
				var length:int = callbacks.length;
				while (--length > -1)
				{
					callbacks[length](messageBase);
				}
			}
		}
		/**
		 * 订阅消息回调函数
		 * @param messageID
		 * @param callBackFunction
		 *
		 */
		public function subscribeHttp(messageType:String, callback:Function):void
		{
			if (callback == null)
			{
				return ;
			}
			var functionsArr:Array = this._messageCallBackMap[messageType];
			if (functionsArr == null)
			{
				this._messageCallBackMap[messageType] = [callback];
			} else
			{
				if (functionsArr.indexOf(callback) <= -1)
				{
					functionsArr.unshift(callback);
				}
			}
		}
		
		/**
		 * 取消订阅消息回调函数
		 * @param messageID
		 * @param callBackFunction
		 *
		 */
		public function unsubscribeHttp(messageType:String, callback:Function):void
		{
			var functionsArr:Array = this._messageCallBackMap[messageType];
			if (functionsArr != null)
			{
				var index:int = functionsArr.indexOf(callback);
				if (index >= 0)
				{
					functionsArr.splice(index, 1);
				}
			}
		}
		
		
	}
}
