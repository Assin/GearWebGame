package kernel.display.components.tip.members
{
	import kernel.IDispose;
	
	/**
	 *tip自定义显示的数据包
	 * @author 雷羽佳
	 *
	 */
	public class CustomDisplayVO implements IDispose
	{
		/**
		 *自定义显示的模版，接口为ITipCustomDisplay，基类型为BaseTipCustomDisplay, 如果要调用自定义模版类，还需要将type设置为TipMemberType.CONTAINER
		 */
		public var customDisplay:Class;
		
		/**
		 *根据选择的模版来规定模版的数据包格式，可以是object也可以是array等等。
		 */
		public var data:*;
		
		public var isShowBG:Boolean = true;
		
		public function dispose():void
		{
			customDisplay = null;
			data = null;
		}
		
		
		
	}
}