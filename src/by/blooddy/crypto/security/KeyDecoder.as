////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security {
	
	import by.blooddy.crypto.Base64;
	import by.blooddy.crypto.security.rsa.RSAKeyDecoder;
	import by.blooddy.crypto.security.rsa.RSAKeyPair;
	import by.blooddy.crypto.security.utils.ASN1Key;
	import by.blooddy.crypto.security.utils.PEM;
	import by.blooddy.crypto.security.utils.XMLKey;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					07.02.2011 15:02:58
	 */
	public class KeyDecoder {
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _CURRENT_DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @see				http://en.wikipedia.org/wiki/Privacy_Enhanced_Mail
		 */
		public static function decodePEM(str:String):KeyPair {
			var pem:PEM = PEM.decode( str );
			return _decodeDER( pem.content, pem.type );
		}

		/**
		 * @see				http://en.wikipedia.org/wiki/Distinguished_Encoding_Rules
		 */
		public static function decodeDER(bytes:ByteArray):KeyPair {
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( bytes );
			return _decodeDER( mem, null );
		}

		/**
		 * @see				http://www.w3.org/TR/xmldsig-core/#sec-RSAKeyValue
		 * @see				http://www.w3.org/TR/xkms2/#ElementRSAKeyPair
		 */
		public static function decodeXML(xml:XML):KeyPair {
			var keyPair:KeyPair;
			
			try {

				var bytes:ByteArray;
				var rsaKeyPair:RSAKeyPair;
				
				for each ( var k:XMLKey in XMLKey.decode( xml ) ) {

					try {
						switch ( k.type ) {

							case PEM.RSA_PUBLIC_KEY:
							case PEM.RSA_PRIVATE_KEY:
								rsaKeyPair = RSAKeyDecoder.decodeXML( k.xml );
								keyPair = new KeyPair( rsaKeyPair.publicKey, rsaKeyPair.privateKey );
								break;

							case PEM.CERTIFICATE:
								keyPair = _decodeDER(
									Base64.decode(
										k.xml.*.toString()
									),
									PEM.CERTIFICATE
								);
								break;

							default:
								throw null;

						}
					} catch ( e:* ) {
						// skip
					}

					if ( keyPair ) break;

				}
				
				if ( !keyPair ) throw null;
				
			} catch ( e:* ) {
				Error.throwError( SyntaxError, 0 );
			}
			
			return keyPair;
		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static function _decodeDER(mem:ByteArray, type:String):KeyPair {
			var keyPair:KeyPair;

			var tmp:ByteArray = _CURRENT_DOMAIN.domainMemory;

			var len:uint = mem.length;
			mem.length <<= 1;
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_CURRENT_DOMAIN.domainMemory = mem;

			try {
				
				var k:ASN1Key = ASN1Key.readMemory( 0, len, type );
				var bytes:ByteArray;

				switch ( k.type ) {

					case PEM.RSA_PUBLIC_KEY:
					case PEM.RSA_PRIVATE_KEY:
						bytes = new ByteArray();
						mem.position = k.der.pos;
						mem.readBytes( bytes, 0, k.der.len );
						var rsaKeyPair:RSAKeyPair = RSAKeyDecoder.decodeDER( bytes );
						keyPair = new KeyPair( rsaKeyPair.publicKey, rsaKeyPair.privateKey );
						break;

					// TODO: DSA

					default:
						throw null;

				}

			} catch ( e:* ) {
				Error.throwError( SyntaxError, 0 );
			} finally {
				_CURRENT_DOMAIN.domainMemory = tmp;
			}

			return keyPair;
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
		public function KeyDecoder() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}
	
}