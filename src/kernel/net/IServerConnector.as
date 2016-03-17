package kernel.net
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 3:51:20 PM
	 */
	public interface IServerConnector
	{
		function init():void;
		function set getMessageClassCallBack(value:Function):void;
		function get getMessageClassCallBack():Function;
		function get name():String;
		function request(messageBase:IMessageBase):void;
		function response(messageBase:IMessageBase):void;
		function set onResponseCallBack(value:Function):void;
		function close():void;
	}
}