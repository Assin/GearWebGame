package kernel.display.components.text
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.BitmapProxy;
	import kernel.utils.DisplayUtil;
	import kernel.utils.ObjectPool;
	import kernel.utils.StringUtil;
	
	/**
	 * 文件名：RichTextField.as
	 * <p>
	 * 功能：图文混排文本，使用addTransfer方法以key增加映射以后需要用%key%进行转换
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-31
	 * <p>
	 * 作者：yanghongbin
	 */
	public class RichTextField extends BaseComponent
	{
		private static const PLACE_HOLDER:String = String.fromCharCode(160);
		private static const HEIGHT_KEEPER:String = String.fromCharCode(133);
		
		private static var _faceDict:Dictionary = new Dictionary(); // 储存转义信息
		private static var _regFunction:RegExp = /@([^%\?:=&@#]+)((#[^%]+)*)/;
		private static var _regAttribute:RegExp = /([^%\?:=&@#]+):([^%\?:=&@#]+)=([^%&#]+)/;
		
		private var _regCheck:RegExp = /%([^%\?:=&@#]+)(\?([^%]+))?%/ig;
		private var _regHolder:RegExp = new RegExp("([^" + PLACE_HOLDER + "]?)" + PLACE_HOLDER + "+", "ig");
		private var _textField:TextFieldProxy;
		private var _faceContainer:Sprite;
		private var _faceDatas:Array; // 储存已经转义的信息
		private var _lastIndex:int;
		private var _lastLine:int;
		
		private var _defaultTextFormat:TextFormat;
		private var _defaultFilters:Array;
		
		/**
		 * 获取或设置文本框宽度
		 */
		override public function get width():Number
		{
			return _textField.width;
		}
		
		override public function set width(value:Number):void
		{
			_textField.width = value;
			updateFaces();
		}
		
		/**
		 * 获取或设置文本框高度
		 */
		override public function get height():Number
		{
			return _textField.height;
		}
		
		override public function set height(value:Number):void
		{
			_textField.height = value;
			updateFaces();
		}
		
		/**
		 * 获取或设置文本框的滤镜列表
		 */
		override public function get filters():Array
		{
			return _textField.filters;
		}
		
		override public function set filters(value:Array):void
		{
			_textField.filters = value;
			_defaultFilters = value;
			updateFaces();
		}
		
		/**
		 * 获取文本的宽度，以像素为单位。
		 */
		public function get textWidth():Number
		{
			return _textField.textWidth;
		}
		
		/**
		 * 获取文本的高度，以像素为单位。
		 */
		public function get textHeight():Number
		{
			return _textField.textHeight;
		}
		
		/**
		 * 获取或设置文本框内作为文本字段中当前文本的字符串
		 */
		public function get text():String
		{
			var temp:String = _textField.htmlText;
			var html:String = temp;
			var result:String;
			for (var i:int = _faceDatas.length - 1; i >= 0; i--)
			{
				var data:Object = _faceDatas[i];
				html = html.substring(0, data.index) + data.expression + html.substr(data.index + data.length);
			}
			_textField.htmlText = html;
			result = _textField.text;
			_textField.htmlText = temp;
			return result;
		}
		
		public function set text(value:String):void
		{
			clear();
			appendText(value);
		}
		
		/**
		 * 获取或设置文本框内包含文本字段内容的 HTML 表示形式
		 */
		public function get htmlText():String
		{
			var temp:String = _textField.htmlText;
			var html:String = temp;
			var result:String;
			for (var i:int = _faceDatas.length - 1; i >= 0; i--)
			{
				var data:Object = _faceDatas[i];
				html = html.substring(0, data.index) + data.expression + html.substr(data.index + data.length);
			}
			_textField.htmlText = html;
			result = _textField.htmlText;
			_textField.htmlText = temp;
			return result;
		}
		
		public function set htmlText(value:String):void
		{
			clear();
			appendHTMLText(value);
		}
		
		/**
		 * 获取或设置文本框的默认文字样式
		 */
		public function get defaultTextFormat():TextFormat
		{
			return _textField.defaultTextFormat;
		}
		
		public function set defaultTextFormat(value:TextFormat):void
		{
			_textField.defaultTextFormat = value;
			_defaultTextFormat = value;
			updateFaces();
		}
		
		/**
		 * 获取或设置文本的样式表
		 */
		public function get styleSheet():StyleSheet
		{
			return _textField.styleSheet;
		}
		
		public function set styleSheet(value:StyleSheet):void
		{
			_textField.styleSheet = value;
			updateFaces();
		}
		
		/**
		 * 获取或设置文本框是否支持自动换行
		 */
		public function get wordWrap():Boolean
		{
			return _textField.wordWrap;
		}
		
		public function set wordWrap(value:Boolean):void
		{
			_textField.wordWrap = value;
			updateFaces();
		}
		
		/**
		 * 获取或设置文本框是否支持多行文本显示
		 */
		public function get multiline():Boolean
		{
			return _textField.multiline;
		}
		
		public function set multiline(value:Boolean):void
		{
			_textField.multiline;
			updateFaces();
		}
		
		/**
		 * 获取或设置文本框的自动大小调整和对齐
		 */
		public function get autoSize():String
		{
			return _textField.autoSize;
		}
		
		public function set autoSize(value:String):void
		{
			_textField.autoSize = value;
			updateFaces();
		}
		
		/**
		 * 获取定义多行文本字段中的文本行数
		 */
		public function get numLines():int
		{
			return _textField.numLines;
		}
		
		public function RichTextField(id:int = 0)
		{
			super(id);
			
			_faceDatas = new Array();
			
			_textField = new TextFieldProxy();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.wordWrap = true;
			addChild(_textField);
			
			_faceContainer = new Sprite();
			DisplayUtil.removeAllChildren(_faceContainer);
			_faceContainer.graphics.clear();
			addChild(_faceContainer);
		}
		
		private function toRichText():void
		{
			var index:int;
			var key:String;
			var expression:String;
			var face:DisplayObject;
			var data:Object;
			var html:String = _textField.htmlText;
			var str:String;
			var tempDatas:Array = [];
			
			_regCheck.lastIndex = _lastIndex;
			while ((data = _regCheck.exec(html)) != null)
			{
				index = data.index;
				expression = data[0];
				key = data[1];
				face = getFace(key);
				if (face != null)
				{
					// 提取参数并执行操作
					if (data[2] != null)
					{
						str = data[3];
						if (str != null)
						{
							var paramStrs:Array = str.split("&");
							var paramData:Object;
							for each (var paramStr:String in paramStrs)
							{
								try
								{
									if (paramStr.substr(0, 1) == "@")
									{
										// 是方法
										paramData = _regFunction.exec(paramStr);
										var funcName:String = paramData[1];
										var funcParams:Array = paramData[2].split("#");
										var funcParamList:Array = new Array();
										for (var i:int = 1; i < funcParams.length; i++)
										{
											var funcParam:String = funcParams[i];
											var funcParamData:Object = _regAttribute.exec(funcParam);
											var funcParamAttribute:* = getParamClass(funcParamData[2])(funcParamData[3]);
											funcParamList.push(funcParamAttribute);
										}
										runFunction(face[funcName], funcParamList);
									} else
									{
										// 是属性
										paramData = _regAttribute.exec(paramStr);
										face[paramData[1]] = getParamClass(paramData[2])(paramData[3]);
									}
								} catch (error:Error)
								{
								}
								ObjectPool.clearAndPushPool(paramData);
							}
						}
					}
					
					_textField.htmlText = "<font size='2'>" + PLACE_HOLDER + "</font>";
					_textField.width; // 此句不可以删掉，否则后面语句会报错
					var rect:Rectangle = _textField.getCharBoundaries(0);
					var placeWidth:Number = rect.width;
					var placeNum:int = Math.ceil((face.width + 2) / placeWidth);
					var holder:String = "";
					for (i = 0; i < placeNum; i++)
					{
						holder += PLACE_HOLDER;
					}
					holder = StringUtil.format("<font size='2'>{0}</font><font size='{1}'>{2}</font>", holder, face.height +
						1, HEIGHT_KEEPER);
					html = html.replace(expression, holder);
					
					var replaceData:Object = new Object();
					replaceData.index = index;
					replaceData.expression = expression;
					replaceData.length = holder.length;
					replaceData.face = face;
					tempDatas.push(replaceData);
				} else
				{
					_regCheck.lastIndex--;
				}
			}
			_textField.htmlText = html;
			str = _textField.text;
			_regHolder.lastIndex = _lastIndex;
			for (i = 0; i < tempDatas.length; i++)
			{
				data = tempDatas[i];
				face = data.face;
				var regRes:Object = _regHolder.exec(str);
				index = regRes.index + regRes[1].length;
				_textField.width; // 此句不可以删掉，否则后面语句会报错
				rect = _textField.getCharBoundaries(index);
				face.x = rect.x + 1;
				face.y = rect.y - 1;
				_faceContainer.addChild(face);
			}
			_faceDatas = _faceDatas.concat(tempDatas);
		}
		
		private function toNormalText():void
		{
			var html:String = _textField.htmlText;
			while (_faceDatas.length > 0)
			{
				var data:Object = _faceDatas.pop();
				html = html.substring(0, data.index) + data.expression + html.substr(data.index + data.length);
			}
			_textField.htmlText = html;
			_lastIndex = 0;
			DisplayUtil.removeAllChildren(_faceContainer);
			ObjectPool.clearList(_faceDatas);
		}
		
		private function updateFaces():void
		{
			toNormalText();
			toRichText();
		}
		
		private static function runFunction(func:Function, params:Array):void
		{
			if (func == null)
				return ;
			switch (params.length)
			{
				case 0:
					func();
					break;
				case 1:
					func(params[0]);
					break;
				case 2:
					func(params[0], params[1]);
					break;
				case 3:
					func(params[0], params[1], params[2]);
					break;
				case 4:
					func(params[0], params[1], params[2], params[3]);
					break;
				case 5:
					func(params[0], params[1], params[2], params[3], params[4]);
					break;
				case 6:
					func(params[0], params[1], params[2], params[3], params[4], params[5]);
					break;
				case 7:
					func(params[0], params[1], params[2], params[3], params[4], params[5], params[6]);
					break;
				case 8:
					func(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7]);
					break;
				case 9:
					func(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8]);
					break;
				case 10:
					func(params[0], params[1], params[2], params[3], params[4], params[5], params[6], params[7], params[8],
						params[9]);
					break;
			}
		}
		
		private static function getParamClass(str:String):Class
		{
			var cls:Class;
			switch (str)
			{
				case "int":
					cls = int;
					break;
				case "Number":
					cls = Number;
					break;
				case "String":
					cls = String;
					break;
			}
			return cls;
		}
		
		private static function getFace(key:String):DisplayObject
		{
			var face:* = _faceDict[key];
			if (face == null)
			{
				try
				{
					face = getDefinitionByName(key);
					if (face == null)
						return null;
				} catch (error:ReferenceError)
				{
					return null;
				}
			}
			
			var obj:DisplayObject;
			
			if (face is Class)
			{
				obj = new face() as DisplayObject;
			} else if (face is String)
			{
				try
				{
					var classReference:Class = getDefinitionByName(face)as Class;
					obj = new classReference()as DisplayObject;
				} catch (error:ReferenceError)
				{
					obj = new BitmapProxy();
					BitmapProxy(obj).setURL(face);
				}
			} else if (face is BitmapData)
			{
				obj = new Bitmap();
				Bitmap(obj).bitmapData = face;
			} else
			{
				obj = face as DisplayObject;
			}
			
			return obj;
		}
		
		/**
		 * 添加转义映射
		 * @param key 转义符文字
		 * @param source 转义符替换对象，可以是类引用、类的完全限定名、图片路径、BitmapData对象，显示对象实例将被转换为位图
		 */
		public static function addTransfer(key:String, source:*):void
		{
			if (source is Class || source is String || source is BitmapData)
			{
				_faceDict[key] = source;
			} else if (source is IBitmapDrawable)
			{
				var bd:BitmapData = new BitmapData(source["width"], source["height"], true, 0);
				bd.draw(source);
				_faceDict[key] = bd;
			}
		}
		
		/**
		 * 删除转义映射
		 * @param key 要删除的转义映射的转义符文字
		 */
		public static function removeTransfer(key:String):void
		{
			ObjectPool.clearObject(_faceDict[key]);
			_faceDict[key] = null;
			delete _faceDict[key];
		}
		
		/**
		 * 向混排文本框内添加字符串
		 * @param value 要添加的字符串
		 */
		public function appendText(value:String):void
		{
			_lastIndex = _textField.length;
			_lastLine = _textField.numLines - 1;
			_textField.appendText(value);
			toRichText();
		}
		
		/**
		 * 向混排文本框内添加HTML格式字符串
		 * @param value 要添加的HTML格式字符串
		 */
		public function appendHTMLText(value:String):void
		{
			_lastIndex = _textField.length;
			_lastLine = _textField.numLines - 1;
			_textField.htmlText += value;
			toRichText();
		}
		
		/**
		 * 设置文字样式类型
		 * @param style 样式类型
		 */
		public function setStyle(style:int):void
		{
			_textField.setStyle(style);
		}
		
		/**
		 * 清除混排文本框内的文字和图形
		 */
		override public function clear():void
		{
			super.clear();
			_textField.text = "";
			_textField.reset();
			if (_defaultTextFormat != null)
				_textField.defaultTextFormat = _defaultTextFormat;
			if (_defaultFilters != null)
				_textField.filters = _defaultFilters;
			_lastIndex = 0;
			DisplayUtil.removeAllChildren(_faceContainer);
			ObjectPool.clearList(_faceDatas);
		}
		
		override public function dispose():void
		{
			_regFunction = null;
			 _regAttribute = null;
			_regCheck = null;
			_regHolder = null;
			ObjectPool.disposeObject(_faceDict);
			_faceDict = null;
			
			ObjectPool.disposeObject(_defaultFilters);
			_defaultFilters = null;
			ObjectPool.disposeObject(_textField);
			_textField = null;
			ObjectPool.disposeObject(_faceContainer);
			_faceContainer = null;
			ObjectPool.disposeObject(_faceDatas);
			_faceDatas = null;
			
			_defaultTextFormat = null;
			
			super.dispose();
		}
	}
}