package kernel.data
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Mar 14, 2012 6:49:59 PM
	 */
	public class ResourceType
	{
		/**
		 * 单个的图片 比如.jpg  .png等
		 */
		public static var IMAGE:String = "image";
		/**
		 * 纯文本的类型
		 */
		public static var TEXT_DATA:String = "textdata";
		/**
		 * 二进制数据文件
		 */
		public static var BINARY_DATA:String = "binarydata";
		/**
		 * module
		 */
		public static var MODULE:String = "module";
		/**
		 * 直接播放的swf
		 */
		public static var MOVIECLIP_SWF:String = "movieclipswf";
		/**
		 * 位图打包文件
		 */
		public static var BITMAP_SWF:String = "bitmapswf";
		/**
		 * 库索引的swf文件
		 */
		public static var REFLECT_SWF:String = "reflectswf";
		/**
		 * 语言包文件
		 */
		public static var LANGUAGE_SWF:String = "languageswf";
		/**
		 * 加密的模块文件
		 */
		public static var ENCRYPT_MODULE:String = "encryptmodule";
		/**
		 * 声音文件
		 */
		public static var SOUND_SWF:String = "soundswf";
		/**
		 * 字体文件
		 */
		public static var FONT_SWF:String = "fontswf";
		/**
		 * 用于动作动画打包的文件，将一个人物其中的一个衣服或武器的 所有动作合并为一个文件。扩展名为 .pswf
		 */
		public static var P_SWF:String = "pswf";
		
		public function ResourceType()
		{
		}
	}
}