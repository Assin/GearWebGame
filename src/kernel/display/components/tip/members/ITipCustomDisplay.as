package kernel.display.components.tip.members
{
	import flash.display.DisplayObject;
	/**
	 *BaseTipCustomDisplay的接口 
	 * @author 雷羽佳
	 * 
	 */
	public interface ITipCustomDisplay
	{
		/**
		 *如果添加的是Vector.< DisplayObject>，当displayList已经存在内容的时候，将新的displayList添加到原始的displayList的结尾
		 * 在子类里，添加的也可以是其他的形式，但是具体解析需要自己实现。但是注意，无论怎么复写，最终都要把需要显示的内容添加到displayList列表中。
		 * @param displayList
		 * 
		 */		
		function addData(data:*):void;
		
		/**
		 *内部显示列表
		 * @return 
		 * 
		 */		
		function get displayList():Vector.<DisplayObject>;
		
		/**
		 *清除DisplayList里的全部内容，使其变为一个新的list
		 * 
		 */		
		function clearDisplayList():void;
		/**
		 *显示顺序按照displayList内容的先后顺序显示 
		 * 
		 */		
		function render():void;
	}
}