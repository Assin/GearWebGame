package kernel.runner
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import kernel.utils.MaskUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name 游戏层级管理,这里管理所有游戏都有的层级
	 * @explain
	 * @author yanghongbin
	 * @create Oct 30, 2012 6:09:21 PM
	 */
	public class LayerRunner
	{
		/**
		 * loading游戏层
		 */
		public var loadingPageLayer:Sprite;
		/**
		 * 登录游戏层
		 */
		public var loginPageLayer:Sprite;
		/**
		 * 创建人物层
		 */
		public var createRolePageLayer:Sprite;
		/**
		 * 主游戏层
		 */
		public var gamePageLayer:Sprite;
		/**
		 * 游戏面板层
		 */
		public var panelLayer:Sprite;
		/**
		 * 游戏chat层
		 */
		public var chatLayer:Sprite;
		/**
		 * 游戏tip层
		 */
		public var tipLayer:Sprite;
		/**
		 * 游戏提示层
		 */
		public var promptLayer:Sprite;
		/**
		 * 浮字层
		 */
		public var announceLayer:Sprite;
		/**
		 * 外面的黑色大边框层。
		 */
		public var frameAroundLayer:Sprite;
		
		private static var _instance:LayerRunner;
		
		
		private var _promptMask:Sprite;
		
		public static function getInstance():LayerRunner
		{
			if (_instance == null)
			{
				_instance = new LayerRunner();
			}
			return _instance;
			
		}
		
		public function LayerRunner()
		{
		}
		
		public function init():void
		{
			this.loadingPageLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.loadingPageLayer);
			
			this.loginPageLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.loginPageLayer);
			
			this.gamePageLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.gamePageLayer);
			
			this.chatLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.chatLayer);
			
			this.panelLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.panelLayer);
			
			this.createRolePageLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.createRolePageLayer);
			
			this.promptLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.promptLayer);
			
			this.announceLayer = new Sprite();
			announceLayer.mouseChildren = false;
			announceLayer.mouseEnabled = false;
			StageRunner.getInstance().root.addChild(this.announceLayer);
			
			this.tipLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.tipLayer);
			
			this.frameAroundLayer = new Sprite();
			StageRunner.getInstance().root.addChild(this.frameAroundLayer);
			
		}
		
		public function addMask(alpha:Number = 0):void
		{
			if(_promptMask == null)
			{
				//监听舞台大小变化,在removeMask的时候不取消监听，因为会因为需要监听的在其他地方调用了removeMask导致失效。需要在事件处理函数判断下时候还存在
				StageRunner.getInstance().stage.addEventListener(Event.RESIZE, onStageResize);
				//郭鑫全屏：
				_promptMask = MaskUtil.setRectMask(promptLayer, 0, 0, StageRunner.getInstance().stage.stageWidth, StageRunner.getInstance().stage.stageHeight, 0x000000, alpha);
			}
		}
		
		private function onStageResize(e:Event):void
		{
			if(_promptMask)
			{
				_promptMask.x = StageRunner.getInstance().gameLeftX;
				_promptMask.y = StageRunner.getInstance().gameTopY;
				_promptMask.width = StageRunner.getInstance().gameShowWidth;
				_promptMask.height = StageRunner.getInstance().gameShowHeight;
			}
		}
		
		public function removeMask():void
		{
			ObjectPool.disposeObject(_promptMask);
			_promptMask = null;
		}
	}
}