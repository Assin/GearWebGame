package kernel.net
{
	import kernel.data.ServerServiceNameType;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 3:27:30 PM
	 */
	public interface IServerService
	{
		function init():void;
		function set messageClassCallBack(value:Function):void;
		function get messageClassCallBack():Function;
		function addConnector(value:IServerInfoVO):void;
		function startupConnectorByName(name:String):void;
		function closeConnectorByName(name:String):void;
		function getConnectorByName(name:String):IServerConnector;
		function request(messageBase:IMessageBase, serverName:String = ""):void;
		function requestTo(messageBase:IMessageBase, toURL:String, serverName:String):void;
		function response(messageBase:IMessageBase, serverName:String):void;
		function subscribe(messageCode:int, callback:Function):void;
		function unsubscribe(messageCode:int, callback:Function):void;
	}
}