////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	[ExcludeClass]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					Mar 28, 2016 11:24:15 AM
	 */
	public final class BackgroundWorker {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		private static const _CHANNEL:MessageChannel = ( function():MessageChannel {
			
			var worker:flash.system.Worker = flash.system.Worker.current;
			
			var input:MessageChannel = worker.getSharedProperty( 'input' );
			var output:MessageChannel = worker.getSharedProperty( 'output' );

			input.addEventListener( Event.CHANNEL_MESSAGE, function(event:Event):void {

				var data:Object = input.receive( true );

				var method:QName = data.method;
				var arguments:Array = data.arguments;

				try {
					
					var target:Object = ApplicationDomain.currentDomain.getDefinition( method.uri );
					
					output.send( {
						success: target[ method.localName ].apply( target, arguments )
					} );
					
				} catch ( e:Error ) {
					
					output.send( {
						fault: e
					} );
					
				}

			} );
			
			return output;
			
		}() );
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function BackgroundWorker() {
			super();
		}

	}
	
}