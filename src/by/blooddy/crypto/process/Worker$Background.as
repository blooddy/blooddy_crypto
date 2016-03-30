////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.process {

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.system.ApplicationDomain;
	import flash.system.MessageChannel;
	import flash.system.Worker;
	
	[ExcludeClass]
	[SWF( width="1", height="1", frameRate="1", scriptTimeLimit="-1", scriptRecursionLimit="10000", pageTitle="blooddy_crypto" )]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					Mar 28, 2016 11:24:15 AM
	 */
	public final class Worker$Background extends Sprite {

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const input:MessageChannel = Worker.current.getSharedProperty( 'input' )
		
		/**
		 * @private
		 */
		private static const output:MessageChannel = Worker.current.getSharedProperty( 'output' )

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static function process():void {
			
			var data:Object;
			var target:Object;
			var result:Object;
			
			data = input.receive( true );
			
			try {
				
				target = ApplicationDomain.currentDomain.getDefinition( data.c );
				result = { success: target[ data.m ].apply( target, data.a ) };
				
			} catch ( e:Error ) {
				
				result = { fault: e };
				
			}
			
			output.send( result );
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------
		
		input.addEventListener( Event.CHANNEL_MESSAGE, function(event:Event):void {

			while ( input.messageAvailable ) {
				process();
			}

		} );
		
		while ( input.messageAvailable ) {
			process();
		}
		
	}
	
}