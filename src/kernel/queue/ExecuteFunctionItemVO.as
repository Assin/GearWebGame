package kernel.queue
{
	import kernel.IDispose;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Jun 8, 2013
	 */
	public class ExecuteFunctionItemVO implements IDispose
	{
		public var id:int;
		public var functionCall:Function;
		public var args:Array;
		
		public function ExecuteFunctionItemVO()
		{
		}
		
		public function callFunction():void
		{
			functionCall.apply(null, args);
		}
		
		public function dispose():void
		{
			functionCall = null;
			args = null;
		}
	}
}
