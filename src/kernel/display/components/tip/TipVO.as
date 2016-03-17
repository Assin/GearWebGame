package kernel.display.components.tip
{
	import kernel.IClear;
	import kernel.IDispose;
	import kernel.display.components.tip.members.TipMemberType;
	import kernel.utils.ObjectPool;
	
	/**
	 * 文件名：TipVO.as
	 * <p>
	 * 功能：Tip所需的信息的数据类型，每一个TipVO为Tip显示对象里的某一个子显示对象提供数据支持
	 * <p>
	 * 版本：1.0.0
	 * <p>
	 * 日期：2010-8-20
	 * <p>
	 * 作者：yanghongbin
	 * <p>
	 * 版权：(c)千橡游戏
	 */
	public class TipVO implements IClear,IDispose
	{
		/**
		 * 该VO所对应的显示对象类型，由TipMemberType类提供枚举
		 */		
		public var type:int = TipMemberType.NONE;
		/**
		 * 该类型的VO所具有的数据，如图片路径等，也可以是自定义显示的CustomDisplayVO
		 */		
		public var data:* = null;
		/**
		 * 该VO所对应的显示对象的横坐标
		 */		
		public var x:Number = 0;
		/**
		 * 该VO所对应的显示对象的纵坐标
		 */		
		public var y:Number = 0;
		/**
		 * 表示横坐标是否为与前一节点的相对坐标，如果是相对坐标则表示与父容器的所有子节点中前一个节点的相对横坐标，如果没有前一个节点则为绝对横坐标
		 */		
		public var isRelativeX:Boolean = false;
		/**
		 * 表示纵坐标是否为与前一节点的相对坐标，如果是相对坐标则表示与父容器的所有子节点中前一个节点的相对纵坐标，如果没有前一个节点则为绝对纵坐标
		 */		
		public var isRelativeY:Boolean = false;
		/**
		 * 表示该显示对象的所有子节点数据，如果没有子节点则为null
		 */		
		public var children:Array = null;
		
		
		
		
		
		
		/**
		 * Tip所需的信息的数据类型，每一个TipVO为Tip显示对象里的某一个子显示对象提供数据支持
		 */		
		public function TipVO()
		{
			
		}
		
		/**
		 * 判断两个TipVO是否相等
		 * @param tipVO 另外的TipVO
		 * @return 是否相等
		 */		
		public function equal(tipVO:TipVO):Boolean {
			var equal:Boolean = true;
			equal &&= (type == tipVO.type);
			equal &&= (data == tipVO.data);
			equal &&= (x == tipVO.x);
			equal &&= (y == tipVO.y);
			equal &&= (isRelativeX == tipVO.isRelativeX);
			equal &&= (isRelativeY == tipVO.isRelativeY);
			if(children != null && tipVO.children != null) {
				if(children.length == tipVO.children.length) {
					for(var i:int = 0; i < children.length; i++) {
						if(children[i] is TipVO && tipVO.children[i] is TipVO) {
							equal &&= TipVO(children[i]).equal(tipVO.children[i]);
						} else {
							equal &&= (children[i] == tipVO.children[i]);
						}
					}
				} else {
					equal = false;
				}
			} else if(children != tipVO.children) {
				equal = false;
			}
			return equal;
		}
		
		
		
		
		
		
		
		/**
		 * 清除该数据对象中的所有信息，且为深度清除
		 */		
		public function clear():void {
			type = TipMemberType.NONE;
			x = 0;
			y = 0;
			isRelativeX = false;
			isRelativeY = false;
			if(children != null) {
				ObjectPool.clearList(children);
				ObjectPool.clearAndPushPool(children);
				children = null;
			}
		}
		
		public function dispose():void
		{
			ObjectPool.disposeObject(data);
			data = null;
			ObjectPool.disposeObject(children);
			children = null;
		}
	}
}