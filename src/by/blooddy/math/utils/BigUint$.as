////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import apparat.inline.Macro;
	
	import by.blooddy.system.Memory;
	
	import flash.utils.ByteArray;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					31.01.2011 10:59:37
	 */
	public final class BigUint$ extends Macro { // internal?

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		[Inline( "direct_copy" )]
		public static function fillZero(mem:ByteArray, pos:uint, end:uint, i:uint):void {
			Memory.setI32( pos, 0 );
			mem.position = pos + 4;
			if ( mem.position < end ) {
				Memory.setI32( mem.position, 0 );
				mem.position += 4;
				i = 8;
				while ( mem.position < end ) {
					mem.writeBytes( mem, pos, i );
					i <<= 1;
				}
			}
		}
		
		[Inline( "direct_copy" )]
		public static function clean(pos:uint, len:uint):void {
			while ( len > 0 && Memory.getI32( pos + len - 4 ) == 0 ) {
				len -= 4;
			}
		}

		[Inline( "direct_copy" )]
		public static function getShift(pos:uint, len:uint, e:int, c:uint):void {
			c = pos + len - 4;
			e = Memory.getI32( c );
			if ( ( e & ( e - 1 ) ) == 0 ) {
				while ( c > pos ) {
					c -= 4;
					if ( Memory.getI32( c ) != 0 ) {
						e = -1;
						break;
					}
				}
				if ( e != -1 ) {
					e = int( Math.log( e ) * Math.LOG2E + 0.5 ) + ( ( len - 4 ) << 3 );
				}
			} else {
				e = -1;
			}
		}

		[Inline( "direct_copy" )]
		/**
		 * result = 1 << n
		 */
		public static function shiftLeftOne(
			mem:ByteArray,
			n:uint, pos:uint, len:uint,
			s:uint
		):void {
			var len:uint = 0;
			var s:uint = n >>> 3;
			s -= s & 3;
			if ( s > 0 ) {
				s += pos;
				BigUint$.fillZero( mem, pos, s, len );
			}
			Memory.setI32( s, 1 << ( n & 31 ) );
			len = s - pos + 4;
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 * v2
		 */
		public static function mult_s(
			p1:uint, l1:uint, v2:uint, pos:uint, len:uint,
			temp:uint
		):void {
			len = 0;
			temp = 0;
			do {
				temp += Memory.getUI16( p1 + len ) * v2;
				Memory.setI16( pos + len, temp );
				len += 2;
				temp >>>= 16;
			} while ( len < l1 );
			if ( temp > 0 ) {
				Memory.setI32( pos + len, temp );
				len += 4;
			}
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 * v2
		 */
		public static function mult(
			mem:ByteArray,
			p1:uint, l1:uint, p2:uint, l2:uint, pos:uint, len:uint,
			c1:uint, c2:uint, i:uint, j:uint, temp:uint
		):void {
			temp = 0;
			c1 = Memory.getUI16( p1 );
			c2 = Memory.getUI16( p2 );
			i = 2;
			j = 2;
			if ( c1 && c2 ) {
				temp = c1 * c2;
				Memory.setI16( pos, temp );
				j = 2;
				while ( j < l2 ) {
					temp = ( temp >>> 16 ) + c1 * Memory.getUI16( p2 + j );
					Memory.setI16( pos + j, temp );
					j += 2;
				}
				Memory.setI16( pos + l2, temp >>> 16 );
			} else {
				if ( c1 ) i = 0;
				else {
					while ( i < l1 && Memory.getUI16( p1 + i ) == 0 ) {
						i += 2;
					}
				}
				if ( c2 ) j = 0;
				else {
					while ( j < l2 && Memory.getUI16( p2 + j ) == 0 ) {
						j += 2;
					}
				}
				if ( j > i ) {
					temp = p1; p1 = p2; p2 = temp;
					temp = l1; l1 = l2; l2 = temp;
					temp = c1; c1 = c2; c2 = temp;
					i = j;
				}
				temp = pos + l2 + i;
				BigUint$.fillZero( mem, pos, temp, j ); 
			}
			while ( i < l1 ) {
				c1 = Memory.getUI16( p1 + i );
				if ( c1 ) {
					len = pos + i;
					temp = c2 * c1 + Memory.getUI16( len );
					Memory.setI16( len, temp );
					j = 2;
					while ( j < l2 ) {
						len = pos + i + j;
						temp = ( temp >>> 16 ) + c1 * Memory.getUI16( p2 + j ) + Memory.getUI16( len );
						Memory.setI16( len, temp );
						j += 2;
					}
					Memory.setI16( pos + i + j, temp >>> 16 );
				} else {
					Memory.setI16( pos + i + l2, 0 );
				}
				i += 2;
			}
			len = i + j;
			BigUint$.clean( pos, len );
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v * v
		 */
		public static function sqr(
			mem:ByteArray,
			p:uint, l:uint, pos:uint, len:uint,
			c1:uint, c2:uint, i:uint, j:uint, temp:uint
		):void {
			c1 = Memory.getUI16( p );
			i = 2;
			if ( c1 ) {
				temp = c1 * c1;
				Memory.setI16( pos, temp );
				j = 2;
				while ( j < l ) {
					temp = ( temp >>> 16 ) + c1 * Memory.getUI16( p + j );
					Memory.setI16( pos + j, temp );
					j += 2;
				}
				Memory.setI16( pos + j, temp >>> 16 );
			} else {
				while ( i < l && Memory.getUI16( p + i ) == 0 ) {
					i += 2;
				}
				temp = pos + l + i;
				BigUint$.fillZero( mem, pos, temp, j ); 
			}
			while ( i < l ) {
				c2 = Memory.getUI16( p + i );
				if ( c2 ) {
					len = pos + i;
					temp = c2 * c1 + Memory.getUI16( len );
					Memory.setI16( len, temp );
					j = 2;
					while ( j < l ) {
						len = pos + i + j;
						temp = ( temp >>> 16 ) + c2 * Memory.getUI16( p + j ) + Memory.getUI16( len );
						Memory.setI16( len, temp );
						j += 2;
					}
					Memory.setI16( pos + i + j, temp >>> 16 );
				} else {
					Memory.setI16( pos + i + l, 0 );
				}
				i += 2;
			}
			len = i << 1;
			BigUint$.clean( pos, len );
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 / v2
		 */
		public static function div_s(
			p1:uint, l1:uint, v2:uint, pos:uint, len:uint,
			c:uint, i:uint
		):void {
			c = 0;
			i = l1;
			do {
				i -= 2;
				c = Memory.getUI16( p1 + i ) | ( c << 16 );
				Memory.setI16( pos + i, c / v2 );
				c %= v2;
			} while ( i > 0 ) ;
			len = l1;
			BigUint$.clean( pos, len );
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 / v2
		 */
		public static function mod_s(
			p1:uint, l1:uint, v2:uint,
			c:uint, i:uint
		):void {
			c = 0;
			i = l1;
			do {
				i -= 2;
				c = ( Memory.getUI16( p1 + i ) | ( c << 16 ) ) % v2;
			} while ( i > 0 );
		}

	}

}