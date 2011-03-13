////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.math.utils.BigUint;
	import by.blooddy.system.Memory;
	
	import flash.utils.getQualifiedClassName;

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

		public static function toBigUint(p:uint, l:uint, pos:uint):BigUint {
			reverse( p, l, pos );
			while ( l & 3 ) {
				Memory.setI8( pos + l, 0 );
				++l;
			}
			while ( l > 0 && Memory.getI32( pos + l - 4 ) == 0 ) {
				l -= 4;
			}
			return new BigUint( pos, l );
		}

		public static function fromBigUint(v:BigUint, pos:uint):void {
			while ( v.len > 0 && Memory.getUI8( v.pos + v.len - 1 ) == 0 ) {
				--v.len;
			}
			reverse( v.pos, v.len, pos );
		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function reverse(p:uint, l:uint, pos:uint):void {
			var j:uint = 0;
			do {
				Memory.setI8( pos + j, Memory.getUI8( p + l - j - 1 ) );
			} while ( ++j < l );
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