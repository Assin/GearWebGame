package kernel.utils
{
	import flash.filters.BitmapFilter;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BitmapFilterType;
	import flash.filters.BlurFilter;
	import flash.filters.ColorMatrixFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.filters.GradientBevelFilter;
	import flash.filters.GradientGlowFilter;
	
	/**
	 * @name 特效类
	 * @version 1.0
	 * @author liuzhongmin
	 * @create Jan 17, 2012
	 */
	public class FiltersUtil
	{
		public static const GLOW:GlowFilter = new GlowFilter(0, 1, 3, 3, 10, 3);
		//
		private static const RR:Number = 0.3086;
		private static const GG:Number = 0.6940;
		private static const BB:Number = 0.0820;
		
		private static const distance:Number = 2;
		private static const angleInDegrees:Number = 45; // opposite 45 degrees
		private static const colors:Array = [0xFFFFFF, 0xCCCCCC, 0x000000];
		private static const alphas:Array = [1, 0, 1];
		private static const ratios:Array = [0, 128, 255];
		private static const blurX:Number = 20;
		private static const blurY:Number = 20;
		private static const strength:Number = 3;
		private static const quality:Number = BitmapFilterQuality.HIGH;
		private static const type:String = BitmapFilterType.INNER;
		
		private static const knockout:Boolean = false;
		
		public static function getFlyTxtFilters():Array
		{
			var ftr1:DropShadowFilter = new DropShadowFilter(3, 45, 0xFFFFFF, 1, 3, 3, 1, 1, true);
			var ftr2:GlowFilter = new GlowFilter(0x5C3D1C, 1, 3, 3, 50, 3);
			var ftr3:DropShadowFilter = new DropShadowFilter(2, 90, 0x332002, 1, 1.5, 1.5, 12, 3);
			return [ftr1, ftr2, ftr3];
		}
		
		public static function setBorderFilter():GlowFilter
		{
			return new GlowFilter(0x996633, 1, 1.5, 1.5, 50, 3);
		}
		
		//黑色描边
		public static function setBlackBorderFilter():GlowFilter
		{
			return new GlowFilter(0x000000, 1, 1.5, 1.5, 50, 3);
		}
		
		public static function getBlackWhiteFilter():ColorMatrixFilter
		{
			//这三个值是提供标准的黑白效果
			var m:Array = [RR, GG, BB, 0, 0]; //red
			m = m.concat([RR, GG, BB, 0, 0]); //green
			m = m.concat([RR, GG, BB, 0, 0]); //blue
			m = m.concat([0, 0, 0, 1, 0]); //alpha
			return new ColorMatrixFilter(m);
		}
		
		public static function white():GradientGlowFilter
		{
			var _distance:Number = 0;
			var _angleInDegrees:Number = 45;
			var _colors:Array = [0xcccccc, 0xcccccc, 0xFFFFFF, 0xFFFFFF];
			var _alphas:Array = [0, 1, 1, 1];
			var _ratios:Array = [0, 63, 126, 255];
			var _blurX:Number = 5;
			var _blurY:Number = 5;
			var _strength:Number = 2.5;
			var _quality:Number = BitmapFilterQuality.HIGH;
			var _type:String = BitmapFilterType.OUTER;
			var _knockout:Boolean = false;
			return new GradientGlowFilter(_distance, _angleInDegrees, _colors, _alphas, _ratios, _blurX, _blurY, _strength,
				_quality, _type, _knockout);
		}
		
		
		
		public static function black():GradientGlowFilter
		{
			var _distance:Number = 0;
			var _angleInDegrees:Number = 45;
			var _colors:Array = [0xcccccc, 0xcccccc, 0x000000, 0x000000];
			var _alphas:Array = [0, 1, 1, 1];
			var _ratios:Array = [0, 63, 126, 255];
			var _blurX:Number = 5;
			var _blurY:Number = 5;
			var _strength:Number = 2.5;
			var _quality:Number = BitmapFilterQuality.HIGH;
			var _type:String = BitmapFilterType.OUTER;
			var _knockout:Boolean = false;
			return new GradientGlowFilter(_distance, _angleInDegrees, _colors, _alphas, _ratios, _blurX, _blurY, _strength,
				_quality, _type, _knockout);
		}
		
		//活动图标文本描边滤镜
		public static function activeBlack():GradientGlowFilter
		{
			var _distance:Number = 0;
			var _angleInDegrees:Number = 45;
			var _colors:Array = [0xcccccc, 0xcccccc, 0x000000, 0x000000];
			var _alphas:Array = [0, 1, 1, 1];
			var _ratios:Array = [0, 63, 126, 255];
			var _blurX:Number = 2;
			var _blurY:Number = 2;
			var _strength:Number = 2.5;
			var _quality:Number = BitmapFilterQuality.HIGH;
			var _type:String = BitmapFilterType.OUTER;
			var _knockout:Boolean = false;
			return new GradientGlowFilter(_distance, _angleInDegrees, _colors, _alphas, _ratios, _blurX, _blurY, _strength,
				_quality, _type, _knockout);
		}
		
		public static function getBorderClolor():GradientGlowFilter
		{
			var _distance:Number = 0;
			var _angleInDegrees:Number = 45;
			var _colors:Array = [0xcccccc, 0xcccccc, 0x00cbff, 0x333333];
			var _alphas:Array = [0, 0, 1, 0];
			var _ratios:Array = [0, 63, 126, 255];
			var _blurX:Number = 3;
			var _blurY:Number = 3;
			var _strength:Number = 3;
			var _quality:Number = BitmapFilterQuality.HIGH;
			var _type:String = BitmapFilterType.OUTER;
			var _knockout:Boolean = false;
			return new GradientGlowFilter(_distance, _angleInDegrees, _colors, _alphas, _ratios, _blurX, _blurY, _strength,
				_quality, _type, _knockout);
		}
		
		/**
		 * 设置模糊1
		 */
		public static function getGradientBevelFilter():GradientBevelFilter
		{
			return new GradientBevelFilter(distance, angleInDegrees, colors, alphas, ratios, blurX, blurY, strength, quality,
				type, knockout);
		}
		
		/**
		 * 设置模糊2
		 */
		public static function getBitmapFilter():BitmapFilter
		{
			var blurX:Number = 20;
			var blurY:Number = 20;
			return new BlurFilter(blurX, blurY, BitmapFilterQuality.HIGH);
		}
		
		/**
		 * 发光变亮
		 */
		public static function getGlowFilter():GlowFilter
		{
			var color:Number = 0xffffff;
			var alpha:Number = 1;
			var blurX:Number = 60;
			var blurY:Number = 60;
			var strength:Number = 1;
			var quality:Number = BitmapFilterQuality.HIGH;
			var inner:Boolean = true;
			var knockout:Boolean = false;
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		/**
		 * 发光变亮
		 */
		public static function getGlowFilterUseColor(colorNum:Number):GlowFilter
		{
			var color:Number = colorNum;
			var alpha:Number = 1;
			var blurX:Number = 60;
			var blurY:Number = 60;
			var strength:Number = 1;
			var quality:Number = BitmapFilterQuality.LOW;
			var inner:Boolean = true;
			var knockout:Boolean = false;
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		/**
		 * 默认的文本框发光 光边效果
		 * @return
		 *
		 */
		public static function getNormalTextFieldGlowFilter(color:uint = 0x000000,alpha:Number = 1,blurX:Number = 2,blurY:Number = 2,strength:Number = 10,quality:Number = BitmapFilterQuality.HIGH,inner:Boolean = false,knockout:Boolean = false):GlowFilter
		{		
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		/**
		 *红色的文本框发光 光边效果
		 * @return
		 *
		 */
		public static function getRedTextFieldGlowFilter(color:uint = 0xfbbd8c,alpha:Number = 0.47,blurX:Number = 6,blurY:Number = 6,strength:Number = 20,quality:Number = BitmapFilterQuality.HIGH,inner:Boolean = false,knockout:Boolean = false):GlowFilter
		{		
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
		
		public static function getWorldItemTitleTextFieldGlowFilter(color:uint = 0x64543e,alpha:Number = 0.8,blurX:Number = 2,blurY:Number = 3,strength:Number = 20,quality:Number = BitmapFilterQuality.HIGH,inner:Boolean = false,knockout:Boolean = false):GlowFilter
		{		
			return new GlowFilter(color, alpha, blurX, blurY, strength, quality, inner, knockout);
		}
	}
}
