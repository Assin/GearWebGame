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
	import kernel.compositecommand.event.CommandEvent;
	import kernel.compositecommand.event.CompositeCommandEvent;
	import kernel.operation.AbstractProgressOperation;
	import kernel.operation.IOperation;
	import kernel.operation.OperationEvent;
	import kernel.runner.LogRunner;
	
	
	
	
	
	/**
	 * Basic implementation of the <code>ICompositeCommand</code> that executes a list of <code>ICommand</code> instances
	 * that were added through the <code>addCommand()</code> method. The commands are executed in the order in which
	 * they were added.
	 * @author Christophe Herreman
	 * @author Roland Zwaga
	 * @docref the_operation_api.html#composite_commands
	 */
	public class CompositeCommand extends AbstractProgressOperation implements ICompositeCommand
	{
		
		
		/**
		 * Determines if the execution of all the <code>ICommands</code> should be aborted if an
		 * <code>IAsyncCommand</code> instance dispatches an <code>AsyncCommandFaultEvent</code> event.
		 * @default false
		 * @see org.springextensions.actionscript.core.command.IAsyncCommand IAsyncCommand
		 */
		public var failOnFault:Boolean = false;
		private var _executingCommands:Array = [];
		private var _commands:Array = [];
		
		private var _isPlaying:Boolean = false;
		
		public function set args(value:Array):void
		{
			
		}
		
		
		public function get commands():Array
		{
			return _commands;
		}
		
		protected function setCommands(value:Array):void
		{
			_commands = value;
		}
		
		// --------------------------------------------------------------------
		//
		// Constructor
		//
		// --------------------------------------------------------------------
		
		/**
		 * Creates a new <code>CompositeCommand</code> instance.
		 * @default CompositeCommandKind.SEQUENCE
		 */
		public function CompositeCommand(kind:CompositeCommandKind = null)
		{
			super();
			_kind = (kind != null) ? kind : CompositeCommandKind.SEQUENCE;
		}
		
		// --------------------------------------------------------------------
		//
		// Properties
		//
		// --------------------------------------------------------------------
		
		private var _kind:CompositeCommandKind;
		
		public function get kind():CompositeCommandKind
		{
			return _kind;
		}
		
		public function set kind(value:CompositeCommandKind):void
		{
			_kind = value;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get numCommands():uint
		{
			return _commands.length;
		}
		
		private var _currentCommand:ICommand;
		
		/**
		 * The <code>ICommand</code> that is currently being executed.
		 */
		public function get currentCommand():ICommand
		{
			return _currentCommand;
		}
		
		// --------------------------------------------------------------------
		//
		// Implementation: ICommand
		//
		// --------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function execute():*
		{
			if(this._executingCommands == null)
			{
				this._executingCommands = [];
			}
			if (_commands)
			{
				this._isPlaying = true;
				switch (_kind)
				{
					case CompositeCommandKind.SEQUENCE:
						executeNextCommand();
						break;
					case CompositeCommandKind.PARALLEL:
						executeCommandsInParallel();
						break;
					default:
						break;
				}
			} else
			{
				dispatchCompleteEvent();
			}
		}
		
		public function get isPlaying():Boolean
		{
			return this._isPlaying;
		}
		
		public function stop():void
		{
			this._isPlaying = false;
			this.dispose();
		}
		
		// --------------------------------------------------------------------
		//
		// Public Methods
		//
		// --------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function addCommand(command:ICommand):ICompositeCommand
		{
			if (_commands == null)
			{
				_commands = [];
			}
			_commands[_commands.length] = command;
			total++;
			return this;
		}
		
		public function addOperation(operationClass:Class, ... constructorArgs):ICompositeCommand
		{
			return null;
		}
		
		// --------------------------------------------------------------------
		//
		// Protected Methods
		//
		// --------------------------------------------------------------------
		
		/**
		 * If the specified <code>ICommand</code> implements the <code>IAsyncCommand</code> interface the <code>onCommandResult</code>
		 * and <code>onCommandFault</code> event handlers are added. Before the <code>ICommand.execute()</code> method is invoked
		 * the <code>CompositeCommandEvent.EXECUTE_COMMAND</code> event is dispatched.
		 * <p>When the <code>command</code> argument is <code>null</code> the <code>CompositeCommandEvent.COMPLETE</code> event is dispatched instead.</p>
		 * @see org.springextensions.actionscript.core.command.event.CommandEvent CompositeCommandEvent
		 */
		protected function executeCommand(command:ICommand):void
		{
			
			
			_currentCommand = command;
			
			// listen for "result" or "fault" if we have an async command
			addCommandListeners(command as IOperation);
			
			// execute the command
			dispatchEvent(new CommandEvent(CommandEvent.EXECUTE, command));
			dispatchBeforeCommandEvent(command);
			command.execute();
			if (!(command is IOperation))
			{
				dispatchAfterCommandEvent(command);
			}
			
			// execute the next command if the executed command was synchronous
			if (command is IOperation)
			{
			} else
			{
				progress++;
				dispatchProgressEvent();
				executeNextCommand();
			}
		}
		
		/**
		 * Retrieves and removes the next <code>ICommand</code> from the internal list and passes it to the
		 * <code>executeCommand()</code> method.
		 */
		protected function executeNextCommand():void
		{
			var nextCommand:ICommand = null;
			if(_commands == null)
			{
				return;
			}
			if (_commands.length > 0)
			{
				nextCommand = _commands.shift()as ICommand;
			}
			
			if (nextCommand)
			{
				this._executingCommands.push(nextCommand);
				executeCommand(nextCommand);
			} else
			{
				LogRunner.log("CompositeCommand Complete");
				this._isPlaying = false;
				dispatchCompleteEvent();
			}
		}
		
		protected function removeCommand(asyncCommand:IOperation):void
		{
			if (_commands != null)
			{
				var idx:int = _commands.indexOf(asyncCommand);
				if (idx > -1)
				{
					_commands.splice(idx, 1);
				}
				if (_commands.length < 1)
				{
					dispatchCompleteEvent();
				}
			}
		}
		
		protected function executeCommandsInParallel():void
		{
			var containsOperations:Boolean = false;
			for each (var cmd:ICommand in _commands)
			{
				if (cmd is IOperation)
				{
					containsOperations = true;
					addCommandListeners(IOperation(cmd));
				}
				dispatchBeforeCommandEvent(cmd);
				cmd.execute();
				if (!(cmd is IOperation))
				{
					dispatchAfterCommandEvent(cmd);
				}
			}
			if (!containsOperations)
			{
				dispatchCompleteEvent();
			}
		}
		
		/**
		 * Adds the <code>onCommandResult</code> and <code>onCommandFault</code> event handlers to the specified <code>IAsyncCommand</code> instance.
		 */
		protected function addCommandListeners(asyncCommand:IOperation):void
		{
			if (asyncCommand)
			{
				asyncCommand.addCompleteListener(onCommandResult);
				asyncCommand.addErrorListener(onCommandFault);
			}
		}
		
		/**
		 * Removes the <code>onCommandResult</code> and <code>onCommandFault</code> event handlers from the specified <code>IAsyncCommand</code> instance.
		 */
		protected function removeCommandListeners(asyncCommand:IOperation):void
		{
			if (asyncCommand)
			{
				asyncCommand.removeCompleteListener(onCommandResult);
				asyncCommand.removeErrorListener(onCommandFault);
			}
		}
		
		protected function onCommandResult(event:OperationEvent):void
		{
			progress++;
			dispatchProgressEvent();
			removeCommandListeners(IOperation(event.target));
			dispatchAfterCommandEvent(ICommand(event.target));
			LogRunner.log("Command complete:" + event.target);
			switch (_kind)
			{
				case CompositeCommandKind.SEQUENCE:
					executeNextCommand();
					break;
				case CompositeCommandKind.PARALLEL:
					removeCommand(IOperation(event.target));
					break;
				default:
					break;
			}
		}
		
		protected function onCommandFault(event:OperationEvent):void
		{
			dispatchErrorEvent(event.error);
			removeCommandListeners(event.target as IOperation);
			switch (_kind)
			{
				case CompositeCommandKind.SEQUENCE:
					if (failOnFault)
					{
						_currentCommand = null;
					} else
					{
						executeNextCommand();
					}
					break;
				case CompositeCommandKind.PARALLEL:
					removeCommand(IOperation(event.target));
					break;
				default:
					break;
			}
		}
		
		protected function dispatchAfterCommandEvent(command:ICommand):void
		{
			dispatchEvent(new CompositeCommandEvent(CompositeCommandEvent.AFTER_EXECUTE_COMMAND, command));
		}
		
		protected function dispatchBeforeCommandEvent(command:ICommand):void
		{
			dispatchEvent(new CompositeCommandEvent(CompositeCommandEvent.BEFORE_EXECUTE_COMMAND, command));
		}
		
		override public function dispose():void
		{
			for each (var c:ICommand in _commands)
			{
				c.dispose();
			}
			for each (var ec:ICommand in _executingCommands)
			{
				ec.dispose();
			}
			this._isPlaying = false;
			_commands = null;
			_executingCommands = null;
		}
		
		override public function toString():String
		{
			var s:String = "";
			for each(var c:* in _commands)
			{
				s += c.toString() + "\n";
			}
			return s;
		}
		
		
	}
	
}