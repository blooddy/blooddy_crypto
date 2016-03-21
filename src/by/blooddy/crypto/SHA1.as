///////////////////////////////////////////////////////////////////////////////
//
//  (C) 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import avm2.intrinsics.memory.li32;
	import avm2.intrinsics.memory.li8;
	import avm2.intrinsics.memory.si32;
	import avm2.intrinsics.memory.si8;

	/**
	 * Encodes and decodes binary data using 
	 * <a herf="http://www.faqs.org/rfcs/rfc3174.html">SHA-1 (Secure Hash Algorithm)</a> algorithm.
	 * 
	 * @author					BlooDHounD
	 * @version					3.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					07.03.2011 14:48:31
	 */
	public final class SHA1 {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Performs SHA-1 hash algorithm on a String.
		 *
		 * @param	str		The string to hash.
		 *
		 * @return			A string containing the hash value of <code>source</code>.
		 *
		 * @keyword			sha1.hash, hash
		 */
		public static function hash(str:String):String {
			
			if ( !str ) str = '';
			
			var bytes:ByteArray = new ByteArray( );
			bytes.writeUTFBytes( str );
			
			return hashBytes( bytes );
			
		}
		
		/**
		 * Performs SHA-1 hash algorithm on a <code>ByteArray</code>.
		 *
		 * @param	data	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A string containing the hash value of data.
		 *
		 * @keyword			sha1.hashBytes, hashBytes
		 */
		public static function hashBytes(bytes:ByteArray):String {

			if ( !bytes ) bytes = new ByteArray();
			
			var tmp:ByteArray = _DOMAIN.domainMemory;
			
			var i:int = bytes.length << 3;
			var bytesLength:int = 80 * 4 + ( ( ( ( ( i+ 64 ) >>> 9 ) << 4 ) + 15 ) << 2 );
			
			var mem:ByteArray = new ByteArray();
			mem.length = bytesLength + 4
			mem.position = 80 * 4;
			mem.writeBytes( bytes );
				
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			
			_DOMAIN.domainMemory = mem;
			
//			Memory.setI32( 80 * 4 + ( ( i >>> 5 ) << 2 ), Memory.getI32( 80 * 4 + ( ( i >>> 5 ) << 2 ) ) | ( 0x80 << ( i % 32 ) ) );
			si32( li32( 80 * 4 + ( ( i >>> 5 ) << 2 ) ) | ( 0x80 << ( i % 32 ) ), 80 * 4 + ( ( i >>> 5 ) << 2 ) );
//			Memory.setBI32( bytesLength, i );
			si8( i >> 24, bytesLength     );
			si8( i >> 16, bytesLength + 1 );
			si8( i >>  8, bytesLength + 2 );
			si8( i      , bytesLength + 3 );

			var h0:int = 1732584193;//0x67452301;
			var h1:int = -271733879;//0xEFCDAB89;
			var h2:int = -1732584194;//0x98BADCFE;
			var h3:int = 271733878;//0x10325476;
			var h4:int = -1009589776;//0xC3D2E1F0;

			var a:int = 0;
			var b:int = 0;
			var c:int = 0;
			var d:int = 0;
			var e:int = 0;
			var w:int = 0;
			
			var t:int = 0;
			
			i = 80 * 4;
			do {
				
				a = h0;
				b = h1;
				c = h2;
				d = h3;
				e = h4;
				
				t = 0;
				
//				phase( a, b, c, d, e, i, t, 16 );
				do {
					
					w =	( li8( i + t     ) << 24 ) |
						( li8( i + t + 1 ) << 16 ) |
						( li8( i + t + 2 ) <<  8 ) |
						  li8( i + t + 3 )         ;

					si32( w, t );

					w += 0x5A827999 + e + ( ( a << 5 ) | ( a >>> 27 ) ) + ( ( b & c ) | ( ~b & d ) );
					
					e = d;
					d = c;
					c = ( b << 30 ) | ( b >>> 2 );
					b = a;
					a = w;
					
					t += 4;
					
				} while ( t < 16 * 4 );

//				phase( a, b, c, d, e, i, t, 20 );
				do {
					
					w = li32( t -  3 * 4 ) ^
						li32( t -  8 * 4 ) ^
						li32( t - 14 * 4 ) ^
						li32( t - 16 * 4 ) ;

					w = ( w << 1 ) | ( w >>> ( 32 - 1 ) );
					
					si32( w, t );
					
					w += 0x5A827999 + e + ( ( a << 5 ) | ( a >>> 27 ) ) + ( ( b & c ) | ( ~b & d ) );
					
					e = d;
					d = c;
					c = ( b << 30 ) | ( b >>> 2 );
					b = a;
					a = w;
					
					t += 4;
					
				} while ( t < 20 * 4 );
				
				
				
//				phase( a, b, c, d, e, i, t, 40 );
				do {
					
					w = li32( t -  3 * 4 ) ^
						li32( t -  8 * 4 ) ^
						li32( t - 14 * 4 ) ^
						li32( t - 16 * 4 ) ;

					w = ( w << 1 ) | ( w >>> ( 32 - 1 ) );

					si32( w, t );
					
					w += 0x6ED9EBA1 + e + ( ( a << 5 ) | ( a >>> 27 ) ) + ( b ^ c ^ d );
					
					e = d;
					d = c;
					c = ( b << 30 ) | ( b >>> 2 );
					b = a;
					a = w;
					
					t += 4;
					
				} while ( t < 40 * 4 );
				
//				phase( a, b, c, d, e, i, t, 60 );
				do {
					
					w = li32( t -  3 * 4 ) ^
						li32( t -  8 * 4 ) ^
						li32( t - 14 * 4 ) ^
						li32( t - 16 * 4 ) ;

					w = ( w << 1 ) | ( w >>> ( 32 - 1 ) );

					si32( w, t );
					
					w += 0x8F1BBCDC + e + ( ( a << 5 ) | ( a >>> 27 ) ) + ( ( b & c ) | ( b & d ) | ( c & d ) );
					
					e = d;
					d = c;
					c = ( b << 30 ) | ( b >>> 2 );
					b = a;
					a = w;
					
					t += 4;
					
				} while ( t < 60 * 4 );
				
//				phase( a, b, c, d, e, i, t, 80 );
				do {
					
					w = li32( t -  3 * 4 ) ^
						li32( t -  8 * 4 ) ^
						li32( t - 14 * 4 ) ^
						li32( t - 16 * 4 ) ;

					w = ( w << 1 ) | ( w >>> ( 32 - 1 ) );

					si32( w, t );
					
					w += 0xCA62C1D6 + e + ( ( a << 5 ) | ( a >>> 27 ) ) + ( b ^ c ^ d );
					
					e = d;
					d = c;
					c = ( b << 30 ) | ( b >>> 2 );
					b = a;
					a = w;
					
					t += 4;
					
				} while ( t < 80 * 4 );
				
				h0 += a;
				h1 += b;
				h2 += c;
				h3 += d;
				h4 += e;
				
				i += 16 * 4;
				
			} while ( i < bytesLength );
			
			mem.position = 0;
			mem.writeUTFBytes( '0123456789abcdef' );
			
			si8( h0 >> 24, 16 );
			si8( h0 >> 16, 17 );
			si8( h0 >>  8, 18 );
			si8( h0      , 19 );

			si8( h1 >> 24, 20 );
			si8( h1 >> 16, 21 );
			si8( h1 >>  8, 22 );
			si8( h1      , 23 );
			
			si8( h2 >> 24, 24 );
			si8( h2 >> 16, 25 );
			si8( h2 >>  8, 26 );
			si8( h2      , 27 );
			
			si8( h3 >> 24, 28 );
			si8( h3 >> 16, 29 );
			si8( h3 >>  8, 30 );
			si8( h3      , 31 );
			
			si8( h4 >> 24, 32 );
			si8( h4 >> 16, 33 );
			si8( h4 >>  8, 34 );
			si8( h4      , 35 );
			
			b = 36 - 1;
			i = 16;
			do {
				a = li8( i );
				si8( li8( a >>> 4 ), ++b );
				si8( li8( a & 0xF ), ++b );
			} while ( ++i < 16 + 5 * 4 );
			
			_DOMAIN.domainMemory = tmp;

			mem.position = 36;
			return mem.readUTFBytes( 5 *8 );

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
		public function SHA1() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}