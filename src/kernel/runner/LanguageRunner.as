package kernel.runner
{
	import data.GameConfig;
	
	import kernel.utils.StringUtil;
	
	
	/**
	 * @name 多国语言
	 * @explain
	 * @author yanghongbin
	 * @create Dec 5, 2012 6:33:04 PM
	 */
	public class LanguageRunner
	{
		public var dict:Object;
		
		private static var _instance:LanguageRunner;
		
		public static function getInstance():LanguageRunner
		{
			if (_instance == null)
			{
				_instance = new LanguageRunner();
			}
			return _instance;
			
		}
		
		/**
		 * 获取多国语言值，通过语言key
		 * @param key
		 *
		 */
		public function getLanguage(key:String, ... args):String
		{
			var languageValue:String = dict[key];
			
			if (languageValue == null)
			{
				languageValue = key;
			}
			var result:String
			//查找{RoleName}替换
			var myPattern:RegExp = /{RoleName}/ig;
			var name:String = GameConfig.roleName;
			
			if (myPattern.test(languageValue))
			{
				result = languageValue.replace(myPattern, name);
			} else
			{
				result = languageValue;
			}
			
			if (args.length > 0)
			{
				args.unshift(result);
				result = StringUtil.format.apply(null, args);
			}
			return result;
		}
		
		public function LanguageRunner()
		{
		}
	}
}