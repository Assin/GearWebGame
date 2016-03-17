package kernel.display.components.text
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	import kernel.IDispose;
	import kernel.display.components.BitmapProxy;
	import kernel.utils.ObjectPool;
	
	/**
	 * 聊天系统里用的富文本
	 * @author 雷羽佳 2013.2.22 15：32
	 * 
	 */	
	public class RichTextFieldProxy extends Sprite implements IDispose
	{
		//基本文本框
		private var _textfield:TextField;
		//表情数据列表
		private var _faceVOList:Vector.<RichTextFiledImgVO>;
		//表情的开始符
		private const faceBegin	: String = "/:"
		//表情的结束符号
		private const faceEnd	: String = String.fromCharCode(160)+String.fromCharCode(133);
		//不间断占位符
		private const PLACE_HOLDER:String = String.fromCharCode(160);
		//横向不占位的符号，可以用来撑起高度
		private const HEIGHT_KEEPER:String = String.fromCharCode(133);
		//记录文字域的html格式文本。
		private var _htmlTextContent:String = "";
		//最大行数
		private var _maxNumOfLines:int = 50;
		
		private var _stage:Stage;
		private var isDisposed:Boolean = false;
		
		/**
		 * 最大限制行数 
		 */
		public function get maxNumOfLines():int
		{
			return _maxNumOfLines;
		}
		/**
		 * @private
		 */
		public function set maxNumOfLines(value:int):void
		{
			_maxNumOfLines = value;
		}
		private var _linkColor:String = "#000000";
		/**
		 *链接颜色 
		 */
		public function get linkColor():String
		{
			return _linkColor;
		}
		/**
		 * @private
		 */
		public function set linkColor(value:String):void
		{
			_linkColor = value;
			styleSheet.setStyle("a:hover",{color:_linkColor});
			_textfield.styleSheet = styleSheet;
		}
		private var _defaultColor:String = "#000000";
		/**
		 * 默认颜色 
		 * @param value
		 * 
		 */		
		public function set defaultColor(value:String):void
		{
			_defaultColor = value;
		}
		public function get defaultColor():String
		{
			return _defaultColor;
		}
		
		private var faceList:Array;
		private var textFormat:TextFormat;
		private var styleSheet:StyleSheet;
		public function RichTextFieldProxy()
		{
			_faceVOList = new Vector.<RichTextFiledImgVO>();
			_textfield = new TextField();
			this.addChild(_textfield);
			textFormat = new TextFormat();
			styleSheet = new StyleSheet();
			styleSheet.setStyle("a:hover",{color:"#ff0000"});
			
			_textfield.styleSheet = styleSheet;
			
			faceList = new Array();
			_textfield.selectable = true;
			defaultColor = "#ffffff";
			multiline = true;
			wordWrap = true;
			_textfield.useRichTextClipboard = true;
			autoSize = TextFieldAutoSize.LEFT;
			
			funcList = new Dictionary();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN,mouseDown_handler);
			
			this.addEventListener(Event.ADDED_TO_STAGE,addedToStage_handler);	
		}
		
		public function set selectable(value:Boolean):void
		{
			_textfield.selectable = value;
			if(value == false)
			{
				this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown_handler);
			}
		}
		
		/**
		 * 注册一个表情，表情注册了才能用哦~亲要注册呀 
		 * @param key 表情的key
		 * @param date 表情的data 这个参考bitmapProxy
		 * @param width 表情的宽度
		 * @param height 表情的高度
		 * 
		 */		
		public function registeFace(key:String,data:*,width:Number,height:Number):void
		{
			_faceVOList.push(new RichTextFiledImgVO(key,data,width,height));
		}
		/**
		 * 注册一串表情，表情注册了才能用哦~亲要注册呀
		 * @param list 表情列表
		 * 
		 */		
		public function registeFaceFromList(list:Vector.<RichTextFiledImgVO>):void
		{
			for(var i:int = 0; i<list.length; i++)
			{
				_faceVOList.push(new RichTextFiledImgVO(list[i].key,list[i].data,list[i].width,list[i].height));
			}
		}	
		private var funcList:Dictionary;
		/**
		 *注册一个link的被点击时候的方法。 
		 * @param key
		 * @param func
		 * 
		 */		
		public function registeLinkFunction(key:String,func:Function):void
		{
			funcList[key] = func;
		}
		
		protected function addedToStage_handler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE,addedToStage_handler);	
			if(isDisposed == true)
			{
				return;
			}
			_stage = stage;
			
			if(_textfield.selectable == true)
			{
				_stage.addEventListener(MouseEvent.MOUSE_UP,mouseUp_handler);
			}
			this._textfield.addEventListener(TextEvent.LINK,link_handler);
		}
		
		protected function mouseUp_handler(event:MouseEvent):void
		{
			if(_textfield.selectable == true)
			{
				this.removeEventListener(Event.ENTER_FRAME,updateSelect_handler)
				var str:String = this.getSelectString();
				fixFaceSelect(str);
			}
		}
		protected function mouseDown_handler(event:MouseEvent):void
		{
			this.addEventListener(Event.ENTER_FRAME,updateSelect_handler)
		}
		//更新选择，主要是对表情的修正
		protected function updateSelect_handler(event:Event):void
		{
			var str:String = this.getSelectString();
			fixFaceSelect(str);
		}
		private var currentLine:int = 0;
		/**
		 * 插入图片
		 * @param key
		 */		
		public function typeInFace(key:String):void
		{
			_textfield.htmlText = _htmlTextContent;
			var index:int = getFaceVOByKey(key);
			var date:*;
			var faceWidth:Number = 0;
			var faceHeight:Number = 0;
			
			if(index != -1)
			{
				date = _faceVOList[index].data;
				faceWidth = _faceVOList[index].width;
				faceHeight = _faceVOList[index].height;
			}
			else
			{
				this.typeInText(faceBegin+key);
			}
			
			if(index != -1)
			{
				var bitmap:BitmapProxy = new BitmapProxy(date);
				var num:int = _textfield.length;
				var tmp:String = "<font size='1' color='#00000000'>"+faceBegin+key;
				
				tmp += "<font size='"+faceHeight+"' color='#ffffff'>"+HEIGHT_KEEPER+"</font>";
				for(var i:int = 0;i<faceWidth-faceBegin.length-key.length-faceEnd.length;i++)
				{
					tmp += PLACE_HOLDER;
				}
				tmp += faceEnd+"</font>";
				_htmlTextContent += tmp;
				_textfield.htmlText = _htmlTextContent;
				_textfield.width; // 此句不可以删掉，否则后面语句会报错
				var rect:Rectangle = _textfield.getCharBoundaries(num);
				var currentLine:int = _textfield.getLineIndexOfChar(num);
				this.addChild(bitmap);
				if(faceList[currentLine] == undefined)
				{
					faceList[currentLine] = new FaceRow();
				}
				FaceRow(faceList[currentLine]).addBitmap(bitmap,rect.x,rect.y-(faceHeight-rect.height),faceHeight);
			}		
		}
		private var _linkCheck:RegExp = /(#(?:'[^']*'){3,7}#)/
		private var _linkCheck2:RegExp = /#(?:'[^']*'){3,7}#/
			
//		private var _linkCheck:RegExp = /(#'[^']*''[^']*''[^']*'#)/
//		private var _linkCheck2:RegExp = /#'[^']*''[^']*''[^']*'#/
			
			
		private var _linkCheck3:RegExp = /('[^']*')/
			
		/**
		 * 输入一段字符串，其中包括表情等。 
		 * @param value
		 * @param color
		 */		
		public function typeInMultString(value:String,color:String = null,nameColor:String=null):void
		{
		//	var time1:int = getTimer();
			creatNewParagraph();
			
			if(color!=null)
				defaultColor = color;
			
			var arr:Array = value.split(_linkCheck);
			for(var i:int = 0;i<arr.length;i++)
			{
				if(String(arr[i]).match(_linkCheck2) != null)
				{
					var tmp:Array = String(arr[i]).split(_linkCheck3);
					var color:String;
					var isHaveChar:Boolean;
					var isUnderLine:Boolean = false;
					if(tmp[7] != undefined)
					{
						color = "#"+String(tmp[7]).slice(1,String(tmp[7]).length-1)
					}

					if(tmp[9] == undefined)
					{
						isHaveChar = true;
					}else if(tmp[9] != undefined)
					{
						if(tmp[9] == "'true'") isHaveChar = true;
						else if(tmp[9] == "'false'") isHaveChar = false;	
					}
					
					if(tmp[11] != undefined)
					{
						if(tmp[11] == "'true'") isUnderLine = true;
						else if(tmp[11] == "'false'") isUnderLine = false;
					}
					
					typeInLink(
						String(tmp[1]).slice(1,String(tmp[1]).length-1),
						String(tmp[3]).slice(1,String(tmp[3]).length-1),
						String(tmp[5]).slice(1,String(tmp[5]).length-1),
						color,isHaveChar,isUnderLine,nameColor
					);
				}else
				{
					splitStrByFace(arr[i],nameColor);
				}
			}
			_textfield.htmlText = _htmlTextContent;
		}
		/**
		 * 递归调用自己 ，用表情将文字隔离开来
		 * @param value
		 * 
		 */		
		private function splitStrByFace(value:String,nameColor:String=null):void
		{
			
		//	var time1:int = getTimer();
			var max:int = 200;
			var key:String = " ";
			for(var i:int = 0;i<_faceVOList.length;i++)
			{
				var index:int = value.indexOf(faceBegin+_faceVOList[i].key);
				if(index < max && index != -1)
				{
					max = index;
					key = _faceVOList[i].key;
				}		
			}
			if(key != " ")
			{
				var str1:String = value.slice(0,max);
				var str2:String = value.slice(max+faceBegin.length+key.length);
				
				typeInText(str1,12,null,null,nameColor);
				typeInFace(key);
				splitStrByFace(str2)
				
			}else
			{
				typeInText(value,12,null,null,nameColor);
			}
		//	trace("splitStrByFace "+(getTimer()-time1));
		}
		
		private var currentFontSize:Number = 0;
		/**
		 * 插入一个超链接 
		 * @param value 超链接的显示内容
		 * @param functionKey 超链接的key，对一个方法，此方法和key的对应需要被注册
		 * @param data 需要传递给方法的参数
		 */		
//		public function typeInLink(value:String,functionKey:String,data:String):void
//		{	
//			_htmlTextContent += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+currentFontSize+"'>"+"["+"</font>";
//			_htmlTextContent += "<a href='event:"+functionKey+"#"+data+"'>"+"<font color = '"+_defaultColor+"' face = '"+_defaultFont+"' size='"+currentFontSize+"'>"+value+"</font>"+"</a>";
//			_htmlTextContent += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+currentFontSize+"'>"+"]"+"</font>";
//			_textfield.htmlText = _htmlTextContent;		
//		}
		
		public function typeInLink(value:String,functionKey:String,data:String,color:String = null,isHaveChar:Boolean = true,isUnderLine:Boolean = false,nameColor:String = null):void
		{	
			if(isHaveChar)
			{
				_htmlTextContent += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+currentFontSize+"'>"+"["+"</font>";
			}
			
			if(isUnderLine)
			{
				_htmlTextContent += "<u>";
			}
			if(color == null)
			{
				_htmlTextContent += "<a href='event:"+functionKey+"#"+data+"'>"+"<font color = '"+_defaultColor+"' face = '"+_defaultFont+"'>"+value+"</font>"+"</a>";
			}
			else
			{  
				if (nameColor) 
				{
					_htmlTextContent += "<a href='event:"+functionKey+"#"+data+"#"+nameColor+"'>"+"<font color = '"+nameColor+"' face = '"+_defaultFont+"'>"+value+"</font>"+"</a>";
				}else
				{
			    	var colorTmp:String = color.replace(/\#/,"");
			    	_htmlTextContent += "<a href='event:"+functionKey+"#"+data+"#"+colorTmp+"'>"+"<font color = '"+color+"' face = '"+_defaultFont+"'>"+value+"</font>"+"</a>";
				}
			}
			if(isUnderLine)
			{
				_htmlTextContent += "</u>";
			}
			if(isHaveChar)
			{
			    _htmlTextContent += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+currentFontSize+"'>"+"]"+"</font>";
			}
			_textfield.htmlText = _htmlTextContent;
		}
		
		
		protected function link_handler(event:TextEvent):void
		{
			var key:String = event.text.split("#")[0];
			var value:String = event.text.split("#")[1];
			var func:Function = funcList[key];
			if(func != null)
			{
				func(value);
			}
		}
		private var ParagraphNum:int = 0;
		/**
		 * 创建一个新段落，新段落的内容为空，需要进行插入。 
		 */		
		public function creatNewParagraph():void
		{
			if(_textfield.htmlText != "")
			{
			//	trace("ffffffff "+_maxNumOfLines+" "+ParagraphNum);
				_htmlTextContent += "<br>"
				_textfield.htmlText = _htmlTextContent;
				ParagraphNum++;
				if(ParagraphNum >= maxNumOfLines)
				{
					deleteFristParagraph();
					ParagraphNum--;
				}
			}
		}
		/**
		 * 在当前段落插入一段文字
		 * @param value 文字内容
		 * @param color 文字颜色
		 * @param font  文字字体
		 *  
		 */		
		public function typeInText(value:String,size:Number = 12,color:String = null,font:String = null,nameColor:String=null):void
		{
			
			//var time1:int = getTimer();
			var _color:String;
			var _font:String;
			if(color == null)
				_color = defaultColor;
			else
				_color = color
			if(font == null)
				_font = _textfield.defaultTextFormat.font;
			else
				_font = font;
			currentFontSize = size;
			if (nameColor) 
			{
				if (value==" [ "||value.charAt(1)=="]") 
				{   
					if (value.charAt(1)=="]") 
					{
						_htmlTextContent += "<font size='"+size+"' color = '"+nameColor+"' face = '"+_defaultFont+"'>"+value.charAt(1)+"</font>";
						_htmlTextContent += "<font size='"+size+"' color = '"+_color+"' face = '"+_defaultFont+"'>"+value.substr(3,value.length)+"</font>";
					}else
					{
						_htmlTextContent += "<font size='"+size+"' color = '"+nameColor+"' face = '"+_defaultFont+"'>"+value+"</font>";
					}
				}else
				{
					_htmlTextContent += "<font size='"+size+"' color = '"+nameColor+"' face = '"+_defaultFont+"'>"+value+"</font>";
				}
			}else
			{
			
			    _htmlTextContent += "<font size='"+size+"' color = '"+_color+"' face = '"+_defaultFont+"'>"+value+"</font>";
			 }
			
			
			//_textfield.htmlText = _htmlTextContent;
			
		//	trace("gggggggggggggg "+(getTimer()-time1));
		}
		private function getSelectString():String
		{
			var str:String = _textfield.text.slice(_textfield.selectionBeginIndex,_textfield.selectionEndIndex);
			return str;
		}
		/**
		 * 查找str1里面拥有的str2的个数 
		 * @param str1
		 * @param str2
		 * @return 
		 */		
		private function contentNum(str1:String,str2:String):int
		{
			var num:int = 0;
			var _str1:String = str1;
			while(_str1.indexOf(str2) >= 0)
			{
				num++;
				_str1 = _str1.slice(_str1.indexOf(str2)+str2.length);
			}
			return num;
		}
		//修正表情的选择
		private function fixFaceSelect(str:String):void
		{
			var begin:int;
			var i:int = 0;
			var tmp:String;
			contentNum(str,faceBegin);
			if(contentNum(str,faceEnd) - contentNum(str,faceBegin) == 1)
			{
				begin = this._textfield.selectionBeginIndex+str.indexOf(faceEnd);
				for(i = begin-1;i>0;i--)
				{
					if(_textfield.text.charAt(i) == faceBegin.charAt(faceBegin.length-1) ) 
					{
						tmp = _textfield.text.slice(i-faceBegin.length+1,i+1);
						if(tmp == faceBegin)
							break;
					}
				}
				if(tmp == faceBegin) 
				{	
					_textfield.setSelection(i-faceBegin.length+1,_textfield.selectionEndIndex);
				}
			}
			if(contentNum(str,faceEnd) - contentNum(str,faceBegin) == -1)
			{
				begin = _textfield.selectionBeginIndex+str.lastIndexOf(faceBegin)+String(faceBegin).length;
				for(i = begin;i<_textfield.text.length;i++)
				{
					if(_textfield.text.charAt(i) == faceEnd.charAt(0))
					{
						tmp = _textfield.text.slice(i,i+faceEnd.length);
						if(tmp == faceEnd)
							break;
					}
				}
				if(tmp == faceEnd) 
				{
					_textfield.setSelection(_textfield.selectionBeginIndex,i+faceEnd.length);
				}
			}
			var end:int = 0;
			var tmp2:String;
			if(
				contentNum(str,faceEnd) == contentNum(str,faceBegin) 
			)
			{
				for(i = _textfield.selectionBeginIndex;i>0;i--)
				{
					if(_textfield.text.charAt(i) == faceBegin.charAt(faceBegin.length-1)) 
					{
						tmp = _textfield.text.slice(i-faceBegin.length+1,i+1);
						if(tmp == faceBegin)
							break;
					}
					if(_textfield.text.charAt(i) == faceEnd.charAt(faceEnd.length-1)) 
					{
						tmp = _textfield.text.slice(i-faceEnd.length+1,i+1);
						if(tmp == faceEnd)
							break;
					}
				}
				for(var j:int = _textfield.selectionEndIndex;j<_textfield.text.length;j++)
				{
					if(_textfield.text.charAt(j) == faceEnd.charAt(0)) 
					{
						tmp2 = _textfield.text.slice(j,j+faceEnd.length)
						if(tmp2 == faceEnd)
							break;
					}
					if(_textfield.text.charAt(j) == faceBegin.charAt(0)) 
					{
						tmp2 = _textfield.text.slice(j,j+faceBegin.length)
						if(tmp2 == faceEnd)
							break;
					}
				}
				if(tmp == faceBegin && tmp2 == faceEnd)
				{
					_textfield.setSelection(i-1,j+faceEnd.length);
				}	
			}
		}
		//通过key得到表情vo的索引
		private function getFaceVOByKey(key:String):int
		{
			var result:int = -1;
			for(var i:int = 0; i < _faceVOList.length;i++)
			{
				if(_faceVOList[i].key == key) 
				{
					result = i;
					break;
				}
			}
			return result;
		}
		/**
		 *删除第一行内容 
		 */		
		public function deleteFristParagraph():void
		{
			//var time1:int = getTimer();
			var textCatch:String = _htmlTextContent;
			var lines0:Number = _textfield.numLines;
			
			var deletedStr:String = "";
			
			for(var i:int = 0;i<_htmlTextContent.length-3;i++)
			{
				if(_htmlTextContent.charAt(i) == "<" &&
					_htmlTextContent.charAt(i+1) == "b" && 
					_htmlTextContent.charAt(i+2) == "r" &&
					_htmlTextContent.charAt(i+3) == ">"
				)
				{
					_htmlTextContent = _htmlTextContent.slice(i+4);
					deletedStr = _htmlTextContent.slice(0,i+4);
					break;
				}
			}
			
			
			
			var linesHeight:Number = 0;
			var tmpTextf:TextField = new TextField();
			tmpTextf.wordWrap = wordWrap;
			tmpTextf.multiline = multiline;
			tmpTextf.styleSheet = styleSheet;
			tmpTextf.useRichTextClipboard = true;
			tmpTextf.selectable = true;
			tmpTextf.autoSize = autoSize;
			tmpTextf.htmlText = deletedStr
			linesHeight = tmpTextf.height;
				
			/*
			var tmp:Array = _htmlTextContent.split("<br>");
			_htmlTextContent = "";
			for(var i:int = 1;i<tmp.length-1;i++)
			{
				_htmlTextContent+=tmp[i];
				_htmlTextContent+="<br>";
			}
			_htmlTextContent+=tmp[i];
			*/
			
			
		//	_textfield.htmlText = _htmlTextContent;
			var lines1:Number = _textfield.numLines;
			var deleteLinesNum:int =  lines0-lines1;
			//trace("aaaaaaaaaaaaaaa "+(getTimer()-time1));
			
			
			
			//time1 = getTimer();
			
			//_textfield.htmlText = textCatch;
			//var linesHeight:Number = 0;
			//for(i = 0;i<deleteLinesNum;i++)
			//{
				//linesHeight += _textfield.getLineMetrics(i).height;
			//}
			//_textfield.htmlText = _htmlTextContent;
			
			//trace("aaaaaaaaaaaaaaa "+(getTimer()-time1)+" "+deleteLinesNum);
			
			
			//time1 = getTimer();
			for(i = 0;i<deleteLinesNum;i++)
			{
				var tmpFaceRow:FaceRow = faceList.shift() as FaceRow;
				if(tmpFaceRow != null)
				{
					tmpFaceRow.dispose();
				}
			}
			
			//trace("aaaaaaaaaaaaaaa "+(getTimer()-time1)+" "+deleteLinesNum);
			
			
			//time1 = getTimer();
			for(i = 0;i<faceList.length;i++)
			{
				tmpFaceRow = faceList[i];
				
				if(tmpFaceRow != null)
				{
					tmpFaceRow.fixHeight(linesHeight);
				}
			}
			//trace("aaaaaaaaaaaaaaa "+(getTimer()-time1)+" "+faceList.length);
			
		}
		override public function get width():Number
		{
			return _textfield.width;
		}
		override public function set width(value:Number):void
		{
			_textfield.width = value;
		}
		override public function get height():Number
		{
			return _textfield.height;
		}
		override public function set height(value:Number):void
		{
			_textfield.height = value;
		}
		
		public function get textWidth():Number
		{
			return _textfield.textWidth;
		}
		
		public function get textHeight():Number
		{
			return _textfield.textHeight;
		}
		
		/**
		 *指示字段是否为多行文本字段。如果值为 true，则文本字段为多行文本字段；如果值为 false，则文本字段为单行文本字段。在类型为 TextFieldType.INPUT 的字段中，multiline 值将确定 Enter 键是否创建新行（如果值为 false，则将忽略 Enter 键）。如果将文本粘贴到其 multiline 值为 false 的 TextField 中，则文本中将除去新行。 
		 * @return 
		 * 
		 */		
		public function get multiline():Boolean
		{
			return _textfield.multiline;
		}
		/**
		 *指示字段是否为多行文本字段。如果值为 true，则文本字段为多行文本字段；如果值为 false，则文本字段为单行文本字段。在类型为 TextFieldType.INPUT 的字段中，multiline 值将确定 Enter 键是否创建新行（如果值为 false，则将忽略 Enter 键）。如果将文本粘贴到其 multiline 值为 false 的 TextField 中，则文本中将除去新行。 
		 * @param value
		 */
		public function set multiline(value:Boolean):void
		{
			_textfield.multiline = value;
		}
		/**
		 * 一个布尔值，指示文本字段是否自动换行。如果 wordWrap 的值为 true，则该文本字段自动换行；如果值为 false，则该文本字段不自动换行。默认值为 false。 
		 * @return 
		 */
		public function get wordWrap():Boolean
		{
			return _textfield.wordWrap;
		}
		/**
		 * 一个布尔值，指示文本字段是否自动换行。如果 wordWrap 的值为 true，则该文本字段自动换行；如果值为 false，则该文本字段不自动换行。默认值为 false。
		 * @param value
		 */
		public function set wordWrap(value:Boolean):void
		{
			_textfield.wordWrap = value;
		}
		/**
		 * 指定的 autoSize 不是 flash.text.TextFieldAutoSize 的成员。
		 * @return 
		 * 
		 */		
		public function get autoSize():String
		{
			return _textfield.autoSize;
		}
		/**
		 *指定的 autoSize 不是 flash.text.TextFieldAutoSize 的成员。 
		 * @param value
		 * 
		 */
		public function set autoSize(value:String):void
		{
			_textfield.autoSize = value;
		}
		private var _defaultFont:String = "Arial";
		
		/**
		 *默认字体 
		 */
		public function get defaultFont():String
		{
			return _defaultFont;
		}
		/**
		 * @private
		 */
		public function set defaultFont(value:String):void
		{
			_defaultFont = value;
		}
		private var _defaultLinkCharColor:String = "#FF0000"
		/**
		 * 默认链接的颜色提示符
		 */
		public function get defaultLinkCharColor():String
		{
			return _defaultLinkCharColor;
		}
		/**
		 * @private
		 */
		public function set defaultLinkCharColor(value:String):void
		{
			_defaultLinkCharColor = value;
		}
		/**
		 *  清空当前所有内容，不是销毁对象
		 * 
		 */		
		public function clean():void
		{
			while(faceList.length>0)
			{
				var tmp:FaceRow = faceList.pop() as FaceRow;
				if(tmp != null)
					tmp.dispose();
			}
			ParagraphNum = 0;
			_htmlTextContent = "";
			this._textfield.htmlText = "";
			this._textfield.text = "";
		}
		public function dispose():void
		{
			isDisposed = true;
			this.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDown_handler);
			this.removeEventListener(Event.ADDED_TO_STAGE,addedToStage_handler);	
			if(_stage != null)
			_stage.removeEventListener(MouseEvent.MOUSE_UP,mouseUp_handler);
			this._textfield.removeEventListener(TextEvent.LINK,link_handler);
			this.removeEventListener(Event.ENTER_FRAME,updateSelect_handler);
				
			while(faceList.length>0)
			{
				var tmp:FaceRow = faceList.pop() as FaceRow;
				tmp.dispose();
			}
			ObjectPool.disposeObject(_htmlTextContent);
			ObjectPool.disposeObject(faceList);
			ObjectPool.disposeObject(_textfield);
			ObjectPool.disposeObject(_faceVOList);
			ObjectPool.disposeObject(funcList);
			
			this._textfield.removeEventListener(TextEvent.LINK,link_handler);
			
		}
	}
}
import flash.display.Bitmap;

import kernel.display.components.BitmapProxy;
import kernel.utils.ObjectPool;
/**
 * 每行的内容 
 * @author Administrator
 * 
 */
class FaceRow
{
	private var _faceList:Vector.<Bitmap>;
	private var _currentMaxHeight:Number;
	
	public function FaceRow()
	{
		_currentMaxHeight = 0;
		_faceList = new Vector.<Bitmap>();	
	}
	public function dispose():void
	{
		while(_faceList.length>0)
		{
			ObjectPool.disposeObject(_faceList.pop());
		}
	}
	public function addBitmap(target:BitmapProxy,x:Number,y:Number,h:Number):void
	{
		_faceList.push(target);
		
		if(h>_currentMaxHeight)
		{
			for(var i:int = 0;i<_faceList.length;i++)
			{
				_faceList[i].y +=  h-_currentMaxHeight;
			}
			_currentMaxHeight = h;
		}
		target.x = x;
		target.y = y;
	}
	public function fixHeight(h:Number):void
	{
		
		for(var i:int = 0;i<_faceList.length;i++)
		{
			_faceList[i].y -=  h;
		}
	}
}