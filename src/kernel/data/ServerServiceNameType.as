package kernel.data
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Oct 29, 2012 3:47:06 PM
	 */
	public class ServerServiceNameType
	{
		/**
		 * 登录
		 */
		public static const LOGIN:String = "login";
		/**
		 * 逻辑
		 */
		public static const LOGIC:String = "logic";
		/**
		 * http服务器  发送log的地址
		 */
		public static const HTTP_GAMEBOXLOG:String = "gameboxlog";
		
		/**
		 * http服务器  客服
		 */
		public static const GAME_TASK:String = "gametask";
		
		public function ServerServiceNameType()
		{
		}
	}
}