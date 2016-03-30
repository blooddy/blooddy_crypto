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
	
	[SWF( width="1", height="1", frameRate="1", scriptTimeLimit="-1", scriptRecursionLimit="10000", pageTitle="blooddy_crypto" )]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					Mar 28, 2016 11:24:15 AM
	 */
	public final class BackgroundProcess extends Sprite {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		private static const _INPUT:MessageChannel = Worker.current.getSharedProperty( 'input' )
		
		private static const _OUTPUT:MessageChannel = Worker.current.getSharedProperty( 'output' )

		_INPUT.addEventListener( Event.CHANNEL_MESSAGE, function(event:Event):void {
			while ( _INPUT.messageAvailable ) {
				process();
			}
		} );
		
		while ( _INPUT.messageAvailable ) {
			process();
		}
		
		private static function process():void {
			
			var data:Object = _INPUT.receive( true );
			
			try {
				
				var target:Object = ApplicationDomain.currentDomain.getDefinition( data.c );
				
				_OUTPUT.send( {
					success: target[ data.m ].apply( target, data.a )
				} );
				
			} catch ( e:Error ) {
				
				_OUTPUT.send( {
					fault: e
				} );
				
			}
			
		}

	}
	
}