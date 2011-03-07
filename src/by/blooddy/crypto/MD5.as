////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import by.blooddy.math.utils.IntUtils;
	import by.blooddy.system.Memory;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * @author					BlooDHounD
	 * @version					3.0
	 * @playerversion			Flash 10
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
		private static const _domain:ApplicationDomain = ApplicationDomain.currentDomain;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function hash(str:String):String {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );
			return _hashBytes( bytes );
		}

		public static function hashBytes(bytes:ByteArray):String {
			
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

			var result:String = _hashBytes( bytes );

			bytes.position = padPos;
			bytes.writeBytes( pad );

			bytes.length = len;
			bytes.position = pos;

			return result;

		}

		public static function digest(bytes:ByteArray):ByteArray {

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
			
			var tmp:ByteArray = _domain.domainMemory;
			
			var k:uint = len & 63;
			
			bytes.length = Math.max(
				len + ( k ? 128 - k : 64 ),
				ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH
			);
			
			_domain.domainMemory = bytes;
			
			_digest( len );
			
			_domain.domainMemory = tmp;
			
			var result:ByteArray = new ByteArray();
			bytes.position = len;
			bytes.readBytes( result, 16 );

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

		/**
		 * @private
		 */
		private static function _hashBytes(mem:ByteArray):String {

			var tmp:ByteArray = _domain.domainMemory;

			var len:uint = mem.length;
			var k:uint = len & 63;

			mem.length = Math.max(
				len + ( k ? 128 - k : 64 ),
				ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH
			);

			_domain.domainMemory = mem;

			_digest( len );

			var i:uint = len;
			var t:uint = i + 16;
			var j:uint = t + 16 - 1;
			
			len = t;

			mem.position = t;
			mem.writeUTFBytes( '0123456789abcdef' );

			do {
				k = Memory.getUI8( i );
				Memory.setI8( ++j, Memory.getUI8( t + ( k >>> 4 ) ) );
				Memory.setI8( ++j, Memory.getUI8( t + ( k & 0xF ) ) );
			} while ( ++i < len );
			
			_domain.domainMemory = tmp;

			mem.position = t + 16;
			
			return mem.readUTFBytes( 32 );
			
		}

		/**
		 * @private
		 */
		private static function _digest(len:uint):void {

			var i:uint = len << 3;
			var bytesLength:uint = ( ( ( ( i + 64 ) >>> 9 ) << 4 ) + 15 ) << 2; // длинна для подсчёта в блоках
			
			Memory.setI32( ( i >>> 5 ) << 2, Memory.getI32( ( i >>> 5 ) << 2 ) | ( 0x80 << ( i & 31 ) ) );
			Memory.setI32( bytesLength - 4, i );

			const S11:int =  7;
			const S12:int = 12;
			const S13:int = 17;
			const S14:int = 22;
			const S21:int =  5;
			const S22:int =  9;
			const S23:int = 14;
			const S24:int = 20;
			const S31:int =  4;
			const S32:int = 11;
			const S33:int = 16;
			const S34:int = 23;
			const S41:int =  6;
			const S42:int = 10;
			const S43:int = 15;
			const S44:int = 21;
			
			const T00:int = -  680876936;
			const T01:int = -  389564586;
			const T02:int =    606105819;
			const T03:int = - 1044525330;
			const T04:int = -  176418897;
			const T05:int =   1200080426;
			const T06:int = - 1473231341;
			const T07:int = -   45705983;
			const T08:int =   1770035416;
			const T09:int = - 1958414417;
			const T0A:int = -      42063;
			const T0B:int = - 1990404162;
			const T0C:int =   1804603682;
			const T0D:int = -   40341101;
			const T0E:int = - 1502002290;
			const T0F:int =   1236535329;
			const T10:int = -  165796510;
			const T11:int = - 1069501632;
			const T12:int =    643717713;
			const T13:int = -  373897302;
			const T14:int = -  701558691;
			const T15:int =     38016083;
			const T16:int = -  660478335;
			const T17:int = -  405537848;
			const T18:int =    568446438;
			const T19:int = - 1019803690;
			const T1A:int = -  187363961;
			const T1B:int =   1163531501;
			const T1C:int = - 1444681467;
			const T1D:int = -   51403784;
			const T1E:int =   1735328473;
			const T1F:int = - 1926607734;
			const T20:int = -     378558;
			const T21:int = - 2022574463;
			const T22:int =   1839030562;
			const T23:int = -   35309556;
			const T24:int = - 1530992060;
			const T25:int =   1272893353;
			const T26:int = -  155497632;
			const T27:int = - 1094730640;
			const T28:int =    681279174;
			const T29:int = -  358537222;
			const T2A:int = -  722521979;
			const T2B:int =     76029189;
			const T2C:int = -  640364487;
			const T2D:int = -  421815835;
			const T2E:int =    530742520;
			const T2F:int = -  995338651;
			const T30:int = -  198630844;
			const T31:int =   1126891415;
			const T32:int = - 1416354905;
			const T33:int = -   57434055;
			const T34:int =   1700485571;
			const T35:int = - 1894986606;
			const T36:int = -    1051523;
			const T37:int = - 2054922799;
			const T38:int =   1873313359;
			const T39:int = -   30611744;
			const T3A:int = - 1560198380;
			const T3B:int =   1309151649;
			const T3C:int = -  145523070;
			const T3D:int = - 1120210379;
			const T3E:int =    718787259;
			const T3F:int = -  343485551;

			var x0:int;
			var x1:int;
			var x2:int;
			var x3:int;
			var x4:int;
			var x5:int;
			var x6:int;
			var x7:int;
			var x8:int;
			var x9:int;
			var xA:int;
			var xB:int;
			var xC:int;
			var xD:int;
			var xE:int;
			var xF:int;
			
			var a:int =   1732584193;
			var b:int = -  271733879;
			var c:int = - 1732584194;
			var d:int =    271733878;
			
			var aa:int = a;
			var bb:int = b;
			var cc:int = c;
			var dd:int = d;
			
			i = 0;
			
			do {
				
				aa = a;
				bb = b;
				cc = c;
				dd = d;
				
				x0 = Memory.getI32( i );	i += 4;
				x1 = Memory.getI32( i );	i += 4;
				x2 = Memory.getI32( i );	i += 4;
				x3 = Memory.getI32( i );	i += 4;
				x4 = Memory.getI32( i );	i += 4;
				x5 = Memory.getI32( i );	i += 4;
				x6 = Memory.getI32( i );	i += 4;
				x7 = Memory.getI32( i );	i += 4;
				x8 = Memory.getI32( i );	i += 4;
				x9 = Memory.getI32( i );	i += 4;
				xA = Memory.getI32( i );	i += 4;
				xB = Memory.getI32( i );	i += 4;
				xC = Memory.getI32( i );	i += 4;
				xD = Memory.getI32( i );	i += 4;
				xE = Memory.getI32( i );	i += 4;
				xF = Memory.getI32( i );	i += 4;
				
				a = FF( a, b, c, d, x0, S11, T00 );
				d = FF( d, a, b, c, x1, S12, T01 );
				c = FF( c, d, a, b, x2, S13, T02 );
				b = FF( b, c, d, a, x3, S14, T03 );
				a = FF( a, b, c, d, x4, S11, T04 );
				d = FF( d, a, b, c, x5, S12, T05 );
				c = FF( c, d, a, b, x6, S13, T06 );
				b = FF( b, c, d, a, x7, S14, T07 );
				a = FF( a, b, c, d, x8, S11, T08 );
				d = FF( d, a, b, c, x9, S12, T09 );
				c = FF( c, d, a, b, xA, S13, T0A );
				b = FF( b, c, d, a, xB, S14, T0B );
				a = FF( a, b, c, d, xC, S11, T0C );
				d = FF( d, a, b, c, xD, S12, T0D );
				c = FF( c, d, a, b, xE, S13, T0E );
				b = FF( b, c, d, a, xF, S14, T0F );
				a = GG( a, b, c, d, x1, S21, T10 );
				d = GG( d, a, b, c, x6, S22, T11 );
				c = GG( c, d, a, b, xB, S23, T12 );
				b = GG( b, c, d, a, x0, S24, T13 );
				a = GG( a, b, c, d, x5, S21, T14 );
				d = GG( d, a, b, c, xA, S22, T15 );
				c = GG( c, d, a, b, xF, S23, T16 );
				b = GG( b, c, d, a, x4, S24, T17 );
				a = GG( a, b, c, d, x9, S21, T18 );
				d = GG( d, a, b, c, xE, S22, T19 );
				c = GG( c, d, a, b, x3, S23, T1A );
				b = GG( b, c, d, a, x8, S24, T1B );
				a = GG( a, b, c, d, xD, S21, T1C );
				d = GG( d, a, b, c, x2, S22, T1D );
				c = GG( c, d, a, b, x7, S23, T1E );
				b = GG( b, c, d, a, xC, S24, T1F );
				a = HH( a, b, c, d, x5, S31, T20 );
				d = HH( d, a, b, c, x8, S32, T21 );
				c = HH( c, d, a, b, xB, S33, T22 );
				b = HH( b, c, d, a, xE, S34, T23 );
				a = HH( a, b, c, d, x1, S31, T24 );
				d = HH( d, a, b, c, x4, S32, T25 );
				c = HH( c, d, a, b, x7, S33, T26 );
				b = HH( b, c, d, a, xA, S34, T27 );
				a = HH( a, b, c, d, xD, S31, T28 );
				d = HH( d, a, b, c, x0, S32, T29 );
				c = HH( c, d, a, b, x3, S33, T2A );
				b = HH( b, c, d, a, x6, S34, T2B );
				a = HH( a, b, c, d, x9, S31, T2C );
				d = HH( d, a, b, c, xC, S32, T2D );
				c = HH( c, d, a, b, xF, S33, T2E );
				b = HH( b, c, d, a, x2, S34, T2F );
				a = II( a, b, c, d, x0, S41, T30 );
				d = II( d, a, b, c, x7, S42, T31 );
				c = II( c, d, a, b, xE, S43, T32 );
				b = II( b, c, d, a, x5, S44, T33 );
				a = II( a, b, c, d, xC, S41, T34 );
				d = II( d, a, b, c, x3, S42, T35 );
				c = II( c, d, a, b, xA, S43, T36 );
				b = II( b, c, d, a, x1, S44, T37 );
				a = II( a, b, c, d, x8, S41, T38 );
				d = II( d, a, b, c, xF, S42, T39 );
				c = II( c, d, a, b, x6, S43, T3A );
				b = II( b, c, d, a, xD, S44, T3B );
				a = II( a, b, c, d, x4, S41, T3C );
				d = II( d, a, b, c, xB, S42, T3D );
				c = II( c, d, a, b, x2, S43, T3E );
				b = II( b, c, d, a, x9, S44, T3F );
				
				a += aa;
				b += bb;
				c += cc;
				d += dd;
				
			} while ( i < bytesLength );
			
			Memory.setI32( len     , a );
			Memory.setI32( len +  4, b );
			Memory.setI32( len +  8, c );
			Memory.setI32( len + 12, d );

		}

		/**
		 * transformations for round 1
		 */
		private static function FF(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			a += ( ( b & c ) | ( ( ~b ) & d ) ) + x + t;
			return IntUtils.rol( a, s ) +  b;
		}
		
		/**
		 * transformations for round 2
		 */
		private static function GG(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			a += ( ( b & d ) | ( c & ( ~d ) ) ) + x + t;
			return IntUtils.rol( a, s ) +  b;
		}
		
		/**
		 * transformations for round 3
		 */
		private static function HH(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			a += ( b ^ c ^ d ) + x + t;
			return IntUtils.rol( a, s ) +  b;
		}
		
		/**
		 * transformations for round 4
		 */
		private static function II(a:int, b:int, c:int, d:int, x:int, s:int, t:int):int {
			a += ( c ^ ( b | ( ~d ) ) ) + x + t;
			return IntUtils.rol( a, s ) +  b;
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
		public function MD5() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}
	
}