////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.events.EventDispatcher;
	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;
	
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
				if ( AVAIBLE ) $Channel.$construct();
			} else {
				Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Protected methods
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
			if ( AVAIBLE ) {
				$Channel.$call( this.success, this.fail, method, args );
			} else {
				setTimeout( function():void {
					try {
						var o:Object = ApplicationDomain.currentDomain.getDefinition( method.uri );
						success( o[ method.localName ].apply( args ) );
					} catch ( e:Error ) {
						fail( e );
					}
				}, 0 );
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function success(result:*):void {
			super.dispatchEvent( new ResultEvent( result ) );
		}
		
		/**
		 * @private
		 */
		private function fail(e:*):void {
			super.dispatchEvent( new FaultEvent( e ) );
		}
		
	}

}

import flash.events.Event;
import flash.system.ApplicationDomain;
import flash.system.MessageChannel;
import flash.system.Worker;
import flash.system.WorkerDomain;
import flash.utils.ByteArray;

/**
 * @private
 */
internal const AVAIBLE:Boolean = ApplicationDomain.currentDomain.hasDefinition( 'flash.system.Worker' ) && Worker.isSupported;

/**
 * @private
 */
internal final class $Channel {
	
	internal static function $construct():void {
		if ( !_worker ) {
			
			_worker = WorkerDomain.current.createWorker( new ByteArray() );
			
			_input = _worker.createMessageChannel( flash.system.Worker.current );
			_output = flash.system.Worker.current.createMessageChannel( _worker );
			
			_worker.setSharedProperty( 'output', _input );
			_worker.setSharedProperty( 'input', _output );
			
			_queue = new Vector.<Function>();
			
			_input.addEventListener( Event.CHANNEL_MESSAGE, handler_channelMessage );
			
		}
	}
	
	internal static function $call(success:Function, fail:Function, ...arguments):void {
		_queue.push( success, fail );
		_output.send( arguments );
	}
	
	private static var _worker:flash.system.Worker;
	
	private static var _input:MessageChannel;
	
	private static var _output:MessageChannel;
	
	private static var _queue:Vector.<Function>;
	
	private static function handler_channelMessage(event:Event):void {
		var result:Object = _input.receive();
		var success:Function = _queue.pop();
		var fail:Function = _queue.pop();
		if ( result.success ) success( result.success );
		else if ( result.fail ) fail( result.fail );
	}
	
}