package kernel.display.components.button
{
	import flash.events.MouseEvent;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Dec 7, 2012 7:22:25 PM
	 */
	public class ToggleButton extends ToggleButtonBase
	{
		
		public function ToggleButton(id:int = 0, label:String = "", clickHandler:Function = null)
		{
			super(id, label, clickHandler);
		}
		
		override public function set selected(value:Boolean):void
		{
			super.selected = value;
			switchBG(value);
		}
		
		override protected function clickHandler(event:MouseEvent):void
		{
			this.selected = !this.selected;
			super.clickHandler(event);
		}
		
		
	}
}