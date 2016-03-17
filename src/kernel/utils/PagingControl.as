package kernel.utils
{
	import kernel.IDispose;
	
	/**
	 * @name 分页控制类
	 * @explain 传入每页数量，和当前要显示的页数，以及全部的内容，调用next 和prev方法后即可返回新分页数组
	 * @author yanghongbin
	 * @create May 23, 2013
	 */
	public class PagingControl implements IDispose
	{
		private var _currentPageNum:int;
		private var _content:*;
		private var _pageItemNum:int;
		private var _pagingContent:*;
		public function PagingControl()
		{
		}
		
		/**
		 * 获取后面是否还有 
		 * @return 
		 * 
		 */		
		public function get nextUsable():Boolean
		{
			return (this._currentPageNum < this.maxPageNum) ? true : false;
		}
		
		/**
		 * 获取前一个是否还有
		 * @return 
		 * 
		 */		
		public function get prevUsable():Boolean
		{
			return (this._currentPageNum > 1) ? true : false;
		}
		
		/**
		 * 获取分页后的数据 
		 * @return 
		 * 
		 */
		public function get pagingContent():*
		{
			return _pagingContent;
		}

		public function get pageItemNum():int
		{
			return _pageItemNum;
		}
		/**
		 * 每页内容的数量 
		 * @param value
		 * 
		 */
		public function set pageItemNum(value:int):void
		{
			_pageItemNum = value;
		}

		/**
		 * 当前所在页数
		 * @return
		 *
		 */
		public function get currentPageNum():int
		{
			return _currentPageNum;
		}
		/**
		 * 当前所在页数
		 * @return
		 *
		 */
		public function set currentPageNum(value:int):void
		{
			_currentPageNum = value;
			this.pagingToCollection();
		}
		
		/**
		 * 最大页数
		 * @param value
		 *
		 */
		public function get maxPageNum():int
		{
			if(this.content == null || this.pageItemNum <= 0)
			{
				return 0;
			}
			var length:uint = 0;
			if(this.content is Array)
			{
				length = (this.content as Array).length;
			}else if(this.content is Vector.<*>)
			{
				var vector:Vector.<*> = this.content as Vector.<*>;
				length = vector.length;
			}
			return Math.ceil(length / this.pageItemNum);
		}
		
		public function get content():*
		{
			return _content;
		}
		
		/**
		 * 要控制的所有内容
		 * @param value
		 *
		 */
		public function set content(value:*):void
		{
			_content = value;
			if(this.contentLength > 0)
			{
				this.currentPageNum = 1;
			}
		}
		/**
		 * 获得原始内容的数量 
		 * @return 
		 * 
		 */		
		protected function get contentLength():uint
		{
			if(this.content == null )
			{
				return 0;
			}
			var length:uint = 0;
			if(this.content is Array)
			{
				length = (this.content as Array).length;
			}else if(this.content is Vector.<*>)
			{
				var vector:Vector.<*> = this.content as Vector.<*>;
				length = vector.length;
			}
			return length;
		}
		//将数据分页进集合中去
		protected function pagingToCollection():void
		{
			if(this._content is Array)
			{
				this._pagingContent = PageUtil.getPageContentArray(this._content, this._currentPageNum, this._pageItemNum);
			}else if(this._content is Vector.<*>)
			{
				this._pagingContent = PageUtil.getPageContentVector(this._content, this._currentPageNum, this._pageItemNum);
			}
		}
		/**
		 * 获得下一个 
		 * 
		 */		
		public function next():void
		{
			if(this.nextUsable == false)
			{
				return;
			}
			var tempPageNum:int = (this._currentPageNum + 1) % this.maxPageNum;
			if(tempPageNum == 0)
			{
				tempPageNum = this.maxPageNum;
			}
			this.currentPageNum = tempPageNum;
			
		}
		/**
		 * 获得上一个 
		 * 
		 */		
		public function prev():void
		{
			if(this.prevUsable == false)
			{
				return;
			}
			var tempPageNum:int = (this._currentPageNum - 1) % this.maxPageNum;
			this.currentPageNum = tempPageNum;
		}
		
		public function dispose():void
		{
			_pagingContent = null;
		}
		
		
	}
}
