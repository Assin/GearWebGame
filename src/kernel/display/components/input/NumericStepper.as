package kernel.display.components.input
{
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import kernel.display.components.BaseComponent;
	import kernel.display.components.button.Button;
	import kernel.events.NumberInputChangeEvent;
	import kernel.utils.ObjectPool;
	

	/**
	 * ---<--<-@
	 * @author 
	 * 
	 */	
	public class NumericStepper extends BaseComponent
	{
		private var _numInput:NumberInput;
		private var _upButton:Button;
		private var _downButton:Button;
		private var _width:Number;
		private var _height:Number;
		private var _stepSize:Number = 1;
		
		override public function set width(value:Number):void{
			_width = value;
			drawLayout();
		}
		
		override public function get width():Number{
			return _width;
		}
		
		/* override public function set height(value:Number):void{
			_height = value;
			drawLayout();
		} */
		
		override public function get height():Number{
			return _height;
		}
		
		public function NumericStepper(id:int=0)
		{
			super(id);
		}
		
		public function set minimum(value:Number):void{
			_numInput.minimum = value;
			checkButtonEnable();
		}
		
		public function set maximum(value:Number):void{
			_numInput.maximum = value;
			checkButtonEnable();
		}
		
		public function get minimum():Number{
			return _numInput.minimum;
		}
		
		public function set stepSize(value:Number):void{
			_stepSize = value;
		}
		
		public function get stepSize():Number{
			return _stepSize;
		}
		
		public function get maximum():Number{
			return _numInput.maximum;
		}
		
		override protected function init():void{
			super.init();
			_numInput = new NumberInput(1,null,numInputChangeHandler);
			_upButton = new Button(1,"+",clickHandler);
			_downButton = new Button(2,"-",clickHandler);
			_upButton.width = 20;
			_upButton.height = 9;
			_downButton.width = 20;
			_downButton.height = 9;
			/* _upButton.setBackground(Resources.FIRST_COMPONENT_CHECKBOX_OFF_PNG);
			_downButton.setBackground(Resources.FIRST_COMPONENT_CHECKBOX_OFF_PNG); */
			addChild(_numInput);
			addChild(_upButton);
			addChild(_downButton);
			drawLayout();
		}
		
		public function get text():String{
			return _numInput.text;
		}
		
		public function set text(value:String):void{
			this._numInput.text = value;
			checkButtonEnable();
		}
		public function set number(value:Number):void{
			this._numInput.number = value;
			checkButtonEnable();
		}
		private function numInputChangeHandler(e:Event):void{
			var evt:NumberInputChangeEvent = new NumberInputChangeEvent(NumberInputChangeEvent.CHANGE);
			evt.number = _numInput.number;
			dispatchEvent(evt);
			checkButtonEnable();
		}
		
		private function checkButtonEnable():void{
			if(Number(_numInput.text) >= this.maximum){
				this._upButton.enabled = false;
			}else{
				this._upButton.enabled = true;
			}
			if(Number(_numInput.text) <= this.minimum){
				this._downButton.enabled = false;
			}else{
				this._downButton.enabled = true;
			}
		}
		
		private function drawLayout():void{
			_numInput.width = this.width - _upButton.width;
			_numInput.height = _upButton.height + _downButton.height;
			_upButton.x = _numInput.x + _numInput.width;
			_downButton.x = _numInput.x + _numInput.width;
			_downButton.y = _upButton.y + _upButton.height;
		}
		
		private function clickHandler(e:MouseEvent):void{
			switch(e.target.id){
				case 1:
					_numInput.number = _numInput.number + this.stepSize;
				break;
				case 2:
					_numInput.number = _numInput.number - this.stepSize;
				break;
			}
			//点击增大或减小按钮派发事件
			this.numInputChangeHandler(null);
		}
		
		override public function dispose():void
		{
			ObjectPool.disposeObject(_numInput);
			_numInput = null;
			ObjectPool.disposeObject(_upButton);
			_upButton = null;
			ObjectPool.disposeObject(_downButton);
			_downButton = null;
			
			super.dispose();
		}
	}
}