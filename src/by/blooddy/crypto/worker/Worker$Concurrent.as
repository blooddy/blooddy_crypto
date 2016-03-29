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

		private static const _QUEUE:Vector.<Function> = new Vector.<Function>();
		
		private static const _CHANNEL:MessageChannel = ( function():MessageChannel {
			
			[Embed( source="BackgroundWorker.swf", mimeType="application/octet-stream" )]
			var BackgroundWorkerSWF:Class;
			
			var worker:flash.system.Worker = WorkerDomain.current.createWorker( new BackgroundWorkerSWF() as ByteArray );
			
			var input:MessageChannel = worker.createMessageChannel( flash.system.Worker.current );
			var output:MessageChannel = flash.system.Worker.current.createMessageChannel( worker );

			input.addEventListener( Event.CHANNEL_MESSAGE, function(event:Event):void {
				var success:Function = _QUEUE.shift();
				var fault:Function = _QUEUE.shift();
				var result:Object = input.receive( true );
				if ( result.fault ) fault( result.fault );
				else if ( result.success ) success( result.success );
			} );
			
			worker.setSharedProperty( 'output', input );
			worker.setSharedProperty( 'input', output );
				
			worker.start();
				
			return output;
			
		}() );
		
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
		public function process(className:String, methodName:String, arguments:Array, success:Function, fault:Function):void {
			
			_QUEUE.push( success, fault );

			_CHANNEL.send( { c: className, m: methodName, a: arguments } );

		}
		
	}

}