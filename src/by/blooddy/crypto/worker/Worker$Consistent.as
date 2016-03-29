////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	import flash.utils.setTimeout;

	[ExcludeClass]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					25.03.2016 17:07:01
	 */
	internal final class Worker$Consistent implements Worker$ {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		internal static const instance:Worker$Consistent = new Worker$Consistent();
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function Worker$Consistent() {
			if ( !instance ) {
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
		public function call(success:Function, fault:Function, className:String, methodName:String, args:Array):void {
			setTimeout( function():void {
				try {

					var target:Object = ApplicationDomain.currentDomain.getDefinition( className );
					success( target[ methodName ].apply( target, args ) );

				} catch ( e:Error ) {

					fault( e );

				}
			}, 0 );
		}
		
	}

}