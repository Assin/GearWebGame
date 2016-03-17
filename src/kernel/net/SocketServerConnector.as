package kernel.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import kernel.events.KernelEventDispatcher;
	import kernel.events.ServerEvent;
	import kernel.runner.LogRunner;
	import kernel.utils.StringUtil;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * @name socket服务器连接器
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 3:53:58 PM
	 */
	public class SocketServerConnector implements IServerConnector
	{
		// 数据发送时间间隔
		private static const SEND_INTERVAL:uint = 25;
		// 尝试重新连接次数
//		private static const RECONNECT_TIMES:int = -1;
		// 尝试重新连接的时间间隔
//		private static const RECONNECT_INTERVAL:Number = 1000;
		//连接信息
		private var _socketServerInfoVO:SocketServerInfoVO;
		//连接器
		private var _socket:Socket;
		//返回数据缓存
		private var _responseByteCache:ServerByteArray;
		//是否正在解析返回的数据
		private var _isResolvingResponseByte:Boolean;
		
		private var _messageResolvingContentLength:int = -1;
		//发送计时器		
		private var _timer:EnterFrameTimer;
		//重新连接标记
		private var _reconnectFlag:uint;
		//重连接settimeout标记
		private var _timeoutErrorConnectID:uint = 0;
		//消息发送队列
		private var _messageQueue:Array = [];
		//返回回调函数
		private var _onResponseCallBack:Function;
		//获得消息类的方法
		private var _getMessageClassCallBack:Function;
		
		public function SocketServerConnector(socketServerInfoVO:IServerInfoVO)
		{
			this._socketServerInfoVO = socketServerInfoVO as SocketServerInfoVO;
		}
		
		public function set onResponseCallBack(value:Function):void
		{
			_onResponseCallBack = value;
		}
		
		/**
		 * 获得消息类的方法
		 */
		public function set getMessageClassCallBack(value:Function):void
		{
			this._getMessageClassCallBack = value;
		}
		
		/**
		 * 获得消息类的方法
		 */
		public function get getMessageClassCallBack():Function
		{
			return this._getMessageClassCallBack;
		}
		
		
		public function get name():String
		{
			return this._socketServerInfoVO.name;
		}
		
		
		public function get ip():String
		{
			return this._socketServerInfoVO.ip;
		}
		
		public function get port():int
		{
			return this._socketServerInfoVO.port;
		}
		
		/**
		 * 获取是否已经连接到服务器
		 */
		public function get connected():Boolean
		{
			if (this._socket == null)
			{
				return false;
			}
			return this._socket.connected;
		}
		
		/**
		 * 初始化并连接
		 *
		 */
		public function init():void
		{
			_timer = new EnterFrameTimer(SEND_INTERVAL);
			_timer.onTimer = onTimerHandler;
			_timer.start();
			
			_socket = new Socket();
			_socket.endian = Endian.LITTLE_ENDIAN;
			_socket.addEventListener(Event.CONNECT, onConnectHandler);
			_socket.addEventListener(IOErrorEvent.IO_ERROR, onErrorHandler);
			_socket.addEventListener(Event.CLOSE, onCloseHandler);
			_socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
			_socket.addEventListener(ProgressEvent.SOCKET_DATA, onGetDataHandler);
			
			//初始化缓存
			this._responseByteCache = new ServerByteArray();
			
			this.connect();
		}
		
		/**
		 * 关闭连接
		 *
		 */
		public function close():void
		{
			this.disconnect();
		}
		
		
		private function onTimerHandler():void
		{
			if (connected)
			{
				if (_messageQueue.length > 0)
				{
					var message:IMessageBase = _messageQueue.shift();
					var bytes:ByteArray = message.byteArray;
					
					// 输出调试信息
					LogRunner.log("****************************************************************");
					LogRunner.log("Message sended!");
					LogRunner.log("[Message]:\n" + message.toString());
					LogRunner.log("****************************************************************");
					
					// 发送消息
					_socket.writeBytes(bytes, 0, bytes.length);
					_socket.flush();
					
				}
			}
		}
		
		private function onConnectHandler(event:Event):void
		{
			// 显示提示信息
			LogRunner.log("Connect to server succeeded! " + this._socketServerInfoVO.toString());
			_reconnectFlag = 0;
			
			// 触发事件
			var evt:ServerEvent = new ServerEvent(ServerEvent.CONNECTED);
			evt.ip = ip;
			evt.port = port;
			KernelEventDispatcher.getInstance().dispatchEvent(evt);
		}
		
		private function onCloseHandler(event:Event):void
		{
			LogRunner.error("Server closed server...  " + this._socketServerInfoVO.toString());
			// 触发事件
			KernelEventDispatcher.getInstance().dispatchEvent(new ServerEvent(ServerEvent.DISCONNECTION));
		}
		
		private function onErrorHandler(event:Event):void
		{
			// 如果断开时不在登录状态则退回到登录状态再尝试重连
			LogRunner.error("IOError connect to server...  " + this._socketServerInfoVO.toString());
//			_timeoutErrorConnectID = setTimeout(connectOne, RECONNECT_INTERVAL);
			
			// 触发事件
			KernelEventDispatcher.getInstance().dispatchEvent(new ServerEvent(ServerEvent.DISCONNECTION));
		}
		
		private function onSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			// 当出现安全沙箱异常时直接无视
		}
		
		private function onGetDataHandler(event:ProgressEvent):void
		{
			if (this._socket.bytesAvailable > 0)
			{
				this._socket.readBytes(this._responseByteCache, this._responseByteCache.length, this._socket.bytesAvailable);
			}
			//如果没在解析，那么进入解析方法
			if (this._isResolvingResponseByte == false)
			{
				readData();
			}
		}
		
		private function readData():void
		{
			//表示正在解析数据
			this._isResolvingResponseByte = true;
			
			while (this._responseByteCache.bytesAvailable > 0)
			{
				//如果返回的数据大于头文件的20字节
				if (this._responseByteCache.bytesAvailable > 20)
				{
					if (_messageResolvingContentLength == -1)
					{
						this._responseByteCache.position = 16;
						_messageResolvingContentLength = this._responseByteCache.readShort();
					}
					//如果后面的数据大于等长度，那么解析
					if (this._responseByteCache.bytesAvailable >= _messageResolvingContentLength)
					{
						//将一个完整的数据二进制保存下来.
						var messageByteArray:ServerByteArray = new ServerByteArray();
						this._responseByteCache.position = 0;
						this._responseByteCache.readBytes(messageByteArray, 0, 20 + _messageResolvingContentLength);
						//清空之前的二进制数据
						var tempByteArray:ServerByteArray = new ServerByteArray();
						this._responseByteCache.readBytes(tempByteArray, 0, this._responseByteCache.bytesAvailable);
						this._responseByteCache.clear();
						this._responseByteCache = tempByteArray;
						this._responseByteCache.position = 0;
						_messageResolvingContentLength = -1;
						
						//处理回调
						messageByteArray.position = 6;
						var messageID:int = messageByteArray.readShort();
						messageByteArray.position = 0;
						var messageClass:Class = this.getMessageClass(messageID);
						if (messageClass != null)
						{
							var message:IMessageBase = new messageClass();
							message.byteArray = messageByteArray;
							// 输出调试信息
							LogRunner.log("================================================================");
							LogRunner.log("Message received!");
							LogRunner.log("[Message]:\n" + message.toString());
							LogRunner.log("================================================================");
							response(message);
						}
					} else
					{
						break;
					}
				} else
				{
					break;
				}
			}
			
			//表示停止解析数据
			this._isResolvingResponseByte = false;
		}
		
		private function connectOne():void
		{
			_timeoutErrorConnectID = 0;
//			if (_reconnectFlag >= RECONNECT_TIMES && RECONNECT_TIMES != -1)
//			{
//				_messageQueue = [];
//				LogRunner.error("Can't connect to Server.");
//				return ;
//			}
			
			// 显示提示信息
			LogRunner.warning(StringUtil.format("Trying Server [{0}:{1}] for the {2} time.", ip, port, _reconnectFlag + 1));
			// 连接服务器
			_socket.connect(ip, port);
			_reconnectFlag++;
		}
		
		/**
		 * 连接服务器
		 */
		public function connect():void
		{
			if (_timeoutErrorConnectID > 0)
				clearTimeout(_timeoutErrorConnectID);
			_timeoutErrorConnectID = 0;
			_reconnectFlag = 0;
			connectOne();
		}
		
		/**
		 * 断开连接
		 */
		public function disconnect():void
		{
			if (_timeoutErrorConnectID > 0)
				clearTimeout(_timeoutErrorConnectID);
			_timeoutErrorConnectID = 0;
			_socket.close();
			LogRunner.error("Client closed connect...  " + this._socketServerInfoVO.toString());
		}
		
		/**
		 * 使用消息类型获取消息类
		 * @param messageCode
		 * @return 获取到的消息类
		 */
		public function getMessageClass(messageCode:int):Class
		{
			return this._getMessageClassCallBack(messageCode);
		}
		
		
		public function request(messageBase:IMessageBase):void
		{
			if (!connected)
				connect();
			_messageQueue.push(messageBase);
		}
		
		public function response(messageBase:IMessageBase):void
		{
			_onResponseCallBack(messageBase, this.name);
		}
		
		
	}
}