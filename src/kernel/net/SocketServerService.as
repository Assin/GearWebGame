package kernel.net
{
	import flash.utils.Dictionary;
	
	import kernel.configs.ApplicationConfig;
	import kernel.data.ServerServiceNameType;
	
	/**
	 * @name socket服务器服务
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 3:32:57 PM
	 */
	public class SocketServerService implements IServerService
	{
		private static var _instance:SocketServerService;
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
		
		public static function getInstance():SocketServerService
		{
			if (_instance == null)
			{
				_instance = new SocketServerService();
			}
			return _instance;
			
		}
		
		public function SocketServerService()
		{
		}
		
		public function init():void
		{
			this._messageCallBackMap = new Dictionary();
			this.connectorList = new Vector.<IServerConnector>();
			for each (var socketServerInfoVO:IServerInfoVO in ApplicationConfig.SOCKET_SERVER_LIST)
			{
				this.connectorList.push(this.createSocketServerConnectorBySocketServerInfo(socketServerInfoVO));
			}
		}
		
		/**
		 * 创建一个连接器通过连接信息
		 * @param value
		 * @return
		 *
		 */
		private function createSocketServerConnectorBySocketServerInfo(value:IServerInfoVO):IServerConnector
		{
			var socketServerConnector:IServerConnector = new SocketServerConnector(value);
			socketServerConnector.onResponseCallBack = response;
			return socketServerConnector;
		}
		
		/**
		 * 获得消息类的方法
		 */
		public function set messageClassCallBack(value:Function):void
		{
			this._messageClassCallBack = value;
			for each (var socketServerConnector:IServerConnector in connectorList)
			{
				socketServerConnector.getMessageClassCallBack = this.messageClassCallBack;
			}
		}
		
		/**
		 * 获得消息类的方法
		 */
		public function get messageClassCallBack():Function
		{
			return this._messageClassCallBack;
		}
		
		/**
		 * 添加一个连接器
		 * @param value
		 *
		 */
		public function addConnector(value:IServerInfoVO):void
		{
			var socketConnector:IServerConnector = this.createSocketServerConnectorBySocketServerInfo(value);
			socketConnector.getMessageClassCallBack = this.messageClassCallBack;
			this.connectorList.push(socketConnector);
		}
		
		/**
		 * 通过name 启动一个连接器
		 * @param name
		 *
		 */
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
		
		/**
		 * 通过名字获取一个连接器
		 * @param name
		 * @return
		 *
		 */
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
		
		/**
		 * 发送一个请求
		 * @param messageBase
		 * @param serverName
		 *
		 */
		public function request(messageBase:IMessageBase, serverName:String = ""):void
		{
			if (serverName == "")
			{
				serverName = ServerServiceNameType.LOGIC;
			}
			var connector:IServerConnector = this.getConnectorByName(serverName);
			if (connector != null)
			{
				connector.request(messageBase);
			}
		}
		
		public function requestTo(messageBase:IMessageBase, toURL:String, serverName:String):void
		{
		}
		
		/**
		 * 请求响应
		 * @param messageBase
		 * @param serverName
		 *
		 */
		public function response(messageBase:IMessageBase, serverName:String):void
		{
			this.invokeMessageCallBack(messageBase);
		}
		
		/**
		 * 调用消息返回的方法回调
		 * @param messageBase
		 *
		 */
		private function invokeMessageCallBack(messageBase:IMessageBase):void
		{
			var messageID:int = messageBase.messageID;
			var callbacks:Array = this._messageCallBackMap[messageID];
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
		public function subscribe(messageCode:int, callback:Function):void
		{
			if (callback == null)
			{
				return ;
			}
			var functionsArr:Array = this._messageCallBackMap[messageCode];
			if (functionsArr == null)
			{
				this._messageCallBackMap[messageCode] = [callback];
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
		public function unsubscribe(messageCode:int, callback:Function):void
		{
			var functionsArr:Array = this._messageCallBackMap[messageCode];
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