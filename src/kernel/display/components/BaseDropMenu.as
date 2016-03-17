package kernel.display.components
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	import kernel.IDispose;
	import kernel.display.components.button.ImageButton;
	import kernel.display.components.text.TextFieldProxy;
	import kernel.runner.StageRunner;
	import kernel.runner.UISkinRunner;

	/**
	 * 简单版下拉菜单 
	 * @author 雷羽佳 2013.3.13 9：46
	 * 
	 */	
	public class BaseDropMenu extends Sprite implements IDispose
	{
		private var _bg:ImageButton
		private var _text:TextFieldProxy;
		private var _selectedIndex:int = 0;

		private var _changeFunc:Function;

		public function get changeFunc():Function
		{
			return _changeFunc;
		}

		public function set changeFunc(value:Function):void
		{
			_changeFunc = value;
		}

		public function get selectedIndex():int
		{
			return _selectedIndex;
		}
		
		public function get selectedItem():Object
		{
			return _menu.list[_selectedIndex].data;
		}

		
		public function set selectedIndex(value:int):void
		{
			_selectedIndex = value;
			var _list:Vector.<Item> = _menu.list;
			if(_list.length>value)
			{
				if(_list[_selectedIndex] != null)
				{
					_text.fontColor = _list[_selectedIndex].color;
					_text.text = _list[_selectedIndex].text.slice(3);
					updateMainButton();
					
					if(_changeFunc != null)
					{
						_changeFunc(_list[_selectedIndex].data);
					}
					
				}
			}
	
		}

		
		public function BaseDropMenu()
		{
			_bg = new ImageButton();
			_bg.bitmapScale9GirdData = UISkinRunner.BaseDropMenuButton
			_bg.width = 200;
			_bg.height = 24;
			
			addChild(_bg);
//			itemArr = new Array();
			
			_text = new TextFieldProxy();
			
			_text.autoSize = TextFieldAutoSize.LEFT;
			_text.multiline = false;
			_text.wordWrap = false;
			_text.mouseEnabled = false;
			_text.selectable = false;
			_text.fontColor = 0xffffff;
			this.addChild(_text);
			
			_text.text = "";
			updateMainButton();
			
			_menu = new Menu();
//			
			_menu.visible = false;
			_bg.addEventListener(MouseEvent.MOUSE_DOWN,prepareShowMenu);
		}
		
		private function prepareShowMenu(e:MouseEvent):void
		{
			_bg.addEventListener(MouseEvent.MOUSE_UP,ShowMenu);	
		}
		
		protected function ShowMenu(event:MouseEvent):void
		{
			_bg.removeEventListener(MouseEvent.MOUSE_UP,ShowMenu);
			if(_menu.visible == false)
			{
				_menu.visible = true;
				updateMenuPosistion();
				StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_DOWN,prepareHideMenu);
			}
		}		
		
		protected function prepareHideMenu(event:MouseEvent):void
		{
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_DOWN,prepareHideMenu);
			StageRunner.getInstance().stage.addEventListener(MouseEvent.MOUSE_UP,HideMenu);
		}
		
		protected function HideMenu(event:MouseEvent):void
		{
			StageRunner.getInstance().stage.removeEventListener(MouseEvent.MOUSE_UP,HideMenu);
			_menu.visible = false;
		}
		private function updateMainButton():void
		{
			_text.x = _bg.x+_bg.width/2-_text.width/2-1;
			_text.y = _bg.y+_bg.height/2-_text.height/2-1;
		}
		
		private function updateMenuPosistion():void
		{
			_menu.x = 5;
			_menu.y = _bg.y-_menu.height;	
//			_menu.x = _bg.x+_bg.width/2;
//			_menu.y = _bg.y+_bg.height/2-_menu.height;
			this.addChild(_menu);
		}
		
		public function get list():Array
		{
			var arr:Array = new Array();
			for(var i:int = 0;i<_menu.list.length;i++)
			{
				var obj:Object = {text:_menu.list[i].text,data:_menu.list[i].data,color:_menu.list[i].color};
				arr.push(obj);
			}
			return arr;
		}
		
		
		private var _menu:Menu;
		/**
		 * 添加一项 
		 * @param text
		 * @param data
		 * 
		 */	
		public function pushItem(text:String,data:Object,color:String):void
		{
			var _color:String = "0x"+color.slice(1);
			var _item:Item = new Item(text,data,uint(_color));
			_menu.addItem(_item);
			_item.addEventListener(MouseEvent.CLICK,itemClick_handler);
		}
		
		protected function itemClick_handler(event:MouseEvent):void
		{
			_text.fontColor = Item(event.currentTarget).color;
			_text.text = Item(event.currentTarget).text.slice(3);
			_selectedIndex = _menu.list.indexOf(event.currentTarget as Item);
			updateMainButton();
			if(_changeFunc != null)
			{
				_changeFunc(Item(event.currentTarget).data);
			}
		}
		
		
		override public function set width(value:Number):void
		{
			_bg.width = value;
		}
		
		override public function set height(value:Number):void
		{
			_bg.height = value;
		}
		
		public function dispose():void
		{
			
		}
		
	}
}
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextFieldAutoSize;

import kernel.display.components.BitmapProxy;
import kernel.display.components.text.TextFieldProxy;
import kernel.runner.UISkinRunner;

class Menu extends Sprite
{
	private var _bg:BitmapProxy;
	public function Menu()
	{
		_bg = new BitmapProxy();
		_bg.bitmapScale9GirdData = UISkinRunner.BaseDropMenuTextBG;
		this.addChild(_bg);
		_list = new Vector.<Item>();
		
	}
	
	private var _list:Vector.<Item>;

	public function get list():Vector.<Item>
	{
		return _list;
	}

	public function addItem(i:Item):void
	{
		if(_list.length>0)
		{
			i.x = 0;
			i.y = _list[_list.length-1].y+_list[_list.length-1].height;
		}
		this.addChild(i);
		_list.push(i);
		_bg.width = this.width;
		_bg.height = this.height;
	}
	
}

class Item extends Sprite
{
	private var _textField:TextFieldProxy;
	public var data:Object;
	public var text:String;
	public var color:uint;
	private var _width:Number = 85;

	override public function get width():Number
	{
		return _width;
	}

	override public function set width(value:Number):void
	{
		_width = value;
		update();
	}

	private var _height:Number = 22;

	override public function get height():Number
	{
		return _height;
	}

	override public function set height(value:Number):void
	{
		_height = value;
		update();
	}

	
	private var _bg:BitmapProxy;
	public function Item(_text:String,_data:Object,_color:uint)
	{
		text = _text;
		color = _color;
		_bg = new BitmapProxy();
		_bg.bitmapScale9GirdData = UISkinRunner.BaseDropMenuTextHover;

		this.addChild(_bg);
		_bg.alpha = 0;
		
		data = _data;
		_textField = new TextFieldProxy();
		
		_textField.autoSize = TextFieldAutoSize.LEFT;
		_textField.multiline = false;
		_textField.wordWrap = false;
		_textField.mouseEnabled = false;
		_textField.selectable = false;
		_textField.fontColor = _color;
		this.addChild(_textField);
		_textField.text = _text;
		
		update();
		this.addEventListener(MouseEvent.MOUSE_OVER,mouseOver_handler);
		this.addEventListener(MouseEvent.MOUSE_OUT,mouseOut_handler);
	}
	
	private function mouseOver_handler(e:MouseEvent):void
	{
		_bg.alpha = 1;	
	}
	
	private function mouseOut_handler(e:MouseEvent):void
	{
		_bg.alpha = 0;
	}
	
	private function update():void
	{
//		_textField.x = _width/2-_textField.width/2-1;
		_textField.x = 10;
		_textField.y = _height/2-_textField.height/2-1;
		_bg.width = _width + 10;
		_bg.height = _height;
	}
	
	
}


