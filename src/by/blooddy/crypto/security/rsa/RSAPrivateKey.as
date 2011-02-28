////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.math.utils.BigUint;

	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					16.01.2011 22:05:04
	 */
	public class RSAPrivateKey extends RSAPublicKey implements IRSAPrivateKey {

		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------

		use namespace internal_rsa;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function RSAPrivateKey() {
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		internal_rsa var d:BigUint;

		/**
		 * @private
		 */
		internal_rsa var p:BigUint;

		/**
		 * @private
		 */
		internal_rsa var q:BigUint;

		/**
		 * @private
		 */
		internal_rsa var dp:BigUint;

		/**
		 * @private
		 */
		internal_rsa var dq:BigUint;

		/**
		 * @private
		 */
		internal_rsa var invq:BigUint;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function decrypt(bytes:ByteArray):ByteArray {
			return null;
		}

		public function getPublicKey():RSAPublicKey {
			internalCall = true;
			var result:RSAPublicKey = new RSAPublicKey();
			result.bytes = this.bytes;
			result.n = this.n;
			result.e = this.e;
			return result;
		}

		public override function toString():String {
			var result:String;
			if ( this.bytes ) {
				var app:ApplicationDomain = ApplicationDomain.currentDomain;
				var tmp:ByteArray = app.domainMemory;
				var mem:ByteArray;
				if ( this.bytes.length >= ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) {
					mem = this.bytes;
				} else {
					mem = new ByteArray();
					mem.writeBytes( this.bytes );
					mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
				}
				app.domainMemory = mem;
				result =	'[RSAPrivateKey' +
								' n="' +/* BigUint.toString( this.n ) +*/ '"' +
								' e="' + /*this.e.toString( 16 ) +*/ '"' +
								' d="' + /*BigUint.toString( this.d ) +*/ '"' +
								' P="' + /*BigUint.toString( this.p ) +*/ '"' +
								' Q="' + /*BigUint.toString( this.q ) +*/ '"' +
								' dP="' + /*BigUint.toString( this.dp ) +*/ '"' +
								' dQ="' + /*BigUint.toString( this.dq ) +*/ '"' +
								' iQ="' + /*BigUint.toString( this.invq ) +*/ '"' +
							']';
				app.domainMemory = tmp;
			} else {
				result =	'[RSAPrivateKey empty]';
			}
			return result;
		}

	}

}