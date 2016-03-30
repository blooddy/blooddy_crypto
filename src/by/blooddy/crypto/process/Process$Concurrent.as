////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.process {

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
	internal final class Process$Concurrent implements Process$ {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		internal static const instance:Process$Concurrent = new Process$Concurrent();
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		private static const _QUEUE:Vector.<Function> = new Vector.<Function>();

		[Embed( source="BackgroundProcess.swf", mimeType="application/octet-stream" )]
		private static const BackgroundWorkerSWF:Class;

		private static const _WORKER:Worker = WorkerDomain.current.createWorker( new BackgroundWorkerSWF() as ByteArray );
		
		private static const _INPUT:MessageChannel = _WORKER.createMessageChannel( Worker.current );
		private static const _OUTPUT:MessageChannel = Worker.current.createMessageChannel( _WORKER );
		
		_INPUT.addEventListener( Event.CHANNEL_MESSAGE, function(event:Event):void {
			var success:Function = _QUEUE.shift();
			var fault:Function = _QUEUE.shift();
			var result:Object = _INPUT.receive( true );
			if ( result.fault ) fault( result.fault );
			else if ( result.success ) success( result.success );
		} );
		
		_WORKER.setSharedProperty( 'output', _INPUT );
		_WORKER.setSharedProperty( 'input', _OUTPUT );
			
		_WORKER.start();
				
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function Process$Concurrent() {
			if ( !instance && Worker.isSupported ) {
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

			_OUTPUT.send( { c: className, m: methodName, a: arguments } );

		}
		
	}

}