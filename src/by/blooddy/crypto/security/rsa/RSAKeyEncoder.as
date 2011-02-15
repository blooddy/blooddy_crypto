package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.Base64;
	import by.blooddy.crypto.security.utils.PEM;
	import by.blooddy.math.utils.BigUint;
	import by.blooddy.system.Memory;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					18.01.2011 16:22:29
	 */
	public class RSAKeyEncoder {

		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------

		use namespace internal_rsa;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @see				http://en.wikipedia.org/wiki/Privacy_Enhanced_Mail
		 */
		public static function encodePublicPEM(key:RSAPublicKey):String {
			return	'-----BEGIN ' + PEM.RSA_PUBLIC_KEY + '-----\r\n' +
					Base64.encode( encodePublicDER( key ) ) +
					'\r\n-----END ' + PEM.RSA_PUBLIC_KEY + '-----';
		}

		/**
		 * @see				http://en.wikipedia.org/wiki/Privacy_Enhanced_Mail
		 */
		public static function encodePrivatePEM(key:RSAPrivateKey):String {
			return	'-----BEGIN ' + PEM.RSA_PRIVATE_KEY + '-----\r\n' +
					Base64.encode( encodePrivateDER( key ) ) +
					'\r\n-----END ' + PEM.RSA_PRIVATE_KEY + '-----';
		}

		/**
		 * @see				http://en.wikipedia.org/wiki/Distinguished_Encoding_Rules
		 */
		public static function encodePublicDER(key:RSAPublicKey):ByteArray {
			var app:ApplicationDomain = ApplicationDomain.currentDomain;
			var tmp:ByteArray = app.domainMemory;
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( key.bytes );
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) {
				mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			}
			app.domainMemory = mem;

			app.domainMemory = tmp;
			var result:ByteArray = new ByteArray();
			return result;
		}

		/**
		 * @see				http://en.wikipedia.org/wiki/Distinguished_Encoding_Rules
		 */
		public static function encodePrivateDER(key:RSAPrivateKey):ByteArray {
			var app:ApplicationDomain = ApplicationDomain.currentDomain;
			var tmp:ByteArray = app.domainMemory;
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( key.bytes );
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) {
				mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			}
			app.domainMemory = mem;

			app.domainMemory = tmp;
			var result:ByteArray = new ByteArray();
			return result;
		}

		/**
		 * @see				http://www.w3.org/TR/xmldsig-core/#sec-RSAKeyValue
		 */
		public static function encodePublicXML(key:RSAPublicKey):XML {
			var app:ApplicationDomain = ApplicationDomain.currentDomain;
			var tmp:ByteArray = app.domainMemory;
			var mem:ByteArray;
			if ( key.bytes.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) {
				mem = new ByteArray();
				mem.writeBytes( key.bytes );
				mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			} else {
				mem = key.bytes;
			}
			app.domainMemory = mem;

			var result:XML = <RSAKeyValue xmlns="http://www.w3.org/2000/09/xmldsig#" />;
			result.Modulus =	encodeBigUintBase64( key.n );
			result.Exponent =	encodeUintBase64( key.e );

			app.domainMemory = tmp;
			return result;
		}

		/**
		 * @see				http://www.w3.org/TR/xkms2/#ElementRSAKeyPair
		 */
		public static function encodePrivateXML(key:RSAPrivateKey):XML {
			var app:ApplicationDomain = ApplicationDomain.currentDomain;
			var tmp:ByteArray = app.domainMemory;
			var mem:ByteArray;
			if ( key.bytes.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) {
				mem = new ByteArray();
				mem.writeBytes( key.bytes );
				mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			} else {
				mem = key.bytes;
			}
			app.domainMemory = mem;

			var result:XML = <RSAKeyPair xmlns="http://www.w3.org/2002/03/xkms#" />;
			result.Modulus =	encodeBigUintBase64( key.n );
			result.Exponent =	encodeUintBase64( key.e );
			result.P =			encodeBigUintBase64( key.p );
			result.Q =			encodeBigUintBase64( key.q );
			result.DP =			encodeBigUintBase64( key.dp );
			result.DQ =			encodeBigUintBase64( key.dq );
			result.InverseQ =	encodeBigUintBase64( key.invq );
			result.D =			encodeBigUintBase64( key.d );

			app.domainMemory = tmp;
			return result;
		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function encodeUintBase64(i:uint):String {
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.BIG_ENDIAN;
			bytes.writeUnsignedInt( i );
			return Base64.encode( bytes );
		}

		/**
		 * @private
		 */
		private static function encodeBigUintBase64(bi:BigUint):String {
			var bytes:ByteArray = new ByteArray();
			bytes.endian = Endian.BIG_ENDIAN;

			var p:uint = bi.pos;
			var i:uint = p + bi.len;
			while ( i > p ) {
				i -= 4;
				bytes.writeInt( Memory.getI32( i ) );
			}

			return Base64.encode( bytes );
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
		public function RSAKeyEncoder() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}