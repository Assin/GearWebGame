package kernel.net
{
	import flash.utils.ByteArray;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 1, 2011 1:37:00 PM
	 */
	public interface IMessageBase
	{
		function get messageID():int;
		function get byteArray():ByteArray;
		function set byteArray(value:ByteArray):void;
		function toString():String;
	}
}