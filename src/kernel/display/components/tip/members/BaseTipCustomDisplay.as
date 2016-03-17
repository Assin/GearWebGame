package kernel.display.components.tip.members
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import kernel.IDispose;
	import kernel.utils.ObjectPool;
	
	/**
	 *自定义显示模版类的基类，在TipMemberFactory里会自动实例化此类，并通过addData来向本类中添加需要显示的信息
	 * 在BaseTipCustomDisplay的子类中可以重写addData，但是需要重新定义自己的数据格式和解析方法。 子类的范例详见EquipTipCustomDisplay
	 * <p>
	 * date 2012.12.17
	 * @author 雷羽佳
	 */
	public class BaseTipCustomDisplay extends Sprite implements ITipCustomDisplay, IDispose
	{
		private var _displayList:Vector.<DisplayObject>;
		
		private var _POS_RIGHT:String = "right";
		private var _POS_LEFT:String = "left";
		
		public var currentPos:String = "right";
		/**
		 * 是否显示底图 
		 */		
		public var isShowBG:Boolean = true;
		
		public function BaseTipCustomDisplay()
		{
			
		}
		
		protected function get POS_LEFT():String
		{
			return _POS_LEFT;
		}

		protected function get POS_RIGHT():String
		{
			return _POS_RIGHT;
		}
		
		public function get displayList():Vector.<DisplayObject>
		{
			if (_displayList == null)
				_displayList = new Vector.<DisplayObject>();
			return _displayList;
		}
		
		public function addData(data:*):void
		{
			if (data != null)
			{
				if (data is Vector.<DisplayObject>)
				{
					var displayList:Vector.<DisplayObject> = data as Vector.<DisplayObject>;
					
					if (_displayList == null)
						_displayList = displayList;
					else
						for (var i:int = 0; i < displayList.length; i++)
						{
							_displayList.push(displayList[i]);
						}
				} else
				{
					throw new Error("data不是Vector.<DisplayObject>，请检查data的类型是否正确");
				}
			}
		}
		
		
		public function render():void
		{
			if (_displayList != null)
				for (var i:int = 0; i < _displayList.length; i++)
				{
					this.addChild(_displayList[i]);
				}
		}
		
		public function clearDisplayList():void
		{
			ObjectPool.disposeObject(_displayList);
			_displayList = null;
		}
		
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_displayList);
			_displayList = null;
		}
		
		
		public function posChangeHandler(pos:String):void
		{
			
		}
	}
}