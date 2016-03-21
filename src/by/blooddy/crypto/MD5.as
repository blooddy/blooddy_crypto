////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
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
	 * <a herf="http://www.faqs.org/rfcs/rfc1321.html">MD5 (Message Digest)</a> algorithm.
	 * 
	 * @author					BlooDHounD
	 * @version					3.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					07.03.2011 14:48:31
	 */
	public final class MD5 {

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
		 * Performs MD5 hash algorithm on a String.
		 *
		 * @param	str		The string to hash.
		 *
		 * @return			A string containing the hash value of <code>source</code>.
		 *
		 * @keyword			md5.hash, hash
		 */
		public static function hash(str:String):String {

			if ( !str ) str = '';
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );

			return hashBytes( bytes );

		}

		/**
		 * Performs MD5 hash algorithm on a <code>ByteArray</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A string containing the hash value of data.
		 *
		 * @keyword			md5.hashBytes, hashBytes
		 */
		public static function hashBytes(bytes:ByteArray):String {

			var mem:ByteArray = digest( bytes );
			
			var tmp:ByteArray = _DOMAIN.domainMemory;
			
			var k:int;
			var i:int = 0;
			var j:int = 31;
			
			mem.position = 16;
			mem.writeUTFBytes( '0123456789abcdef' );
			
			mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			
			_DOMAIN.domainMemory = mem;
			
			do {
				
//				k = Memory.getUI8( i );
				k = li8( i );
//				Memory.setI8( ++j, Memory.getUI8( t + ( k >>> 4 ) ) );
				si8( li8( 16 + ( k >>> 4 ) ), ++j );
//				Memory.setI8( ++j, Memory.getUI8( t + ( k & 0xF ) ) );
				si8( li8( 16 + ( k & 0xF ) ), ++j );
				
			} while ( ++i < 16 );
			
			_DOMAIN.domainMemory = tmp;
			
			mem.position = 32;
			return mem.readUTFBytes( 32 );

		}

		
		/**
		 * Performs MD5 hash algorithm on a <code>ByteArray</code>.
		 * 
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 * 
		 * @return			A <code>ByteArray</code> containing the hash value of data.
		 * 
		 * @keyword			md5.digest, digest
		 */
		public static function digest(bytes:ByteArray):ByteArray {

			if ( !bytes ) bytes = new ByteArray();
			
			var tmp:ByteArray = _DOMAIN.domainMemory;
			
			var pos:uint = bytes.position;
			var len:uint = bytes.length;
			
			// бинарники могут быть очень большими, и его копирование может быть
			// слишким дорогим. поэтому копируем только паизменяемую часть
			var padPos:uint = Math.max( 0, bytes.length - 64 );
			var pad:ByteArray = new ByteArray();
			bytes.position = padPos;
			bytes.length += 64;
			bytes.readBytes( pad, 0, bytes.length - padPos );
			bytes.length -= 64;
			
			var k:int = len & 63;
			
			bytes.length = Math.max(
				len + ( k ? 128 - k : 64 ),
				ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH
			);
			
			_DOMAIN.domainMemory = bytes;
			
			var i:int = len << 3;
			var bytesLength:int = ( ( ( ( i + 64 ) >>> 9 ) << 4 ) + 15 ) << 2; // длинна для подсчёта в блоках
			
//			Memory.setI32( ( i >>> 5 ) << 2, Memory.getI32( ( i >>> 5 ) << 2 ) | ( 0x80 << ( i & 31 ) ) );
			si32( li32( ( i >>> 5 ) << 2 ) | 0x80 << ( i & 31 ), ( i >>> 5 ) << 2 );
//			Memory.setI32( bytesLength - 4, i );
			si32( i, bytesLength - 4 );

//			const S11:int =  7;
//			const S12:int = 12;
//			const S13:int = 17;
//			const S14:int = 22;
//			const S21:int =  5;
//			const S22:int =  9;
//			const S23:int = 14;
//			const S24:int = 20;
//			const S31:int =  4;
//			const S32:int = 11;
//			const S33:int = 16;
//			const S34:int = 23;
//			const S41:int =  6;
//			const S42:int = 10;
//			const S43:int = 15;
//			const S44:int = 21;
			
//			const T00:int = -  680876936;
//			const T01:int = -  389564586;
//			const T02:int =    606105819;
//			const T03:int = - 1044525330;
//			const T04:int = -  176418897;
//			const T05:int =   1200080426;
//			const T06:int = - 1473231341;
//			const T07:int = -   45705983;
//			const T08:int =   1770035416;
//			const T09:int = - 1958414417;
//			const T0A:int = -      42063;
//			const T0B:int = - 1990404162;
//			const T0C:int =   1804603682;
//			const T0D:int = -   40341101;
//			const T0E:int = - 1502002290;
//			const T0F:int =   1236535329;
//			const T10:int = -  165796510;
//			const T11:int = - 1069501632;
//			const T12:int =    643717713;
//			const T13:int = -  373897302;
//			const T14:int = -  701558691;
//			const T15:int =     38016083;
//			const T16:int = -  660478335;
//			const T17:int = -  405537848;
//			const T18:int =    568446438;
//			const T19:int = - 1019803690;
//			const T1A:int = -  187363961;
//			const T1B:int =   1163531501;
//			const T1C:int = - 1444681467;
//			const T1D:int = -   51403784;
//			const T1E:int =   1735328473;
//			const T1F:int = - 1926607734;
//			const T20:int = -     378558;
//			const T21:int = - 2022574463;
//			const T22:int =   1839030562;
//			const T23:int = -   35309556;
//			const T24:int = - 1530992060;
//			const T25:int =   1272893353;
//			const T26:int = -  155497632;
//			const T27:int = - 1094730640;
//			const T28:int =    681279174;
//			const T29:int = -  358537222;
//			const T2A:int = -  722521979;
//			const T2B:int =     76029189;
//			const T2C:int = -  640364487;
//			const T2D:int = -  421815835;
//			const T2E:int =    530742520;
//			const T2F:int = -  995338651;
//			const T30:int = -  198630844;
//			const T31:int =   1126891415;
//			const T32:int = - 1416354905;
//			const T33:int = -   57434055;
//			const T34:int =   1700485571;
//			const T35:int = - 1894986606;
//			const T36:int = -    1051523;
//			const T37:int = - 2054922799;
//			const T38:int =   1873313359;
//			const T39:int = -   30611744;
//			const T3A:int = - 1560198380;
//			const T3B:int =   1309151649;
//			const T3C:int = -  145523070;
//			const T3D:int = - 1120210379;
//			const T3E:int =    718787259;
//			const T3F:int = -  343485551;

			var x0:int = 0;
			var x1:int = 0;
			var x2:int = 0;
			var x3:int = 0;
			var x4:int = 0;
			var x5:int = 0;
			var x6:int = 0;
			var x7:int = 0;
			var x8:int = 0;
			var x9:int = 0;
			var xA:int = 0;
			var xB:int = 0;
			var xC:int = 0;
			var xD:int = 0;
			var xE:int = 0;
			var xF:int = 0;
			
			var a:int =   1732584193;
			var b:int = -  271733879;
			var c:int = - 1732584194;
			var d:int =    271733878;
			
			var aa:int = 0;
			var bb:int = 0;
			var cc:int = 0;
			var dd:int = 0;
			
			i = 0;
			
			do {
				
				aa = a;
				bb = b;
				cc = c;
				dd = d;
				
//				x0 = Memory.getI32( i );	i += 4;
				x0 = li32( i      );
//				x1 = Memory.getI32( i );	i += 4;
				x1 = li32( i +  4 );
//				x2 = Memory.getI32( i );	i += 4;
				x2 = li32( i +  8 );
//				x3 = Memory.getI32( i );	i += 4;
				x3 = li32( i + 12 );
//				x4 = Memory.getI32( i );	i += 4;
				x4 = li32( i + 16 );
//				x5 = Memory.getI32( i );	i += 4;
				x5 = li32( i + 20 );
//				x6 = Memory.getI32( i );	i += 4;
				x6 = li32( i + 24 );
//				x7 = Memory.getI32( i );	i += 4;
				x7 = li32( i + 28 );
//				x8 = Memory.getI32( i );	i += 4;
				x8 = li32( i + 32 );
//				x9 = Memory.getI32( i );	i += 4;
				x9 = li32( i + 36 );
//				xA = Memory.getI32( i );	i += 4;
				xA = li32( i + 40 );
//				xB = Memory.getI32( i );	i += 4;
				xB = li32( i + 44 );
//				xC = Memory.getI32( i );	i += 4;
				xC = li32( i + 48 );
//				xD = Memory.getI32( i );	i += 4;
				xD = li32( i + 52 );
//				xE = Memory.getI32( i );	i += 4;
				xE = li32( i + 56 );
//				xF = Memory.getI32( i );	i += 4;
				xF = li32( i + 60 );
				
//				a = FF( a, b, c, d, x0, S11, T00 );
				a += ( b & c | ~b & d ) + x0 - 680876936;
				a = ( a << 7 | a >>> 25 ) + b;
//				d = FF( d, a, b, c, x1, S12, T01 );
				d += ( a & b | ~a & c ) + x1 - 389564586;
				d = ( d << 12 | d >>> 20 ) + a;
//				c = FF( c, d, a, b, x2, S13, T02 );
				c += ( d & a | ~d & b ) + x2 + 606105819;
				c = ( c << 17 | c >>> 15 ) + d;
//				b = FF( b, c, d, a, x3, S14, T03 );
				b += ( c & d | ~c & a ) + x3 - 1044525330;
				b = ( b << 22 | b >>> 10 ) + c;
//				a = FF( a, b, c, d, x4, S11, T04 );
				a += ( b & c | ~b & d ) + x4 - 176418897;
				a = ( a << 7 | a >>> 25 ) + b;
//				d = FF( d, a, b, c, x5, S12, T05 );
				d += ( a & b | ~a & c ) + x5 + 1200080426;
				d = ( d << 12 | d >>> 20 ) + a;
//				c = FF( c, d, a, b, x6, S13, T06 );
				c += ( d & a | ~d & b ) + x6 - 1473231341;
				c = ( c << 17 | c >>> 15 ) + d;
//				b = FF( b, c, d, a, x7, S14, T07 );
				b += ( c & d | ~c & a ) + x7 - 45705983;
				b = ( b << 22 | b >>> 10 ) + c;
//				a = FF( a, b, c, d, x8, S11, T08 );
				a += ( b & c | ~b & d ) + x8 + 1770035416;
				a = ( a << 7 | a >>> 25 ) + b;
//				d = FF( d, a, b, c, x9, S12, T09 );
				d += ( a & b | ~a & c ) + x9 - 1958414417;
				d = ( d << 12 | d >>> 20 ) + a;
//				c = FF( c, d, a, b, xA, S13, T0A );
				c += ( d & a | ~d & b ) + xA - 42063;
				c = ( c << 17 | c >>> 15 ) + d;
//				b = FF( b, c, d, a, xB, S14, T0B );
				b += ( c & d | ~c & a ) + xB - 1990404162;
				b = ( b << 22 | b >>> 10 ) + c;
//				a = FF( a, b, c, d, xC, S11, T0C );
				a += ( b & c | ~b & d ) + xC + 1804603682;
				a = ( a << 7 | a >>> 25 ) + b;
//				d = FF( d, a, b, c, xD, S12, T0D );
				d += ( a & b | ~a & c ) + xD - 40341101;
				d = ( d << 12 | d >>> 20 ) + a;
//				c = FF( c, d, a, b, xE, S13, T0E );
				c += ( d & a | ~d & b ) + xE - 1502002290;
				c = ( c << 17 | c >>> 15 ) + d;
//				b = FF( b, c, d, a, xF, S14, T0F );
				b += ( c & d | ~c & a ) + xF + 1236535329;
				b = ( b << 22 | b >>> 10 ) + c;
				
//				a = GG( a, b, c, d, x1, S21, T10 );
				a += ( b & d | c & ~d ) + x1 - 165796510;
				a = ( a << 5 | a >>> 27 ) + b;
//				d = GG( d, a, b, c, x6, S22, T11 );
				d += ( a & c | b & ~c ) + x6 - 1069501632;
				d = ( d << 9 | d >>> 23 ) + a;
//				c = GG( c, d, a, b, xB, S23, T12 );
				c += ( d & b | a & ~b ) + xB + 643717713;
				c = ( c << 14 | c >>> 18 ) + d;
//				b = GG( b, c, d, a, x0, S24, T13 );
				b += ( c & a | d & ~a ) + x0 - 373897302;
				b = ( b << 20 | b >>> 12 ) + c;
//				a = GG( a, b, c, d, x5, S21, T14 );
				a += ( b & d | c & ~d ) + x5 - 701558691;
				a = ( a << 5 | a >>> 27 ) + b;
//				d = GG( d, a, b, c, xA, S22, T15 );
				d += ( a & c | b & ~c ) + xA + 38016083;
				d = ( d << 9 | d >>> 23 ) + a;
//				c = GG( c, d, a, b, xF, S23, T16 );
				c += ( d & b | a & ~b ) + xF - 660478335;
				c = ( c << 14 | c >>> 18 ) + d;
//				b = GG( b, c, d, a, x4, S24, T17 );
				b += ( c & a | d & ~a ) + x4 - 405537848;
				b = ( b << 20 | b >>> 12 ) + c;
//				a = GG( a, b, c, d, x9, S21, T18 );
				a += ( b & d | c & ~d ) + x9 + 568446438;
				a = ( a << 5 | a >>> 27 ) + b;
//				d = GG( d, a, b, c, xE, S22, T19 );
				d += ( a & c | b & ~c ) + xE - 1019803690;
				d = ( d << 9 | d >>> 23 ) + a;
//				c = GG( c, d, a, b, x3, S23, T1A );
				c += ( d & b | a & ~b ) + x3 - 187363961;
				c = ( c << 14 | c >>> 18 ) + d;
//				b = GG( b, c, d, a, x8, S24, T1B );
				b += ( c & a | d & ~a ) + x8 + 1163531501;
				b = ( b << 20 | b >>> 12 ) + c;
//				a = GG( a, b, c, d, xD, S21, T1C );
				a += ( b & d | c & ~d ) + xD - 1444681467;
				a = ( a << 5 | a >>> 27 ) + b;
//				d = GG( d, a, b, c, x2, S22, T1D );
				d += ( a & c | b & ~c ) + x2 - 51403784;
				d = ( d << 9 | d >>> 23 ) + a;
//				c = GG( c, d, a, b, x7, S23, T1E );
				c += ( d & b | a & ~b ) + x7 + 1735328473;
				c = ( c << 14 | c >>> 18 ) + d;
//				b = GG( b, c, d, a, xC, S24, T1F );
				b += ( c & a | d & ~a ) + xC - 1926607734;
				b = ( b << 20 | b >>> 12 ) + c;
				
//				a = HH( a, b, c, d, x5, S31, T20 );
				a += ( b ^ c ^ d ) + x5 - 378558;
				a = ( a << 4 | a >>> 28 ) + b;
//				d = HH( d, a, b, c, x8, S32, T21 );
				d += ( a ^ b ^ c ) + x8 - 2022574463;
				d = ( d << 11 | d >>> 21 ) + a;
//				c = HH( c, d, a, b, xB, S33, T22 );
				c += ( d ^ a ^ b ) + xB + 1839030562;
				c = ( c << 16 | c >>> 16 ) + d;
//				b = HH( b, c, d, a, xE, S34, T23 );
				b += ( c ^ d ^ a ) + xE - 35309556;
				b = ( b << 23 | b >>> 9 ) + c;
//				a = HH( a, b, c, d, x1, S31, T24 );
				a += ( b ^ c ^ d ) + x1 - 1530992060;
				a = ( a << 4 | a >>> 28 ) + b;
//				d = HH( d, a, b, c, x4, S32, T25 );
				d += ( a ^ b ^ c ) + x4 + 1272893353;
				d = ( d << 11 | d >>> 21 ) + a;
//				c = HH( c, d, a, b, x7, S33, T26 );
				c += ( d ^ a ^ b ) + x7 - 155497632;
				c = ( c << 16 | c >>> 16 ) + d;
//				b = HH( b, c, d, a, xA, S34, T27 );
				b += ( c ^ d ^ a ) + xA - 1094730640;
				b = ( b << 23 | b >>> 9 ) + c;
//				a = HH( a, b, c, d, xD, S31, T28 );
				a += ( b ^ c ^ d ) + xD + 681279174;
				a = ( a << 4 | a >>> 28 ) + b;
//				d = HH( d, a, b, c, x0, S32, T29 );
				d += ( a ^ b ^ c ) + x0 - 358537222;
				d = ( d << 11 | d >>> 21 ) + a;
//				c = HH( c, d, a, b, x3, S33, T2A );
				c += ( d ^ a ^ b ) + x3 - 722521979;
				c = ( c << 16 | c >>> 16 ) + d;
//				b = HH( b, c, d, a, x6, S34, T2B );
				b += ( c ^ d ^ a ) + x6 + 76029189;
				b = ( b << 23 | b >>> 9 ) + c;
//				a = HH( a, b, c, d, x9, S31, T2C );
				a += ( b ^ c ^ d ) + x9 - 640364487;
				a = ( a << 4 | a >>> 28 ) + b;
//				d = HH( d, a, b, c, xC, S32, T2D );
				d += ( a ^ b ^ c ) + xC - 421815835;
				d = ( d << 11 | d >>> 21 ) + a;
//				c = HH( c, d, a, b, xF, S33, T2E );
				c += ( d ^ a ^ b ) + xF + 530742520;
				c = ( c << 16 | c >>> 16 ) + d;
//				b = HH( b, c, d, a, x2, S34, T2F );
				b += ( c ^ d ^ a ) + x2 - 995338651;
				b = ( b << 23 | b >>> 9 ) + c;

//				a = II( a, b, c, d, x0, S41, T30 );
				a += ( c ^ ( b | ~d ) ) + x0 - 198630844;
				a = ( a << 6 | a >>> 26 ) + b;
//				d = II( d, a, b, c, x7, S42, T31 );
				d += ( b ^ ( a | ~c ) ) + x7 + 1126891415;
				d = ( d << 10 | d >>> 22 ) + a;
//				c = II( c, d, a, b, xE, S43, T32 );
				c += ( a ^ ( d | ~b ) ) + xE - 1416354905;
				c = ( c << 15 | c >>> 17 ) + d;
//				b = II( b, c, d, a, x5, S44, T33 );
				b += ( d ^ ( c | ~a ) ) + x5 - 57434055;
				b = ( b << 21 | b >>> 11 ) + c;
//				a = II( a, b, c, d, xC, S41, T34 );
				a += ( c ^ ( b | ~d ) ) + xC + 1700485571;
				a = ( a << 6 | a >>> 26 ) + b;
//				d = II( d, a, b, c, x3, S42, T35 );
				d += ( b ^ ( a | ~c ) ) + x3 - 1894986606;
				d = ( d << 10 | d >>> 22 ) + a;
//				c = II( c, d, a, b, xA, S43, T36 );
				c += ( a ^ ( d | ~b ) ) + xA - 1051523;
				c = ( c << 15 | c >>> 17 ) + d;
//				b = II( b, c, d, a, x1, S44, T37 );
				b += ( d ^ ( c | ~a ) ) + x1 - 2054922799;
				b = ( b << 21 | b >>> 11 ) + c;
//				a = II( a, b, c, d, x8, S41, T38 );
				a += ( c ^ ( b | ~d ) ) + x8 + 1873313359;
				a = ( a << 6 | a >>> 26 ) + b;
//				d = II( d, a, b, c, xF, S42, T39 );
				d += ( b ^ ( a | ~c ) ) + xF - 30611744;
				d = ( d << 10 | d >>> 22 ) + a;
//				c = II( c, d, a, b, x6, S43, T3A );
				c += ( a ^ ( d | ~b ) ) + x6 - 1560198380;
				c = ( c << 15 | c >>> 17 ) + d;
//				b = II( b, c, d, a, xD, S44, T3B );
				b += ( d ^ ( c | ~a ) ) + xD + 1309151649;
				b = ( b << 21 | b >>> 11 ) + c;
//				a = II( a, b, c, d, x4, S41, T3C );
				a += ( c ^ ( b | ~d ) ) + x4 - 145523070;
				a = ( a << 6 | a >>> 26 ) + b;
//				d = II( d, a, b, c, xB, S42, T3D );
				d += ( b ^ ( a | ~c ) ) + xB - 1120210379;
				d = ( d << 10 | d >>> 22 ) + a;
//				c = II( c, d, a, b, x2, S43, T3E );
				c += ( a ^ ( d | ~b ) ) + x2 + 718787259;
				c = ( c << 15 | c >>> 17 ) + d;
//				b = II( b, c, d, a, x9, S44, T3F );
				b += ( d ^ ( c | ~a ) ) + x9 - 343485551;
				b = ( b << 21 | b >>> 11 ) + c;
				
				a += aa;
				b += bb;
				c += cc;
				d += dd;
				
				i += 64;
				
			} while ( i < bytesLength );
			
//			Memory.setI32( len     , a );
			si32( a, len );
//			Memory.setI32( len +  4, b );
			si32( b, len + 4 );
//			Memory.setI32( len +  8, c );
			si32( c, len + 8 );
//			Memory.setI32( len + 12, d );
			si32( d, len + 12 );

			_DOMAIN.domainMemory = tmp;
			
			var result:ByteArray = new ByteArray();
			bytes.position = len;
			bytes.readBytes( result, 0, 16 );
			
			bytes.position = padPos;
			bytes.writeBytes( pad );
			
			bytes.length = len;
			bytes.position = pos;
			
			return result;

		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

//		[Inline]
//		/**
//		 * transformations for round 1
//		 */
//		private static function FF( a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
//			a += ( ( b & c ) | ( ( ~b ) & d ) ) + x + t;
//			return ( ( a << s ) | ( a >>> ( 32 - s ) ) ) +  b;
//		}
//		
//		[Inline]
//		/**
//		 * transformations for round 2
//		 */
//		private static function GG( a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
//			a += ( ( b & d ) | ( c & ( ~d ) ) ) + x + t;
//			return ( ( a << s ) | ( a >>> ( 32 - s ) ) ) +  b;
//		}
		
//		[Inline]
//		/**
//		 * transformations for round 3
//		 */
//		private static function HH( a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
//			a += ( b ^ c ^ d ) + x + t;
//			return ( ( a << s ) | ( a >>> ( 32 - s ) ) ) +  b;
//		}
		
//		[Inline]
//		private static function II( a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
//			a += ( c ^ ( b | ( ~d ) ) ) + x + t;
//			return ( ( a << s ) | ( a >>> ( 32 - s ) ) ) + b;
//		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function MD5() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}
	
}