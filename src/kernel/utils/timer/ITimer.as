package kernel.utils.timer
{
	/**
	 * @name Timer接口类
	 * @explain 
	 * @author yanghongbin
	 * @create 2011 Nov 21, 2011 10:34:29 AM
	 */	
	public interface ITimer
	{
		function get currentCount():int;
		function get delay():int;
		function set delay(value:int):void;
		function get repeatCount():int;
		function set repeatCount(value:int):void;
		function get running():Boolean;
		function reset():void;
		function start():void;
		function stop():void;
		function step():void;
	}
}