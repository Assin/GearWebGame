package kernel
{
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.system.Security;
	
	import kernel.configs.ApplicationConfig;
	import kernel.data.ResourceType;
	import kernel.data.ServerServiceNameType;
	import kernel.display.components.tip.TipRunner;
	import kernel.errors.KernelErrorRunner;
	import kernel.events.KernelEventDispatcher;
	import kernel.events.ServerEvent;
	import kernel.loader.KernelSWFEncryptionLoader;
	import kernel.net.HttpServerService;
	import kernel.net.SocketServerService;
	import kernel.runner.BaseKeyPressRunner;
	import kernel.runner.LayerRunner;
	import kernel.runner.LogRunner;
	import kernel.runner.PlatformRunner;
	import kernel.runner.ResourcesRunner;
	import kernel.runner.StageRunner;
	import kernel.runner.TickRunner;
	import kernel.utils.KernelLoaderResourceDataUtil;
	import kernel.utils.KernelLoaderResourceUtil;
	import kernel.utils.ObjectPool;
	import kernel.utils.ResourcePathRevisionUtil;
	
	import org.gearloader.events.GLoaderEvent;
	import org.gearloader.loader.GBaseLoader;
	import org.gearloader.loader.GBinaryLoader;
	import org.gearloader.loader.GQueueLoader;
	import org.gearloader.loader.GSWFLoader;
	import org.gearloader.loader.GTextLoader;
	
	/**
	 * @name 程序的核心，主入口程序继承此类
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 12:30:15 PM
	 */
	public class ApplicationKernel extends Sprite implements IDispose
	{
		/**
		 * 配置文件加载器
		 */
		private var _applicationConfigURLLoader:URLLoader;
		/**
		 * 初始化加载器
		 */
		protected var _coreLoader:GQueueLoader;
		/**
		 * 当前正在加载的队列名称，为""就是没有在加载
		 */
		protected var currentLoadQueueName:String = "";
		
		public function ApplicationKernel()
		{
			super();
			
			Security.allowDomain("*");
			Security.allowInsecureDomain("*");
			
			if (this.stage)
			{
				this.initRevision(initConfig);
			} else
			{
				this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			}
		}
		
		protected function onAddedToStageHandler(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			this.initRevision(initConfig);
		}
		
		protected function initRevision(onComplete:Function):void
		{
			ResourcesRunner.getInstance().init();
			var revisionFile:String = "";
			
			if (getRevisionable())
			{
				revisionFile = getApplicationURL() + "/" + "revision_" + loaderInfo.parameters["revisionVersion"] + "." + "binary";
				ResourcesRunner.getInstance().getRevisionFile(revisionFile, onComplete);
			} else
			{
				onComplete();
			}
		}
		
		private function getRevisionable():Boolean
		{
			return (loaderInfo.parameters["revisionVersion"] != null && loaderInfo.parameters["revisionVersion"] != "undefined" && loaderInfo.parameters["revisionVersion"] != "" && loaderInfo.parameters["revisionVersion"] != "#revisionVersion#");
		}
		
		/**
		 * 初始化程序
		 *
		 */
		protected function initConfig():void
		{
			this.loadApplicationConfig();
		}
		
		/**
		 * 加载程序配置application_config
		 *
		 */
		private function loadApplicationConfig():void
		{
			try
			{
				var urlRequest:URLRequest = new URLRequest();
				urlRequest.url = ApplicationConfig.CONFIG_PATH;
				if (getRevisionable())
				{
					urlRequest.url = ResourcePathRevisionUtil.convertVersionFilePath(urlRequest.url);
				}
				urlRequest.url = getApplicationURL() + "/" + urlRequest.url;
				urlRequest.url = urlRequest.url + "?nocache=" + new Date().getTime().toString();
				LogRunner.log("加载config：" + urlRequest.url);
				
				this._applicationConfigURLLoader = new URLLoader();
				this._applicationConfigURLLoader.addEventListener(Event.COMPLETE, onApplicationConfigCompleteHandler);
				this._applicationConfigURLLoader.addEventListener(IOErrorEvent.IO_ERROR, onApplicationConfigIOErrorHandler);
				this._applicationConfigURLLoader.load(urlRequest);
				
			} catch (error:IOError)
			{
			}
		}
		
		/**
		 * 加载配置文件完成
		 * @param e
		 *
		 */
		private function onApplicationConfigCompleteHandler(e:Event):void
		{
			this._applicationConfigURLLoader.removeEventListener(Event.COMPLETE, onApplicationConfigCompleteHandler);
			this._applicationConfigURLLoader.removeEventListener(IOErrorEvent.IO_ERROR, onApplicationConfigIOErrorHandler);
			this.onResolveApplicationConfig(new XML(e.target.data));
			this._applicationConfigURLLoader = null;
			this.startupKernel();
		}
		
		private function onApplicationConfigIOErrorHandler(e:IOErrorEvent):void
		{
			this._applicationConfigURLLoader.removeEventListener(IOErrorEvent.IO_ERROR, onApplicationConfigIOErrorHandler);
			LogRunner.log(e.text);
			KernelErrorRunner.getInstance().throwException("IOError application_config\n" + e.text);
			
			
		}
		
		/**
		 * 解析配置XML
		 * @param config
		 *
		 */
		protected function onResolveApplicationConfig(config:XML):void
		{
			ApplicationConfig.resolve(config);
		}
		
		/**
		 * 启动核心
		 * 当连接上服务器以后才会继续执行startupGame方法
		 */
		protected function startupKernel():void
		{
			LogRunner.log("startupKernel");
			StageRunner.getInstance().init(this.stage);
			BaseKeyPressRunner.getInstance().init(this.stage);
			LayerRunner.getInstance().init();
			TickRunner.getInstance().init(this.stage);
			TipRunner.getInstance().init(1, 800, 25, 25, 5, 5, 5, 5);
			StageRunner.getInstance().startResize();
			//初始化HTTP发送连接器
			HttpServerService.getInstance().init();
			HttpServerService.getInstance().startupConnectorByName(ServerServiceNameType.HTTP_GAMEBOXLOG);
			HttpServerService.getInstance().startupConnectorByName(ServerServiceNameType.GAME_TASK);
			//初始化socket连接器,并且连接服务器
			KernelEventDispatcher.getInstance().addEventListener(ServerEvent.CONNECTED, onServerConnectedHandler);
			SocketServerService.getInstance().init();
			SocketServerService.getInstance().startupConnectorByName(ServerServiceNameType.LOGIN);
		}
		
		private function onServerConnectedHandler(e:ServerEvent):void
		{
			LogRunner.log("server connect complete!");
			KernelEventDispatcher.getInstance().removeEventListener(ServerEvent.CONNECTED, onServerConnectedHandler);
			this.startupGame();
		}
		
		/**
		 * 启动游戏
		 *
		 */
		protected function startupGame():void
		{
			
		}
		
		private function getVersionFile(file:String):String
		{
			var s:String;
			
			if (KernelLoaderResourceUtil.hasResourceRemoteRootPathInStartsWith(file))
			{
				s = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(file);
			} else if (KernelLoaderResourceDataUtil.hasResourceDataRemoteRootPathInStartsWith(file))
			{
				s = KernelLoaderResourceDataUtil.convertKeyToResourceDataRemotePath(file);
			} else
			{
				s = ResourcePathRevisionUtil.convertVersionFilePath(file);
			}
			return s;
		}
		
		/**
		 * 获取加载文件加载器，通过类型
		 * @param file
		 * @return
		 *
		 */
		private function getLoaderByApplicationConfigResourceType(file:Object):GBaseLoader
		{
			var loader:GBaseLoader = null;
			var fileURL:String = getVersionFile(file["url"]);
			var fileName:String = file["name"];
			
			switch (file["type"])
			{
				case ResourceType.TEXT_DATA:
					loader = new GTextLoader();
					break;
				case ResourceType.BINARY_DATA:
					loader = new GBinaryLoader();
					break;
				case ResourceType.REFLECT_SWF:
				case ResourceType.FONT_SWF:
					loader = new GSWFLoader();
					GSWFLoader(loader).context = new LoaderContext();
					break;
				case ResourceType.MODULE:
				case ResourceType.MOVIECLIP_SWF:
				case ResourceType.BITMAP_SWF:
				case ResourceType.SOUND_SWF:
					loader = new GSWFLoader();
					break;
				case ResourceType.LANGUAGE_SWF:
					loader = new GBinaryLoader();
					break;
				case ResourceType.ENCRYPT_MODULE:
					loader = new KernelSWFEncryptionLoader();
					break;
			}
			loader.url = fileURL;
			loader.name = fileName;
			loader.onComplete = onLoadQueueResourceItemCompleteHandler;
			loader.onError = onLoaderItemErrorHandler;
			loader.onProgress = onLoadQueueResourceItemProgressHandler;
			return loader;
		}
		
		
		//当加载出错误
		private function onLoaderItemErrorHandler(e:GLoaderEvent):void
		{
			//发送给：运营用的 平台日志,加载错误日志。
			PlatformRunner.getInstance().flashLoadError(e.url, e.name);
		}
		
		/**
		 * 加载一个初始化队列通过名字
		 * @param name
		 *
		 */
		protected function loadInitQueueByName(name:String):void
		{
			LogRunner.log("start queue load. " + "QueueName:" + name);
			
			if (this._coreLoader != null)
			{
				this._coreLoader.dispose();
				this._coreLoader = null;
			}
			_coreLoader = new GQueueLoader();
			_coreLoader.onComplete = onLoadQueueCompleteHandler;
			_coreLoader.onProgress = onLoadQueueProgressHandler;
			_coreLoader.onError = onLoadQueueErrorHandler;
			var loader:GBaseLoader;
			var queue:Array = ApplicationConfig.INIT_LOAD_RESOURCE_LIST[name];
			
			for each (var file:Object in queue)
			{
				loader = getLoaderByApplicationConfigResourceType(file);
				_coreLoader.addLoader(loader);
			}
			
			this._coreLoader.load();
			this.currentLoadQueueName = name;
		}
		
		/**
		 * 加载队列中的单个文件进度,子类重写
		 * @param e
		 *
		 */
		protected function onLoadQueueResourceItemProgressHandler(e:GLoaderEvent):void
		{
			
		}
		
		/**
		 * 加载队列中的单个文件完成
		 * @param e
		 *
		 */
		protected function onLoadQueueResourceItemCompleteHandler(e:GLoaderEvent):void
		{
			LogRunner.log("init load item complete. " + e.name);
		}
		
		/**
		 * 加载队列全部完成,重新此方法后最后在调用这个父类执行一下清空
		 * @param e
		 *
		 */
		protected function onLoadQueueCompleteHandler(e:GLoaderEvent):void
		{
			LogRunner.log("init load queue complete. " + "QueueName:" + this.currentLoadQueueName);
			this._coreLoader.dispose();
			this._coreLoader = null;
			this.currentLoadQueueName = "";
		}
		
		/**
		 * 加载队列进度事件, 子类重写
		 * @param e
		 *
		 */
		protected function onLoadQueueProgressHandler(e:GLoaderEvent):void
		{
			
		}
		
		/**
		 * 加载队列资源发生错误
		 * @param e
		 *
		 */
		protected function onLoadQueueErrorHandler(e:GLoaderEvent):void
		{
			LogRunner.error("init load error. " + "QueueName:" + this.currentLoadQueueName + " ErrorInfo:" + e.url);
		}
		
		private function getApplicationURL():String{
			var url:String = loaderInfo.url;
			var urlArr:Array = url.split("/");
			urlArr.splice(urlArr.length - 1, 1);
			return urlArr.join("/");
		}
		
		public function dispose():void
		{
			this._applicationConfigURLLoader = null;
			ObjectPool.disposeObject(this._coreLoader);
			this._coreLoader = null;
		}
	}
}