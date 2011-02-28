////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {
	
	import by.blooddy.system.Memory;
	
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

		/**
		 * @private
		 */
		private static const _PATTERN:RegExp = /^[A-Za-z\d\+\/\s\v\b]*[=\s\v\b]*$/;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function isValid(str:String):Boolean {
			return _PATTERN.test( str );
		}

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
		public static function encode(bytes:ByteArray!, newLines:uint=0):String {

			if ( bytes == null ) Error.throwError( TypeError, 2007, 'bytes' );
			if ( newLines & 3 )	throw new RangeError();

			if ( bytes.length == 0 ) return '';

			var insertNewLines:Boolean = newLines != 0;
			var len:uint = Math.ceil( bytes.length / 3 ) << 2;
			if ( insertNewLines ) {
				len += ( int( len / newLines + 0.5 ) - 1 ) << 1; // переносы занимают дополнительные байтики
				newLines *= 0.75; // переносы будем отсчитывать по исходнику. поэтому отсчитывать надо по 3 байта
			}

			var i:uint = 63 + len - bytes.length + 2; // сюда запишем данные для кодирования
			if ( insertNewLines ) {
				// что бы не производить допрасчёты, сдвинем для кратности стартовую позицию.
				i += newLines - i % newLines;
			}

			var tmp:ByteArray = _domain.domainMemory;
			
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( _ENCODE_TABLE );
			mem.position = i + 1;
			mem.writeBytes( bytes );
			var rest:uint = bytes.length % 3;
			var bytesLength:uint = mem.length - rest - 1;
			// помещаем в пямять
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_domain.domainMemory = mem;


			var j:uint = 63;	// сюда запишем результат
			var c:uint;

			do {
				
				c =	Memory.getUI8( ++i ) << 16 |
					Memory.getUI8( ++i ) << 8  |
					Memory.getUI8( ++i )       ;

				// TODO: speed test: setI8 x4 vs setI32
				Memory.setI8( ++j, Memory.getUI8(   c >>> 18          ) );
				Memory.setI8( ++j, Memory.getUI8( ( c >>> 12 ) & 0x3F ) );
				Memory.setI8( ++j, Memory.getUI8( ( c >>> 6  ) & 0x3F ) );
				Memory.setI8( ++j, Memory.getUI8(   c          & 0x3F ) );

				if ( insertNewLines && i % newLines == 0 ) {
					Memory.setI16( ++j, 0x0A0D );
					++j;
				}

			} while ( i < bytesLength );

			if ( rest ) {
				if ( rest == 1 ) {
					c = Memory.getUI8( ++i );
					Memory.setI8( ++j, Memory.getUI8(   c >>> 2       ) );
					Memory.setI8( ++j, Memory.getUI8( ( c & 3 ) <<  4 ) );
					Memory.setI8( ++j, 61 )
					Memory.setI8( ++j, 61 )
				} else {
					c =	( Memory.getUI8( ++i ) << 8 )	|
						  Memory.getUI8( ++i )			;
					Memory.setI8( ++j, Memory.getUI8(   c >>> 10          ) );
					Memory.setI8( ++j, Memory.getUI8( ( c >>>  4 ) & 0x3F ) );
					Memory.setI8( ++j, Memory.getUI8( ( c & 15 ) << 2     ) );
					Memory.setI8( ++j, 61 )
				}
			}

			_domain.domainMemory = tmp;

			mem.position = 64;
			return mem.readUTFBytes( len );

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
		public static function decode(str:String!):ByteArray {

			if ( str == null ) Error.throwError( TypeError, 2007, 'str' );

			if ( !str )	return new ByteArray();

			var tmp:ByteArray = _domain.domainMemory;

			var mem:ByteArray = new ByteArray();
			mem.writeBytes( _DECODE_TABLE );
			mem.writeUTFBytes( str );
			var bytesLength:uint = mem.length;
			mem.writeUTFBytes( '=' ); // записываю pad на всякий случай
			// помещаем в пямять
			if ( bytesLength < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_domain.domainMemory = mem;

			var i:uint = 255;
			var j:uint = 255;

			var a:uint;
			var b:uint;
			var c:uint;
			var d:uint;

			do {

				a = Memory.getUI8( Memory.getUI8( ++i ) );
				if ( a >= 0x40 ) {
					while ( a == 0x43 ) { // пропускаем пробелы
						a = Memory.getUI8( Memory.getUI8( ++i ) );
					}
					if ( a == 0x41 ) { // наткнулись на pad
						b = c = d = 0x41;
						break;
					} else if ( a == 0x40 ) { // не валидный символ
						_domain.domainMemory = tmp;
						Error.throwError( VerifyError, 1509 );
					}
				}

				b = Memory.getUI8( Memory.getUI8( ++i ) );
				if ( b >= 0x40 ) {
					while ( b == 0x43 ) { // пропускаем пробелы
						b = Memory.getUI8( Memory.getUI8( ++i ) );
					}
					if ( b == 0x41 ) { // наткнулись на pad
						c = d = 0x41;
						break;
					} else if ( b == 0x40 ) { // не валидный символ
						_domain.domainMemory = tmp;
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
					} else if ( c == 0x40 ) { // не валидный символ
						_domain.domainMemory = tmp;
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
					} else if ( d == 0x40 ) { // не валидный символ
						_domain.domainMemory = tmp;
						Error.throwError( VerifyError, 1509 );
					}
				}

				Memory.setI8( ++j, ( a << 2 ) | ( b >> 4 ) );
				Memory.setI8( ++j, ( b << 4 ) | ( c >> 2 ) );
				Memory.setI8( ++j, ( c << 6 ) |   d        );

			} while ( true );

			while ( i < bytesLength ) {
				if ( !( Memory.getUI8( Memory.getUI8( ++i ) & 0x41 ) ) ) { // что-то помимо
					_domain.domainMemory = tmp;
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

			_domain.domainMemory = tmp;
			
			var result:ByteArray = new ByteArray();
			if ( j > 255 ) {
				mem.position = 256;
				mem.readBytes( result, 0, j - 255 );
			}

			return result;
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