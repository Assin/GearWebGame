package kernel.mvc
{
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	
	import kernel.IDispose;
	import kernel.mvc.patterns.context.Context;
	import kernel.mvc.patterns.proxy.Proxy;
	import kernel.utils.ObjectPool;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 7:15:04 PM
	 */
	public final class Model implements IDispose
	{
		private var _proxyMap:Dictionary;
		private var _context:Context;
		
		public function Model(context:Context)
		{
			_context = context;
		}
		
		public function initializeModel():void
		{
			this._proxyMap = new Dictionary();
		}
		
		public function registerProxy(proxy:Proxy):void
		{
			var proxyName:String = getQualifiedClassName(proxy);
			this._proxyMap[proxyName] = proxy;
			proxy.context = _context;
			proxy.init();
		}
		
		public function removeProxy(proxy:Proxy):void
		{
			var proxyName:String = getQualifiedClassName(proxy);
			var _proxy:Proxy = this._proxyMap[proxyName];
			
			if (_proxy != null)
			{
				_proxy.dispose();
				this._proxyMap[proxyName] = null;
				delete this._proxyMap[proxyName];
			}
		}
		
		public function getProxy(proxyRef:Class):Proxy
		{
			var proxyName:String = getQualifiedClassName(proxyRef);
			return this._proxyMap[proxyName];
		}
		
		public function hasProxy(proxyRef:Class):Boolean
		{
			var proxyName:String = getQualifiedClassName(proxyRef);
			var _proxy:Proxy = this._proxyMap[proxyName];
			return (_proxy == null) ? false : true;
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(_proxyMap);
			
			_context = null;
		}
		
		
	}
}