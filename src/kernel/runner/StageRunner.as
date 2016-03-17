package kernel.runner
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Capabilities;
	
	import data.GameConfig;
	
	/**
	 * @name 舞台管理
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 12:07:28 PM
	 */
	public class StageRunner
	{
		/**
		 * 游戏舞台
		 */
		public var stage:Stage;
		/**
		 * 游戏显示层次的根节点 
		 */		
		public var root:Sprite;
		private static var _instance:StageRunner;
		/**
		 * 游戏显示区域的 左侧X值。
		 */
		private var  _gameLeftX:Number;
		/**
		 * 游戏显示区域的右侧的X值。
		 */
		private var _gameRightX:Number;
		
		/**
		 * 游戏显示区域的 上方Y值。
		 */
		private var _gameTopY:Number;
		/**
		 * 游戏显示区域的 下方Y值。
		 */
		private var _gameBottomY:Number;
		
		/**
		 * 游戏显示区域的宽度。
		 */
		private var _gameShowWidth:Number;
		/**
		 * 游戏显示区域的高度。
		 */
		private var _gameShowHeight:Number;

		public static function getInstance():StageRunner
		{
			if (_instance == null)
			{
				_instance = new StageRunner();
			}
			return _instance;
		}
		
		
		public function init(stage:Stage):void
		{
			this.stage = stage;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.showDefaultContextMenu = false;
			
			this.root = new Sprite();
			this.stage.addChild(this.root);
		}
		
		/**
		 * 开始，监听全屏自适应，外部调用，因为要生成  LayerRunner 的 init 的时候才 能画 黑色边框。
		 */
		public function startResize():void
		{
			stageResize(null);
			this.stage.addEventListener(Event.RESIZE , stageResize);
		}
		
		private function stageResize(evt:Event):void
		{
			var layer:Sprite = LayerRunner.getInstance().frameAroundLayer;
			
			layer.graphics.clear();
			layer.graphics.beginFill(0x000000 , 1);
			layer.graphics.drawRect(0,0,stage.stageWidth ,stage.stageHeight);
			layer.graphics.drawRect(gameLeftX , gameTopY , gameShowWidth , gameShowHeight);
			layer.graphics.endFill();
		}
		
		/**
		 * 游戏显示区域的高度。
		 */
		public function get gameShowHeight():Number
		{
			if(this.stage)
			{
				return this.stage.stageHeight <= GameConfig.MAX_GAME_HEIGHT ? this.stage.stageHeight : GameConfig.MAX_GAME_HEIGHT ; 
			}
			else
			{
				return GameConfig.MAX_GAME_HEIGHT;
			}
		}
		
		/**
		 * 游戏显示区域的宽度。
		 */
		public function get gameShowWidth():Number
		{
			if(this.stage)
			{
				return this.stage.stageWidth <= GameConfig.MAX_GAME_WIDTH ? this.stage.stageWidth : GameConfig.MAX_GAME_WIDTH ;
			}
			else
			{
				return GameConfig.MAX_GAME_WIDTH;
			}
		}
		
		/**
		 * 游戏显示区域的Y值。
		 */
		public function get gameTopY():Number
		{
			if(this.stage)
			{
				return this.stage.stageHeight <= GameConfig.MAX_GAME_HEIGHT ? 0 : (this.stage.stageHeight - GameConfig.MAX_GAME_HEIGHT)/2;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 游戏显示区域的 下方Y值。
		 */
		public function get  gameBottomY():Number
		{
			return gameTopY + gameShowHeight;
		}
		
		
		/**
		 * 游戏显示区域的 X值。
		 */
		public function get gameLeftX():Number
		{
			if(this.stage)
			{
				return this.stage.stageWidth <= GameConfig.MAX_GAME_WIDTH ? 0 : (this.stage.stageWidth - GameConfig.MAX_GAME_WIDTH) / 2 ;
			}
			else
			{
				return 0;
			}
		}
		
		/**
		 * 游戏显示区域的右侧的X值。
		 */
		public  function   get gameRightX():Number
		{
			return gameLeftX + gameShowWidth;
		}
		
		
	}
}



