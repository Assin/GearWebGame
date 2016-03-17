package kernel.utils
{
	
	/**
	 * 迭代器接口
	 */
	public interface IIterator
	{
		function get hasNext():Boolean;
		function next():*;
	}
}