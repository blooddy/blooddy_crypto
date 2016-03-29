////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.events.EventDispatcher;
	import flash.utils.getQualifiedClassName;
	
	[Event( type="by.blooddy.crypto.worker.WorkerEvent", name="success" )]
	[Event( type="by.blooddy.crypto.worker.WorkerEvent", name="fault" )]
	
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
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const worker:Worker$ = ( function():Worker$ {
			var o:Object;
			try {
				o = Worker$Concurrent;
			} catch ( e:Error ) {
				o = Worker$Consistent;
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
		public function Worker() {
			if ( ( this as Object ).constructor != Worker ) {
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
			worker.process(
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
			super.dispatchEvent( new WorkerEvent( WorkerEvent.SUCCESS, false, false, result ) );
		}
		
		/**
		 * @private
		 */
		private function fail(e:*):void {
			super.dispatchEvent( new WorkerEvent( WorkerEvent.FAULT, false, false, e ) );
		}
		
	}

}