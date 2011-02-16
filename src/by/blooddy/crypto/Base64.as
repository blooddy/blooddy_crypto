////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {
	
	import by.blooddy.system.Memory;
	
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Encodes and decodes binary data using
	 * <a herf="http://www.faqs.org/rfcs/rfc4648.html">Base64</a> encoding algorithm.
	 *
	 * @author					BlooDHounD
	 * @version					3.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 */
	public final class Base64 {
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _domain:ApplicationDomain = ApplicationDomain.currentDomain;

		/**
		 * @private
		 */
		private static const _ENCODE_TABLE:ByteArray = new ByteArray();
		_ENCODE_TABLE.writeUTFBytes(
			'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
		);

		/**
		 * @private
		 */
		private static const _DECODE_TABLE:ByteArray = new ByteArray();
		_DECODE_TABLE.writeUTFBytes(
			'\x40\x40\x40\x40\x40\x40\x40\x40\x43\x43\x43\x43\x43\x43\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x43\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x3e\x40\x40\x40\x3f\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x40\x40\x40\x41\x40\x40\x40\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x40\x40\x40\x40\x40\x40\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x40\x40\x40\x40\x40' +
			'\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40\x40'
		);
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Encodes the <code>bytes</code> while conditionally inserting line breaks.
		 *
		 * @param	bytes			The data to be encoded.
		 *
		 * @param	insertNewLines	If <code>true</code> passed, the resulting
		 * 							string will contain line breaks.
		 *
		 * @return					The data encoded.
		 */
		public static function encode(bytes:ByteArray, insertNewLines:Boolean=false):String {
			throw new IllegalOperationError( 'TODO: plz, implement this!' );
		}

		/**
		 * Decodes the <code>source</code> string previously encoded using Base64
		 * algorithm.
		 *
		 * @param	str				The string containing encoded data.
		 *
		 * @return					The array of bytes obtained by decoding the <code>source</code>
		 * 							string.
		 *
		 * @throws	VerifyError		string is not valid
		 */
		public static function decode(str:String):ByteArray {
			
			var len:uint = str.length * 0.75;
			var tmp:ByteArray = _domain.domainMemory;
			
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( _DECODE_TABLE );
			mem.writeUTFBytes( str );
			var bytesLength:uint = mem.length;
			mem.writeUTFBytes( '====' ); // записываю pad на всякий случай
			// помещаем в пямять
			if ( bytesLength < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_domain.domainMemory = mem;

			var i:uint = 255;
			var j:uint = 255;
			
			var a:uint;
			var b:uint;
			var c:uint;
			var d:uint;
			
			try {

				do {

					a = Memory.getUI8( Memory.getUI8( ++i ) );
					if ( a >= 0x40 ) {
						while ( a == 0x43 ) { // пропускаем пробелы
							a = Memory.getUI8( Memory.getUI8( ++i ) );
						}
						if ( a == 0x41 ) { // наткнулись на pad
							b = c = d = 0x41;
							break;
						} else if ( a > 40 ) { // не валидный символ
							Error.throwError( VerifyError, 1509 );
						}
					}

					b = Memory.getUI8( Memory.getUI8( ++i ) );
					if ( b >= 0x40 ) {
						while ( a == 0x43 ) { // пропускаем пробелы
							b = Memory.getUI8( Memory.getUI8( ++i ) );
						}
						if ( b == 0x41 ) { // наткнулись на pad
							c = d = 0x41;
							break;
						} else if ( b > 40 ) { // не валидный символ
							Error.throwError( VerifyError, 1509 );
						}
					}

					c = Memory.getUI8( Memory.getUI8( ++i ) );
					if ( c >= 0x40 ) {
						while ( c == 0x43 ) { // пропускаем пробелы
							c = Memory.getUI8( Memory.getUI8( ++i ) );
						}
						if ( c == 0x41 ) { // наткнулись на pad
							d = 0x41;
							break;
						} else if ( c > 40 ) { // не валидный символ
							Error.throwError( VerifyError, 1509 );
						}
					}

					d = Memory.getUI8( Memory.getUI8( ++i ) );
					if ( d >= 0x40 ) {
						while ( d == 0x43 ) { // пропускаем пробелы
							d = Memory.getUI8( Memory.getUI8( ++i ) );
						}
						if ( d == 0x41 ) { // наткнулись на pad
							break;
						} else if ( d > 40 ) { // не валидный символ
							Error.throwError( VerifyError, 1509 );
						}
					}

					Memory.setI8( ++j, ( a << 2 ) | ( b >> 4 ) );
					Memory.setI8( ++j, ( b << 4 ) | ( c >> 2 ) );
					Memory.setI8( ++j, ( c << 6 ) |   d        );

				} while ( true );

				while ( i < bytesLength ) {
					if ( !( Memory.getUI8( Memory.getUI8( ++i ) & 0x41 ) ) ) { // что-то помимо
						Error.throwError( VerifyError, 1509 );
					}
				}

				if ( a != 0x41 && b != 0x41 ) {
					Memory.setI8( ++j, ( a << 2 ) | ( b >> 4 ) );
					if ( c != 0x41 ) {
						Memory.setI8( ++j, ( b << 4 ) | ( c >> 2 ) );
						if ( d != 0x41 ) {
							Memory.setI8( ++j, ( c << 6 ) | d );
						}
					}
				}

			} finally {
				_domain.domainMemory = tmp;
			}
			
			var bytes:ByteArray = new ByteArray();
			if ( j > 255 ) {
				mem.position = 256;
				mem.readBytes( bytes, 0, j - 255 );
			}

			return bytes;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function Base64() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}
	
}