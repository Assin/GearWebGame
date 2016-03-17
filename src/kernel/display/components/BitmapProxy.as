package kernel.display.components
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	import kernel.IDispose;
	import kernel.errors.KernelErrorRunner;
	import kernel.runner.ResourcesRunner;
	import kernel.utils.DisplayUtil;
	import kernel.utils.LayoutUtil;
	
	
	/**
	 * @name 位图图片代理
	 * @explain 当没有指定的图片的时候会从远程自动加载,支持九宫格显示
	 * @author yanghongbin
	 * @create 2011 Nov 4, 2011 5:06:34 PM
	 *
	 *  重复使用必须 监听 new Event(Event.COMPLETE)事件 ,设置相关尺寸
	 */
	public class BitmapProxy extends Bitmap implements IDispose, ILayoutable, IBrightDisplayObject
	{
		private var _brightName:String;
		private var _url:String = "";
		private var _isClone:Boolean;
		private var _width:Number = -1;
		private var _height:Number = -1;
		
		protected var _originalBitmap:BitmapData;
		protected var _scale9Grid:Rectangle = null;
		
		protected var _onLoadComplete:Function;
		protected var _useRealURL:Boolean;
		
		
		public var useScale9Grid:Boolean = false;
		
		/**
		 * 创建位图九宫格信息
		 *
		 */
		public static function createBitmapScale9GirdData(url:String, top:Number, bottom:Number, left:Number, right:Number):BitmapProxyScale9GirdData
		{
			var bps9gd:BitmapProxyScale9GirdData = new BitmapProxyScale9GirdData();
			bps9gd.url = url;
			var rect:Rectangle = new Rectangle();
			rect.top = top;
			rect.bottom = bottom;
			rect.left = left;
			rect.right = right;
			bps9gd.scale9Gird = rect;
			
			return bps9gd;
		}
		
		/**
		 * 设置九宫格数据data,并且设置后就显示出来
		 * @param value
		 *
		 */
		public function set bitmapScale9GirdData(value:BitmapProxyScale9GirdData):void
		{
			this.useScale9Grid = true;
			this.setURL(value.url);
			this.scale9Grid = value.scale9Gird;
		}
		
		/**
		 * 是否使用loader加载
		 */
		public function get useRealURL():Boolean
		{
			return _useRealURL;
		}
		
		/**
		 * @private
		 */
		public function set useRealURL(value:Boolean):void
		{
			_useRealURL = value;
		}
		
		/**
		 * 设置加载完图片回调
		 * @param value
		 *
		 */
		public function set onLoadComplete(value:Function):void
		{
			_onLoadComplete = value;
		}
		
		override public function get width():Number
		{
			return (_width < 0 ? super.width : _width);
		}
		
		override public function set width(value:Number):void
		{
			_width = value;
			this.setSize(_width, _height);
		}
		
		override public function get height():Number
		{
			return (_height < 0 ? super.height : _height);
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			this.setSize(_width, _height);
		}
		
		/**
		 * 获取或设置远程图片URL，如果设置该属性则会导致加载图片操作
		 */
		public function getURL():String
		{
			return _url;
		}
		
		public function setURL(value:String, isClone:Boolean = false):void
		{
			_url = value;
			_isClone = isClone;
			loadImage();
		}
		
		/**
		 * 加载完成回调
		 *
		 */ /**
		* 初始化 Bitmap 对象以引用指定的 BitmapData 对象。
		* @param url 远程图片位置
		* @param bitmapData 被引用的 BitmapData 对象。
		* @param pixelSnapping Bitmap 对象是否贴紧至最近的像素。
		* @param smoothing 在缩放时是否对位图进行平滑处理。
		*/
		public function BitmapProxy(url:String = "", bitmapData:BitmapData = null, pixelSnapping:String = "auto", smoothing:Boolean = false, onLoadComplete:Function = null)
		{
			super(bitmapData, pixelSnapping, smoothing);
			_url = url;
			_onLoadComplete = onLoadComplete;
			loadImage();
		}
		
		private function loadImage():void
		{
			if (_url == null || _url == "")
				return ;
			
			if (this._useRealURL)
			{
				ResourcesRunner.getInstance().getBitmapDataByRealURL(_url, loadImageOKHandler, _isClone);
			} else
			{
				ResourcesRunner.getInstance().getBitmapData(_url, loadImageOKHandler, _isClone);
			}
		}
		
		private function loadImageOKHandler(bitmapData:BitmapData):void
		{
			this.bitmapData = bitmapData;
			
			if (_width >= 0)
				super.width = _width;
			
			if (_height >= 0)
				super.height = _height;
			// 触发事件表示加载完成
			dispatchEvent(new Event(Event.COMPLETE));
			
			if (_onLoadComplete != null)
				_onLoadComplete(this);
		}
		
		override public function set bitmapData(bmpData:BitmapData):void
		{
			if (this.useScale9Grid)
			{
				if (_originalBitmap != null)
				{
					_originalBitmap.dispose();
				}
				//如果使用9宫格，那么复制一份原图的bitmapdata
				_originalBitmap = bmpData.clone();
				
				if (_scale9Grid != null)
				{
					if (!validGrid(_scale9Grid))
					{
						_scale9Grid = null;
					}
					setSize(bmpData.width, bmpData.height);
				}
			} else
			{
				assignBitmapData(bmpData);
			}
		}
		
		override public function set scale9Grid(r:Rectangle):void
		{
			if ((_scale9Grid == null && r != null) || (_scale9Grid != null))
			{
				if (!validGrid(r))
				{
					KernelErrorRunner.getInstance().throwException("BitmapProxy scale9Grid 无效");
					return ;
				}
				_scale9Grid = r.clone();
				resizeBitmap(width, height);
				scaleX = 1;
				scaleY = 1;
			}
		}
		
		protected function assignBitmapData(bmp:BitmapData):void
		{
			if (this._isClone || this.useScale9Grid)
			{
				if (super.bitmapData != null)
				{
					super.bitmapData.dispose();
				}
			}
			super.bitmapData = bmp;
		}
		
		private function validGrid(r:Rectangle):Boolean
		{
			return r.right <= _originalBitmap.width && r.bottom <= _originalBitmap.height;
		}
		
		override public function get scale9Grid():Rectangle
		{
			return _scale9Grid;
		}
		
		public function setSize(w:Number, h:Number):void
		{
			if (_scale9Grid == null)
			{
				super.width = w;
				super.height = h;
				
			} else
			{
				//				w = Math.max(w, _originalBitmap.width - _scale9Grid.width);
				//				h = Math.max(h, _originalBitmap.height - _scale9Grid.height);
				resizeBitmap(w, h);
			}
			
		}
		
		protected function resizeBitmap(w:Number, h:Number):void
		{
			if (w < 1 || h < 1)
			{
				return ;
			}
			var bmpData:BitmapData = new BitmapData(w, h, true, 0x00000000);
			
			var rows:Array = [0, _scale9Grid.top, _originalBitmap.height - _scale9Grid.bottom, _originalBitmap.height];
			var cols:Array = [0, _scale9Grid.left, _originalBitmap.width - _scale9Grid.right, _originalBitmap.width];
			
			var dRows:Array = [0, _scale9Grid.top, h - _scale9Grid.bottom, h];
			var dCols:Array = [0, _scale9Grid.left, w - _scale9Grid.right, w];
			
			var origin:Rectangle;
			var draw:Rectangle;
			
			var mat:Matrix = new Matrix();
			
			
			for (var cx:int = 0; cx < 3; cx++)
			{
				for (var cy:int = 0; cy < 3; cy++)
				{
					
					origin = new Rectangle(cols[cx], rows[cy], cols[cx + 1] - cols[cx], rows[cy + 1] - rows[cy]);
					draw = new Rectangle(dCols[cx], dRows[cy], dCols[cx + 1] - dCols[cx], dRows[cy + 1] - dRows[cy]);
					mat.identity();
					mat.a = draw.width / origin.width;
					mat.d = draw.height / origin.height;
					mat.tx = draw.x - origin.x * mat.a;
					mat.ty = draw.y - origin.y * mat.d;
					bmpData.draw(_originalBitmap, mat, null, null, draw, smoothing);
				}
			}
			assignBitmapData(bmpData);
		}
		
		public function setLayout(layout:LayoutVO):void
		{
			LayoutUtil.layout(this, layout);
		}
		
		public function getBrightRectangle():Rectangle
		{
			return DisplayUtil.getGlobalRectangle(this);
		}
		
		public function get brightName():String
		{
			return _brightName;
		}
		
		public function set brightName(value:String):void
		{
			this._brightName = value;
		}
		
		public function dispose():void
		{
			_url = "";
			_width = _height = -1;
			this.scaleX = this.scaleY = 1;
			this.smoothing = false;
			
			if (this._isClone || this.useScale9Grid)
			{
				if (super.bitmapData != null)
				{
					super.bitmapData.dispose();
				}
			} else
			{
				super.bitmapData = null;
			}
			
			if (_originalBitmap != null)
			{
				_originalBitmap.dispose();
				_originalBitmap = null;
			}
			_isClone = false;
			_scale9Grid = null;
			_onLoadComplete = null;
		}
		
	}
}