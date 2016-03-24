////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import by.blooddy.crypto.events.FaultEvent;
	import by.blooddy.crypto.events.ResultEvent;
	
	[Event( type="by.blooddy.crypto.events.ResultEvent", name="result" )]
	[Event( type="by.blooddy.crypto.events.FaultEvent", name="fault" )]
	
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					24.03.2016 23:45:13
	 */
	public class Worker extends EventDispatcher {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static var _worker:flash.system.Worker;
		
		/**
		 * @private
		 */
		private static var _input:MessageChannel;
		
		/**
		 * @private
		 */
		private static var _output:MessageChannel;
		
		/**
		 * @private
		 */
		private static var _queue:Vector.<Callback>;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static function $construct():void {
			if ( !_worker ) {
				
				_worker = WorkerDomain.current.createWorker( new ByteArray() );
				
				_input = _worker.createMessageChannel( flash.system.Worker.current );
				_output = flash.system.Worker.current.createMessageChannel( _worker );
				
				_worker.setSharedProperty( 'output', _input );
				_worker.setSharedProperty( 'input', _output );
				
				_queue = new Vector.<Callback>();
				
				_input.addEventListener( Event.CHANNEL_MESSAGE, handler_channelMessage );
				
			}
		}
		
		/**
		 * @private
		 */
		private static function $call(success:Function, error:Function, ...arguments):void {
			_queue.push( new Callback( success, error ) );
			_output.send( arguments );
		}
		
		/**
		 * @private
		 */
		private static function handler_channelMessage(event:Event):void {
			var result:Object = _input.receive();
			var callback:Callback = _queue.pop();
			if ( result.success && callback.success ) {
				callback.success( result.success );
			} else if ( result.error && callback.error ) {
				callback.error( result.error );
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function Worker() {
			if ( ( this as Object ).constructor != by.blooddy.crypto.worker.Worker ) {
				super();
				$construct();
			} else {
				Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @param	callback
		 * @param	method
		 * @param	args
		 * 
		 * @event	data
		 */
		protected function call(method:QName, ...args):void {
			args.unshift( method );
			$call( this.success, this.error, args );
		}

		/**
		 * @private
		 */
		private function success(result:*):void {
			super.dispatchEvent( new ResultEvent( result ) );
		}
		
		/**
		 * @private
		 */
		private function error(e:*):void {
			super.dispatchEvent( new FaultEvent( e ) );
		}
		
	}

}

/**
 * @private
 */
internal final class Callback {
	
	public function Callback(success:Function, error:Function) {
		this.success = success;
		this.error = error;
	}
	
	public var success:Function;
	public var error:Function;
	
}