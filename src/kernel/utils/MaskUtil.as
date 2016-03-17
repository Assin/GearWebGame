package kernel.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Dec 2, 2011 10:54:58 AM
	 */
	public class MaskUtil
	{
		
		public function MaskUtil()
		{
		}
		
		/**
		 *可以用来给容器设置一个透明的矩形鼠标区域
		 * @param container
		 * @param _x
		 * @param _y
		 * @param _w
		 * @param _h
		 * @return
		 *
		 */
		public static function setRectMouseArea(container:DisplayObjectContainer, _x:Number, _y:Number, _w:Number, _h:Number):Sprite
		{
			var _mask:Sprite = new Sprite();
			_mask.graphics.beginFill(0xffffff, 0);
			_mask.graphics.drawRect(0, 0, _w, _h);
			_mask.graphics.endFill();
			_mask.x = _x;
			_mask.y = _y;
			container.addChild(_mask);
			_mask.buttonMode = true;
			_mask.tabEnabled = false;
			return _mask;
		}
		
		
		/**
		 *设置一个鼠标区域 不可见
		 * @param container
		 *
		 */
		public static function setTextFieldRectMouseArea(container:DisplayObjectContainer, tf:TextField):void
		{
			var mo:Sprite = new Sprite();
			mo.graphics.beginFill(0x000000, 0);
			mo.graphics.drawRect(0, 0, tf.textWidth, tf.textHeight);
			mo.buttonMode = true;
			mo.x = tf.x;
			mo.y = tf.y;
			container.addChild(mo);
		}
		
		/**
		 *直接添加一个遮罩显示到父容器上，并且返回这个容器
		 * @param container 父容器
		 * @param _x
		 * @param _y
		 * @param w
		 * @param h
		 * @return
		 *
		 */
		public static function setRectMask(container:DisplayObjectContainer, _x:Number, _y:Number, w:Number, h:Number, _color:uint = 0x000000, _alpha:Number = 1):Sprite
		{
			var _mask:Sprite = new Sprite();
			_mask.graphics.beginFill(_color, _alpha);
			_mask.graphics.drawRect(0, 0, w, h);
			_mask.graphics.endFill();
			_mask.x = _x;
			_mask.y = _y;
			container.addChild(_mask);
			return _mask;
		}
	}
}