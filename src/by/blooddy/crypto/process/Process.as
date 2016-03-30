////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.process {

	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	import by.blooddy.crypto.events.ProcessEvent;
	
	[Event( type="by.blooddy.crypto.events.ProcessEvent", name="success" )]
	[Event( type="by.blooddy.crypto.events.ProcessEvent", name="fault" )]
	
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					24.03.2016 23:45:13
	 */
	public class Process extends EventDispatcher {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const process:Process$ = ( function():Process$ {
			var o:Object;
			try {
				o = Process$Concurrent;
			} catch ( e:Error ) {
				o = Process$Consistent;
			}
			return o.internal::instance;
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
		public function Process() {
			if ( ( this as Object ).constructor != Process ) {
				super();
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
		 * @param	method
		 * @param	args
		 */
		protected function call(method:String, ...arguments):void {
			process.process(
				getQualifiedClassName( this ), method, arguments,
				this.success, this.fail
			);
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
			super.dispatchEvent( new ProcessEvent( ProcessEvent.COMPLETE, false, false, result ) );
		}
		
		/**
		 * @private
		 */
		private function fail(e:*):void {
			if ( super.hasEventListener( ProcessEvent.ERROR ) ) {
				super.dispatchEvent( new ProcessEvent( ProcessEvent.ERROR, false, false, e ) );
			} else {
				throw e; 
			}
		}
		
	}

}