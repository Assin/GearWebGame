package kernel.display.components.button
{
	import kernel.display.components.BitmapProxy;
	import kernel.display.components.BitmapProxyScale9GirdData;
	import kernel.display.components.behaviors.DefaultComponentMouseEffectBehavior;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：ImageButton.as
	 * <p>
	 * 功能：只具有图片而没有文字的按钮
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：Aug 27, 2010
	 * <p>
	 * 作者：Hongbin.Yang
	 */
	public class ImageButton extends BaseButton
	{
		protected var _imgBG:BitmapProxy;
		private var _mouseOverImageURL:String;
		private var _mouseDownImageURL:String;
		private var _mouseOutImageURL:String;
		
		public function get mouseOutImageURL():String
		{
			return _mouseOutImageURL;
		}
		
		public function set mouseOutImageURL(value:String):void
		{
			_mouseOutImageURL = value;
			this.setImage(this._mouseOutImageURL);
		}
		
		public function get mouseDownImageURL():String
		{
			return _mouseDownImageURL;
		}
		
		public function set mouseDownImageURL(value:String):void
		{
			_mouseDownImageURL = value;
		}
		
		public function get mouseOverImageURL():String
		{
			return _mouseOverImageURL;
		}
		
		public function set mouseOverImageURL(value:String):void
		{
			_mouseOverImageURL = value;
		}
		
		override public function get width():Number
		{
			return _imgBG.width;
		}
		
		override public function set width(value:Number):void
		{
			if (value <= 0)
				return ;
			_imgBG.width = value;
		}
		
		override public function get height():Number
		{
			return _imgBG.height;
		}
		
		override public function set height(value:Number):void
		{
			if (value <= 0)
				return ;
			_imgBG.height = value;
		}
		
		public function ImageButton(id:int = 0, clickHandler:Function = null)
		{
			super(id, clickHandler);
		}
		
		override protected function init():void
		{
			if (this._mouseEffectBehavior == null)
			{
				this._mouseEffectBehavior = new DefaultComponentMouseEffectBehavior();
			}
			super.init();
			initBG();
		}
		
		protected function initBG():void
		{
			_imgBG = new BitmapProxy();
			addChild(_imgBG);
		}
		
		/**
		 * 设置按钮图片
		 * @param image 图片资源，可以是BitmapData、表示图片地址的String、显示对象或者Class类型
		 */
		public function setImage(image:String, onComplete:Function = null):void
		{
			if(onComplete != null)
				_imgBG.onLoadComplete = onComplete;
			_imgBG.setURL(image);
		}
		
		/**
		 * 设置九宫格数据data,并且设置后就显示出来
		 * @param value
		 *
		 */
		public function set bitmapScale9GirdData(value:BitmapProxyScale9GirdData):void
		{
			this._imgBG.useScale9Grid = true;
			this._imgBG.setURL(value.url);
			this._imgBG.scale9Grid = value.scale9Gird;
		}
		
		override protected function onDownIn():void
		{
			super.onDownIn();
			this.setImage(this._mouseDownImageURL);
		}
		
		override protected function onNormalIn():void
		{
			super.onNormalIn();
			this.setImage(this._mouseOutImageURL);
		}
		
		override protected function onOverIn():void
		{
			super.onOverIn();
			this.setImage(this._mouseOverImageURL);
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_imgBG);
			_imgBG = null;
			super.dispose();
		}
	}
}