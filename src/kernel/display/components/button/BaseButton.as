package kernel.display.components.button
{
	
	import flash.events.MouseEvent;
	
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.runner.UISkinRunner;

	/**
	 * 文件名：BaseButton.as
	 * <p>
	 * 功能：按钮基类，处理按钮的3个状态，分别为抬起状态、悬浮状态和按下状态
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-12
	 * <p>
	 * 作者：yanghongbin
	 */
	public class BaseButton extends MouseEffectiveComponent
	{
		private var _currentStatus:int = ButtonStatus.NORMAL;
		
		public function BaseButton(id:int=0, clickHandler:Function=null)
		{
			super(id, null, clickHandler);
		}
		override protected function init():void {
			if(_mouseEffectBehavior == null) _mouseEffectBehavior = UISkinRunner.buttonMouseEffectBehavior;
			super.init();
			this.buttonMode = true;
		}
		private function switchStatus(status:int):void {
			// 切出旧状态
			switch(_currentStatus) {
				case ButtonStatus.NORMAL:
					onNormalOut();
					break;
				case ButtonStatus.OVER:
					onOverOut();
					break;
				case ButtonStatus.DOWN:
					onDownOut();
					break;
			}
			// 切入新状态
			switch(status) {
				case ButtonStatus.NORMAL:
					onNormalIn();
					break;
				case ButtonStatus.OVER:
					onOverIn();
					break;
				case ButtonStatus.DOWN:
					onDownIn();
					break;
			}
			_currentStatus = status;
		}
		override protected function mouseOverHandler(event:MouseEvent):void {
			super.mouseOverHandler(event);
			if(this.enabled) {
				switchStatus(ButtonStatus.OVER);
			}
		}
		override protected function mouseOutHandler(event:MouseEvent):void {
			super.mouseOutHandler(event);
			if(this.enabled) {
				switchStatus(ButtonStatus.NORMAL);
			}
		}
		override protected function mouseDownHandler(event:MouseEvent):void {
			super.mouseDownHandler(event);
			if(this.enabled) {
				switchStatus(ButtonStatus.DOWN);
			}
		}
		override protected function mouseUpHandler(event:MouseEvent):void {
			super.mouseUpHandler(event);
			if(this.enabled) {
				switchStatus(event.target == this ? ButtonStatus.OVER : ButtonStatus.NORMAL);
			}
		}
		/*
		 * 以下方法为子类覆盖使用，为切换状态时需要执行的一系列方法
		 */
		protected function onNormalIn():void {
			// 等待子类完善
		}
		protected function onNormalOut():void {
			// 等待子类完善
		}
		protected function onOverIn():void {
			// 等待子类完善
		}
		protected function onOverOut():void {
			// 等待子类完善
		}
		protected function onDownIn():void {
			// 等待子类完善
		}
		protected function onDownOut():void {
			// 等待子类完善
		}
		
		override public function dispose():void
		{
			_currentStatus = 0;
			super.dispose();
		}
	}
}