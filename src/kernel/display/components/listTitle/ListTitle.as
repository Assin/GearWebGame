package kernel.display.components.listTitle
{
	
	import flash.display.Sprite;
	
	import kernel.IClear;
	import kernel.display.components.BaseComponent;
	import kernel.display.components.LayoutVO;
	import kernel.display.components.group.SelectGroup;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	
	public class ListTitle extends BaseComponent implements IClear
	{
		private var _selectGroup:SelectGroup;
		private var _buttonContainer:Sprite;
		private var _buttons:Array;
		
		private var _values:Array;
		
		public function ListTitle()
		{
			super();
		}
		
		override protected function init():void
		{
			super.init();
			
			_selectGroup = new SelectGroup();
			_buttons = [];
			_buttonContainer = new Sprite();
			
			DisplayUtil.removeAllChildren(_buttonContainer);
			_buttonContainer.graphics.clear();
			addChild(_buttonContainer);
		}
		
		private function updateView():void
		{
			clear();
			for (var i:int = 0; i < _values.length; i++)
			{
				var button:ListTitleButton = new ListTitleButton();
				button.id = i;
				button.update(_values[i]);
				_selectGroup.addItem(button);
				_buttonContainer.addChild(button);
				_buttons.push(button);
			}
			drawLayout();
		}
		
		private function drawLayout():void
		{
			var x:Number = 0;
			for each (var button:ListTitleButton in _buttons)
			{
				button.x = x;
				x += button.width;
			}
		}
		
		override public function setLayout(layout:LayoutVO):void
		{
			super.setLayout(layout);
			drawLayout();
		}
		
		public function setButtonCurrentSortType(index:int, sortType:int):void
		{
			if (index >= _buttons.length)
				return ;
			ListTitleButton(_buttons[index]).currentSortType = sortType;
		}
		
		public function update(values:Array):void
		{
			_values = (values == null ? [] : values);
			updateView();
		}
		
		public function reset():void
		{
			for each (var button:ListTitleButton in _buttons)
			{
				button.reset();
			}
		}
		
		override public function clear():void
		{
			super.clear();
			
			DisplayUtil.removeAllChildren(_buttonContainer);
			_selectGroup.clear();
			_buttons = [];
		}
		override public function dispose():void
		{
			ObjectPool.disposeObject(_selectGroup);
			_selectGroup = null;
			ObjectPool.disposeObject(_buttons);
			ObjectPool.disposeObject(_buttonContainer);
			_buttonContainer = null;
			_buttons = null;
			ObjectPool.disposeObject(_values);
			_values = null;
		}
	}
}