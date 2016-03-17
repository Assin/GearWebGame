package kernel.mvc.patterns.notice
{
	import kernel.IDispose;
	import kernel.mvc.interfaces.INotification;
	
	/**
	 * @name
	 * @explain
	 * @author yanghongbin
	 * @create Nov 5, 2012 8:06:37 PM
	 */
	public class Notification implements INotification, IDispose
	{
		private var _name:String;
		private var _body:Object;
		private var _type:String;
		private var _args:Array;
		
		public function Notification(name:String, body:Object = null, type:String = null, args:Array = null)
		{
			this._name = name;
			this._body = body;
			this._type = type;
			this._args = args;
		}
		
		
		public function get name():String
		{
			return _name;
		}
		
		public function get body():Object
		{
			return _body;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		/**
		 * 参数数组
		 * @return
		 *
		 */
		public function get args():Array
		{
			return _args;
		}
		
		public function toString():String
		{
			var msg:String = "Notification Name: " + name;
			msg += " Body:" + ((body == null) ? "null" : body.toString());
			msg += " Type:" + ((type == null) ? "null" : type);
			return msg;
		}
		
		public function dispose():void
		{
			this._body = null;
			this._args = null;
		}
		
		public function clone():INotification
		{
			return new Notification(this._name, this._body, this._type, this._args);
		}
		
		
	}
}