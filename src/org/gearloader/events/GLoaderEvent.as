package org.gearloader.events {
	import flash.events.Event;
	import org.gearloader.loader.GBaseLoader;
	
	public class GLoaderEvent extends Event {
		/**
		 * GLoader load complete
		 */
		public static const COMPLETE:String = "complete";
		/**
		 * GLoader load error(ioError,securityError)
		 */
		public static const ERROR:String = "error";
		/**
		 * GLoader load in progress
		 */
		public static const PROGRESS:String = "progress";
		
		public var bytesLoaded:uint;
		public var bytesTotal:uint;
		public var loadRate:int;
		public var loadTime:uint;
		public var errorType:String = "";
		public var content:*;
		public var currentFailTimes:int;
		public var url:String;
		public var name:String;
		public var status:String;
		public var queueTotal:uint;
		public var queueCurrent:uint;
		public var progress:Number = 0;
		public var rawProgress:Number = 0;
		public var item:GBaseLoader;
		
		public function GLoaderEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
	}
}
