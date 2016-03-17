package kernel.display.components.text
{
	import com.greensock.TweenLite;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import kernel.IDispose;
	import kernel.utils.ObjectPool;

	/**
	 * 动态多行文本，可以设定显示时间,超过显示时间后列队中新的一条自动顶替旧的一条 
	 * @author 雷羽佳  2013.3.1 9:28
	 * 
	 */
	public class DynamicMultlineText extends Sprite implements IDispose
	{ 
		private var _textWidth:Number;
		private var _fontSize:Number = 12;
		private var _font:String = "Arial";
		private var _fontColor:String = "#000000";
		private var _pauseTime:Number = 2;
		
		
		private var _list:Vector.<timeTextField>;
		
		public function DynamicMultlineText()
		{
			_list = new Vector.<timeTextField>();
			this.addEventListener(Event.ENTER_FRAME,enterFrame_handler);
		}
	
		/**
		 *添加并显示一条数据
		 * @param value
		 * 
		 */		
		public function addTextAndShow(value:String):void
		{
			var text:timeTextField = new timeTextField();
			text.fontSize = _fontSize;
			text.font = _font;
			text.fontColor = _fontColor;
			text.textWidth = _textWidth;
			text.pauseTime = _pauseTime;
			
			text.setTextAndActivite(value);
			var _y:Number = 0;
			
			if(_list.length>0)
			{
				_y = _list[_list.length-1].targetY+_list[_list.length-1].height;
			}
			text.targetY = _y;
			this.addChild(text);
			_list.push(text);
		}
		
		public function addHtmlText(html:String):void
		{
			var text:timeTextField = new timeTextField();
			text.textWidth = _textWidth;
			text.pauseTime = _pauseTime;
			
			text.setHtmlTextAndActive(html);
			var _y:Number = 0;
			
			if(_list.length>0)
			{
				_y = _list[_list.length-1].targetY+_list[_list.length-1].height;
			}
			text.targetY = _y;
			this.addChild(text);
			_list.push(text);
		}
		
		protected function enterFrame_handler(event:Event):void
		{
			if(_list.length>0)
			{
				var index:Number = -1;
				
				for(var i:int = _list.length-1;i>=0;i--)
				{
					if(_list[i].ifAppera == false)
					{
						index = i;
						break;
					}
				}
				
				if(index != -1 )
				{
					if(_list.length > index+1)
					{
						index = index+1;
						var height:Number =_list[index].targetY;
						
						for(i = index;i<_list.length;i++)
						{
							_list[i].targetY-=height;
						}
					}
				}
				

			}
			while(_list.length>0 && _list[0].ifAppera == false)
			{
				_list.shift();
			}
			
		}

		/**
		 *单条文本的宽度，这个文本是可以多行显示的。 
		 */
		public function get textWidth():Number
		{
			return _textWidth;
		}

		/**
		 * @private
		 */
		public function set textWidth(value:Number):void
		{
			_textWidth = value;
		}

		/**
		 *字号大小 ，默认为12
		 */
		public function get fontSize():Number
		{
			return _fontSize;
		}

		/**
		 * @private
		 */
		public function set fontSize(value:Number):void
		{
			_fontSize = value;
		}

		/**
		 *字体 ，默认为Arial
		 */
		public function get font():String
		{
			return _font;
		}

		/**
		 * @private
		 */
		public function set font(value:String):void
		{
			_font = value;
		}

		/**
		 *字颜色，默认为#000000 
		 */
		public function get fontColor():String
		{
			return _fontColor;
		}

		/**
		 * @private
		 */
		public function set fontColor(value:String):void
		{
			_fontColor = value;
		}

		/**
		 *文字的停顿时间(秒); 
		 */
		public function get pauseTime():Number
		{
			return _pauseTime;
		}

		/**
		 * @private
		 */
		public function set pauseTime(value:Number):void
		{
			_pauseTime = value;
		}	
		
		public function dispose():void
		{
			this.removeEventListener(Event.ENTER_FRAME,enterFrame_handler);
			ObjectPool.disposeObject(this);
		}
		
	}
}


import com.greensock.TweenLite;

import flash.display.Sprite;
import flash.events.Event;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;
import flash.utils.getTimer;

import kernel.utils.ObjectPool;

class timeTextField extends Sprite
{
	private var _textWidth:Number;
	private var _fontSize:Number = 12;
	private var _font:String = "Arial";
	private var _fontColor:String = "#000000";
	private var _pauseTime:Number = 2;
	
	private var _textformat:TextFormat;
	
	private var _timeStamp:int = 0;
	
	private var _text:TextField;
	
	public var ifAppera:Boolean = true;
	public function timeTextField()
	{
		_textformat = new TextFormat();
		_textformat.color = uint("0x"+_fontColor.slice(1,_fontColor.length));
		_textformat.size = _fontSize;
		_textformat.font = _font;
		_text = new TextField();
		_text.width = _textWidth;
		_text.autoSize = TextFieldAutoSize.LEFT;
		_text.multiline = true;
		_text.wordWrap = true;
		_text.defaultTextFormat = _textformat;
		_text.selectable = false;
		_text.alpha = 0;
		this.addChild(_text);
	}
	/**
	 * 显示并激活 
	 * @param value
	 * 
	 */	
	public function setTextAndActivite(value:String):void
	{
//		
		_text.width = _textWidth;
		_text.defaultTextFormat = _textformat;
		_text.text = value;
		TweenLite.to(_text, 0.2, {alpha:1});
		_timeStamp = getTimer();
		this.addEventListener(Event.ENTER_FRAME,enterFrame_handler);
	}
	
	
	public function setHtmlTextAndActive(html:String):void
	{
		_text.width = _textWidth;
		_text.htmlText = html;
		TweenLite.to(_text, 0.2, {alpha:1});
		_timeStamp = getTimer();
		this.addEventListener(Event.ENTER_FRAME,enterFrame_handler);
	}
	
	protected function enterFrame_handler(event:Event):void
	{
		if(getTimer() >= _timeStamp+_pauseTime*1000)
		{
			this.removeEventListener(Event.ENTER_FRAME,enterFrame_handler);
			disappera();
		}
	}	
	
	
	private function disappera():void
	{
		ifAppera = false;
		TweenLite.to(_text, 0.2, {alpha:0,onComplete:dispose});
	}
	
	private function dispose():void
	{
		_text.text = "";
		this.removeChild(_text);
		_text = null;
		_textformat = null;
		ObjectPool.disposeObject(this);
		
	}
	
	/**
	 *单条文本的宽度，这个文本是可以多行显示的。 
	 */
	public function get textWidth():Number
	{
		return _textWidth;
	}
	
	/**
	 * @private
	 */
	public function set textWidth(value:Number):void
	{
		_textWidth = value;
	}
	
	/**
	 *字号大小 ，默认为12
	 */
	public function get fontSize():Number
	{
		return _fontSize;
	}
	
	/**
	 * @private
	 */
	public function set fontSize(value:Number):void
	{
		_fontSize = value;
		_textformat.size = _fontSize;
	}
	
	/**
	 *字体 ，默认为Arial
	 */
	public function get font():String
	{
		return _font;
	}
	
	/**
	 * @private
	 */
	public function set font(value:String):void
	{
		_font = value;
		_textformat.font = _font;
	}
	
	/**
	 *字颜色，默认为#000000 
	 */
	public function get fontColor():String
	{
		return _fontColor;
	}
	
	/**
	 * @private
	 */
	public function set fontColor(value:String):void
	{
		_fontColor = value;
		_textformat.color = uint("0x"+_fontColor.slice(1,_fontColor.length));
	}
	
	/**
	 *文字的停顿时间(秒); 
	 */
	public function get pauseTime():Number
	{
		return _pauseTime;
	}
	
	/**
	 * @private
	 */
	public function set pauseTime(value:Number):void
	{
		_pauseTime = value;
	}	
	
	private var _targetY:Number = 0;

	public function get targetY():Number
	{
		return _targetY;
	}

	public function set targetY(value:Number):void
	{
//		var flag:Boolean = false;
//		if(_targetY == 0) flag = false;
//		else flag = true;
		
		_targetY = value;
//		if(flag == true)
			TweenLite.to(this, 0.4, {y:_targetY});
//		else
//			this.y = _targetY;
	}

	
}

