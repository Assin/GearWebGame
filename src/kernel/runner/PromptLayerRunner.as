package kernel.runner
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import kernel.IDispose;
	import kernel.display.panel.PanelBase;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name 弹出框层的管理者
	 * @explain
	 * @author yanghongbin
	 * @create Dec 11, 2012 5:46:44 PM
	 */
	public class PromptLayerRunner implements IDispose
	{
		private var _layer:Sprite;
		/**
		 * mask可否显示
		 */
		private var _maskVisible:Boolean = true;
		/**
		 * 蒙板
		 */
		private var _mask:Sprite;
		/**
		 * 是否正在显示mask
		 */
		private var _isShowingMask:Boolean;
		/**
		 * 正在打开的panel列表
		 */
		private var _openingPanelList:Vector.<PanelBase> = new Vector.<PanelBase>();
		
		public function PromptLayerRunner()
		{
			addEvents();
		}
		private static var _instance:PromptLayerRunner;
		
		public static function getInstance():PromptLayerRunner
		{
			if (_instance == null)
			{
				_instance = new PromptLayerRunner();
			}
			return _instance;
			
		}
		
		public function init(layer:Sprite):void
		{
			this._layer = layer;
		}
		
		
		public function openPanelNoMask(panel:PanelBase):void
		{
			//郭鑫全屏：
			panel.x = StageRunner.getInstance().gameLeftX + StageRunner.getInstance().gameShowWidth / 2 - panel.width / 2;
			panel.y = StageRunner.getInstance().gameTopY + StageRunner.getInstance().gameShowHeight / 2 - panel.height / 2;
			DisplayUtil.addChild(panel, this._layer);
			panel.open();
			if (this._openingPanelList.indexOf(panel) <= 0)
			{
				this._openingPanelList.push(panel);
			}
		}
		
		public function openPanel(panel:PanelBase):void
		{
			if (this._maskVisible)
			{
				if (!this._isShowingMask)
				{
					//如果没显示蒙板，并且需要显示，那么则把蒙板放到最下
					this._mask = this.getMask();
					DisplayUtil.addChildAt(this._mask, this._layer, 0);
					this._isShowingMask = true;
				}
			}
			//郭鑫全屏：
			panel.x = StageRunner.getInstance().gameLeftX + StageRunner.getInstance().gameShowWidth / 2 - panel.width / 2;
			panel.y = StageRunner.getInstance().gameTopY + StageRunner.getInstance().gameShowHeight / 2 - panel.height / 2;
			DisplayUtil.addChild(panel, this._layer);
			panel.open();
			if (this._openingPanelList.indexOf(panel) <= 0)
			{
				this._openingPanelList.push(panel);
			}
		}
		
		public function closePanel(panel:PanelBase):void
		{
			DisplayUtil.removeChild(panel, this._layer);
			//从打开的列表中删除
			this._openingPanelList.splice(this._openingPanelList.indexOf(panel), 1);
			panel.dispose();
			if (this._openingPanelList.length <= 0)
			{
				DisplayUtil.removeChild(this._mask, this._layer);
				this.disposeMask();
				this._isShowingMask = false;
			}
		}
		
		public function getMask():Sprite
		{
			if (this._mask == null)
			{
				this._mask = new Sprite();
			}
			this._mask.graphics.clear();
			this._mask.graphics.beginFill(0x000000, 0.5);
			//郭鑫全屏：
			this._mask.graphics.drawRect(0, 0, StageRunner.getInstance().stage.stageWidth, StageRunner.getInstance().stage.stageHeight);
			this._mask.graphics.endFill();
			return this._mask;
		}
		
		public function disposeMask():void
		{
			if (this._mask == null)
			{
				return ;
			}
			ObjectPool.disposeObject(this._mask);
			this._mask = null;
		}
		
		/**
		 * 添加事件。
		 */
		private function addEvents():void
		{
			StageRunner.getInstance().stage.addEventListener(Event.RESIZE , stageResize);
				
		}
		
		/**
		 * 给提示框做的全屏自适应。
		 */
		private function stageResize(e:Event):void
		{
			for each(var panel:PanelBase in _openingPanelList)
			{
				panel.x = StageRunner.getInstance().gameLeftX + StageRunner.getInstance().gameShowWidth / 2 - panel.width / 2;
				panel.y = StageRunner.getInstance().gameTopY + StageRunner.getInstance().gameShowHeight / 2 - panel.height / 2;
			}
			
			if(_mask && this._layer.contains(_mask))
			{
				getMask();
			}
			
		}
		
		
		public function dispose():void
		{
			_layer = null;
			this.disposeMask();
			this._mask = null;
			
			super.dispose();
		}
	}
}