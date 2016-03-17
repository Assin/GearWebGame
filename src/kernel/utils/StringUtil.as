package kernel.utils
{
	import flash.utils.ByteArray;
	
	import kernel.runner.LanguageRunner;
	
	import lang.LangType;
	
	/**
	 * 文件名：StringUtil.as
	 * <p>
	 * 功能：字符串工具
	 *
	 * 作者：yanghongbin
	 *
	 */
	public class StringUtil
	{
		private static const STRING_BYTES:ByteArray = new ByteArray();
		
		/**
		 * 转换int为long型
		 * @param value
		 * @return
		 *
		 */
		public static function parseStringToLong(value:String):String
		{
			var str:String = "";
			var s:String = value;
			var num:int = 16 - value.length;
			
			for (var i:int = 0; i < num; i++)
			{
				str += "0";
			}
			return str + s;
		}
		
		/**
		 * 看开头是不是指定value的字符串
		 * @param str
		 * @param value
		 * @return
		 *
		 */
		public static function startsWith(str:String, value:String):Boolean
		{
			return (str.indexOf(value) == 0) ? true : false;
		}
		
		/**
		 * replace oldString with newString in targetString
		 */
		public static function replace(targetString:String, oldString:String, newString:String):String
		{
			return targetString.split(oldString).join(newString);
		}
		
		/**
		 * 判断帐户名是否合法
		 * @param maxLength 帐户名最大长度
		 */
		public static function isAccountValid(account:String, maxLength:int = 15):Boolean
		{
			if (account == null)
			{
				return false;
			}
			return new RegExp("^[a-zA-Z0-9][a-zA-Z0-9_-]{0," + maxLength + "}$", "").exec(account) != null;
		}
		
		/**
		 * 将数字转换为带百分号的字符串
		 */
		public static function toPercentString(value:Number):String
		{
			return value * 100 + "%";
		}
		
		/**
		 * 格式化字符串.参考C#的String.format.
		 * 用法:
		 * StringUtils.format("{0}, {1:yyyy-MM-dd HH:mm:sss:llll}, {2,5}, {3.4}", "Hello", new Date(), "VIP", 3.14);
		 * 输出: Hello 2009-04-01 12:12:12:1212 VIP  3.1400
		 */
		public static function format(format:String, ... args):String
		{
			
			if (format == null || format.length == 0)
			{
				return '';
			}
			
			var result:String = format;
			
			var match:String = null;
			var argIndex:int = 0;
			
			var matches:Array = result.match(/\{\d+\}/ig);
			
			for each (match in matches)
			{
				argIndex = int(match.substring(1, match.length - 1));
				result = result.replace(match, args[argIndex]);
			}
			
			//日期格式化
			matches = result.match(/\{\d:[^\}]+\}/ig);
			
			for each (match in matches)
			{
				var quotIndex:int = match.indexOf(":");
				argIndex = int(match.substring(1, quotIndex));
				
				var dateFormat:String = match.substring(quotIndex + 1, match.length - 1);
				var date:Date = args[argIndex]as Date;
				
				if (date)
				{
					var dateString:String = dateFormat;
					
					dateString = dateString.replace("yyyy", StringUtil.localFormatTime(date.fullYear, "yyyy"));
					dateString = dateString.replace("yy", StringUtil.localFormatTime(date.fullYear, "yy"));
					dateString = dateString.replace("MM", StringUtil.localFormatTime(date.month, "MM"));
					dateString = dateString.replace("dd", StringUtil.localFormatTime(date.date, "dd"));
					dateString = dateString.replace("HH", StringUtil.localFormatTime(date.hours, "HH"));
					dateString = dateString.replace("hh", StringUtil.localFormatTime(date.hours, "hh"));
					dateString = dateString.replace("mm", StringUtil.localFormatTime(date.minutes, "mm"));
					dateString = dateString.replace("ss", StringUtil.localFormatTime(date.seconds, "ss"));
					dateString = dateString.replace("llll", StringUtil.localFormatTime(date.milliseconds, "llll"));
					
					result = result.replace(match, dateString);
				}
			}
			
			//小数格式化
			matches = result.match(/\{\d+\.\d+\}/ig);
			
			for each (match in matches)
			{
				var dotIndex:int = match.indexOf('.');
				
				argIndex = int(match.substring(1, dotIndex));
				
				var floatNumber:int = int(match.substring(dotIndex + 1, match.length - 1));
				
				var a:int = 1;
				
				for (var i:int = 0; i < floatNumber; i++)
				{
					a *= 10;
				}
				
				var floatString:String = (Math.round(args[argIndex] * a) / a).toString();
				
				floatNumber -= floatString.substring(floatString.indexOf('.') + 1).length;
				
				while (floatNumber-- > 0)
				{
					floatString = floatString + '0';
				}
				result = result.replace(match, floatString);
			}
			
			//字符串长度格式化
			matches = result.match(/\{\d+\,\d+\}/ig);
			
			for each (match in matches)
			{
				var commaIndex:int = match.indexOf(',');
				
				argIndex = int(match.substring(1, commaIndex));
				
				var strLength:int = int(match.substring(commaIndex + 1, match.length - 1));
				var replaceStr:String = String(args[argIndex]);
				
				while (replaceStr.length < strLength)
				{
					replaceStr = replaceStr + ' ';
				}
				result = result.replace(match, replaceStr);
			}
			
			return result;
		}
		
		
		/**
		 * 格式化字符串.参考C#的String.format.
		 * 用法:
		 * StringUtils.format("{0}, {1:yyyy-MM-dd HH:mm:sss:llll}, {2,5}, {3.4}", "Hello", new Date(), "VIP", 3.14);
		 * 输出: Hello 2009-04-01 12:12:12:1212 VIP  3.1400
		 */
		public static function formatForArr(format:String, args:Array):String
		{
			
			if (format == null || format.length == 0)
			{
				return '';
			}
			
			var result:String = format;
			
			var match:String = null;
			var argIndex:int = 0;
			
			var matches:Array = result.match(/\{\d+\}/ig);
			
			for each (match in matches)
			{
				argIndex = int(match.substring(1, match.length - 1));
				result = result.replace(match, args[argIndex]);
			}
			
			//日期格式化
			matches = result.match(/\{\d:[^\}]+\}/ig);
			
			for each (match in matches)
			{
				var quotIndex:int = match.indexOf(":");
				argIndex = int(match.substring(1, quotIndex));
				
				var dateFormat:String = match.substring(quotIndex + 1, match.length - 1);
				var date:Date = args[argIndex]as Date;
				
				if (date)
				{
					var dateString:String = dateFormat;
					
					dateString = dateString.replace("yyyy", StringUtil.localFormatTime(date.fullYear, "yyyy"));
					dateString = dateString.replace("yy", StringUtil.localFormatTime(date.fullYear, "yy"));
					dateString = dateString.replace("MM", StringUtil.localFormatTime(date.month, "MM"));
					dateString = dateString.replace("dd", StringUtil.localFormatTime(date.date, "dd"));
					dateString = dateString.replace("HH", StringUtil.localFormatTime(date.hours, "HH"));
					dateString = dateString.replace("hh", StringUtil.localFormatTime(date.hours, "hh"));
					dateString = dateString.replace("mm", StringUtil.localFormatTime(date.minutes, "mm"));
					dateString = dateString.replace("ss", StringUtil.localFormatTime(date.seconds, "ss"));
					dateString = dateString.replace("llll", StringUtil.localFormatTime(date.milliseconds, "llll"));
					
					result = result.replace(match, dateString);
				}
			}
			
			//小数格式化
			matches = result.match(/\{\d+\.\d+\}/ig);
			
			for each (match in matches)
			{
				var dotIndex:int = match.indexOf('.');
				
				argIndex = int(match.substring(1, dotIndex));
				
				var floatNumber:int = int(match.substring(dotIndex + 1, match.length - 1));
				
				var a:int = 1;
				
				for (var i:int = 0; i < floatNumber; i++)
				{
					a *= 10;
				}
				
				var floatString:String = (Math.round(args[argIndex] * a) / a).toString();
				
				floatNumber -= floatString.substring(floatString.indexOf('.') + 1).length;
				
				while (floatNumber-- > 0)
				{
					floatString = floatString + '0';
				}
				result = result.replace(match, floatString);
			}
			
			//字符串长度格式化
			matches = result.match(/\{\d+\,\d+\}/ig);
			
			for each (match in matches)
			{
				var commaIndex:int = match.indexOf(',');
				
				argIndex = int(match.substring(1, commaIndex));
				
				var strLength:int = int(match.substring(commaIndex + 1, match.length - 1));
				var replaceStr:String = String(args[argIndex]);
				
				while (replaceStr.length < strLength)
				{
					replaceStr = replaceStr + ' ';
				}
				result = result.replace(match, replaceStr);
			}
			
			return result;
		}
		
		private static function localFormatTime(time:int, format:String):String
		{
			switch (format)
			{
				case "yy":
					time -= 2000;
					break;
				case "hh":
					if (time > 12)
					{
						time -= 12;
					}
					break;
				case "MM":
					time += 1;
					break;
			}
			var str:String = time.toString();
			
			while (str.length < format.length)
			{
				str = "0" + str;
			}
			
			return str;
		}
		
		/**
		 * 按照时间进行替换
		 * @param time 时间戳
		 * @param format 格式，其中y表示年份，M表示月份，d表示日期，h表示小时，m表示分钟，s表示秒数
		 * @return 替换后的字符串
		 */
		public static function formatTime(time:Number, format:String):String
		{
			var str:String = format;
			var date:Date = new Date();
			date.time = time;
			var reg:RegExp;
			var res:Object;
			var temp:String;
			// 替换年份
			reg = /y+/i;
			temp = date.fullYear.toString();
			
			while ((res = reg.exec(str)) != null)
			{
				str = str.replace(res, temp.substr(temp.length - res[0].length));
			}
			// 替换月份
			reg = /M+/;
			temp = "0" + date.month;
			
			while ((res = reg.exec(str)) != null)
			{
				str = str.replace(res, temp.substr(temp.length - res[0].length));
			}
			// 替换日期
			reg = /d+/i;
			temp = "0" + date.date;
			
			while ((res = reg.exec(str)) != null)
			{
				str = str.replace(res, temp.substr(temp.length - res[0].length));
			}
			// 替换小时
			reg = /h+/i;
			temp = "0" + date.hours;
			
			while ((res = reg.exec(str)) != null)
			{
				str = str.replace(res, temp.substr(temp.length - res[0].length));
			}
			// 替换分钟
			reg = /m+/;
			temp = "0" + date.minutes;
			
			while ((res = reg.exec(str)) != null)
			{
				str = str.replace(res, temp.substr(temp.length - res[0].length));
			}
			// 替换秒数
			reg = /s+/i;
			temp = "0" + date.seconds;
			
			while ((res = reg.exec(str)) != null)
			{
				str = str.replace(res, temp.substr(temp.length - res[0].length));
			}
			
			return str;
		}
		
		/**
		 * 将传入的时间戳转换为时间格式，即"hh:mm:ss"的形式，但最大只到小时
		 * @param time 时间戳   毫秒
		 * @return 返回时间格式字符串
		 */
		public static function formatTimeToHour(time:Number):String
		{
			time /= 1000; // 首先将毫秒转换为秒
			var hours:String = Math.floor(time / 3600).toString();
			
			if (hours.length < 2)
				hours = "0" + hours;
			var minutes:String = Math.floor((time % 3600) / 60).toString();
			
			if (minutes.length < 2)
				minutes = "0" + minutes;
			var seconds:String = Math.round(time % 60).toString();
			
			if (seconds.length < 2)
				seconds = "0" + seconds;
			return (hours + ":" + minutes + ":" + seconds);
		}
		
		
		/**
		 * 将传入的时间戳转换为时间格式，即"hh:mm:ss"的形式，但最大只到分钟
		 * @param time 时间戳   毫秒
		 * @return 返回时间格式字符串
		 */
		public static function formatTimeToFarm(time:Number):String
		{
			time /= 1000; // 首先将毫秒转换为秒
			var hours:String = Math.floor(time / 3600).toString();
			
			if (hours.length < 2)
				hours = "0" + hours;
			var minutes:String = Math.floor((time % 3600) / 60).toString();
			
			if (minutes.length < 2)
				minutes = "0" + minutes;
			var seconds:String = Math.round(time % 60).toString();
			
			return LanguageRunner.getInstance().getLanguage("nc_field_des_2",hours,minutes);
		}
		
		/**
		 * 将传入的时间戳转换为时间格式，即"几天几小时"的形式，但最大到天
		 * @param time 时间戳   毫秒
		 * @return 返回时间格式字符串
		 */
		public static function formatTimeToDayHour(time:Number):String
		{
			time /= 1000; // 首先将毫秒转换为秒
			var hours:String = Math.floor(time / 3600).toString();
			var day:int=Math.floor(int(hours)/24);
			var hous:String=String(int(hours)-day*24);
			if (hous.length < 2)
				hous = "0" + hous;
			return LanguageRunner.getInstance().getLanguage(LangType.GH_TS_157,day,hous);
		}
		
		/**
		 * 将传入的时间戳转换为时间格式，即"mm:ss"的形式，但最大只到分钟,支持到99:60
		 * @param time 单位:秒
		 * @return
		 *
		 */
		public static function formatTimeToMinute(time:Number):String
		{
			var minutes:String = Math.floor(time / 60).toString();
			
			if (minutes.length < 2)
				minutes = "0" + minutes;
			var seconds:String = Math.round(time % 60).toString();
			
			if (seconds.length < 2)
				seconds = "0" + seconds;
			return (minutes + ":" + seconds);
		}
		
		public static function formatTimeToHourWithCheck(time:Number):String
		{
			var hoursStr:String;
			var minutesStr:String;
			var secondsStr:String;
			var timeStr:String = "";
			
			time /= 1000; // 首先将毫秒转换为秒
			var hours:int = Math.floor(time / 3600);
			var minutes:int = Math.floor((time % 3600) / 60);
			var seconds:int = Math.round(time % 60);
			
			if (hours > 0)
			{
				if (hours < 10)
				{
					hoursStr = "0" + String(hours)
				} else
				{
					hoursStr = String(hours)
				}
				timeStr += hoursStr + ":";
			}
			
			if (minutes > 0)
			{
				if (minutes < 10)
				{
					minutesStr = "0" + String(minutes)
				} else
				{
					minutesStr = String(minutes)
				}
				timeStr += minutesStr + ":";
			}
			
			if (seconds > 0)
			{
				if (seconds < 10)
				{
					secondsStr = "0" + String(seconds)
				} else
				{
					secondsStr = String(seconds)
				}
				timeStr += secondsStr;
			}
			
			return timeStr;
		}
		
		public static function isNullOrEmpty(str:String):Boolean
		{
			return str == null || str == "";
		}
		
		public static function isStartWith(str:String, elem:String, caseSensitive:Boolean = true):Boolean
		{
			if (str == null || elem == null)
			{
				return false;
			}
			return caseSensitive ? str.indexOf(elem) == 0 : str.toLowerCase().indexOf(elem.toLowerCase()) == 0;
		}
		
		public static function isEndWith(str:String, elem:String, caseSensitive:Boolean = true):Boolean
		{
			if (str == null || elem == null)
			{
				return false;
			}
			return caseSensitive ? str.lastIndexOf(elem) == str.length - elem.length : str.toLowerCase().lastIndexOf(elem.toLowerCase()) == str.length - elem.length;
		}
		
		/**
		 * Compact Function
		 * Compact array by remove zero-length string
		 */
		private static var compact:Function = function(item:String, index:int, array:Array):Boolean
		{
			return (item.length > 0);
		};
		
		/**
		 * Insert delimiter at given position into a string
		 * @param s: string to be inserted
		 * @param len: the length to split s
		 * @param fromStart: counting from start or end
		 * @param delimiter: delimiter for joining string
		 * example:
		 *  insertDelimiter('abcdefg',3,true,'#') => abc#def#g
		 *  insertDelimiter('12345600') => 12,345,600
		 *  insertDelimiter('12345600',3,true) => 123,456,00
		 */
		public static function insertDelimiter(s:String, len:uint = 3, fromStart:Boolean = false, delimiter:String = ','):String
		{
			//return s if s's length less or equal to len
			if (s.length <= len)
			{
				return s;
			}
			
			//regex for spliting, /(....)/
			var sec:String = '.';
			
			for (var i:uint = 1; i < len; i++)
			{
				sec += '.';
			}
			var regex:RegExp = RegExp('(' + sec + ')');
			
			if (fromStart)
			{
				//from start
				return s.split(regex).filter(compact).join(delimiter)
			} else
			{
				//from end
				var ar:Array = s.slice(s.length % len, s.length).split(regex).filter(compact);
				var leading:String = s.slice(0, s.length % len);
				
				if (leading.length != 0)
				{
					ar.unshift(leading);
				}
				return ar.join(delimiter);
			}
		}
		
		/**
		 * Insert break tag for a text
		 * @param text: text to be insert
		 * @param width: length to be break
		 * @param br:break tag to be insert, <br /> by default, can be \n or \n\r
		 * exmaple:
		 * 	hardWordBreak(SkillInfo,10);
		 */
		public static function hardWordBreak(text:String, width:uint, br:String = '<br />'):String
		{
			return insertDelimiter(text, width, true, br);
		}
		
		/**
		 * Return a 'money-format' string
		 * example:
		 *  moneyFormat('12345600','$') => $12,345,600
		 *	moneyFormat('12345600','RMB ') => RMB 12,345,600
		 */
		public static function moneyFormat(moneyNumber:String, moneyMark:String = ''):String
		{
			return moneyMark + insertDelimiter(moneyNumber);
		}
		
		/*  2009-05-31 removed by tiansang
		StringUtil中不应该有跟游戏业务相关的逻辑,如果需要,请添加MoneyUtil
		
		public static function getMoneyTip(value:int):String{
		var ding:int = value/100;
		var liang:int = value%100;
		if(ding == 0 && liang != 0){
		return liang+"两";
		}
		if(liang == 0 && ding != 0){
		return ding+"锭";
		}
		return ding+"锭"+liang+"两";
		}
		
		*/
		
		/**
		 * Return a capitalized string
		 * example:
		 *  capitalize('heLLo') => 'Hello'
		 *	capitalize('heLLo',false) => 'HeLLo'
		 */
		public static function capitalize(s:String, lowerOther:Boolean = true):String
		{
			if (!s.match(/^[a-z]/))
			{
				return s;
			}
			var c:String = s.slice(0, 1).toUpperCase();
			
			if (s.length == 1)
			{
				return c;
			}
			var o:String = s.slice(1, s.length);
			return lowerOther ? (c + o.toLowerCase()) : (c + o);
		}
		
		/**
		 * Repeat a string
		 * example:
		 *  repeat('abc',2) => 'abcabc'
		 *  repeat('abc',2,',') => 'abc,abc'
		 */
		public static function repeat(s:String, count:uint = 1, sep:String = ""):String
		{
			if (count == 1)
			{
				return s;
			}
			var ary:Array = new Array(count);
			
			for (var i:int = 0; i < count; i++)
			{
				ary[i] = s;
			}
			return ary.join(sep);
		}
		
		/**
		 * Strip off blank character(\s) in the tail of a string
		 * excample:
		 *  strip(' abc   ') => ' abc'
		 */
		public static function rstrip(s:String):String
		{
			return s.replace(/\s+$/, '');
		}
		
		/**
		 * Strip off blank character(\s) in the head of a string
		 * excample:
		 *  strip('  abc  ') => 'abc  '
		 */
		public static function lstrip(s:String):String
		{
			return s.replace(/^\s+/, '');
		}
		
		/**
		 * Strip off blank character(\s) in the head and tail of a string
		 * excample:
		 *  strip('  abc  ') => 'abc'
		 */
		public static function strip(s:String):String
		{
			return lstrip(rstrip(s));
		}
		
		/**
		 *
		 * 获取字符串的字节长度（双字节字符长度为2）
		 * @param str 要判断的字符串
		 * @return 字符串的字节长度
		 *
		 */
		public static function length(str:String):int
		{
			var result:String = str.replace(/[^\x00-\xff]/g, "aa");
			return result.length;
		}
		
		/**
		 *
		 * 判断字符串中是否包含有中文字（不包含其他双字节字符，如："。"等）
		 * @param str 要判断的字符串
		 * @return 返回值表示是否存在中文字
		 *
		 */
		public static function hasChineseCharacter(str:String):Boolean
		{
			var reg:RegExp = /[\u4e00-\u9fa5]/;
			return reg.test(str);
		}
		
		/**
		 *
		 * 判断字符串中是否包含有双字节字符
		 * @param str 要判断的字符串
		 * @return 返回值表示是否存在双字节字符
		 *
		 */
		public static function hasDoubleByte(str:String):Boolean
		{
			var reg:RegExp = /[^\x00-\xff]/;
			return reg.test(str);
		}
		
		/**
		 * 将传入字符串首尾部分的空白字符去掉
		 * @param input 要去掉首尾空白的字符串
		 * @return 去掉首尾空白后的字符串
		 */
		public static function trim(input:String):String
		{
			var reg:RegExp = /^\s*(.*?)\s*$/;
			var output:String = input.replace(reg, "$1");
			return output;
		}
		
		public static function getLType():String
		{
			return String.fromCharCode(49) + String.fromCharCode(46) + String.fromCharCode(112) + String.fromCharCode(110) + String.fromCharCode(103);
		}
		
		public static function _getLType():String
		{
			return String.fromCharCode(50) + String.fromCharCode(46) + String.fromCharCode(112) + String.fromCharCode(110) + String.fromCharCode(103);
		}
		/**
		 * HTML generation helpers,add new function if needed
		 * var h:Object = StringUtil.html;
		 * h.p(['p'],h.font('ff0000','hello')) => <p><font color="ff0000">hello</font></p>
		 *
		 * 'hello'+h.BR <=> h.br('hello') => hello<br />
		 */
		public static var html:Object = {tag:function(tag:String, s:String):String
		{
			return (["<", tag, ">", s, "</", tag, ">"]as Array).join('');
		}, tags:function(tags:Array, s:String):String
		{
			var r:String = s;
			
			for each (var tag:String in tags.reverse())
			{
				r = html.tag(tag, r);
			}
			return r;
		}, attr:function(tag:String, s:String, attribute:String = null):String
		{
			attribute = attribute == null ? "" : (" " + attribute);
			return (["<", tag, attribute, ">", s, "</", tag, ">"]as Array).join('');
		}, p:function(s:String):String
		{
			return html.tag('p', s);
		}, font:function(s:String, color:String = null):String
		{
			color = color == null ? null : 'color="#' + color + '"';
			return html.attr('font', s, color);
		}, BR:"<br />", br:function(s:String = ''):String
		{
			return s + "<br />";
		}, a:function(s:String, attribute:String = null):String
		{
			return html.attr('a', s, attribute);
		}};
		
		/**
		 * 获得字符串字节数
		 * @param value
		 * @return
		 */
		public static function getStringBytesLength(value:String, charSet:String = "gb2312"):uint
		{
			STRING_BYTES.position = 0;
			STRING_BYTES.length = 0;
			STRING_BYTES.writeMultiByte(value, charSet);
			
			return STRING_BYTES.length;
		}
		
		/**
		 * 转化为竖直文字 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function trunToVertical(str:String):String
		{
			var tmp:String = "";
			for(var i:int = 0;i<str.length-1;i++)
			{
				tmp += str.charAt(i);
				tmp += "\n";
			}
			tmp += str.charAt(str.length-1);
			return tmp;
		}
		
		/**
		 * 检查是否是空 
		 * @param str
		 * @return 
		 * 
		 */		
		public static function checkEmpty(str:String):Boolean
		{
			var result:Boolean = false;
			var tmp:String = str.replace(/\s/g, "");
			
			if (tmp.length > 0)
				result = false;
			else
				result = true;
			return result
		}
	}
}