package kernel.display.components.image
{
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import kernel.display.components.BitmapProxy;
	import kernel.display.components.LayoutVO;
	import kernel.display.components.MouseEffectiveComponent;
	import kernel.utils.DisplayUtil;
	import kernel.utils.LayoutUtil;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：Image.as
	 * <p>
	 * 功能：该组件内嵌一个BitmapProxy类，并实现其所有常用方法和属性。该组件是专为给BitmapProxy添加Tip而设置的。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-23
	 * <p>
	 * 作者：yanghongbin
	 */
	public class Image extends MouseEffectiveComponent
	{
		private var _image:DisplayObject;
		private var _width:Number = -1;
		private var _height:Number = -1;
		private var _completeHandler:Function;
		
		/**
		 * 获取或设置图片类实体。设置该属性时传递的参数可以是BitmapData、表示图片地址的String、显示对象或者Class
		 */
		public function get image():Object
		{
			return _image;
		}
		
		public function set image(data:Object):void
		{
			var image:DisplayObject;
			var needComplete:Boolean = false;
			if (data is String)
			{
				image = new BitmapProxy();
				image.addEventListener(Event.COMPLETE, function(event:Event):void
				{
					image.removeEventListener(Event.COMPLETE, arguments.callee);
					if (_width >= 0)
						image.width = _width;
					else
						_width = image.width;
					if (_height >= 0)
						image.height = _height;
					else
						_height = image.height;
					if (_completeHandler != null)
					{
						_completeHandler();
					}
				});
				BitmapProxy(image).setURL(String(data));
				needComplete = false;
			} else if (data is BitmapData)
			{
				image = new BitmapProxy();
				BitmapProxy(image).bitmapData = data as BitmapData;
				needComplete = true;
			} else if (data is DisplayObject)
			{
				image = data as DisplayObject;
				needComplete = true;
			} else if (data is Class)
			{
				image = (new data())as DisplayObject;
				needComplete = true;
			}
			if (image != null)
			{
				DisplayUtil.removeChild(_image, this);
				ObjectPool.disposeObject(_image);
				_image = image;
				addChild(_image);
				if (needComplete && _completeHandler != null)
				{
					_completeHandler();
				}
			}
		}
		
		/**
		 * 设置加载图片完毕后的回调函数
		 */
		public function set complete(value:Function):void
		{
			_completeHandler = value;
		}
		
		override public function get width():Number
		{
			return ((_width < 0 || _image == null) ? super.width : _width);
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			if (_image != null)
				_image.width = value;
		}
		
		override public function get height():Number
		{
			return ((_height < 0 || _image == null) ? super.height : _height);
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			if (_image != null)
				_image.height = value;
		}
		
		override public function get scaleX():Number
		{
			return _image.scaleX;
		}
		
		override public function set scaleX(value:Number):void
		{
			_width = _image.width * value;
			_image.scaleX = value;
		}
		
		override public function get scaleY():Number
		{
			return _image.scaleY;
		}
		
		override public function set scaleY(value:Number):void
		{
			_height = _image.height * value;
			_image.scaleY = value;
		}
		
		/**
		 * 获取或设置内部图片的相对横坐标
		 */
		public function get innerX():Number
		{
			return _image.x;
		}
		
		public function set innerX(value:Number):void
		{
			_image.x = value;
		}
		
		/**
		 * 获取或设置内部图片的相对纵坐标
		 */
		public function get innerY():Number
		{
			return _image.y;
		}
		
		public function set innerY(value:Number):void
		{
			_image.y = value;
		}
		
		public function Image(id:int = 0, clickHandler:Function = null, completeHandler:Function = null)
		{
			_completeHandler = completeHandler;
			super(id, null, clickHandler);
		}
		
		/**
		 * 按照传入的布局数据对组件进行布局，组件默认不对子数据进行布局
		 * @param layout 布局数据
		 */
		override public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layout(this, layout);
		}
		
		/**
		 * 清除图片及宽高信息
		 */
		override public function clear():void
		{
			super.clear();
			DisplayUtil.removeChild(_image, this);
			_image = null;
			_width = _height = -1;
			if (_image != null)
			{
				_image.scaleX = _image.scaleY = 1;
			}
			_image = null;
			_completeHandler = null;
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_image);
			_image = null;
			_completeHandler = null;
			
			super.dispose();
		}
	}
}