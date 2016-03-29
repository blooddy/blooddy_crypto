////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	[SWF( width="1", height="1", frameRate="1", scriptTimeLimit="-1", scriptRecursionLimit="10000", pageTitle="blooddy_crypto" )]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					Mar 28, 2016 11:24:15 AM
	 */
	public final class BackgroundWorker extends Sprite {

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
				process();
			} );
			
			if ( input.messageAvailable ) {
				process();
			}
			
			function process():void {
				
				var data:Object = input.receive( true );
				
				try {
					
					var target:Object = ApplicationDomain.currentDomain.getDefinition( data.c );
					
					output.send( {
						success: target[ data.m ].apply( target, data.a )
					} );
					
				} catch ( e:Error ) {
					
					output.send( {
						fault: e
					} );
					
				}

			}
			
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