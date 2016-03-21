////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					2.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					21.03.2016 16:47:48
	 */
	internal class SHA2 {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		protected static function $hashBytes(bytes:ByteArray, h0:int, h1:int, h2:int, h3:int, h4:int, h5:int, h6:int, h7:int):String {
			throw new IllegalOperationError();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function SHA2() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}