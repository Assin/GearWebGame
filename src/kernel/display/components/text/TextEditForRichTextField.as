package kernel.display.components.text
{
	import flash.events.Event;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;
	
	import kernel.IDispose;
	import kernel.utils.ObjectPool;
	import kernel.utils.StringUtil;
	
	/**
	 * 为聊天框富文本准备的文本输入框，针对格式（表情，链接，文字）有优化。
	 * @author 雷羽佳 2013.2.26 15:11
	 * 
	 */	
	public class TextEditForRichTextField extends TextField implements IDispose
	{
		//不间断占位符
		private const PLACE_HOLDER:String = String.fromCharCode(160);
		//横向不占位的符号，可以用来撑起高度
		private const HEIGHT_KEEPER:String = String.fromCharCode(133);
		private var _styleSheet:StyleSheet;
		private var _maxLenght:int = 100;
		/**超链接限制，默认为3,-1为不限制*/
		public var linkNumLimit:int = 3;
		private var _defaultFontSize:Number = 12;
		private var bufftext:String = "";
		private var textArr0:Array;
		private var tmpHtmlText:String;
		private var _htmlTextContent:String = "";
		private var _defaultLinkColor:String = "#0099FF";
		private var _defaultFont:String = "Arial";
		private var _defaultLinkCharColor:String = "#FF0000"
		/**
		 * 最大显示字数 
		 */		
		private var _maxShowLenght:int = 100;
		
		
		/**
		 *最大字数限制 
		 */
		public function get maxLenght():int
		{
			return _maxLenght;
		}

		/**
		 * @private
		 */
		public function set maxLenght(value:int):void
		{
			_maxLenght = value;
		}


		
		public function get maxShowLenght():int
		{
			return _maxShowLenght;
		}
		
		public function set maxShowLenght(value:int):void
		{
			_maxShowLenght = value;
		}
		
		public function TextEditForRichTextField()
		{
			this.type = TextFieldType.INPUT;
			this.selectable = true;
			this.mouseEnabled = true;
//			this.useRichTextClipboard = true;

			textArr0 = new Array();
			this.addEventListener(Event.CHANGE,change_handler);
		}

		public function dispose():void
		{
			this.text = "";
			this._maxLenght = 0;
			ObjectPool.disposeObject(textArr0);
			textArr0 = null;
			ObjectPool.disposeObject(htmlCheck);
			htmlCheck = null;
			ObjectPool.disposeObject(sizeCheck);
			sizeCheck = null;
			ObjectPool.disposeObject(colorCheck);
			colorCheck = null;
			ObjectPool.disposeObject(fontCheck);
			fontCheck = null;
			ObjectPool.disposeObject(linkCheck);
			linkCheck = null;
			ObjectPool.disposeObject(getAttributeReg);
			getAttributeReg = null;
			ObjectPool.disposeObject(linkCharFixREG);
			linkCharFixREG = null;
			ObjectPool.disposeObject(linkREG);
			linkREG = null;
			ObjectPool.disposeObject(getLinkColorREG);
			getLinkColorREG = null;
			ObjectPool.disposeObject(_linkCheck);
			_linkCheck = null;
			ObjectPool.disposeObject(_linkCheck2);
			_linkCheck2 = null;
			ObjectPool.disposeObject(_linkCheck3);
			_linkCheck3 = null;
			ObjectPool.disposeObject(getlinkReg);
			getlinkReg = null;
			this.removeEventListener(Event.CHANGE,change_handler);
			
		}
		
		/**
		 * 清空 
		 * 
		 */
		public function clean():void
		{
			this.text = "";
			textArr0 = [];
		}
		

		private var htmlCheck:RegExp = /(<[^<>]*>)/;
		private var sizeCheck:RegExp = /SIZE=\"[0-9]*\"/g;
		private var colorCheck:RegExp = /COLOR=\"#[0-9A-Z]*\"/g;
		private var fontCheck:RegExp = /FACE=\"[^=]*\"/g;
		private var linkCheck:RegExp = /(<A[^<]*<\/A>)/;
		private var getAttributeReg:RegExp = /.*?<A[^<]*\"event:(.*?)\".TARGET\=\"[^<]*\">([^<]*)<\/A>.*?/;
		private var linkCharFixREG:RegExp = /(\[<FONT.COLOR=\"\#[0-9A-Za-z]*\"><A[^<]*<\/A><\/FONT>\])/;
		private var linkREG:RegExp = /(>.*<)/;
		private var getLinkColorREG:RegExp = /\<A.HREF\=\"event\:.*?\#.*?#(.*?)\".*/;
		private var _linkCheck:RegExp = /(#(?:'[^']*'){3,5}#)/;
		private var _linkCheck2:RegExp = /#(?:'[^']*'){3,5}#/;
		private var _linkCheck3:RegExp = /('[^']*')/;
		private var getlinkReg:RegExp = /<A[^<]*\"event:(.*?)#(.*?)(#.*?)?\".TARGET\=\"[^<]*\">([^<]*)<\/A>/;
		
		public function updata():void
		{
			change_handler(null);
		}
		
		protected function change_handler(event:Event):void
		{
			
			var str:String = htmlText;
			str = str.replace(sizeCheck,"SIZE=\""+_defaultFontSize+"\"");
			str = str.replace(colorCheck,"COLOR=\""+_defaultColor+"\"");
			str = str.replace(fontCheck,"FACE=\""+_defaultFont+"\"");
			str = fixLinkChar(str);
			var arr:Array = str.split(htmlCheck);
			var tmp:String = "";
			for(var i:int = 0;i<arr.length;i++)
			{
				if(String(arr[i]).indexOf(PLACE_HOLDER) == -1 && String(arr[i]).indexOf(HEIGHT_KEEPER) == -1)
				{
					tmp += String(arr[i]);
				}
			}
			
			arr = tmp.split(linkCheck);
			arr = checkLinkChangeAndFix(textArr0,arr);
			
			tmp = "";
			
			for(i = 0;i<arr.length; i++)
			{
				if(String(arr[i]).indexOf("<A") >=0)
				{
					tmp += fixLinkColor(String(arr[i]));
					
				}else
				{
					tmp += String(arr[i]);
				}
			}
			
			htmlText = tmp;
			textArr0 = htmlText.split(linkCheck);
			maxLenghtCheck2();
		}
		
		
		/**
		 *超过长度以后，就不能再输入
		 * 
		 */		
		private function maxLenghtCheck2():void
		{
			var str1:String = this.getRealText();
			var str2:String = this.text;
			var lenght1:int = StringUtil.getStringBytesLength(str1);
			var lenght2:int = str2.length;
			
			if(lenght1 > _maxLenght || lenght2 > _maxShowLenght)
			{
				this.setSelection(caretIndex-1,caretIndex-1);
				this.htmlText = bufftext;
			}
			bufftext = this.htmlText;
		}
		/**
		 *超过长度以后再输入的话就把最后的字符顶掉 
		 * 
		 */		
		private function maxLenghtCheck():void
		{
			var str:String = this.getRealText();
			var lenght:int = str.length;

			if(lenght > _maxLenght)
			{
				if(ifLinkInLast(str) == true)
				{
					str = deleteLastLink(str);
				}else
				{
					str = str.slice(0,str.length-1);
				}
				typeInMultString(str);
				change_handler(null);
			}
		}
		
		
		private function ifLinkInLast(realText:String):Boolean
		{
			var arr:Array = realText.split(_linkCheck);
			var result:Boolean = false;
			if(String(arr[arr.length-1]) == "")
			{
				result = true;
			}else
			{
				result = false;
			}
			return result;
		}
		
		private function deleteLastLink(realText:String):String
		{
			var arr:Array = realText.split(_linkCheck);
			var str:String = "";
			for(var i:int = 0;i<arr.length-2;i++)
			{
				str = str+String(arr[i]);
			}
			return str;
		}
		
		
		
		/**
		 *检查两个都含有link数组，并尝试修复对link的修改 
		 * @param arr0 原始数组
		 * @param arr1 新的数组
		 * @return 修改完毕返回的数组
		 * 
		 */		
		private function checkLinkChangeAndFix(arr0:Array,arr1:Array):Array
		{
			if(checkTextWithLink(arr0,arr1) == false) 
			{
				return arr1;
			}
			var newArr:Array = new Array();
			var i:int = 0;
			var lenght:int = arr0.length;
			for(i = 0;i<lenght;i++)
			{
				if(String(arr0[i]).indexOf("<A") >=0)
				{
					if(getValueFromLink(arr1[i]).length > getValueFromLink(arr0[i]).length)
					{
						newArr.push(getValueFromLink(arr0[i]));
					}else if(getValueFromLink(arr1[i]).length < getValueFromLink(arr0[i]).length)
					{
						
					}else if(getValueFromLink(arr1[i]).length == getValueFromLink(arr0[i]).length)
					{
						newArr.push(arr0[i]);
					}
				}else if(arr1[i] != undefined)
				{
					newArr.push(arr1[i]);
				}
			}
			return newArr;
		}
		
		
		/**
		 * 判断两个都含有link的数组，link项的位置是否一直 
		 * @param arr0 原有的
		 * @param arr1 新的
		 * @return true相同  false不相同
		 */		
		private function checkTextWithLink(arr0:Array,arr1:Array):Boolean
		{
		
			if(checkNumOfLink(arr0,arr1) == false) return false;
			
			var lenght:int = arr0.length;
			var result:Boolean = true;
			
			var i:int = 0;
			for(i = 0;i<lenght;i++)
			{
				if(String(arr0[i]).indexOf("<A") >=0)
				{
					if(String(arr1[i]).indexOf("<A") >= 0 && getAttributeFromLink(arr0[i]) == getAttributeFromLink(arr1[i]))
					{	
					}else
					{
						result = false;
						break;
					}
				}
			}
			
			for(i = 0;i<lenght;i++)
			{
				if(String(arr1[i]).indexOf("<A") >=0)
				{
					if(String(arr0[i]).indexOf("<A") >= 0 && getAttributeFromLink(arr0[i]) == getAttributeFromLink(arr1[i]))
					{	
					}else
					{
						result = false;
						break;
					}
				}
			}
			
			return result;
		}
		
		
		/**
		 *通过一个链接的html得到他的属性 
		 * @param str
		 * @return 
		 * 
		 */		
		private function getAttributeFromLink(str:String):String
		{
			var arr:Array = str.split(getAttributeReg);
			return arr[1];
		}
		/**
		 *通过一个链接的html得到他的值 
		 * @param str
		 * @return 
		 * 
		 */		
		private function getValueFromLink(str:String):String
		{
			var arr:Array = str.split(getAttributeReg);
			return arr[2];
		}
			
		/**
		 * 判断两个数组内的link数量是否相同
		 * @param arr0
		 * @param arr1
		 * @return true相同  false不相同
		 * 
		 */
		private function checkNumOfLink(arr0:Array,arr1:Array):Boolean
		{
			var num1:int = 0;
			var num2:int = 0;
			
			var i:int = 0;
			for(i = 0;i<arr0.length;i++)
			{
				if(String(arr0[i]).indexOf("<A") >=0)
				{
					num1++;
				}	
			}
			
			for(i = 0;i<arr1.length;i++)
			{
				if(String(arr1[i]).indexOf("<A") >=0)
				{
					num2++;
				}	
			}
			var result:Boolean;
			if(num1 == num2 && num1!=0) result = true;
			else result = false;
			return result;
		}
		

		//修正链接前后的中括号。把丫去掉
		private function fixLinkChar(html:String):String
		{
			var arr:Array = html.split(linkCharFixREG);
			var str:String = "";
			for(var i:int = 0;i<arr.length;i++)
			{
				if(String(arr[i]).indexOf("<A") >= 0 )
				{
					var tmp:String = String(arr[i]);
					tmp = tmp.replace(/\[/,"");
					tmp = tmp.replace(/\]/,"");
					str += tmp;
				}else
				{
					str += String(arr[i]);
				}
			}
			return str;
		}
		
		

		
		private function fixLinkColor(link:String):String
		{
			var tmpArr:Array = link.split(getLinkColorREG);
			var color:String = _defaultLinkColor;
			if(tmpArr[1] != undefined)
			{
				if(String(tmpArr[1]).length == 6)
				{
					color = "#"+String(tmpArr[1]);
				}
			}
			
			var tmp1:String = "<font color = '"+color+"' face = '"+_defaultFont+"'>";
			var tmp2:String = "</font>";
			var arr:Array = link.split(linkREG);
			
			var result:String = "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+_defaultFontSize+"'>"+"["+"</font>";
			result += arr[0]+">"+tmp1+ String(arr[1]).slice(1,String(arr[1]).length-1)  +tmp2+"<"+arr[2];
			result += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+_defaultFontSize+"'>"+"]"+"</font>";
			
			return result;
		}
		
		

		
		/**
		 * 输入一段字符串，其中包括表情等。 
		 * @param value
		 * @param color
		 */		
		public function typeInMultString(value:String,color:String = null):void
		{
			//判断超链接数量，判定是否可以继续输入文字
			var hasNum:int = getLinkNum(getRealText());
			var typeInNum:int = getLinkNum(value);
			//如果已存在的超链接数量已经达到或超过上限，并且要输入的文字中含有超链接，则不能继续输入了
			if(linkNumLimit != -1 && hasNum >= linkNumLimit && typeInNum >= 1)
			{
				return;
			}
			
			tmpHtmlText = "";
			if(color!=null)
				defaultColor = color;
			
			var arr:Array = value.split(_linkCheck);
			for(var i:int = 0;i<arr.length;i++)
			{
				if(String(arr[i]).match(_linkCheck2) != null)
				{
					var tmp:Array = String(arr[i]).split(_linkCheck3);
					var color:String = "";
					var isHaveChar:Boolean;
					
					if(tmp[7] != undefined)
					{
						color = "#"+String(tmp[7]).slice(1,String(tmp[7]).length-1)
					}
					
					if(tmp[9] == undefined)
					{
						isHaveChar = true;
					}else if(tmp[9] != undefined)
					{
						if(tmp[9] == "true") isHaveChar = true;
						else if(tmp[9] == "false") isHaveChar = false;	
					}
				
					if(color == "")
					_typeInLink(
						String(tmp[1]).slice(1,String(tmp[1]).length-1),
						String(tmp[3]).slice(1,String(tmp[3]).length-1),
						String(tmp[5]).slice(1,String(tmp[5]).length-1));
					else
						_typeInLink(
							String(tmp[1]).slice(1,String(tmp[1]).length-1),
							String(tmp[3]).slice(1,String(tmp[3]).length-1),
							String(tmp[5]).slice(1,String(tmp[5]).length-1),
							color
						);
					
					
					
				}else
				{
					_typeInText(arr[i]);
				}
			}
			this.htmlText = tmpHtmlText;
		}
		
		/**
		 * 插入一个超链接 
		 * @param value 超链接的显示内容
		 * @param functionKey 超链接的key，对一个方法，此方法和key的对应需要被注册
		 * @param data 需要传递给方法的参数
		 * 
		 */		
		private function _typeInLink(value:String,functionKey:String,data:String,color:String = null):void
		{	
			tmpHtmlText += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+_defaultFontSize+"'>"+"["+"</font>";
			if(color == null)
				tmpHtmlText += "<a href='event:"+functionKey+"#"+data+"'>"+"<font color = '"+_defaultLinkColor+"' face = '"+_defaultFont+"'>"+value+"</font>"+"</a>";
			else
			{
				color = color.replace(/#/,"");
				tmpHtmlText += "<a href='event:"+functionKey+"#"+data+"#"+color+"'>"+"<font color = '"+"#"+color+"' face = '"+_defaultFont+"'>"+value+"</font>"+"</a>";
			}
			tmpHtmlText += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+_defaultFontSize+"'>"+"]"+"</font>";
		} 
		
		/**
		 * 在当前段落插入一段文字
		 * @param value 文字内容
		 * @param color 文字颜色
		 * @param font  文字字体
		 *  
		 */		
		public function _typeInText(value:String,size:Number = 12,color:String = null,font:String = null):void
		{
			var _color:String;
			var _font:String;
			if(color == null)
				_color = defaultColor;
			else
				_color = color
			if(font == null)
				_font = _defaultFont
			else
				_font = font;
			tmpHtmlText += "<font size='"+size+"' color = '"+_color+"' face = '"+_defaultFont+"'>"+value+"</font>";
		}
		
		
		/**
		 * 在当前段落插入一段文字
		 * @param value 文字内容
		 * @param color 文字颜色
		 * @param font  文字字体
		 *  
		 */		
		public function typeInText(value:String,size:Number = 12,color:String = null,font:String = null):void
		{
			var _color:String;
			var _font:String;
			if(color == null)
				_color = defaultColor;
			else
				_color = color
			if(font == null)
				_font = _defaultFont
			else
				_font = font;
			_htmlTextContent += "<font size='"+size+"' color = '"+_color+"' face = '"+_defaultFont+"'>"+value+"</font>";
			this.htmlText = _htmlTextContent;
		}
		
		/**
		 * 插入一个超链接 
		 * @param value 超链接的显示内容
		 * @param functionKey 超链接的key，对一个方法，此方法和key的对应需要被注册
		 * @param data 需要传递给方法的参数
		 * 
		 */		
		public function typeInLink(value:String,functionKey:String,data:String,color:String = null):void
		{	
			//判断超链接数量，判定是否可以继续输入文字
			var hasNum:int = getLinkNum(getRealText());
			//如果已存在的超链接数量已经达到或超过上限，则不能继续输入了
			if(linkNumLimit != -1 && hasNum >= linkNumLimit)
			{
				return;
			}
			
			_htmlTextContent = "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+_defaultFontSize+"'>"+"["+"</font>";
			if(color == null)
				_htmlTextContent += "<a href='event:"+functionKey+"#"+data+"'>"+"<font color = '"+_defaultLinkColor+"' face = '"+_defaultFont+"'>"+value+"</font>"+"</a>";
			else
			{
				color = color.replace(/#/,"");
				_htmlTextContent += "<a href='event:"+functionKey+"#"+data+"#"+color+"'>"+"<font color = '"+"#"+color+"' face = '"+_defaultFont+"'>"+value+"</font>"+"</a>";
			}
			_htmlTextContent += "<font color = '"+_defaultLinkCharColor+"' face = '"+_defaultFont+"' size = '"+_defaultFontSize+"'>"+"]"+"</font>";
			this.htmlText += _htmlTextContent;
			change_handler(null);
		}
		
		/**
		 *得到真是的文本，给服务器发的就是这个! 
		 * 
		 */		
		public function getRealText():String
		{
			var str:String = fixLinkChar(htmlText);
			var arr:Array = str.split(linkCheck);
			var result:String = "";
			
			
			for(var i:int = 0;i<arr.length;i++)
			{
				if(String(arr[i]).charAt(1) == "A")
				{
					result += getLinkTextFromHtml(arr[i]);
				}else
				{
					result += getTextFromHtml(arr[i]);
				}
			}
			return result;
		}
		
		private function getTextFromHtml(html:String):String
		{
			var arr:Array = html.split(htmlCheck);
			var result:String = ""
			for(var i:int = 0;i<arr.length;i++)
			{
				if(String(arr[i]).charAt(0) != "<")
				{
					result += arr[i];	
				}
			}
			return result;
		}
		

		private function getLinkTextFromHtml(html:String):String
		{
			var arr:Array = html.split(getlinkReg);
			var result:String;
			if(String(arr[3]).length != 7)
				result = "#'"+String(arr[4])+"''"+arr[1]+"''"+arr[2]+"'#";
			else
				result = "#'"+String(arr[4])+"''"+arr[1]+"''"+arr[2]+"''"+String(arr[3]).slice(1)+"'#";
			return result;
		}
		

		
		/**
		 * 默认链接颜色 
		 */
		public function get defaultLinkColor():String
		{
			return _defaultLinkColor;
		}
		
		/**
		 * @private
		 */
		public function set defaultLinkColor(value:String):void
		{
			_defaultLinkColor = value;
		}
		
		
		private var _defaultColor:String = "#000000";
		/**
		 * 默认颜色 
		 */
		public function get defaultColor():String
		{
			return _defaultColor;
		}
		
		/**
		 * @private
		 */
		public function set defaultColor(value:String):void
		{
			_defaultColor = value;
			var textf:TextFormat = new TextFormat();
			textf.color = uint("0x"+value.replace(/\#/,""));
			this.defaultTextFormat = textf;
		}
		
		
		/**
		 *默认字号 
		 */
		public function get defaultFontSize():Number
		{
			return _defaultFontSize;
		}
		
		/**
		 * @private
		 */
		public function set defaultFontSize(value:Number):void
		{
			_defaultFontSize = value;
		}
	
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
		
		/**得到超链接数量*/
		private function getLinkNum(realText:String):int
		{
			var arr:Array = realText.split(_linkCheck);
			var num:int = 0;
			for(var i:int = 0;i<arr.length;i++)
			{
				if(String(arr[i]).match(_linkCheck2) != null)
				{
					num++;
				}
			}
			return num;
		}
		
		
		
		
	}
}