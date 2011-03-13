////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.Base64;
	import by.blooddy.crypto.security.utils.ASN1Key;
	import by.blooddy.crypto.security.utils.DER;
	import by.blooddy.crypto.security.utils.PEM;
	import by.blooddy.crypto.security.utils.XMLKey;
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
	 * @created					18.01.2011 3:58:32
	 */
	public final class RSAKeyDecoder {

		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------

		use namespace $internal;

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _domain:ApplicationDomain = ApplicationDomain.currentDomain;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @see				http://en.wikipedia.org/wiki/Privacy_Enhanced_Mail
		 */
		public static function decodePEM(str:String):RSAKeyPair {
			var pem:PEM = PEM.decode( str );
			return _decodeDER( pem.content, pem.type );
		}

		/**
		 * @see				http://en.wikipedia.org/wiki/Distinguished_Encoding_Rules
		 */
		public static function decodeDER(bytes:ByteArray):RSAKeyPair {
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( bytes );
			return _decodeDER( mem, null );
		}

		/**
		 * @see				http://www.w3.org/TR/xmldsig-core/#sec-RSAKeyValue
		 * @see				http://www.w3.org/TR/xkms2/#ElementRSAKeyPair
		 */
		public static function decodeXML(xml:XML):RSAKeyPair {
			var keyPair:RSAKeyPair;
			var mem:ByteArray = _domain.domainMemory;
			var tmp:ByteArray = new ByteArray();
			tmp.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_domain.domainMemory = tmp;
			try {

				var i:uint;
				var list:XMLList;
				var ns:Namespace;
				var bytes:ByteArray;
				var args:Array;
				var bi:BigUint;
				var p:uint;

				for each ( var k:XMLKey in XMLKey.decode( xml ) ) {

					p = 0;
					xml = k.xml;
					ns = xml.namespace();

					if ( k.type == PEM.RSA_PUBLIC_KEY || k.type == PEM.RSA_PRIVATE_KEY ) {

						// агрументы для созания ключа
						args = new Array();

						// данные big int по ключу
						args.push( tmp );

						// заполняем массив
						list = xml.ns::*;

						bi = decodeXMLInteger( list[ 0 ], p );
						args.push( bi ); // m
						p += bi.len;

						bi = decodeXMLInteger( list[ 1 ], p );
						args.push( bi ); // e
						p += bi.len;

						if ( k.type == PEM.RSA_PUBLIC_KEY ) {

							_domain.domainMemory = null; // надо длинну менять, и надо память сбрасывать
							tmp.length = p;

							// создаём ключ
							keyPair = new RSAKeyPair(
								createPublicKey.apply( null, args ),
								null
							)

						} else {

							bi = decodeXMLInteger( list[ 7 ], p );
							args.push( bi ); // d
							p += bi.len;

							for ( i=2; i<7; i++ ) {
								bi = decodeXMLInteger( list[ i ], p )
								args.push( bi ); // p, q, dp, dq, invq
								p += bi.len;
							}

							_domain.domainMemory = null; // надо длинну менять, и надо память сбрасывать
							tmp.length = p;

							// создаём ключ
							keyPair = new RSAKeyPair(
								null,
								createPrivateKey.apply( null, args )
							);

						}

						break;

					} else if ( k.type == PEM.CERTIFICATE ) {

						try {

							keyPair = _decodeDER(
								Base64.decode(
									xml.*.toString()
								),
								PEM.CERTIFICATE
							);
							break;

						} catch ( e:* ) {
							// skip
						}

					}

				}

				if ( !keyPair ) throw null;

			} catch ( e:* ) {
				Error.throwError( SyntaxError, 0 );
			} finally {
				_domain.domainMemory = mem;
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
		private static function createPublicKey(bytes:ByteArray, n:BigUint, e:BigUint):RSAPublicKey {
			RSAPublicKey.internalCall = true;
			var result:RSAPublicKey = new RSAPublicKey();
			result.bytes = bytes;
			result.n = n;
			result.e = e;
			return result;
		}

		/**
		 * @private
		 */
		private static function createPrivateKey(bytes:ByteArray, n:BigUint, e:BigUint, d:BigUint, p:BigUint, q:BigUint, dp:BigUint, dq:BigUint, invq:BigUint):RSAPublicKey {
			RSAPublicKey.internalCall = true;
			var result:RSAPrivateKey = new RSAPrivateKey();
			result.bytes = bytes;
			result.n = n;
			result.e = e;
			result.d = d;
			result.p = p;
			result.q = q;
			result.dp = dp;
			result.dq = dq;
			result.invq = invq;
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
		private static function _decodeDER(mem:ByteArray, type:String):RSAKeyPair {
			var keyPair:RSAKeyPair;

			var tmp:ByteArray = _domain.domainMemory;

			var len:uint = mem.length;
			mem.length <<= 1;
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_domain.domainMemory = mem;

			try {

				var k:ASN1Key = ASN1Key.readMemory( 0, len, type );
				var t:DER = k.der;
				type = k.type;

				var bi:BigUint;

				var p:uint = len;
				var args:Array;
				var bytes:ByteArray;

				if ( type == PEM.RSA_PUBLIC_KEY ) {

					// агрументы для созания ключа
					args = new Array();
					
					bi = decodeDERInteger( t.seq[ 0 ], p );
					bi.pos -= len;
					args.push( bi ); // m
					p += bi.len;

					bi = decodeDERInteger( t.seq[ 1 ], p );
					bi.pos -= len;
					args.push( bi ); // e
					p += bi.len;
					
					// данные big int по ключу
					bytes = new ByteArray();
					mem.position = len;
					mem.readBytes( bytes, 0, p - len );
					args.unshift( bytes );

					keyPair = new RSAKeyPair(
						createPublicKey.apply( null, args ),
						null
					)

				} else if ( type == PEM.RSA_PRIVATE_KEY ) {

					// агрументы для созания ключа
					args = new Array();

					bi = decodeDERInteger( t.seq[ 1 ], p );
					bi.pos -= len;
					args.push( bi ); // m
					p += bi.len;

					bi = decodeDERInteger( t.seq[ 2 ], p );
					bi.pos -= len;
					args.push( bi ); // e
					p += bi.len;
					
					for ( var i:uint = 3; i<9; ++i ) {
						bi = decodeDERInteger( t.seq[ i ], p );
						bi.pos -= len;
						args.push( bi ); // m
						p += bi.len;
					}

					// данные big int по ключу
					bytes = new ByteArray();
					mem.position = len;
					mem.readBytes( bytes, 0, p - len );
					args.unshift( bytes );

					keyPair = new RSAKeyPair(
						null,
						createPrivateKey.apply( null, args )
					)

				} else {
					throw null;
				}

			} catch ( e:* ) {
				Error.throwError( SyntaxError, 0 );
			} finally {
				_domain.domainMemory = tmp;
			}

			return keyPair;
		}

		/**
		 * @private
		 */
		private static function decodeDERInteger(t:DER, pos:uint):BigUint {
			return decodeBigInteger( t.block.pos, t.block.len, pos );
		}

		/**
		 * @private
		 */
		private static function decodeXMLInteger(x:XML, pos:uint):BigUint {
			var mem:ByteArray = _domain.domainMemory;
			var b:ByteArray = Base64.decode( x.*.toString() );
			var p:uint = pos + b.length + 4;
			var l:uint = b.length;
			b.readBytes( mem, p, l );
			return decodeBigInteger( p, l, pos );
		}

		/**
		 * @private
		 */
		private static function decodeBigInteger(p:uint, l:uint, pos:uint):BigUint {
			var j:uint = p + l;
			var i:uint = pos;
			while ( j != p ) {
				Memory.setI8( i++, Memory.getUI8( --j ) );
			}
			j = l & 3;
			if ( j ) {
				Memory.setI32( i, 0 );
				i += ( 4 - j );
			}
			i -= pos;
			while ( i > 0 && Memory.getI32( pos + i - 4 ) == 0 ) {
				i -= 4;
			}
			return new BigUint( pos, i );
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
		public function RSAKeyDecoder() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}