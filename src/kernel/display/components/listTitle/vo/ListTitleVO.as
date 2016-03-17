package kernel.display.components.listTitle.vo
{
	
	public class ListTitleVO
	{
		public var label:String;
		public var width:Number;
		public var sortType:int;
		public var value:Object;
		
		public function ListTitleVO(label:String = "", width:Number = 60, type:int = 0, value:Object = null)
		{
			super();
			
			this.label = label;
			this.width = width;
			this.sortType = type;
			this.value = value;
		}
	}
}