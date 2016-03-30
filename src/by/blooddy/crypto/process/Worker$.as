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
	
	[ExcludeClass]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					Mar 30, 2016 7:51:57 AM
	 */
	internal final class Worker$ {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @copy	flash.system.Worker.isSupported
		 */
		public static const isSupported:Boolean = Worker.isSupported;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		public function Worker$(bytes:ByteArray) {

			super();

			this.worker = WorkerDomain.current.createWorker( bytes );
			
			this.input = this.worker.createMessageChannel( Worker.current );
			this.output = Worker.current.createMessageChannel( this.worker );
			
			this.worker.setSharedProperty( 'output', this.input );
			this.worker.setSharedProperty( 'input', this.output );
			
			this.worker.start();
			
			this.input.addEventListener( Event.CHANNEL_MESSAGE, this.handler_input_message );

		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var worker:Worker;
		
		/**
		 * @private
		 */
		private var input:MessageChannel;
		
		/**
		 * @private
		 */
		private var output:MessageChannel;
		
		/**
		 * @private
		 */
		private const queue:Vector.<Function> = new Vector.<Function>();
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function send(data:Object, callback:Function=null):void {
			this.queue.push( callback );
			this.output.send( data );
		}
		
		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private function handler_input_message(event:Event):void {
			var result:Object = this.input.receive( true );
			this.queue.shift()( result );
		}
		
	}
	
}