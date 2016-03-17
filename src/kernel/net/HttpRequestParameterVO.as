package kernel.net
{
	
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Oct 25, 2013
	 */
	public class HttpRequestParameterVO
	{
		public var name:String = "";
		public var value:String = "";
		
		public function HttpRequestParameterVO()
		{
		}
		
		public function toURLFormat():String
		{
			if (value == null)
			{
				value = "";
			}
			
			return name + "=" + value.split(" ").join("");
		}
	}
}
