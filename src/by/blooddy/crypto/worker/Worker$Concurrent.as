////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.events.Event;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	import flash.system.WorkerDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					25.03.2016 15:52:46
	 */
	internal final class Worker$Concurrent implements Worker$ {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		internal static const instance:Worker$Concurrent = new Worker$Concurrent();
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		private static const _WORKER:flash.system.Worker = WorkerDomain.current.createWorker( new ByteArray() );
		
		private static const _INPUT:MessageChannel = _WORKER.createMessageChannel( flash.system.Worker.current );
		
		private static const _OUTPUT:MessageChannel = flash.system.Worker.current.createMessageChannel( _WORKER );
		
		private static const _QUEUE:Vector.<Function> = new Vector.<Function>();
		
		/* init */ {

			_WORKER.setSharedProperty( 'output', _INPUT );
			_WORKER.setSharedProperty( 'input', _OUTPUT );
	
			_INPUT.addEventListener( Event.CHANNEL_MESSAGE, function(event:Event):void {
				var success:Function = _QUEUE.shift();
				var fail:Function = _QUEUE.shift();
				var result:Object = _INPUT.receive( true );
				if ( result.success ) success( result.success );
				else if ( result.fail ) fail( result.fail );
			} );
			
			_WORKER.start();
			
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
		public function Worker$Concurrent() {
			if ( !instance && flash.system.Worker.isSupported ) {
				super();
			} else {
				Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @inheritDoc
		 */
		public function call(success:Function, fail:Function, method:QName, args:Array):void {
			
			_QUEUE.push( success, fail );

			_OUTPUT.send( [ method, args ] );

		}
		
	}

}