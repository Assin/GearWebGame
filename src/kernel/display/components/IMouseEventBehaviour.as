package kernel.display.components
{
	
	/**
	 * @name 鼠标行为的接口
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 21, 2011 5:42:22 PM
	 */
	public interface IMouseEventBehaviour
	{
		function onMouseClick():void;
		function onMouseOver():void;
		function onMouseOut():void;
		function onMouseMove():void;
		function onMouseDown():void;
		function onMouseUp():void;
		function set mouseClickable(value:Boolean):void;
		function get mouseClickable():Boolean;
		function set mouseOverable(value:Boolean):void;
		function get mouseOverable():Boolean;
		function set mouseOutable(value:Boolean):void;
		function get mouseOutable():Boolean;
		function set mouseMovable(value:Boolean):void;
		function get mouseMovable():Boolean;
	}
}