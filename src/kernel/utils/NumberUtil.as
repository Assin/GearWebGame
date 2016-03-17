package kernel.utils
{
	
	/**
	 * 文件名：NumberUtil.as
	 * <p>
	 * 功能：数字工具
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-10
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class NumberUtil
	{
		private static var _regDeleteHead0:RegExp = /^0*(\d+)/;
		
		public function NumberUtil()
		{
		}
		
		/**
		 * 转换int为long型
		 * @param value
		 * @return
		 *
		 */
		public static function parseIntToLong(value:int):String
		{
			var str:String = "";
			var s:String = value.toString(16);
			var num:int = 16 - s.length;
			
			for (var i:int = 0; i < num; i++)
			{
				str += "0";
			}
			return str + s;
		}
		
		/**
		 * 转换为十进制int
		 * @param value
		 * @return
		 *
		 */
		public static function parseLongToInt(value:String):int
		{
			return int("0x" + value);
		}
		
		/**
		 * 将所有非数字的字符去掉，并且写成通常习惯的数字形式
		 * @param number 传入的字符串
		 * @return 转换后的字符串<p>
		 * 		         例如：var num:String = NumberUtil.toNormalFormat("1,000,000");<p>
		 * 				trace(num);// 1000000
		 */
		public static function toNormalFormat(number:*):String
		{
			// 如果传进来的是null则返回0
			if (number == null)
				return "0";
			// 将所有非数字的字符去掉
			var str:String = number.toString().replace(/[^\d]/g, "");
			
			// 将头部的0都去掉
			while (str.charAt(0) == "0")
			{
				str = str.substr(1);
			}
			
			// 如果只有0，则等于0
			if (str.length <= 0)
				str = "0";
			return str;
		}
		
		/**
		 * 将传入的数字转换成国际标准形式，忽略所有非数字字符
		 * @param number 传入的数字
		 * @return 国际标准数字形式字符串<p>
		 * 		         例如：var num:String = NumberUtil.toInternationalFormat("1000000");<p>
		 * 				trace(num);// 1,000,000
		 */
		public static function toInternationalFormat(number:*):String
		{
			// 如果传进来的是null则返回0
			if (number == null)
				return "0";
			var str:String = toNormalFormat(number);
			var temp:String = "";
			
			for (var i:int = 0; i < str.length; i++)
			{
				temp += str.charAt(i);
				
				if ((str.length - i) % 3 == 1 && str.length - i > 3)
					temp += ",";
			}
			return temp;
		}
		
		/**
		 * 对比两个数字的大小，理论上支持无限位数字之间的对比（使用字符串对比）
		 * @param a 数字1
		 * @param b 数字2
		 * @return 如果a>b则返回1，a<b则返回-1，a=b则返回0
		 */
		public static function compare(a:*, b:*):int
		{
			var numA:String = toNormalFormat(a);
			var numB:String = toNormalFormat(b);
			var result:int = 0;
			
			if (numA.length > numB.length)
				result = 1;
			else if (numA.length < numB.length)
				result = -1;
			else
			{
				for (var i:int = 0; i < numA.length; i++)
				{
					if (int(numA.charAt(i)) > int(numB.charAt(i)))
					{
						result = 1;
						break;
					} else if (int(numA.charAt(i)) < int(numB.charAt(i)))
					{
						result = -1;
						break;
					}
				}
			}
			return result;
		}
		
		/**
		 * 返回所有正整数中最大的一个
		 * @param n1 第一个数字
		 * @param n2 第二个数字
		 * @param nums 任意数量的数字
		 * @return 最大的一个数字
		 */
		public static function max(n1:*, n2:*, ... nums):*
		{
			var max:* = (compare(n1, n2) > 0 ? n1 : n2);
			
			for (var i:int = 0; i < nums.length; i++)
			{
				var n:* = nums[i];
				
				if (compare(n, max) > 0)
					max = n;
			}
			return max;
		}
		
		/**
		 * 返回所有正整数中最小的一个
		 * @param n1 第一个数字
		 * @param n2 第二个数字
		 * @param nums 任意数量的数字
		 * @return 最小的一个数字
		 */
		public static function min(n1:*, n2:*, ... nums):*
		{
			var min:* = (compare(n1, n2) < 0 ? n1 : n2);
			
			for (var i:int = 0; i < nums.length; i++)
			{
				var n:* = nums[i];
				
				if (compare(n, min) < 0)
					min = n;
			}
			return min;
		}
		
		/**
		 * 对两个或更多正整数进行加法运算并返回运算结果
		 * @param a 被加数
		 * @param b 加数
		 * @param nums 更多的加数
		 * @return 结果的字符串表示形式
		 */
		public static function plus(a:*, b:*, ... nums):String
		{
			// 该算法是以十亿（即最大为9位数）为一个范围进行加法运算的
			var result:String = "";
			var numA:String = toNormalFormat(a);
			var numB:String = toNormalFormat(b);
			var lenA:int = Math.ceil(numA.length / 9);
			var lenB:int = Math.ceil(numB.length / 9);
			var len:int = max(lenA, lenB);
			var carry:int = 0;
			var i:int, j:int;
			j = len * 9 - numA.length;
			
			for (i = 0; i < j; i++)
			{
				numA = "0" + numA;
			}
			j = len * 9 - numB.length;
			
			for (i = 0; i < j; i++)
			{
				numB = "0" + numB;
			}
			
			for (i = len - 1; i >= 0; i--)
			{
				var tempA:int = int(numA.substr(i * 9, 9));
				var tempB:int = int(numB.substr(i * 9, 9));
				var tempRes:int = tempA + tempB + carry;
				var tempStr:String;
				
				if (tempRes >= 1000000000)
				{
					carry = 1;
					tempRes -= 1000000000;
				} else
				{
					carry = 0;
				}
				tempStr = tempRes.toString();
				
				if (i > 0)
				{
					var t:int = 9 - tempStr.length;
					
					for (j = 0; j < t; j++)
					{
						tempStr = "0" + tempStr;
					}
				}
				result = tempStr + result;
			}
			
			if (carry > 0)
				result = "1" + result;
			
			// 和更多的加数相加
			for (i = 0; i < nums.length; i++)
			{
				result = plus(result, nums[i]);
			}
			// 去掉头部多余的0
			result = _regDeleteHead0.exec(result)[1];
			return result;
		}
		
		/**
		 * 两个正整数相减，只支持结果为非负数，如果结果为负数则取其绝对值
		 * @param a 其中一个减数
		 * @param b 另外一个减数
		 * @return 结果，只会是非负数
		 */
		public static function minus(a:*, b:*):String
		{
			if (compare(a, b) < 0)
			{
				var t:* = a;
				a = b;
				b = t;
			}
			a = toNormalFormat(a);
			b = toNormalFormat(b);
			// 该算法是将两数字以8位一截取并转换成Number型来计算差的
			var len:int = Math.ceil(a.length / 8);
			var result:String = "";
			var carry:int = 0;
			
			for (var i:int = 0; i < len; i++)
			{
				var tempA:Number = Number(a.substring(a.length - 8, a.length)) - carry;
				var tempB:Number = Number(b.substring(b.length - 8, b.length));
				a = a.substring(0, a.length - 8);
				b = b.substring(0, b.length - 8);
				
				if (tempA < tempB)
				{
					carry = 1;
					tempA += 100000000;
				}
				var margin:String = (tempA - tempB).toString();
				
				while (margin.length < 8)
				{
					margin = "0" + margin;
				}
				result = margin + result;
			}
			result = toNormalFormat(result);
			return result;
		}
		
		/**
		 * 对两个或更多正整数进行乘法运算并返回运算结果
		 * @param a 被乘数
		 * @param b 乘数
		 * @param nums 更多的乘数
		 * @return 结果的字符串表示形式
		 */
		public static function times(a:*, b:*, ... nums):String
		{
			var result:String = "";
			var numA:String = toNormalFormat(a);
			var numB:String = toNormalFormat(b);
			var arrA:Array = new Array();
			var arrB:Array = new Array();
			var arrRes:Array = new Array();
			var i:int, j:int;
			
			while (numA.length > 0)
			{
				if (numA.length >= 4)
				{
					arrA.push(int(numA.substr(numA.length - 4)));
					numA = numA.substring(0, numA.length - 4);
				} else
				{
					arrA.push(int(numA));
					numA = "";
				}
			}
			
			while (numB.length > 0)
			{
				if (numB.length >= 4)
				{
					arrB.push(int(numB.substr(numB.length - 4)));
					numB = numB.substring(0, numB.length - 4);
				} else
				{
					arrB.push(int(numB));
					numB = "";
				}
			}
			
			for (i = 0; i < arrA.length + arrB.length - 1; i++)
			{
				arrRes.push(0);
			}
			
			for (i = 0; i < arrA.length; i++)
			{
				for (j = 0; j < arrB.length; j++)
				{
					arrRes[i + j] += arrA[i] * arrB[j];
				}
			}
			
			for (i = 0; i < arrRes.length; i++)
			{
				var tempStr:String = arrRes[i].toString();
				
				for (j = 0; j < i; j++)
				{
					tempStr += "0000";
				}
				result = plus(result, tempStr);
			}
			
			// 与更多的乘数相乘
			for (i = 0; i < nums.length; i++)
			{
				result = times(result, nums[i]);
			}
			// 去掉头部多余的0
			result = _regDeleteHead0.exec(result)[1];
			return result;
		}
		
		/**
		 * 对两个正整数进行除法计算
		 * @param a 被除数
		 * @param b 除数
		 * @return 得数对象，包括商和余数，其中quotient表示商，residual表示余数
		 */
		public static function divide(a:*, b:*):Object
		{
			var result:Object = new Object();
			result.quotient = 0;
			result.residual = 0;
			a = toNormalFormat(a);
			b = toNormalFormat(b);
			
			if (b == "0")
				return null;
			
			if (compare(a, b) < 0)
			{
				result.residual = a;
				return result;
			}
			var tempA:String = a.substr(0, b.length + 1);
			var temp:String = a.substr(tempA.length);
			var digits:int = temp.length;
			
			while (compare(tempA, b) >= 0)
			{
				result.quotient++;
				tempA = minus(tempA, b);
			}
			
			for (var i:int = 0; i < digits; i++)
			{
				result.quotient += "0";
			}
			temp = tempA + temp;
			var subRes:Object = divide(temp, b);
			result.quotient = plus(result.quotient, subRes.quotient);
			result.residual = subRes.residual;
			return result;
		}
		
		/**
		 * 判断传入的参数是否为数字
		 * @param obj 需要判断的对象
		 * @return 是否为数字
		 */
		public static function isNumber(obj:*):Boolean
		{
			// 如果传进来的是null则返回false
			if (obj == null)
				return false;
			// 如果该对象和转换为普通标准或转换为国际标准的对象值相同则表示是数字
			return (obj.toString() == toNormalFormat(obj) || obj.toString() == toInternationalFormat(obj));
		}
		
		/**
		 * 计算2次贝塞尔曲线的长度
		 * @param beginX 起点横坐标
		 * @param beginY 起点纵坐标
		 * @param endX 终点横坐标
		 * @param endY 终点纵坐标
		 * @param controlX 控制点横坐标
		 * @param controlY 控制点纵坐标
		 * @return 计算出来的2次贝塞尔曲线长度
		 */
		public static function bezierLength(beginX:Number, beginY:Number, endX:Number, endY:Number, controlX:Number, controlY:Number):Number
		{
			// 以下是2次贝赛尔曲线的长度计算公式，不用看了，看了也看不懂
			var ax:Number = beginX - 2 * controlX + endX;
			var ay:Number = beginY - 2 * controlY + endY;
			
			// 防止出现错误
			if (ax == 0 && ay == 0)
			{
				ax = ay = 0.0000000001;
			}
			var bx:Number = 2 * controlX - 2 * beginX;
			var by:Number = 2 * controlY - 2 * beginY;
			var A:Number = 4 * (ax * ax + ay * ay);
			var B:Number = 4 * (ax * bx + ay * by);
			var C:Number = bx * bx + by * by;
			var length:Number = 1 / (8 * Math.pow(A, 1.5)) * (2 * Math.sqrt(A) * (2 * A * Math.sqrt(A + B + C) + B * (Math.sqrt(A + B + C) - Math.sqrt(C))) + (B * B - 4 * A * C) * (Math.log(B + 2 * Math.sqrt(A *
				C)) -
				Math.log(B + 2 * A + 2 * Math.sqrt(A * (A + B + C)))));
			return length;
		}
		
		/**
		 * 计算指定两点间的直线距离
		 * @param beginX 起始点横坐标
		 * @param beginY 起始点纵坐标
		 * @param endX 终点横坐标
		 * @param endY 终点纵坐标
		 * @return 两点间直线距离
		 */
		public static function lineLength(beginX:Number, beginY:Number, endX:Number, endY:Number):Number
		{
			return Math.sqrt(Math.pow(endX - beginX, 2) + Math.pow(endY - beginY, 2));
		}
		
		/**
		 * 计算一个整数的位数，负号不数位数
		 * @param value 要计算位数的整数。
		 * @return 这个整数的位数。
		 * 
		 * 例如  countDigit(0)返回 1  countDigit(9)返回 1  countDigit(382)返回 3
		 */
		public static function countDigit(value:int):int
		{
			
			var valueS:int = Math.abs(value);
			
			var num:int = 1;
			
			while(Math.floor(valueS/10)>0)
			{
				num++;
				valueS = Math.floor(valueS/10);
			}
			
			return num;
		}
	}
}