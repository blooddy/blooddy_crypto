////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {

	import by.blooddy.math.utils.BigUint;

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

		public static function testBit(v1:String, n:uint):Boolean {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			return BigUint.testBit( _v1, n );
		}

		public static function setBit(v1:String, n:uint):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.setBit( _v1, n, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function clearBit(v1:String, n:uint):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.clearBit( _v1, n, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function flipBit(v1:String, n:uint):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.flipBit( _v1, n, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function not(v1:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.not( _v1, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function and(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.and( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function andNot(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.andNot( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function or(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.or( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function xor(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.xor( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function shiftRight(v1:String, v2:uint):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.shiftRight( _v1, v2, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function shiftLeft(v1:String, v2:uint):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.shiftLeft( _v1, v2, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function compare(v1:String, v2:String):int {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			return BigUint.compare( _v1, _v2 );
		}

		public static function increment(v1:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.increment( _v1, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function add(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.add( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function decrement(v1:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.decrement( _v1, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}

		public static function sub(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.sub( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function mult(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.mult( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function powInt(v1:String, e:uint):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _r:BigUint = BigUint.powInt( _v1, e, _v1.pos + _v1.len );
			return BigUint.toString( _r );
		}
		
		public static function divAndMod(v1:String, v2:String):Array {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:Vector.<BigUint> = BigUint.divAndMod( _v1, _v2, _v2.pos + _v2.len );
			return [ BigUint.toString( _r[ 0 ] ), BigUint.toString( _r[ 1 ] ) ];
		}

		public static function div(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.div( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

		public static function mod(v1:String, v2:String):String {
			var _v1:BigUint = BigUint.fromString( v1, 5 );
			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
			var _r:BigUint = BigUint.mod( _v1, _v2, _v2.pos + _v2.len );
			return BigUint.toString( _r );
		}

//		public static function modPowInt(v1:String, e:uint, v2:String):String {
//			var _v1:BigUint = BigUint.fromString( v1, 5 );
//			var _v2:BigUint = BigUint.fromString( v2, _v1.pos + _v1.len );
//			return BigUint.modPowInt( _p1, _l1, e, _p2, _l2, _pr, _lr );
//		}

	}

}