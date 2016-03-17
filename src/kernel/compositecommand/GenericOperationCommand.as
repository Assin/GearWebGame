/*
* Copyright 2007-2010 the original author or authors.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package kernel.compositecommand
{
	import kernel.operation.AbstractProgressOperation;
	
	
	
	
	/**
	 * Generic <code>ICommand</code> implementation that can be used to wrap arbitrary <code>IOperation</code> or <code>IProgressOperation</code>
	 * implementations. This way immediate execution of the <code>IOperation</code> can be defered to an instance
	 * of this class.
	 * @see org.springextensions.actionscript.core.operation.IOperation IOperation
	 * @see org.springextensions.actionscript.core.operation.IProgressOperation IProgressOperation
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#genericoperationcommand
	 */
	public class GenericOperationCommand extends AbstractProgressOperation
	{
		
		
		private var _constructorArguments:Array;
		
		/**
		 * An array of arguments that will be passed to the constructor of the specified <code>IOperation</code> implementation.
		 */
		public function get constructorArguments():Array
		{
			return _constructorArguments;
		}
		
		/**
		 * @private
		 */
		public function set constructorArguments(value:Array):void
		{
			_constructorArguments = value;
		}
		
		/**
		 * Creates a new <code>GenericOperationCommand</code> instance.
		 * @param operationClass The specified <code>IOperation</code> implementation that will be created.
		 * @param constructorArgs An array of arguments that will be passed to the constructor of the specified <code>IOperation</code> implementation.
		 */
		public function GenericOperationCommand(operationClass:Class, ... constructorArgs)
		{
			super();
		}
		
		
		public static function createNew(clazz:Class, constructorArgs:Array):GenericOperationCommand
		{
			var goc:GenericOperationCommand = new GenericOperationCommand(clazz);
			goc.constructorArguments = constructorArgs;
			return goc;
		}
		
		
	}
}