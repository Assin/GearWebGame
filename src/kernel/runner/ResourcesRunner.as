package kernel.runner
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import kernel.data.ResourceLoadStepType;
	import kernel.data.ResourceType;
	import kernel.errors.KernelError;
	import kernel.events.KernelEventDispatcher;
	import kernel.events.ResourceEvent;
	import kernel.loader.KernelPackageSWFLoader;
	import kernel.loader.ResourceInfo;
	import kernel.utils.KernelLoaderResourceDataUtil;
	import kernel.utils.KernelLoaderResourceUtil;
	import kernel.utils.ObjectPool;
	import kernel.utils.ResourcePathRevisionUtil;
	
	import org.gearloader.events.GLoaderEvent;
	import org.gearloader.loader.GBaseLoader;
	import org.gearloader.loader.GBinaryLoader;
	import org.gearloader.loader.GImageLoader;
	import org.gearloader.loader.GQueueLoader;
	import org.gearloader.loader.GSWFLoader;
	import org.gearloader.loader.GTextLoader;
	
	/**
	 * @name 管理资源的manager
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 3, 2011 1:18:01 PM
	 */
	public class ResourcesRunner
	{
		
		/**
		 * 资源集合
		 */
		private var resources:Dictionary;
		/**
		 * 正在加载的资源 URL存储列表,加载完毕会自动删除
		 */
		private var onLoadingResourceList:Array;
		
		
		private var loaderController:GQueueLoader;
		
		private static var _instance:ResourcesRunner;
		
		
		public static function getInstance():ResourcesRunner
		{
			if (_instance == null)
			{
				_instance = new ResourcesRunner();
			}
			return _instance;
			
		}
		
		/**
		 * 添加一个swf 里面的内容是需要反射取出
		 * @param key
		 * @param value
		 *
		 */
		public function addReflectSWF(key:String, value:ApplicationDomain):void
		{
			if (key == "" || value == null)
			{
				return ;
			}
			this.resources[key] = value;
		}
		
		/**
		 * 添加一个SWF，这个SWF就是一个MovieClip
		 * @param key
		 * @param value
		 *
		 */
		public function addMovieClipSWF(key:String, value:MovieClip):void
		{
			if (key == "" || value == null)
			{
				return ;
			}
			value.stop();
			this.resources[key] = value;
		}
		
		/**
		 * 获取revision文件
		 *
		 */
		public function getRevisionFile(url:String, onComplete:Function):void
		{
			var loader:GBinaryLoader = new GBinaryLoader();
			loader.url = url;
			loader.name = url;
			loader.onError = onLoaderItemErrorHandler;
			
			if (!this.isLoadingResource(url))
			{
				loader.onComplete = function(e:GLoaderEvent):void
				{
					if (loader)
					{
						var byteArray:ByteArray = ByteArray(loader.content);
						byteArray.uncompress();
						var contentString:String = byteArray.readUTFBytes(byteArray.bytesAvailable);
						ResourcePathRevisionUtil.resolveRevisionText(contentString);
					}
					loader.dispose();
					
					//调用下所有加载这个资源的回调
					invokeLoadingResourceListCallBack(url)
					
					removeFromLoadingResourceList(url);
				};
				loaderController.addLoaderAndLoad(loader);
			}
			addToLoadingResourceList(url, onComplete);
		}
		
		/**
		 * 获取SWF文件域
		 * @param swfKey
		 * @return
		 *
		 */
		public function getDomainFromSWF(swfKey:String):ApplicationDomain
		{
			var domain:ApplicationDomain = this.resources[swfKey];
			return domain;
		}
		
		/**
		 * 通过类定义从一个打包的swf中获取一个显示对象
		 * @param swfKey
		 * @param definition
		 * @return
		 *
		 */
		public function getDisplayObjectByClassDefinitionFromSWF(swfKey:String, definition:String):DisplayObject
		{
			var swf:ApplicationDomain = this.resources[swfKey];
			
			if (swf == null || definition == "")
			{
				return null;
			}
			try
			{
				var defClass:Class = this.getClassByClassDefinitionFromSWF(swfKey, definition);
			} 
			catch(error:Error) 
			{
				throw new KernelError("在 " + swfKey + " 中获得定义 " + definition + " 为空");
			}
			
			return new defClass();
		}
		
		/**
		 * 通过类定义从一个打包的swf中获取一个位图数据对象
		 * @param swfKey
		 * @param definition
		 * @return
		 *
		 */
		public function getBitmapDataByClassDefinitionFromSWF(swfKey:String, definition:String):BitmapData
		{
			var assetClass:Class = getClassByClassDefinitionFromSWF(swfKey, definition);
			
			if (assetClass != null)
			{
				var bitmapData:BitmapData = null
				bitmapData = new assetClass(0, 0)as BitmapData;
				return bitmapData;
			}
			return null;
		}
		
		/**
		 * 通过类定义获取一个打包的SWF中的一个类
		 * @param swfKey
		 * @param definition
		 * @return
		 *
		 */
		public function getClassByClassDefinitionFromSWF(swfKey:String, definition:String):Class
		{
			var swf:ApplicationDomain = this.resources[swfKey];
			
			if (swf == null || definition == "")
			{
				return null;
			}
			try
			{
				var defClass:Class = swf.getDefinition(definition)as Class;
			} 
			catch(error:Error) 
			{
				throw new KernelError("在 " + swfKey + " 中获得定义 " + definition + " 为空");
			}
			
			return defClass;
		}
		
		/**
		 * 向资源库中添加一个资源
		 * @param key
		 * @param value
		 *
		 */
		public function addResource(key:String, value:*):void
		{
			if (key == "" || value == null)
			{
				return ;
			}
			this.resources[key] = value;
		}
		
		/**
		 *  添加一个集合的soundclass 来进行存储，用于打包声音的使用
		 * @param value
		 *
		 */
		public function addSoundClassDictionary(value:Dictionary):void
		{
			for (var key:String in value)
			{
				if (value[key]is Class)
				{
					this.resources[key] = new value[key]();
				}
			}
		}
		
		/**
		 * 获取声音资源
		 * @param key
		 * @param completeHandler
		 * @return
		 *
		 */
		public function getSound(key:String, completeHandler:Function = null):Sound
		{
			var url:String = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(key);
			var soundClass:* = this.resources[key];
			var sound:Sound;
			
			//目前没有 那么就远程加载
			if (soundClass == null)
			{
				sound = new Sound();
				sound.load(new URLRequest(KernelLoaderResourceUtil.convertKeyToResourceRemotePath(key)), new SoundLoaderContext(1000, true));
				//放入集合中
				sound.addEventListener(IOErrorEvent.IO_ERROR, function(e:IOErrorEvent):void
				{
					var _sound:Sound = e.currentTarget as Sound;
					LogRunner.log("加载声音失败");
					_sound.removeEventListener(IOErrorEvent.IO_ERROR, arguments.callee);
					_sound.close();
				});
				addResource(key, sound);
				//				if (!this.isLoadingResource(url))
				//				{
				//					var mp3Loader:LoaderItem = new MP3Loader(url, {name:CoreLoaderResourceUtil.convertResourceRemotePathToKey(key), onError:onError, noCache:false});
				//					addToLoadingResourceList(mp3Loader.url);
				//					mp3Loader.addEventListener(LoaderEvent.COMPLETE, function(e:LoaderEvent):void
				//					{
				//						mp3Loader.removeEventListener(LoaderEvent.COMPLETE, arguments.callee);
				//						var target:MP3Loader = e.target as MP3Loader;
				////						
				//						if (target != null)
				//						{
				//							sound = target.content as Sound;
				//							//放入集合中
				//							addResource(mp3Loader.name, sound);
				//							if (completeHandler != null)
				//							{
				//								completeHandler(sound);
				//							}
				//							//派发事件
				//							var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
				//							resourceEvent.resourceKey = CoreLoaderResourceUtil.convertResourceRemotePathToKey(key);
				//							dispatchResourceEvent(resourceEvent);
				//							
				//							removeFromLoadingResourceList(target.url);
				//						}
				//						mp3Loader.dispose();
				//					});
				//					this.loaderController.addLoaderAndLoad(mp3Loader);
				//					//					mp3Loader.load();
				//				}
				//				addToLoadingResourceList(url, completeHandler);
			} else
			{
				if (soundClass is Class)
				{
					sound = new soundClass();
				} else if (soundClass is Sound)
				{
					sound = soundClass;
				}
				
				if (completeHandler != null)
					completeHandler(soundClass);
			}
			return sound;
		}
		
		/**
		 * 添加一个集合的bitmapdataclass 来进行存储，用于打包位图的使用
		 * @param value
		 *
		 */
		public function addBitmapDataClassDictionary(value:Dictionary):void
		{
			for (var key:String in value)
			{
				if (value[key]is Class)
				{
					this.addResource(key, new value[key]());
				} else
				{
					this.addResource(key, value[key]);
				}
			}
		}
		
		/**
		 * 加载一个位图 bitmapdataclass  包SWF
		 * @param url
		 *
		 */
		public function loadBitmapDataClass(key:String, complete:Function = null):void
		{
			var url:String = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(key);
			
			if (!this.isLoadingResource(url))
			{
				var loader:GSWFLoader = new GSWFLoader();
				loader.url = url;
				loader.name = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
				loader.onError = onLoaderItemErrorHandler;
				loader.onComplete = function(e:GLoaderEvent):void
				{
					var target:GSWFLoader = e.item as GSWFLoader;
					var content:* = target.content;
					addBitmapDataClassDictionary(content["dictionary"]);
					
					//派发事件
					var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
					resourceEvent.resourceKey = KernelLoaderResourceUtil.convertResourceRemotePathToKey(url);
					dispatchResourceEvent(resourceEvent);
					
					//调用下所有加载这个资源的回调
					invokeLoadingResourceListCallBack(url)
					
					removeFromLoadingResourceList(url);
					
				};
				this.loaderController.addLoaderAndLoad(loader);
				//			loaderItem.load();
			}
			addToLoadingResourceList(url, complete);
		}
		
		/**
		 * 通过Key获取一个bitmapdata实例
		 * 如果有当前图片，那么立即返回
		 * 如果没有，则远程加载
		 * @param key
		 * @return
		 *
		 */
		public function getBitmapData(key:String, completeHandler:Function = null, isClone:Boolean = false):BitmapData
		{
			var bitmapDataClass:* = this.resources[key];
			var bitmapData:BitmapData = null;
			var params:Array = [];
			
			//目前没有 那么就远程加载
			if (bitmapDataClass == null)
			{
				var url:String = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(key);
				
				if (!this.isLoadingResource(url))
				{
					var loader:GImageLoader = new GImageLoader();
					loader.url = url;
					loader.name = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
					loader.onError = onLoaderItemErrorHandler;
					loader.onComplete = function(e:GLoaderEvent):void
					{
						var target:GImageLoader = e.item as GImageLoader;
						
						if (target)
						{
							bitmapData = target.getBitmapData();
							
							if (isClone)
							{
								bitmapData = bitmapData.clone();
							}
							//放入集合中
							addResource(e.name, bitmapData);
							//派发事件
							var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
							resourceEvent.resourceKey = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
							dispatchResourceEvent(resourceEvent);
							//调用下所有加载这个资源的回调
							params.unshift(bitmapData);
							params.unshift(e.url);
							invokeLoadingResourceListCallBack.apply(null, params);
						}
						
						removeFromLoadingResourceList(url);
						target.dispose();
					};
					loaderController.addLoaderAndLoad(loader);
					//				imageLoader.load();
				}
				addToLoadingResourceList(url, completeHandler);
				
			} else if (bitmapDataClass is BitmapData)
			{
				//是否克隆
				if (isClone)
				{
					bitmapData = BitmapData(bitmapDataClass).clone();
				} else
				{
					bitmapData = BitmapData(bitmapDataClass);
				}
				
				if (completeHandler != null)
				{
					params.unshift(bitmapData);
					completeHandler.apply(null, params);
				}
			} else if (bitmapDataClass is Class)
			{
				bitmapData = new bitmapDataClass();
				//				//用实例化的替换原有的bitmapdata类结构
				//				delete this.resources[key];
				//				this.resources[key] = bitmapData;
				//				if (completeHandler != null)
				//				{
				//					if (args != null)
				//					{
				//						params = args;
				//					}
				//					params.unshift(bitmapData);
				//					completeHandler.apply(null, params);
				//				}
			}
			return bitmapData;
		}
		
		/**
		 * 通过的URL加载bitmapdata
		 *
		 */
		public function getBitmapDataByRealURL(url:String, completeHandler:Function = null, isClone:Boolean = false):BitmapData
		{
			var bitmapDataClass:* = this.resources[url];
			var bitmapData:BitmapData = null;
			var params:Array = [];
			
			//目前没有 那么就远程加载
			if (bitmapDataClass == null)
			{
				if (!this.isLoadingResource(url))
				{
					var loader:GImageLoader = new GImageLoader();
					loader.url = url;
					loader.name = KernelLoaderResourceUtil.convertResourceRemotePathToKey(url);
					loader.onError = onLoaderItemErrorHandler;
					loader.onComplete = function(e:GLoaderEvent):void
					{
						var target:GImageLoader = e.item as GImageLoader;
						
						if (target)
						{
							bitmapData = target.getBitmapData();
							
							if (isClone)
							{
								bitmapData = bitmapData.clone();
							}
							//放入集合中
							addResource(e.name, bitmapData);
							//派发事件
							var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
							resourceEvent.resourceKey = KernelLoaderResourceUtil.convertResourceRemotePathToKey(url);
							dispatchResourceEvent(resourceEvent);
							//调用下所有加载这个资源的回调
							params.unshift(bitmapData);
							params.unshift(e.url);
							invokeLoadingResourceListCallBack.apply(null, params);
						}
						
						removeFromLoadingResourceList(url);
						target.dispose();
					};
					loaderController.addLoaderAndLoad(loader);
					//				imageLoader.load();
				}
				addToLoadingResourceList(url, completeHandler);
				
			} else if (bitmapDataClass is BitmapData)
			{
				//是否克隆
				if (isClone)
				{
					bitmapData = BitmapData(bitmapDataClass).clone();
				} else
				{
					bitmapData = BitmapData(bitmapDataClass);
				}
				
				if (completeHandler != null)
				{
					params.unshift(bitmapData);
					completeHandler.apply(null, params);
				}
			} else if (bitmapDataClass is Class)
			{
				bitmapData = new bitmapDataClass();
			}
			return bitmapData;
		}
		
		/**
		 * 获取movieclip的SWF 没有的话就是远程
		 * @param key
		 * @param completeHandler
		 * @return
		 *
		 */
		public function getMovieClipSWF(key:String, completeHandler:Function = null, progressHandler:Function = null):MovieClip
		{
			var movieClip:MovieClip = this.resources[key];
			
			//目前没有 那么就远程加载
			if (movieClip == null)
			{
				var url:String = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(key);
				
				if (!this.isLoadingResource(url))
				{
					var loader:GSWFLoader = new GSWFLoader();
					loader.url = url;
					loader.name = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
					loader.onProgress = progressHandler;
					loader.onError = onLoaderItemErrorHandler;
					loader.onComplete = function(e:GLoaderEvent):void
					{
						var target:GSWFLoader = e.item as GSWFLoader;
						
						if (target)
						{
							//放入集合中
							movieClip = target.content as MovieClip;
							addMovieClipSWF(e.name, movieClip);
							//派发事件
							var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
							resourceEvent.resourceKey = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
							dispatchResourceEvent(resourceEvent);
							
							//调用下所有加载这个资源的回调
							invokeLoadingResourceListCallBack(e.url, movieClip)
						}
						removeFromLoadingResourceList(url);
						target.dispose();
					};
					loaderController.addLoaderAndLoad(loader);
					//				swfLoader.load();
				}
				addToLoadingResourceList(url, completeHandler);
				
			} else
			{
				if (completeHandler != null)
					completeHandler(movieClip);
			}
			return movieClip;
		}
		
		/**
		 * 获取可以反射的SWF 没有的话就远程加载
		 * @param key
		 * @param completeHandler
		 * @return
		 *
		 */
		public function getReflectSWF(key:String, completeHandler:Function = null, errorHandler:Function = null):ApplicationDomain
		{
			var applicationDomain:* = this.resources[key];
			
			//目前没有 那么就远程加载
			if (applicationDomain == null)
			{
				var url:String = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(key);
				
				if (!this.isLoadingResource(url))
				{
					var loader:GSWFLoader = new GSWFLoader();
					loader.url = url;
					loader.name = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
					loader.onError = onLoaderItemErrorHandler;
					loader.onComplete = function(e:GLoaderEvent):void
					{
						var target:GSWFLoader = e.item as GSWFLoader;
						
						if (target)
						{
							//放入集合中
							applicationDomain = target.contentLoaderInfo.applicationDomain;
							addReflectSWF(e.name, applicationDomain);
							//派发事件
							var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
							resourceEvent.resourceKey = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
							dispatchResourceEvent(resourceEvent);
							
							//调用下所有加载这个资源的回调
							invokeLoadingResourceListCallBack(e.url, applicationDomain)
						}
						removeFromLoadingResourceList(url);
						target.dispose();
					};
					loaderController.addLoaderAndLoad(loader);
					//				swfLoader.load();
				}
				addToLoadingResourceList(url, completeHandler);
			} else
			{
				if (completeHandler != null)
					completeHandler(applicationDomain);
			}
			return applicationDomain;
		}
		
		/**
		 * 加载一个资源队列
		 * @param queue
		 * @param completeHandler 加载完成回调 返回一个LoaderEvent
		 * @param progressHandler 加载进度回调 返回一个LoaderEvent
		 * @param errorHandler
		 *
		 */
		public function loadResourceQueue(queue:Vector.<ResourceInfo>, completeHandler:Function = null, progressHandler:Function = null, errorHandler:Function = null):void
		{
			var coreloaderMachine:GQueueLoader = new GQueueLoader();
			coreloaderMachine.onComplete = completeHandler;
			coreloaderMachine.onProgress = progressHandler;
			coreloaderMachine.onError = errorHandler;
			var toLoadLength:int = queue.length;
			var hasResource:int = 0;
			for each (var tempResourceInfoVO:ResourceInfo in queue)
			{
				var r:* = this.resources[tempResourceInfoVO.pathKey];
				if(r != null)
				{
					++hasResource;
				}else
				{
					//如果没有这个资源，那么加入加载队列中
					var loader:GBaseLoader = getLoader(tempResourceInfoVO);
					loader.onComplete = function(e:GLoaderEvent):void
					{
						var target:GBaseLoader = e.item;
						var resourceType:String = target.resourceType;
						var content:*;
						
						if (target is GImageLoader)
						{
							content = GImageLoader(target).getBitmapData();
							addResource(target.name, content);
						} else if (target is GSWFLoader)
						{
							content = target.content;
							
							if (resourceType == ResourceType.BITMAP_SWF)
							{
								addBitmapDataClassDictionary(content["dictionary"]);
							} else if (resourceType == ResourceType.REFLECT_SWF)
							{
								addReflectSWF(target.name, GSWFLoader(target).contentLoaderInfo.applicationDomain);
							} else if (resourceType == ResourceType.MOVIECLIP_SWF)
							{
								addMovieClipSWF(target.name, target.content as MovieClip);
							} else if (resourceType == ResourceType.P_SWF)
							{
								//处理动作打包pswf的资源
								for each(var pContent:* in KernelPackageSWFLoader(target).bitmapSWFArray)
								{
									addBitmapDataClassDictionary(pContent["dictionary"]);
								}
							} else
							{
								addResource(target.name, content);
							}
							
						} else if (target is GBinaryLoader)
						{
							content = target.content;
							addResource(target.name, content);
						} else if (target is GTextLoader)
						{
							content = target.content;
							addResource(target.name, content);
						}
					};
					
					if (tempResourceInfoVO.type == ResourceType.TEXT_DATA || tempResourceInfoVO.type == ResourceType.BINARY_DATA)
					{
						loader.url = KernelLoaderResourceDataUtil.convertKeyToResourceDataRemotePath(loader.url);
					} else
					{
						loader.url = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(loader.url);
					}
					coreloaderMachine.addLoader(loader);
				}
			}
			if(hasResource == toLoadLength)
			{
				completeHandler(new GLoaderEvent(GLoaderEvent.COMPLETE));
			}
			coreloaderMachine.load();
		}
		
		/**
		 * 得到一个文本数据 如果没有则开始加载
		 * @param key
		 * @param completeHandler 在完成回调中会带入一个字符串
		 * @return
		 *
		 */
		public function getTextData(key:String, completeHandler:Function = null):String
		{
			var textData:* = this.resources[key];
			
			if (textData == null)
			{
				var url:String = KernelLoaderResourceDataUtil.convertKeyToResourceDataRemotePath(key);
				
				if (!this.isLoadingResource(url))
				{
					var loader:GTextLoader = new GTextLoader();
					loader.url = url;
					loader.name = KernelLoaderResourceDataUtil.convertResourceDataRemotePathToKey(key);
					loader.onError = onLoaderItemErrorHandler;
					loader.onComplete = function(e:GLoaderEvent):void
					{
						var target:GTextLoader = e.item as GTextLoader;
						
						if (target)
						{
							var str:String = String(target.content);
							addResource(e.name, str);
						}
						//派发事件
						var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
						resourceEvent.resourceKey = KernelLoaderResourceDataUtil.convertResourceDataRemotePathToKey(key);
						dispatchResourceEvent(resourceEvent);
						
						//调用下所有加载这个资源的回调
						invokeLoadingResourceListCallBack(e.url, str)
						
						removeFromLoadingResourceList(url);
						target.dispose();
					};
					loaderController.addLoaderAndLoad(loader);
				}
				addToLoadingResourceList(url, completeHandler);
			} else
			{
				if (completeHandler != null)
				{
					completeHandler(textData);
				}
			}
			return textData;
		}
		
		/**
		 * 获取二进制数据，没有的话就远程加载
		 * @param key
		 * @param completeHandler 在完成回调中会带入一个byteArray
		 * @return
		 *
		 */
		public function getBinaryData(key:String, completeHandler:Function = null):ByteArray
		{
			var binaryData:* = this.resources[key];
			
			if (binaryData == null)
			{
				var url:String = KernelLoaderResourceDataUtil.convertKeyToResourceDataRemotePath(key);
				
				if (!this.isLoadingResource(url))
				{
					var loader:GBinaryLoader = new GBinaryLoader();
					loader.url = url;
					loader.name = KernelLoaderResourceDataUtil.convertResourceDataRemotePathToKey(key);
					loader.onError = onLoaderItemErrorHandler;
					loader.onComplete = function(e:GLoaderEvent):void
					{
						var target:GBinaryLoader = e.item as GBinaryLoader;
						
						if (target)
						{
							var byteArray:ByteArray = ByteArray(target.content);
						}
						addResource(e.name, byteArray);
						//派发事件
						var resourceEvent:ResourceEvent = new ResourceEvent(ResourceEvent.LOAD_COMPLETE);
						resourceEvent.resourceKey = KernelLoaderResourceDataUtil.convertResourceDataRemotePathToKey(key);
						dispatchResourceEvent(resourceEvent);
						
						//调用下所有加载这个资源的回调
						invokeLoadingResourceListCallBack(e.url, byteArray)
						removeFromLoadingResourceList(url);
						
						target.dispose();
					};
					loaderController.addLoaderAndLoad(loader);
					//				dataLoader.load();
				}
				addToLoadingResourceList(url, completeHandler);
			} else
			{
				if (completeHandler != null)
				{
					completeHandler(binaryData);
				}
			}
			return binaryData;
		}
		
		/**
		 * 派发资源事件
		 * @param resourceEvent
		 *
		 */
		public function dispatchResourceEvent(resourceEvent:ResourceEvent):void
		{
			KernelEventDispatcher.getInstance().dispatchEvent(resourceEvent);
		}
		
		
		/**
		 * 判断是否有资源
		 * @param key
		 * @return
		 *
		 */
		public function hasResource(key:String):Boolean
		{
			key = KernelLoaderResourceUtil.convertResourceRemotePathToKey(key);
			
			if (resources[key] == null)
			{
				return false;
			}
			return true;
		}
		
		/**
		 * 判断一个资源是否在加载中
		 * @return
		 *
		 */
		public function isLoadingResource(_url:String):Boolean
		{
			var remoteURL:String = KernelLoaderResourceUtil.convertKeyToResourceRemotePath(_url);
			var hasURL:Boolean;
			
			for each (var obj:Object in this.onLoadingResourceList)
			{
				if (obj["url"] == _url)
				{
					hasURL = true;
					break;
				}
			}
			return hasURL;
		}
		
		/**
		 * 加入一个地址 到正在加载列表
		 * @param url
		 *
		 */
		private function addToLoadingResourceList(_url:String, _callBack:Function = null):void
		{
			var hasURL:Boolean;
			
			for each (var obj:Object in this.onLoadingResourceList)
			{
				if (obj["url"] == _url)
				{
					hasURL = true;
					var a:Array = obj["callBack"]as Array;
					
					if (a.indexOf(_callBack) == -1)
					{
						a.push(_callBack);
					}
					break;
				}
			}
			
			if (hasURL == false)
			{
				this.onLoadingResourceList.push({url:_url, callBack:[_callBack]});
			}
		}
		
		/**
		 * 调用下 加载中的资源的 回调方法
		 * @param _url
		 * @param args
		 *
		 */
		private function invokeLoadingResourceListCallBack(_url:String, ... args):void
		{
			for each (var obj:Object in this.onLoadingResourceList)
			{
				if (obj["url"] == _url)
				{
					if (obj["callBack"] != null)
					{
						var a:Array = obj["callBack"]as Array;
						
						for each (var cb:Function in a)
						{
							if (cb != null)
							{
								cb.apply(null, args);
							}
						}
					}
					break;
				}
			}
		}
		
		/**
		 * 从正在加载列表中移除一个
		 * @param url
		 *
		 */
		private function removeFromLoadingResourceList(_url:String):void
		{
			for (var i:int = 0; i < this.onLoadingResourceList.length; i++)
			{
				var obj:Object = this.onLoadingResourceList[i];
				
				if (obj["url"] == _url)
				{
					obj["callBack"] = null;
					this.onLoadingResourceList.splice(i, 1);
					break;
				}
			}
		}
		
		/**
		 * 获取资源数量 通过一个key的前缀
		 * @param prefixKey
		 * @return
		 *
		 */
		public function getResourceCountByPrefixKey(prefixKey:String):int
		{
			var count:int = 0;
			
			for (var key:String in this.resources)
			{
				if (key.indexOf(prefixKey) == 0)
				{
					++count;
				}
			}
			return count;
		}
		
		/**
		 * 获取资源key的集合，通过一个key的前缀
		 * @param prefixKey
		 *
		 */
		public function getResourceKeyListByPrefixKey(prefixKey:String):Array
		{
			var arr:Array = [];
			
			for (var key:String in this.resources)
			{
				if (key.indexOf(prefixKey) == 0)
				{
					arr.push(key);
				}
			}
			return arr;
		}
		
		/**
		 * 添加一个到一个 ResourceInfoVO.as的列表中，不重复添加
		 *
		 */
		public function addToResourceInfoVOListUnreduplicate(vector:Vector.<ResourceInfo>, resourceInfoVO:ResourceInfo):void
		{
			if (vector == null || resourceInfoVO == null)
			{
				return ;
			}
			
			for each (var tempResourceInfoVO:ResourceInfo in vector)
			{
				if (tempResourceInfoVO.pathKey == resourceInfoVO.pathKey)
				{
					return ;
				}
			}
			vector.push(resourceInfoVO);
		}
		
		/**
		 * 获取加载器
		 * @param resourceInfoVO
		 * @return
		 *
		 */
		public function getLoader(resourceInfoVO:ResourceInfo):GBaseLoader
		{
			var loader:GBaseLoader = null;
			
			switch (resourceInfoVO.type)
			{
				case ResourceType.IMAGE:
					loader = new GImageLoader();
					break;
				case ResourceType.TEXT_DATA:
					loader = new GTextLoader();
					break;
				case ResourceType.BINARY_DATA:
					loader = new GBinaryLoader();
					break;
				case ResourceType.MODULE:
				case ResourceType.BITMAP_SWF:
				case ResourceType.REFLECT_SWF:
				case ResourceType.LANGUAGE_SWF:
				case ResourceType.MOVIECLIP_SWF:
					loader = new GSWFLoader();
					break;
				case ResourceType.P_SWF:
					loader = new KernelPackageSWFLoader();
					break;
			}
			loader.url = resourceInfoVO.pathKey;
			loader.name = resourceInfoVO.pathKey;
			loader.onError = onLoaderItemErrorHandler;
			loader.resourceType = resourceInfoVO.type;
			return loader;
		}
		
		/**
		 * 释放单个资源,永久从库里删除
		 * @param key
		 *
		 */
		public function disposeResourceByKey(key:String):void
		{
			var obj:* = this.resources[key];
			
			if (this.resources[key] != undefined && this.resources[key] != null)
			{
				ObjectPool.disposeObject(obj);
				this.resources[key] = null;
				delete this.resources[key];
			}
		}
		
		/**
		 * 释放一个列表的内容 ,永久从库里删除
		 * @param resourcesList
		 *
		 */
		public function disposeResources(resourcesList:*):void
		{
			for each (var r:*in resourcesList)
			{
				this.disposeResourceByKey(String(r));
			}
		}
		
		/**
		 * 释放符合key前缀的任意资源。  （把一类key的前面部分传进来，那么这一类资源就会都被释放掉）
		 * @param keyPrefix
		 *
		 */
		public function disposeResourcesByKeyPrefix(keyPrefix:String):void
		{
			for (var key:String in resources)
			{
				if (key.indexOf(keyPrefix) == 0)
				{
					disposeResourceByKey(key);
				}
			}
		}
		
		
		//当加载出错误
		private function onLoaderItemErrorHandler(e:GLoaderEvent):void
		{
			LogRunner.error("ResourceRunner加载资源异常" + e.url);
			//加载失败 从正在加载列表中删除
			var loaderItem:GBaseLoader = GBaseLoader(e.item);
			var url:String = loaderItem.url;
			
			this.removeFromLoadingResourceList(url);
			onErrorLoadItem(loaderItem);
		}
		
		public function ResourcesRunner()
		{
		}
		
		private function onBeginLoadItem(loaderItem:GBaseLoader):void
		{
			this.sendFlashLoadMessage(loaderItem, loaderItem.name, ResourceLoadStepType.BEGIN);
		}
		
		private function onEndLoadItem(loaderItem:GBaseLoader):void
		{
			this.sendFlashLoadMessage(loaderItem, loaderItem.name, ResourceLoadStepType.END);
		}
		
		private function onErrorLoadItem(loaderItem:GBaseLoader):void
		{
			this.sendFlashLoadMessage(loaderItem, loaderItem.name, ResourceLoadStepType.ERROR);
			
			//发送给：运营用的 平台日志,加载错误日志。
			PlatformRunner.getInstance().flashLoadError(loaderItem["url"], loaderItem.name);
			
		}
		
		public function sendFlashLoadMessage(loaderItem:GBaseLoader, name:String, type:String):void
		{
		}
		
		public function init():void
		{
			this.resources = new Dictionary();
			this.onLoadingResourceList = [];
			
			this.loaderController = new GQueueLoader();
		}
	}
}