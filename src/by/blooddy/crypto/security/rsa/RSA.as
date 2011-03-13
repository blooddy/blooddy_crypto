////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.math.utils.BigUint;
	
	import flash.utils.getQualifiedClassName;
	import by.blooddy.math.utils.BigUintStr;

	[ExcludeClass]
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

		public static function EP(key:RSAPublicKey, value:BigUint, pos:uint):BigUint {
			if ( BigUint.compare( value, key.n ) >= 0 ) throw new ArgumentError();
			return BigUint.modPow( value, key.e, key.n, pos );
		}

		public static function DP(key:RSAPrivateKey, value:BigUint, pos:uint):BigUint {
			if ( BigUint.compare( value, key.n ) >= 0 ) throw new ArgumentError();
			if ( key.p.len <= 0 && key.q.len <= 0 ) {

				return BigUint.modPow( value, key.d, key.n, pos );

			} else {

				var xp:BigUint = BigUint.modPow( value, key.dp, key.p, pos );
				pos = xp.pos + xp.len;
				var xq:BigUint = BigUint.modPow( value, key.dq, key.q, pos );
				pos = xp.pos + xp.len;

				while ( BigUint.compare( xp, xq ) < 0 ) {
					xp = BigUint.add( xp, key.p, pos );
					pos = xp.pos + xp.len;
				}
				
				xp = BigUint.sub( xp, xq, pos );
				pos = xp.pos + xp.len;
				xp = BigUint.mul( xp, key.invq, pos );
				pos = xp.pos + xp.len;
				xp = BigUint.mod( xp, key.p, pos );
				pos = xp.pos + xp.len;
				xp = BigUint.mul( xp, key.q, pos );
				pos = xp.pos + xp.len;
				return BigUint.add( xp, xq, pos );

			}
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