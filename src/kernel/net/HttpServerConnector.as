package kernel.net
{
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import kernel.runner.LogRunner;
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * @name http请求或服务器的连接器
	 * @explain
	 * @author yanghongbin
	 * @create Oct 25, 2013
	 */
	public class HttpServerConnector implements IServerConnector
	{
		// 数据发送时间间隔
		private static const SEND_INTERVAL:uint = 100;
		
		private var _httpServerInfoVO:HttpServerInfoVO;
		private var _urlLoader:URLLoader;
//		private var _currentMessage:IHttpMessageBase;
		//获得消息类的方法
		private var _getMessageClassCallBack:Function;
		//返回回调函数
		private var _onResponseCallBack:Function;
		//消息队列
		private var _messageQueue:Vector.<IHttpMessageBase>;
		//发送计时器		
		private var _timer:EnterFrameTimer;
		/**存这是否log的对应关系*/
		private var _isLogDict:Dictionary;
		
		public function HttpServerConnector(httpServerInfoVO:IServerInfoVO)
		{
			_httpServerInfoVO = httpServerInfoVO as HttpServerInfoVO;
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
		
		
		public function init():void
		{
			_isLogDict = new Dictionary();
			
			_timer = new EnterFrameTimer(SEND_INTERVAL);
			_timer.onTimer = onTimerHandler;
			_timer.start();
			
			_urlLoader = new URLLoader();
			_messageQueue = new Vector.<IHttpMessageBase>();
			
		}
		
		public function get name():String
		{
			return _httpServerInfoVO.name;
		}
		
		public function request(messageBase:IMessageBase):void
		{
		}
		
		public function response(messageBase:IMessageBase):void
		{
		}
		
		
		public function requestByURLParameters(paramsArray:Array, onResponseCallBack:Function = null, requestMethod:String = URLRequestMethod.GET):void
		{
			try
			{
				var address:String = _httpServerInfoVO.address;
				var urlRequest:URLRequest = new URLRequest();
				var paramsStringArray:Array = [];
				
				for each (var vo:HttpRequestParameterVO in paramsArray)
				{
					paramsStringArray.push(vo.toURLFormat());
				}
				address += "?";
				address += paramsStringArray.join("&");
				urlRequest.url = address;
				this._urlLoader = new URLLoader();
				this._urlLoader.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					_urlLoader.removeEventListener(Event.COMPLETE, arguments.callee);
					_urlLoader.removeEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
					_urlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
					
					if (onResponseCallBack != null)
					{
						onResponseCallBack(e);
					}
				});
				this._urlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOErrorHandler);
				this._urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler);
				this._urlLoader.load(urlRequest);
				LogRunner.log(_httpServerInfoVO.name + ":" + urlRequest.url);
			} catch (error:SecurityError)
			{
				
			} catch (error:IOError)
			{
				
			} catch (error:Error)
			{
				
			}
		}
		
		private function onIOErrorHandler(e:IOErrorEvent):void
		{
			LogRunner.log(_httpServerInfoVO.name + ":" + e.text);
		}
		
		private function onSecurityErrorHandler(e:SecurityErrorEvent):void
		{
			LogRunner.log(_httpServerInfoVO.name + ":" + e.text);
		}
		
		private function onTimerHandler():void
		{
			if(_messageQueue.length>0)
			{
				var message:IHttpMessageBase = _messageQueue.shift();
				var _messageLoader:MessageLoader = new MessageLoader();
				_messageLoader.message = message;
				_messageLoader.addEventListener(Event.COMPLETE,onHttpCompleteHandler);
				_messageLoader.addEventListener(IOErrorEvent.IO_ERROR,onHttpIoErrorHandler);
				_messageLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,onHttpSecurityErrorHandler);
				var url:String = _httpServerInfoVO.address+message.messageType+message.getVariables();
				_messageLoader.load(new URLRequest(encodeURI(url)));
				
				
				if((_isLogDict[message.messageType] == null) || (_isLogDict[message.messageType] != null && Boolean(_isLogDict[message.messageType])) == true)
					LogRunner.log("[HTTP Connector Sended]: \n"+url+"\n"+message.toString()+"\n");
			}
		}
		/**
		 * 设置是否log的对应关系 
		 * @param messageType
		 * @param isLog
		 * 
		 */		
		public function setIsLog(messageType:String,isLog:Boolean):void
		{
			_isLogDict[messageType] = isLog;
		}
		
		public function requestHttp(messageBase:IHttpMessageBase):void
		{
			_messageQueue.push(messageBase);
		}
		
		private function onHttpIoErrorHandler(event:IOErrorEvent):void
		{
			var messageLoader:MessageLoader = event.currentTarget as MessageLoader;
			messageLoader.removeEventListener(Event.COMPLETE,onHttpCompleteHandler);
			messageLoader.removeEventListener(IOErrorEvent.IO_ERROR,onHttpIoErrorHandler);
			messageLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onHttpSecurityErrorHandler);
			var message:IHttpMessageBase = messageLoader.message;
			if((_isLogDict[message.messageType] == null) || (_isLogDict[message.messageType] != null && Boolean(_isLogDict[message.messageType])) == true)
				LogRunner.log("[HTTP Connector Io Error]: \n"+_httpServerInfoVO.address+message.messageType+" "+event.errorID+" "+event.text+"\n");
			ObjectPool.disposeObject(messageLoader);
		}
		
		private function onHttpSecurityErrorHandler(event:SecurityErrorEvent):void
		{
			var messageLoader:MessageLoader = event.currentTarget as MessageLoader;
			messageLoader.removeEventListener(Event.COMPLETE,onHttpCompleteHandler);
			messageLoader.removeEventListener(IOErrorEvent.IO_ERROR,onHttpIoErrorHandler);
			messageLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onHttpSecurityErrorHandler);
			var message:IHttpMessageBase = messageLoader.message;
			if((_isLogDict[message.messageType] == null) || (_isLogDict[message.messageType] != null && Boolean(_isLogDict[message.messageType])) == true)
				LogRunner.log("[HTTP Connector Security Error]: \n"+_httpServerInfoVO.address+message.messageType + ":" + event.text);
			ObjectPool.disposeObject(messageLoader);
		}
		
		protected function onHttpCompleteHandler(event:Event):void
		{
			var messageLoader:MessageLoader = event.currentTarget as MessageLoader;
			messageLoader.removeEventListener(Event.COMPLETE,onHttpCompleteHandler);
			messageLoader.removeEventListener(IOErrorEvent.IO_ERROR,onHttpIoErrorHandler);
			messageLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,onHttpSecurityErrorHandler);
			var message:IHttpMessageBase = messageLoader.message;
			var str:String = event.target.data;
			var _backMsgClass:Class = this.getMessageClass(message.messageType);
			var backMessage:IHttpMessageBase = new _backMsgClass();
			ObjectPool.disposeObject(messageLoader);
			try
			{
				backMessage.setJson(str);
				if((_isLogDict[message.messageType] == null) || (_isLogDict[message.messageType] != null && Boolean(_isLogDict[message.messageType])) == true)
				{
					LogRunner.log("[HTTP Connector Message Back Json]: \n"+str);
					LogRunner.log("[HTTP Connector Message back]: \n"+backMessage.toString()+"\n");
				}
			} 
			catch(error:Error) 
			{
				backMessage.success = false;
				if((_isLogDict[message.messageType] == null) || (_isLogDict[message.messageType] != null && Boolean(_isLogDict[message.messageType])) == true)
					LogRunner.error("[HTTP Connector Json Error]"+getQualifiedClassName(backMessage));
			}
			
			this.responseHttp(backMessage);
		}
		
		public function responseHttp(messageBase:IHttpMessageBase):void
		{
			_onResponseCallBack(messageBase, this.name);
		}
		
		
		/**
		 * 使用消息类型获取消息类
		 * @param messageCode
		 * @return 获取到的消息类
		 */
		public function getMessageClass(messageType:String):Class
		{
			return this._getMessageClassCallBack(messageType);
		}
		
		public function close():void
		{
			_urlLoader.close();
			_urlLoader = null;
		}
	}
}
