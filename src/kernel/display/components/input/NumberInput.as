package kernel.display.components.input
{
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import kernel.events.NumberInputEvent;
	import kernel.utils.NumberUtil;
	import kernel.utils.StringUtil;
	
	/**
	 * 文件名：NumberInput.as
	 * <p>
	 * 功能：NumberInput是继承自Input的，具有以上所有功能功能，同时具有以下功能：<p>
	 * 		NumberInput.maxChars 重写了这个方法，功能和maxBytes相同，目的是防止输入过长不响应Event.CHANGE事件。<p>
	 * 		NumberInput.max 设置可输入的最大值，如果输入的数字大于这个数字则自动调整为这个数字，同时在失去焦点时判断输入是否合法。<p>
	 * 		NumberInput.min 设置可输入的最小值，仅在失去焦点时用来判断输入是否合法，如果不合法则触发NumberInputEvent.INPUT_OUT_OF_RANGE事件。<p>
	 * 		NumberInput.numberType 可取值有NumberInput.TYPE_NORMAL和NumberInput.TYPE_INTERNATIONAL，默认为前者，如果是后者则显示为带逗号的形式，如“1,000,000”。<p>
	 * 		NumberInput.clear() 将text设为“0”。
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：
	 * <p>
	 * 作者：yanghongbin
	 */
	public class NumberInput extends Input
	{
		public static const TYPE_NORMAL				: int = 1;
		public static const TYPE_INTERNATIONAL		: int = 2;
		
		protected var _numberType					: int = TYPE_NORMAL;
		protected var _maximum						: Number = 0;
		protected var _minimum						: Number = 0;
		protected var _num							: Number = 0;
		
		/**
		 * 获取或设置该输入框中字符的字符串表示形式
		 */		
		override public function get text():String {
			return NumberUtil.toNormalFormat(super.text);
		}
		/**
		 * 获取或设置该输入框中字符的数字表示形式
		 */		
		public function get number():Number {
			return _num;
		}
		public function set number(value:Number):void {
			if(value > _maximum){
				_num = _maximum;
			}else if(value < _minimum){
				_num = _minimum;
			}else{
				_num =  value;
			}
			this.text = NumberUtil.toNormalFormat(_num);
		}
		/**
		* 获取或设置可输入的最大长度。在此等同于maxBytes属性
		*/		
		override public function get maxChars():int {
			return maxBytes;
		}
		override public function set maxChars(value:int):void {
			super.maxBytes = value;
		}
		/**
		 * 获取或设置数字样式
		 * NumberInput.TYPE_NORMAL 表示是普通的数字显示形式
		 * NumberInput.TYPE_INTERNATIONAL 表示是国家化的数字显示形式，即每三位用一个逗号（,）隔开的形式
		 */		
		public function get numberType():int {
			return _numberType;
		}
		public function set numberType(value:int):void {
			_numberType = value;
			updateView();
		}
		/**
		 * 输入框所允许输入的最大数字，如果用户输入超过该值则会立即强制修改为该值
		 */		
		public function get maximum():Number {
			return (NumberUtil.isNumber(_maximum) ? _maximum : 0);
		}
		public function set maximum(value:*):void {
			// 2010-5-12 yanghongbin 如果传进来的不是数字则表示不进行上限判断，设为空字符串
			_maximum = NumberUtil.isNumber(value) ? value : 0;
			// 如果目前的值大于最大值则调整为默认值
			if(NumberUtil.compare(number, maximum) > 0) {
				reset();
			}
		}
		/**
		 * 获取或设置输入框所允许的最小值。
		 * 与maximum属性不同，该值不会强制修改输入框中的值，而只是在设置number属性的时候进行判断
		 */		
		public function get minimum():Number {
			return _minimum;
		}
		public function set minimum(value:*):void {
			_minimum = value;
		}
		
		public function NumberInput(id:int=0, clickHandler:Function=null, changeHandler:Function=null, enterHandler:Function=null, numberType:int=NumberInput.TYPE_NORMAL)
		{
			super(id, clickHandler, changeHandler, enterHandler);
			this.numberType = numberType;
		}
		override protected function initTextField():void {
			super.initTextField();
			_textField.restrict = "0-9";
		}
		override protected function textChangeHandler(e:Event):void {
			// 判断上限
			if(maximum != 0) {
				if(NumberUtil.compare(this.text, maximum) > 0) {
					this.number = maximum;
					text = NumberUtil.toNormalFormat(maximum);
					e.preventDefault();
				}
			}
			// 判断字符串长度，忽略非数字字符
			if(maxBytes > 0) {
				var str:String = NumberUtil.toNormalFormat(_textField.text);
				while(StringUtil.length(str) > maxBytes) {
					str = str.substr(0, str.length - 1);
				}
				text = (numberType == TYPE_INTERNATIONAL ? NumberUtil.toInternationalFormat(str) : str);
				e.preventDefault();
			}
			updateView();
			// 触发回调函数
			if(_changeHandler != null) _changeHandler(e);
		}
		override protected function textFocusOutHandler(e:FocusEvent):void {
			super.textFocusOutHandler(e);
			if((maximum != 0 && NumberUtil.compare(this.text, maximum) > 0) ||
			   (minimum != 0 && NumberUtil.compare(this.text, minimum) < 0)) {
				var evt:NumberInputEvent = new NumberInputEvent(NumberInputEvent.INPUT_OUT_OF_RANGE, this);
				evt.data.value = this.number;
				evt.data.max = this.maximum;
				evt.data.min = this.minimum;
				this.dispatchEvent(evt);
			}
		}
		protected function updateView():void {
			if(_textField.text == "") {
				_textField.text = "0";
				setSelection();
				return;
			}
			switch(_numberType) {
				case TYPE_NORMAL:
					this.text = NumberUtil.toNormalFormat(this.text);
					break;
				case TYPE_INTERNATIONAL:
					this.text = NumberUtil.toInternationalFormat(this.text);
					break;
			}
			this.number = parseFloat(this.text);
			setSelection(_textField.length);
		}
		
		override public function clear():void {
			super.clear();
			_textField.text = "0";
		}
		
		override public function dispose():void
		{
			super.dispose();
		}
	}
}