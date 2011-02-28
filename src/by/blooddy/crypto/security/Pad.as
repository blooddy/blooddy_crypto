////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security {

	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					28.02.2011 3:12:57
	 */
	public class Pad {
		
		//--------------------------------------------------------------------------
		//
		//  Namesapces
		//
		//--------------------------------------------------------------------------

		use namespace $private;

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		$private static var _privateCall:Boolean = false;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function Pad() {
			super();
			if ( !_privateCall ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			_privateCall = false;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Add padding to the array
		 */
		public function pad(bytes:ByteArray, size:uint):void {
			Error.throwError( IllegalOperationError, 1001, 'pad' );
		}

		/**
		 * Remove padding from the array.
		 */
		public function unpad(bytes:ByteArray, size:uint):void {
			Error.throwError( IllegalOperationError, 1001, 'unpad' );
		}

	}
	
}

//==============================================================================
//
//  Inner definitions
//
//==============================================================================

internal namespace $private;