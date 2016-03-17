package kernel.display.components.text
{
	import kernel.utils.ObjectPool;
	import kernel.utils.timer.EnterFrameTimer;
	
	/**
	 * 文件名：CountDownTextField.as
	 * <p>
	 * 功能：
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-10-13
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class CountDownTextField extends TextFieldProxy
	{
		protected static const TIMER_INTERVAL		: int = 1;
		
		protected var _before						: String;
		protected var _after						: String;
		protected var _countDown					: int = 0;
		protected var _timer						: EnterFrameTimer;
		protected var _complete						: Function;
		
		/**
		 * 设置前置字符
		 */		
		public function set before(value:String):void {
			_before = value;
		}
		/**
		 * 设置后置字符
		 */		
		public function set after(value:String):void {
			_after = value;
		}
		/**
		 * 设置完成时的回调方法
		 */		
		public function set complete(callBack:Function):void{
			_complete = callBack;
		}
		/**
		 * 获取剩余秒数
		 */		
		public function get leftSeconds():int {
			return _countDown < 0 ? 0 : _countDown;
		}
		/**
		 * 获取剩余时间的小时部分
		 */		
		public function get hour():int {
			var hour:int = Math.floor(_countDown / 3600);
			return hour;
		}
		/**
		 * 获取剩余时间的分钟部分
		 */		
		public function get minute():int {
			var min:int = Math.floor(_countDown / 60) % 60;
			return min;
		}
		/**
		 * 获取剩余时间的秒数部分
		 */		
		public function get second():int {
			var sec:int = _countDown % 60;
			return sec;
		}
		/**
		 * 设置剩余秒数，该操作不修改当前倒计时状态
		 */
		public function set formatText(value:int):void {
			_countDown = value;
			refreshText();
		}
		
		public function CountDownTextField(before:String = "", after:String = "")
		{
			super();
			_before = before;
			_after = after;
			init();
		}
		protected function init():void {
			_timer = new EnterFrameTimer(TIMER_INTERVAL * 1000);
			_timer.onTimer = timerHandler;
		}
		protected function timerHandler():void {
			_countDown--;
			refreshText();
			if(_countDown < 0) {
				_countDown = 0;
				_timer.stop();
				if(_complete != null){
					_complete();
				}
			}
		}
		protected function refreshText():void {
			if(_countDown <= 0) {
				this.text = _before + "--:--:--" + _after;
				return;
			}
			this.text = _before + getFormatNumber(hour) + ":" + getFormatNumber(minute) + ":" + getFormatNumber(second) + _after;
		}
		protected function getFormatNumber(num:Number, count:int = 2):String {
			var str:String = num.toString();
			while(str.length < count) {
				str = "0" + str;
			}
			return str;
		}
		
		/**
		 *
		 * 根据传入的秒数开始倒计时，并显示为格式化文本 
		 * @param countDown 倒计时剩余秒数
		 * 
		 */		
		public function startCountDown(countDown:int = -1):void {
			if(countDown >= 0) _countDown = countDown;
			if(!_timer.running) _timer.start();
		}
		/**
		 *
		 * 停止倒计时
		 * 
		 */		
		public function stopCountDown():void {
			if(_timer.running) _timer.stop();
		}
		override public function clear():void {
			super.clear();
			stopCountDown();
			_countDown = 0;
			refreshText();
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_timer);
			_timer = null;
			_complete = null;
			
			super.dispose();
		}
	}
}