package kernel.display.components.text
{
	

	/**
	 * 给<code>RichTextFieldProxy</code>用的，在文本中插入的图片VO
	 * @author 雷羽佳 2013.2.22 11:35
	 * 
	 */	
	public class RichTextFiledImgVO
	{
		private var _key:String;
		private var _data:*;
		private var _width:Number;

		public function get width():Number
		{
			return _width;
		}

		public function set width(value:Number):void
		{
			_width = value;
		}

		private var _height:Number;

		public function get height():Number
		{
			return _height;
		}

		public function set height(value:Number):void
		{
			_height = value;
		}

		
		public function RichTextFiledImgVO(key:String,data:*,width:Number,height:Number)
		{
			this._key = key;
			this._data = data;
			_width = width;
			_height = height;
		}
		
		/**
		 *富文本中图片的内容，具体类型根据bitmapProxy而定
		 */
		public function get data():*
		{
			return _data;
		}

		/**
		 * @private
		 */
		public function set data(value:*):void
		{
			_data = value;
		}

		/**
		 *富文本中图片的key 
		 */
		public function get key():String
		{
			return _key;
		}

		/**
		 * @private
		 */
		public function set key(value:String):void
		{
			_key = value;
		}

	}
}