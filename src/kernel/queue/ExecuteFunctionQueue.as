package kernel.queue
{
	
	
	
	
	/**
	 * @name 执行队列,加入队列的时候分配一个ID，随后发送一个完成某一个ID，来执行方法
	 * @explain
	 * @author yanghongbin
	 * @create Jun 8, 2013
	 */
	public class ExecuteFunctionQueue
	{
		private static var _instance:ExecuteFunctionQueue;
		
		private var _idCounter:int;
		
		private var _queueList:Vector.<ExecuteFunctionItemVO>;
		
		private var _isExecuting:Boolean;
		
		public static function getInstance():ExecuteFunctionQueue
		{
			if (_instance == null)
			{
				_instance = new ExecuteFunctionQueue();
			}
			return _instance;
		}
		
		public function ExecuteFunctionQueue()
		{
			this._queueList = new Vector.<ExecuteFunctionItemVO>();
		}
		
		/**
		 * 添加一个方法 和他的参数  返回一个ID
		 * @param functionCall
		 * @param args
		 * @return
		 *
		 */
		public function addFunction(functionCall:Function, ... args):int
		{
			var item:ExecuteFunctionItemVO = new ExecuteFunctionItemVO();
			item.id = ++_idCounter;
			item.functionCall = functionCall;
			item.args = args;
			this._queueList.push(item);
			return item.id;
		}
		
		/**
		 * 执行一下，如果可以执行，就执行第一个
		 *
		 */
		public function execute():void
		{
			if (_isExecuting == false)
			{
				this.executeFirst();
			}
		}
		
		/**
		 * 完成某个并且执行下一个
		 * @param id
		 *
		 */
		public function completeAndExecuteNext(id:int):void
		{
			var item:ExecuteFunctionItemVO;
			
			if (this._queueList != null && this._queueList.length > 0 && this._queueList[0].id == id)
			{
				item = this._queueList[0]
			}
			
			if (item != null)
			{
				//如果第一个符合条件，那么才能执行下一个
				item.dispose();
				item = null;
				this._queueList.shift();
				_isExecuting = false;
				//执行下一个
				this.executeFirst();
			}
		}
		
		private function executeFirst():void
		{
			if (this._queueList.length > 0)
			{
				_isExecuting = true;
				this._queueList[0].callFunction();
			}
			
		}
	}
}
