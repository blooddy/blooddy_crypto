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
	import flash.utils.getQualifiedClassName;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					16.01.2011 22:03:30
	 */
	public class RSAPublicKey implements IRSAPublicKey {

		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------

		use namespace internal_rsa;

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		internal_rsa static var internalCall:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function RSAPublicKey() {
			super();
			if ( !internalCall ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			internalCall = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		internal_rsa var bytes:ByteArray;

		/**
		 * @private
		 */
		internal_rsa var n:BigUint;

		/**
		 * @private
		 */
		internal_rsa var e:uint;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inhertDoc
		 */
		public function verify(message:ByteArray, pad:IPad=null):ByteArray {
			return null;
		}
		
		/**
		 * @inhertDoc
		 */
		public function encrypt(bytes:ByteArray, pad:IPad=null):ByteArray {
			return null;
		}

		public function toString():String {
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
				result =
					'[RSAPublicKey' +
						' n="' + BigUint.toString( this.n ) + '"' +
						' e="' + this.e.toString( 16 ) + '"' +
					']';
				app.domainMemory = tmp;
			} else {
				result = '[RSAPublicKey empty]';
			}
			return result;
		}

	}

}