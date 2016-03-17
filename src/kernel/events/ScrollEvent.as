package kernel.events
{
	import flash.events.Event;
	
	public class ScrollEvent extends Event
	{
		public static const SCROLL:String = "scroll";
		
		private var _direction:String;
		private var _delta:int;
		private var _position:int;
		
		public function ScrollEvent(direction:String, delta:int, position:int)
		{
			super(ScrollEvent.SCROLL, false, false);
			_direction = direction;
			_delta = delta;
			_position = position;
		}
		
		public function get direction():String
		{
			return _direction;
		}
		
		public function get delta():int
		{
			return _delta;
		}
		
		public function get position():int
		{
			return _position;
		}
		
		override public function toString():String
		{
			return formatToString("ScrollEvent", "type", "bubbles", "cancelable", "direction", "delta", "position");
		}
		
		override public function clone():Event
		{
			return new ScrollEvent(_direction, _delta, _position);
		}
	}
}