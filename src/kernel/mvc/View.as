package kernel.mvc
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import kernel.IDispose;
	import kernel.mvc.patterns.context.Context;
	import kernel.mvc.patterns.mediator.Mediator;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 7:15:12 PM
	 */
	public final class View implements IDispose
	{
		private var _viewMap:Dictionary;
		private var _context:Context;
		
		public function View(context:Context)
		{
			_context = context;
		}
		
		public function initializeView():void
		{
			this._viewMap = new Dictionary();
		}
		
		public function registerMediator(mediator:Mediator):void
		{
			var mediatorName:String = getQualifiedClassName(mediator);
			this._viewMap[mediatorName] = mediator;
			mediator.context = _context;
			mediator.init();
		}
		
		public function removeMediator(mediator:Mediator):void
		{
			if (mediator == null)
			{
				return ;
			}
			var mediatorName:String = getQualifiedClassName(mediator);
			var _mediator:Mediator = this._viewMap[mediatorName];
			
			if (_mediator != null)
			{
				_mediator.dispose();
				this._viewMap[mediatorName] = null;
				delete this._viewMap[mediatorName];
			}
		}
		
		public function getMediator(mediatorRef:Class):Mediator
		{
			var mediatorName:String = getQualifiedClassName(mediatorRef);
			return this._viewMap[mediatorName];
		}
		
		public function hasMediator(mediatorRef:Class):Boolean
		{
			var mediatorName:String = getQualifiedClassName(mediatorRef);
			var _mediator:Mediator = this._viewMap[mediatorName];
			return (_mediator == null) ? false : true;
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_viewMap);
			_context = null;
		}
		
		
	}
}