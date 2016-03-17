package kernel.runner
{
	import flash.utils.Dictionary;
	
	import kernel.display.components.LayoutVO;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Dec 5, 2012 8:30:33 PM
	 */
	public class LayoutRunner
	{
		private var _layoutXML:XML;
		
		/**
		 * 设置布局原始XML数据
		 * @param value 布局原始XML数据
		 */
		public function set layoutXML(value:XML):void
		{
			_layoutXML = value;
		}
		
		private var _layoutDict:Dictionary;
		
		
		private static var _instance:LayoutRunner;
		
		public static function getInstance():LayoutRunner
		{
			if (_instance == null)
			{
				_instance = new LayoutRunner();
			}
			return _instance;
			
		}
		
		public function LayoutRunner()
		{
		}
		
		public function init():void
		{
			_layoutDict = new Dictionary();
			parseValues(_layoutXML);
		}
		
		/**
		 * 解析布局数据
		 * @param xml 布局原始数据
		 */
		private function parseValues(xml:XML):void
		{
			var list:XMLList = xml.children();
			for (var i:int = 0; i < list.length(); i++)
			{
				var child:XML = list[i];
				if (child != null)
				{
					_layoutDict[child.localName().toString()] = parseXML(child);
				}
			}
		}
		
		private function parseXML(xml:XML):LayoutVO
		{
			var layout:LayoutVO = new LayoutVO();
			// 赋值基本信息
			layout.x = Number(xml.@x);
			layout.y = Number(xml.@y);
			layout.width = Number(xml.@width);
			layout.height = Number(xml.@height);
			// 赋值子数据信息
			var children:XMLList = xml.children();
			if (children.length() > 0)
			{
				layout.children = new Dictionary();
				for (var i:int = 0; i < children.length(); i++)
				{
					var child:XML = children[i];
					layout.children[child.localName().toString()] = parseXML(child);
				}
			}
			return layout;
		}
		
		/**
		 * 通过布局名获取布局数据
		 * @param type 布局名
		 * @return 布局数据
		 */
		public function getLayoutValue(type:String):LayoutVO
		{
			return _layoutDict[type];
		}
	}
}