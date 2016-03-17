package kernel.utils
{
	
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.geom.ColorTransform;
	
	import kernel.display.components.text.TextFieldProxy;
	
	
	public class ColorUtil
	{
		
		/**
		 * RGB纯红色
		 */
		public static const RGB_RED:uint = 0xff0000;
		/**
		 * RGB纯黄色
		 */
		public static const RGB_YELLOW:uint = 0xffff00;
		/**
		 * RGB纯白色
		 */
		public static const RGB_WHITE:uint = 0xffffff;
		/**
		 * RGB橙色
		 */
		public static const RGB_ORANGE:uint = 0xff9900;
		/**
		 * RGB绿色
		 */
		public static const RGB_GREEN:uint = 0x00ff00;
		/**
		 * RGB黑色
		 */
		public static const RGB_BLACK:uint = 0x000000;
		
		// 普通
		private static var defaultTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 0, 0, 0, 0);
		// 变灰
		private static var fadeFilter:ColorMatrixFilter = new ColorMatrixFilter([1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 1 / 3, 1 / 3, 1 / 3, 0, 0, 0, 0, 0, 1, 0]);
		// 高亮
		private static var highLightTransform:ColorTransform = new ColorTransform(1, 1, 1, 1, 30, 30, 30, 0);
		
		//自定义颜色
		private static var customTransform:ColorTransform;
		
		
		private static var highLightFilter:ColorMatrixFilter = new ColorMatrixFilter([1, 0, 0, 0, 30, 0, 1, 0, 0, 30, 0, 0, 1, 0, 30, 0, 0, 0, 1, 0]);
		
		/**
		 * 颜色字符串转换为16进制颜色
		 * @param value
		 * @return
		 *
		 */
		public static function colorStringToColorHex(value:String):uint
		{
			var color:uint = 0;
			
			if (value.charAt(0) == "#")
			{
				value = value.slice(1);
			}
			color = parseInt(value, 16);
			return color;
			
		}
		
		/**
		 * 添加标题的渐变特效和黑边
		 * @param text
		 *
		 */
		public static function setColorGradientForTitleText(text:TextFieldProxy):void
		{
			var g1:GradientBevelFilter = new GradientBevelFilter();
			g1.colors = [0xEBE5CF, 0xB8A848, 0x65570E];
			g1.alphas = [1, 1, 1];
			g1.ratios = [0, 128, 255];
			
			g1.blurX = 15;
			g1.blurY = 15;
			g1.strength = 5;
			g1.angle = 270;
			g1.distance = 5;
			g1.type = BitmapFilterType.INNER;
			
			var g3:GlowFilter = FiltersUtil.getNormalTextFieldGlowFilter();
			
			text.filters = [g1, g3];
		}
		
		/**
		 * 活动标题 
		 * @param text
		 * 
		 */
		public static function setColorGradientForActivityTitleText(text:TextFieldProxy):void
		{
			var g1:GradientBevelFilter = new GradientBevelFilter();
			g1.colors = [0xFBF9E2, 0xECD041, 0x856721];
			g1.alphas = [1, 1, 1];
			g1.ratios = [0, 128, 255];
			
			g1.blurX = 15;
			g1.blurY = 15;
			g1.strength = 5;
			g1.angle = 270;
			g1.distance = 5;
			g1.type = BitmapFilterType.INNER;
			
			var g3:GlowFilter = FiltersUtil.getNormalTextFieldGlowFilter(0x674719);
			
			text.filters = [g1, g3];
		}
		
		
		/**
		 * 添加剧情人物名称渐变
		 * @param text
		 *
		 */
		public static function setColorGradientForStoryTitleText(text:TextFieldProxy):void
		{
			var g1:GradientBevelFilter = new GradientBevelFilter();
			g1.colors = [0xffe8c1, 0xc57207];
			g1.alphas = [1, 1];
			g1.ratios = [0, 255];
			
			g1.blurX = 15;
			g1.blurY = 15;
			g1.strength = 5;
			g1.angle = 270;
			g1.distance = 5;
			g1.type = BitmapFilterType.INNER;
			
			
			var g3:GlowFilter = FiltersUtil.getNormalTextFieldGlowFilter();
			
			text.filters = [g1, g3];
		}
		
		/**
		 * 添加战斗力渐变
		 * @param text
		 *
		 */
		public static function setColorGradientForFightText(text:TextFieldProxy):void
		{
			var g1:GradientBevelFilter = new GradientBevelFilter();
			g1.colors = [0xf6ffff, 0x33cbe5, 0x255186];
			g1.alphas = [1, 1, 1];
			g1.ratios = [0, 128, 255];
			
			g1.blurX = 15;
			g1.blurY = 15;
			g1.strength = 5;
			g1.angle = 270;
			g1.distance = 5;
			g1.type = BitmapFilterType.INNER;
			var g3:GlowFilter = FiltersUtil.getNormalTextFieldGlowFilter();
//			var g3:GlowFilter = FiltersUtil.getNormalTextFieldGlowFilter(0x10fcff);
			
			text.filters = [g1, g3];
		}
		
		/**
		 * 红色外发光
		 * @param text
		 *
		 */
		public static function setColorGradientForRedText(text:TextFieldProxy):void
		{
			
			var g3:GlowFilter = FiltersUtil.getRedTextFieldGlowFilter();
			
			text.filters = [g3];
		}
		
		
		public static function setColorGradientRedForText(text:TextFieldProxy):void
		{
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter();
			dropShadowFilter.color = 0x000000;
			dropShadowFilter.alpha = 0.75;
			dropShadowFilter.distance = 1;
			dropShadowFilter.blurX = 2;
			dropShadowFilter.blurY = 2;
			dropShadowFilter.angle = 120;
			dropShadowFilter.quality = 1;
			
			var gradientBevelFilter:GradientBevelFilter = new GradientBevelFilter();
			gradientBevelFilter.colors = [0xff7178, 0x810f00];
			gradientBevelFilter.alphas = [1, 1];
			gradientBevelFilter.ratios = [0, 255];
			gradientBevelFilter.blurX = 15;
			gradientBevelFilter.blurY = 15;
			gradientBevelFilter.strength = 5;
			gradientBevelFilter.angle = 270;
			gradientBevelFilter.distance = 5;
			gradientBevelFilter.type = BitmapFilterType.INNER;
			
			var glowFilter:GlowFilter = new GlowFilter();
			glowFilter.color = 0x151513;
			glowFilter.alpha = 1;
			glowFilter.blurX = 2;
			glowFilter.blurY = 2;
			glowFilter.strength = 15;
			glowFilter.quality = 1;
			
			text.filters = [dropShadowFilter, gradientBevelFilter, glowFilter];
		}
		
		
		public static function setColorGradientWhiteForText(text:TextFieldProxy):void
		{
			var dropShadowFilter:DropShadowFilter = new DropShadowFilter();
			dropShadowFilter.color = 0x000000;
			dropShadowFilter.alpha = 0.75;
			dropShadowFilter.distance = 1;
			dropShadowFilter.blurX = 2;
			dropShadowFilter.blurY = 2;
			dropShadowFilter.angle = 120;
			dropShadowFilter.quality = BitmapFilterQuality.HIGH;
			
			var gradientBevelFilter:GradientBevelFilter = new GradientBevelFilter();
			gradientBevelFilter.colors = [0xffffff, 0xfff1c5];
			gradientBevelFilter.alphas = [1, 1];
			gradientBevelFilter.ratios = [0, 255];
			gradientBevelFilter.blurX = 15;
			gradientBevelFilter.blurY = 15;
			gradientBevelFilter.strength = 5;
			gradientBevelFilter.angle = 270;
			gradientBevelFilter.distance = 5;
			gradientBevelFilter.quality = BitmapFilterQuality.HIGH;
			gradientBevelFilter.type = BitmapFilterType.INNER;
			
			var glowFilter:GlowFilter = new GlowFilter();
			glowFilter.color = 0x151513;
			glowFilter.alpha = 1;
			glowFilter.blurX = 2;
			glowFilter.blurY = 2;
			glowFilter.strength = 15;
			glowFilter.quality = BitmapFilterQuality.HIGH;
			
			text.filters = [dropShadowFilter, gradientBevelFilter, glowFilter];
		}
		/**首冲礼包黑白渐变字体（领取按钮 ）by 李齐*/
		public static function setColorGradientGradForText(text:TextFieldProxy):void
		{
			var g1:GradientBevelFilter = new GradientBevelFilter();
			g1.colors = [0xcccccc, 0x999999, 0x444444];
			g1.alphas = [1, 1, 1];
			g1.ratios = [0, 128, 255];
			
			g1.blurX = 15;
			g1.blurY = 15;
			g1.strength = 5;
			g1.angle = 270;
			g1.distance = 5;
			g1.type = BitmapFilterType.INNER;
			
			var g3:GlowFilter = FiltersUtil.getNormalTextFieldGlowFilter();
			
			text.filters = [g1, g3];
		}
		
		/**
		 *
		 * 使物体褪色，变为黑白色
		 * @param displayObject 要被褪色的显示对象
		 */
		public static function fadeColor(displayObject:DisplayObject, redMultplier:Number = 0.8, greenMultplier:Number = 0.8, blueMultplier:Number = 0.8):void
		{
			deFadeColor(displayObject);
			var filters:Array = displayObject.filters;
			filters.push(fadeFilter);
			displayObject.filters = filters;
			displayObject.transform.colorTransform = new ColorTransform(redMultplier, greenMultplier, blueMultplier, 1, 10, 10, 10, 0);
		}
		
		public static function darkColor(displayObject:DisplayObject):void
		{
			dedarkColor(displayObject);
			displayObject.transform.colorTransform = new ColorTransform(0.5, 0.5, 0.5, 1, 10, 10, 10, 0);
		}
		
		public static function dedarkColor(displayObject:DisplayObject):void
		{
			displayObject.transform.colorTransform = defaultTransform;
		}
		
		public static function customColor(displayObject:DisplayObject, color:uint):void
		{
			
			var r:int = color >> 16;
			var g:int = color >> 8 & 0xff;
			var b:int = color & 0xff;
			
			var colorFilter:ColorMatrixFilter = new ColorMatrixFilter([r / 255, 0, 0, 0, 0, 0, g / 255, 0, 0, 0, 0, 0, b / 255, 0, 0, 0, 0, 0, 1, 0]);
			
			var arr:Array = [];
			
			var f:Array = displayObject.filters;
			
			if (f != null)
			{
				for (var i:int = 0; i < f.length; i++)
				{
					arr.push(f[i]);
				}
			}
			arr.push(colorFilter);
			
			displayObject.filters = arr;
		}
		
		
		
		/**
		 *
		 * 使物体恢复彩色
		 * @param displayObject 要恢复色彩的显示对象
		 */
		public static function deFadeColor(displayObject:DisplayObject):void
		{
			var filters:Array = displayObject.filters;
			
			for (var i:int = 0; i < filters.length; i++)
			{
				var colorFilter:ColorMatrixFilter = filters[i]as ColorMatrixFilter;
				
				// 如果不是ColorMatrixFilter则跳过
				if (colorFilter == null)
					continue;
				// 如果与变灰滤镜相同则删除
				var flag:Boolean = true;
				var cMatrix:Array = colorFilter.matrix;
				var fMatrix:Array = fadeFilter.matrix;
				
				for (var j:int = 0; j < 20; j++)
				{
					if (cMatrix[j] != fMatrix[j])
					{
						flag = false;
						break;
					}
				}
				
				if (flag)
				{
					filters.splice(i, 1);
					break;
				}
			}
			displayObject.filters = filters;
			displayObject.transform.colorTransform = defaultTransform;
		}
		
		/**
		 * 为显示对象设置高光
		 * @param displayObject 要设置高光的显示对象
		 */
		public static function highLight(displayObject:DisplayObject):void
		{
			//displayObject.transform.colorTransform = highLightTransform;
			var filtersTmp:Array = displayObject.filters;
			
			if (filtersTmp.length > 0)
			{
				filtersTmp.push(highLightFilter);
				displayObject.filters = filtersTmp;
			} else
			{
				displayObject.filters = [highLightFilter];
			}
		}
		
		/**
		 * 为显示对象去掉高光
		 * @param displayObject 要去掉高光的显示对象
		 */
		public static function deHighLight(displayObject:DisplayObject):void
		{
			//displayObject.transform.colorTransform = defaultTransform;
			
			var arr:Array = displayObject.filters;
			var res:Array = new Array();
			
			for (var i:int = 0; i < arr.length; i++)
			{
				var colorFilter:ColorMatrixFilter = arr[i]as ColorMatrixFilter;
				
				if (isHighLightFilter(colorFilter))
				{
					
				} else
				{
					res.push(arr[i]);
				}
			}
			displayObject.filters = [];
			displayObject.filters = res;
			
		}
		
		private static function isHighLightFilter(f:ColorMatrixFilter):Boolean
		{
			var result:Boolean = false;
			
			if (f != null)
			{
				var arr:Array = f.matrix;
				
				if (isArrayEqual(arr, highLightFilter.matrix))
					result = true;
			}
			return result;
		}
		
		private static function isArrayEqual(arr1:Array, arr2:Array):Boolean
		{
			var result:Boolean = true;
			
			for (var i:int = 0; i < arr1.length; i++)
			{
				if (arr1[i] != arr2[i])
				{
					result = false;
					break;
				}
			}
			return result;
		}
		
		
		//加光边
		public static function addColorRing(target:DisplayObject, color:uint = 0xcccc00, diffuse:Number = 3, strength:Number = 6, alhpa:Number = 1, inner:Boolean = false):void
		{
			if (target)
			{
				var filters:Array = target.filters;
				var filter:GlowFilter
				
				for (var i:String in filters)
				{
					if (filters[i]is GlowFilter)
					{
						filter = filters[i];
						break;
					}
				}
				
				if (filter)
				{
					filter.color = color;
					filter.alpha = strength;
					filter.blurX = diffuse;
					filter.blurY = diffuse;
					filter.strength = strength;
					filter.quality = BitmapFilterQuality.HIGH;
					filter.inner = inner;
				} else
				{
					filter = new GlowFilter(color, alhpa, diffuse, diffuse, strength, BitmapFilterQuality.HIGH , inner);
					filters.push(filter);
				}
				
				target.filters = filters;
			}
		}
		
		//取消光边
		public static function removeColorRing(target:DisplayObject):void
		{
			if (target && target.filters)
			{
				var filers:Array = target.filters;
				
				for (var i:int = 0; i < target.filters.length; i++)
				{
					if (target.filters[i]is GlowFilter)
					{
						filers.splice(i, 1);
						target.filters = filers;
					}
				}
			}
		}
		
		public static function addShadow(target:DisplayObject, distance:int = 4, strength:int = 1, alpha:Number = .5):void
		{
			var filter:DropShadowFilter = new DropShadowFilter(distance, 45, 0, alpha, 2, 2, strength);
			var filters:Array = target.filters;
			filters.push(filter);
			target.filters = filters;
		}
		
		public static function addBlur(target:DisplayObject, strength:int):void
		{
			if (target)
			{
				var filter:BlurFilter;
				var filters:Array = target.filters;
				
				for (var i:String in filters)
				{
					if (filters[i]is BlurFilter)
					{
						filter = filters[i];
						break;
					}
				}
				
				if (filter)
				{
					filter.blurX = filter.blurY = strength;
				} else
				{
					filter = new BlurFilter(strength, strength);
					filters.push(filter);
				}
				target.filters = filters;
			}
		}
		
		/**
		 *返回一段html文字 主要用于给文字加颜色
		 * @param content
		 * @param color
		 *
		 */
		public static function getFontColorHtmlString(content:String, htmlColor:String):String
		{
			return "<font color='" + htmlColor + "'>" + content + "</font>";
		}
	}
}