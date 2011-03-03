////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.math.utils.BigUint;
	
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					02.03.2011 23:22:03
	 */
	internal final class RSA {

		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------

		use namespace $internal;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function RSAEP(key:RSAPublicKey, value:BigUint, pos:uint):BigUint {
			if ( BigUint.compare( value, key.n ) >= 0 ) throw new ArgumentError();
			return BigUint.modPowInt( value, key.e, key.n, pos );
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function RSA() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}