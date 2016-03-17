package kernel.net
{
	
	/**
	 * HTTP协议消息借口
	 * @author 雷羽佳
	 *
	 */
	public interface IHttpMessageBase
	{
		/**
		 * 内容为同一地址下不同的do文件，同时用来标识不同的消息类型
		 * @return
		 *
		 */
		function get messageType():String;
		/**
		 * 是否成功
		 */
		function get success():Boolean;
		
		/**
		 * @private
		 */
		function set success(value:Boolean):void;
		/**
		 * 获得属性
		 * @return
		 *
		 */
		function getVariables():String;
		/**
		 * 设置json
		 * @param json
		 *
		 */
		function setJson(json:String):void;
		/**
		 * 设置初始化
		 * @param initVariables
		 *
		 */
		function setInitVariables($initVariables:IInitMessageVariables):void;
		
		function toString():String;
	}
}