package kernel.display.components.group
{
	public interface ISelectGroupItem
	{
		/**
		 * 获取对象的可选择性
		 */		
		function get selectable():Boolean;
		/**
		 * 获取或设置对象的选择状态
		 */		
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		/**
		 * 获取或设置对象选择时的相应方法
		 */		
		function get selectedCallback():Function;
		function set selectedCallback(value:Function):void;
		/**
		 * 获取或设置对象的选择组名
		 */		
		function get groupName():String;
		function set groupName(value:String):void;
	}
}

