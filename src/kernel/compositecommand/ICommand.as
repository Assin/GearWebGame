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
package kernel.compositecommand{
	import kernel.IDispose;
	
	
	/**
	 * Interface to be implemented by command classes.
	 * @author Christophe Herreman
	 * @docref the_operation_api.html#commands
	 */
	public interface ICommand extends IDispose {
		/**
		 * Executes the command.
		 */
		function execute():*;
		
	}
	
}