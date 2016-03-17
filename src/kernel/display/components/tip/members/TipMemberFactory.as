package kernel.display.components.tip.members
{
	
	
	
	/**
	 * 文件名：TipMemberFactory.as
	 * <p>
	 * 功能：一个专门生产用于Tip的子对象的工厂
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 */
	public class TipMemberFactory
	{
		
		public function TipMemberFactory()
		{
		}
		
		/**
		 * 使用子对象类型来创建一个子对象
		 * @param type 子对象类型
		 * @param data 子对象需要的数据，如图片路径等
		 * @return 创建好的子对象
		 */
		public static function createMember(type:int, data:*):ITipMember
		{
			var member:ITipMember;
			switch (type)
			{
				case TipMemberType.CONTAINER:
					var container:TipContainer = new TipContainer();
					if(data is CustomDisplayVO)
					{
						if(CustomDisplayVO(data).customDisplay != null)
						{
							var tmp:CustomDisplayVO = CustomDisplayVO(data);
							container.renderCustomDisplay(new tmp.customDisplay,tmp.data,tmp.isShowBG);
						}
					}
					container.resetLayout();
					member = container;
					break;
				case TipMemberType.TEXT:
					var txt:TipTextField = new TipTextField();
					txt.setStyle(1);
					txt.htmlText = String(data);
					txt.resetLayout();
					member = txt;
					break;
				case TipMemberType.IMAGE:
					var bitmap:TipBitmapProxy = new TipBitmapProxy();
					bitmap.setURL(String(data));
					bitmap.resetLayout();
					member = bitmap;
					break;
			}
			return member;
		}
	}
}