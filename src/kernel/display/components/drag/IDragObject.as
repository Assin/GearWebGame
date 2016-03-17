package kernel.display.components.drag
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;
	
	import kernel.IDispose;
	
	/**
	 * @name 拖拽物体类
	 * @explain
	 * @author yanghongbin
	 * @create Dec 13, 2012 2:34:30 PM
	 */
	public interface IDragObject extends IEventDispatcher
	{
		function getDragDisplayObject():DisplayObject;
		/**
		 * 拖拽成功
		 *
		 */
		function onDragSuccess():void;
		/**
		 * 拖拽取消
		 *
		 */
		function onDragCancel():void;
	}
}