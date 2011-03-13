////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import by.blooddy.system.Memory;

	/**
	 * @author	BlooDHounD
	 * @version	1.0
	 */
	internal final class BigUintStr {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function getBitLength(v:String):uint {
			var _v:BigUint = fromString( v, 5 );
			return BigUint.getBitLength( _v );
		}
		
		public static function testBit(v1:String, n:uint):Boolean {
			var _v1:BigUint = fromString( v1, 5 );
			return BigUint.testBit( _v1, n );
		}

		public static function setBit(v1:String, n:uint):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _r:BigUint = BigUint.setBit( _v1, n, _v1.pos + _v1.len );
			return toString( _r );
		}

		public static function clearBit(v1:String, n:uint):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _r:BigUint = BigUint.clearBit( _v1, n, _v1.pos + _v1.len );
			return toString( _r );
		}

		public static function flipBit(v1:String, n:uint):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _r:BigUint = BigUint.flipBit( _v1, n, _v1.pos + _v1.len );
			return toString( _r );
		}

//		public static function not(v1:String):String {
//			var _v1:BigUint = fromString( v1, 5 );
//			var _r:BigUint = BigUint.not( _v1, _v1.pos + _v1.len );
//			return toString( _r );
//		}

		public static function and(v1:String, v2:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.and( _v1, _v2, _v2.pos + _v2.len );
			return toString( _r );
		}

		public static function andNot(v1:String, v2:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.andNot( _v1, _v2, _v2.pos + _v2.len );
			return toString( _r );
		}

		public static function or(v1:String, v2:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.or( _v1, _v2, _v2.pos + _v2.len );
			return toString( _r );
		}

		public static function xor(v1:String, v2:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.xor( _v1, _v2, _v2.pos + _v2.len );
			return toString( _r );
		}

		public static function shiftRight(v1:String, v2:uint):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _r:BigUint = BigUint.shiftRight( _v1, v2, _v1.pos + _v1.len );
			return toString( _r );
		}

		public static function shiftLeft(v1:String, v2:uint):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _r:BigUint = BigUint.shiftLeft( _v1, v2, _v1.pos + _v1.len );
			return toString( _r );
		}

		public static function compare(v1:String, v2:String):int {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			return BigUint.compare( _v1, _v2 );
		}

		public static function inc(v1:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _r:BigUint = BigUint.inc( _v1, _v1.pos + _v1.len );
			return toString( _r );
		}

		public static function add(v1:String, v2:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.add( _v1, _v2, _v2.pos + _v2.len );
			return toString( _r );
		}

		public static function dec(v1:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _r:BigUint = BigUint.dec( _v1, _v1.pos + _v1.len );
			return toString( _r );
		}

		public static function sub(v1:String, v2:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.sub( _v1, _v2, _v2.pos + _v2.len );
			return toString( _r );
		}

		public static function mul(v1:String, v2:String):String {
			var _v1:BigUint = fromString( v1, 5 );
			var _v2:BigUint = fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.mul( _v1, _v2, _v2.pos + _v2.len );
			return toString( _r );
		}

		public static function powInt(v:String, e:uint):String {
			var _v:BigUint = fromString( v, 5 );
			var _r:BigUint = BigUint.powInt( _v, e, _v.pos + _v.len );
			return toString( _r );
		}
		
		public static function divAndMod(v:String, m:String):Array {
			var _v:BigUint = fromString( v, 5 );
			var _m:BigUint = fromString( m, _v.pos + _v.len );
			var _r:Vector.<BigUint> = BigUint.divAndMod( _v, _m, _m.pos + _m.len );
			return [ toString( _r[ 0 ] ), toString( _r[ 1 ] ) ];
		}

		public static function div(v:String, m:String):String {
			var _v:BigUint = fromString( v, 5 );
			var _m:BigUint = fromString( m, _v.pos + _v.len );
			var _r:BigUint = BigUint.div( _v, _m, _m.pos + _m.len );
			return toString( _r );
		}

		public static function mod(v:String, m:String):String {
			var _v:BigUint = fromString( v, 5 );
			var _m:BigUint = fromString( m, _v.pos + _v.len );
			var _r:BigUint = BigUint.mod( _v, _m, _m.pos + _m.len );
			return toString( _r );
		}

		public static function modPow(v:String, e:String, m:String):String {
			var _v:BigUint = fromString( v, 5 );
			var _e:BigUint = fromString( e, _v.pos + _v.len );
			var _m:BigUint = fromString( m, _e.pos + _e.len );
			var _r:BigUint = BigUint.modPow( _v, _e, _m, _m.pos + _m.len );
			return toString( _r );
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------
		
		public static function toString(v:BigUint):String {
			if ( v.len == 0 ) return '0';
			var p:uint = v.pos;
			var s:String;
			var i:uint = p + v.len - 4;
			var result:String = uint( Memory.getI32( i ) ).toString( 16 );
			while ( i > p ) {
				i -= 4;
				s = uint( Memory.getI32( i ) ).toString( 16 );
				result += '0000000'.substr( 0, 8 - s.length ) + s;
			}
			return result;
		}
		
		public static function fromString(v:String, pos:uint):BigUint {
			var p:uint = pos;
			var i:int = v.length;
			do {
				Memory.setI32( p, parseInt( v.substring( Math.max( 0, i - 8 ), i ), 16 ) );
				i -= 8;
				p += 4;
			} while ( i > 0 );
			i = p - pos;
			while ( i > 0 && Memory.getI32( pos + i - 4 ) == 0 ) {
				i -= 4;
			}
			return new BigUint( pos, i );
		}
		
	}

}