////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.security.pad.IPad;
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

		use namespace $internal;

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
		$internal var d:BigUint;

		/**
		 * @private
		 */
		$internal var p:BigUint;

		/**
		 * @private
		 */
		$internal var q:BigUint;

		/**
		 * @private
		 */
		$internal var dp:BigUint;

		/**
		 * @private
		 */
		$internal var dq:BigUint;

		/**
		 * @private
		 */
		$internal var invq:BigUint;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function sign():ByteArray {
			return null;
		}
	
		/**
		 * @inheritDoc
		 */
		public function decrypt(bytes:ByteArray, pad:IPad=null):ByteArray {
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
				result =	'[RSAPrivateKey' +
								' n="' + bigUintToString( this.n ) + '"' +
								' e="' + bigUintToString( this.e ) + '"' +
								' d="' + bigUintToString( this.d ) + '"' +
								' P="' + bigUintToString( this.p ) + '"' +
								' Q="' + bigUintToString( this.q ) + '"' +
								' dP="' + bigUintToString( this.dp ) + '"' +
								' dQ="' + bigUintToString( this.dq ) + '"' +
								' iQ="' + bigUintToString( this.invq ) + '"' +
							']';
			} else {
				result =	'[RSAPrivateKey empty]';
			}
			return result;
		}

	}

}
