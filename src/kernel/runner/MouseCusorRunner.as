package kernel.runner
{
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;

	/**
	 * @name 指针管理类 需要 SDK4.5以上  flashplayer10.2以上支持
	 * @explain
	 * @author yanghongbin
	 * @create Jan 13, 2012 2:34:03 PM
	 */
	public class MouseCusorRunner
	{
		private static var _instance:MouseCusorRunner;
		private var _isLocked:Boolean;
		private var _currentCursorType:String;

		public static function getInstance():MouseCusorRunner
		{
			if (_instance == null)
			{
				_instance = new MouseCusorRunner();
			}
			return _instance;
			
		}
		
		public function MouseCusorRunner()
		{
		}
		
		public function init():void
		{
			this.showDefault();
			
		}
		
		public function showDefault():void
		{
			Mouse.cursor = "auto";
		}
		
		public function registerCursor(key:String, point:Point, ... bitmapdatas):void
		{
			if (key == null)
			{
				return ;
			}
			if (point == null)
			{
				point = new Point(0, 0);
			}
			var cursorData:MouseCursorData = new MouseCursorData();
			cursorData.hotSpot = point;
			var bitmaps:Vector.<BitmapData> = new Vector.<BitmapData>();
			for each (var bitmapdata:BitmapData in bitmapdatas)
			{
				bitmaps.push(bitmapdata);
			}
			cursorData.data = bitmaps;
			Mouse.registerCursor(key, cursorData);
		}
		
		
		public function get currentCursorType():String
		{
			return Mouse.cursor;
		}
		
		public function show(key:String):void
		{
			if (this._isLocked)
			{
				return ;
			}
			//当前鼠标指针为普通的时候 才能设置其他的鼠标指针
			Mouse.cursor = key;

		}
		
		/**
		 * 锁定鼠标，鼠标将不能被改变
		 *
		 */
		public function lock():void
		{
			this._isLocked = true;
		}
		
		/**
		 * 解除锁定鼠标
		 *
		 */
		public function unlock():void
		{
			this._isLocked = false;
		}
	}
}