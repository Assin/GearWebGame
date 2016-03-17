package kernel.errors
{
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create 2011 Nov 4, 2011 11:43:35 AM
	 */
	public class KernelError extends Error
	{
		
		public function KernelError(message:* = "", id:* = 0)
		{
			super(message, id);
		}
		
	}
}