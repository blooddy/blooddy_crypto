////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {
	
	import by.blooddy.math.utils.BigUintTest;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;
	
	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 */
	public final class BigIntegerTest {
		
		//--------------------------------------------------------------------------
		//
		//  Class initialization
		//
		//--------------------------------------------------------------------------
		
		Parameterized;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  fromString
		//----------------------------------
		
		public static var $fromString:Array = [
			[ '0', 10 ],
			[ '291', 10 ],
			[ '-291', 10 ],
			[ '321020873359199', 10 ],
			[ '-321020873359199', 10 ],
			[ '0xFF007812356', 16, 'FF007812356' ],
			[ '-97876671231231', 16 ]
		];
		
		[Test( order="-4", dataProvider="$fromString" )]
		public function fromString(v:String, radix:uint, result:String=null):void {
			var bi:BigInteger = BigInteger.fromString( v, radix );
			Assert.assertEquals(
				bi.toString( radix ).toLowerCase(), ( result || v ).toLowerCase()
			);
		}

		//----------------------------------
		//  fromNumber
		//----------------------------------

		public static var $fromNumber:Array = [
			[ 0 ],
			[ 291 ],
			[ -291 ],
			[ 321020873359199 ],
			[ -321020873359199 ],
			[ 6.10917779346288e+57 ],
			[ -6.10917779346288e+57 ]
		];

		[Test( order="-3", dataProvider="$fromNumber" )]
		public function fromNumber(v:Number):void {
			var bi:BigInteger = BigInteger.fromNumber( v );
			Assert.assertEquals(
				bi.toString(), v.toString( 16 )
			);
		}

		//----------------------------------
		//  fromVector
		//----------------------------------
		
		public static var $fromVector:Array = [
			[ new <uint>[], false, '0' ],
			[ new <uint>[0x07812356,0xFF0], false, 'FF007812356' ],
			[ new <uint>[0x07812356,0xFF0], true, 'FF007812356' ]
		];
		
		[Test( order="-2", dataProvider="$fromVector" )]
		public function fromVector(v:Vector.<uint>, negative:Boolean, result:String):void {
			var bi:BigInteger = BigInteger.fromVector( v, negative );
			Assert.assertEquals(
				bi.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  negate
		//----------------------------------
		
		public static var $negate:Array = [
			[ '0', '0' ],
			[ 'FF00FF00FF00FF', '-FF00FF00FF00FF' ],
			[ '-FF00FF00FF00FF', 'FF00FF00FF00FF' ]
		];
		
		[Test( order="-1", dataProvider="$negate" )]
		public function negate(v:String, result:String):void {
			var R:BigInteger = BigInteger.fromString( v ).negate();
			Assert.assertEquals(
				'-' + v.toLowerCase(),
				R.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  getBitLength
		//----------------------------------
		
		public static var $getBitLength:Array = [
			[ '0', 0 ],
			[ 'FF', 8 ],
			[ '123', 9 ],
			[ 'FF00123', 28 ],
			[ '123F77F1F3F5F', 49 ],
			[ 'FF00000000', 40 ]
		];
		
		[Test( order="0", dataProvider="$getBitLength" )]
		public function getBitLength(v:String, result:uint):void {
			var R:uint = BigInteger.fromString( v ).getBitLength();
			Assert.assertEquals(
				R, result
			);
		}
		
		//----------------------------------
		//  testBit
		//----------------------------------
		
		public static var $testBit:Array = [
			[ '0', 1, false ],
			[ '123', 40, false ],
			[ '123F77F1F3F5F', 32, true ],
			[ '123F77F1F3F5F', 31, false ],
			[ '-123', 40, true ],
			[ '-123F77F1F3F5F', 32, false ],
			[ '-123F77F1F3F5F', 31, true ],
			[ '-100000', 20, true ],
			[ '100000', 20, true ]
		];
		
		[Test( order="1", dataProvider="$testBit" )]
		public function testBit(v:String, n:uint, result:Boolean):void {
			var R:Boolean = BigInteger.fromString( v ).testBit( n );
			Assert.assertEquals(
				v.toLowerCase() + ' & ( 1 << ' + n + ' ) != 0',
				R, result
			);
		}
		
		//----------------------------------
		//  setBit
		//----------------------------------
		
		public static var $setBit:Array = [
			[ '987654321', 9, '987654321' ],
			[ 'FFFFFFFF111111', 256, '100000000000000000000000000000000000000000000000000FFFFFFFF111111' ],
			[ '12345678', 2, '1234567C' ],
			[ '-123', 90, '-123' ],
			[ '-FFFF', 16, ( (-0xFFFF) | ( 1 << 16 ) ).toString( 16 ) ]
		];
		
		[Test( order="2", dataProvider="$setBit" )]
		public function setBit(v:String, n:uint, result:String):void {
			var R:BigInteger = BigInteger.fromString( v ).setBit( n );
			Assert.assertEquals(
				v.toLowerCase() + ' | ' + '( 1 << ' + n + ' )',
				R.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  clearBit
		//----------------------------------
		
		public static var $clearBit:Array = [
			[ '0', 12, '0' ],
			[ '123', 90, '123' ],
			[ '123', 8, '23' ],
			[ '-123', 90, '-40000000000000000000123' ],
			[ '-FFFF', 16, ( (-0xFFFF) & ~( 1 << 16 ) ).toString( 16 ) ]
		];
		
		[Test( order="3", dataProvider="$clearBit" )]
		public function clearBit(v:String, n:uint, result:String):void {
			var R:BigInteger = BigInteger.fromString( v ).clearBit( n );
			Assert.assertEquals(
				v.toLowerCase() + ' & ~( 1 << ' + n + ' )',
				R.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  flipBit
		//----------------------------------

		public static var $flipBit:Array = [
			[ '00000000', 8, ( 0x00000000 ^ ( 1 << 8 ) ).toString( 16 ) ],
			[ '00000100', 8, ( 0x00000100 ^ ( 1 << 8 ) ).toString( 16 ) ],
			[ '00800000', 11, ( 0x00800000 ^ ( 1 << 11 ) ).toString( 16 ) ],
			[ '00000800', 27, ( 0x00000800 ^ ( 1 << 27 ) ).toString( 16 ) ],
			[ '-00000100', 8, ( (-0x00000100) ^ ( 1 << 8 ) ).toString( 16 ) ],
			[ '-00800000', 11, ( (-0x00800000) ^ ( 1 << 11 ) ).toString( 16 ) ],
			[ '-00000800', 27, ( (-0x00000800) ^ ( 1 << 27 ) ).toString( 16 ) ]
		];
		
		[Test( order="4", dataProvider="$flipBit" )]
		public function flipBit(v:String, n:uint, result:String):void {
			var R:BigInteger = BigInteger.fromString( v ).flipBit( n );
			Assert.assertEquals(
				v.toLowerCase() + ' ^ ( 1 << ' + n + ' )',
				R.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  not
		//----------------------------------
		
		public static var $not:Array = [
			[ '0', '-1' ],
			[ '-1', '0' ],
			[ 'FF00FF00FF00FF00', '-FF00FF00FF00FF01' ],
			[ '-FF00FF00FF00FF01', 'FF00FF00FF00FF00' ],
			[ 'FF00FF00FF00FF', '-FF00FF00FF0100' ],
			[ '-FF00FF00FF0100', 'FF00FF00FF00FF' ]
		];

		[Test( order="5", dataProvider="$not" )]
		public function not(v:String, result:String):void {
			var R:BigInteger = BigInteger.fromString( v ).not();
			Assert.assertEquals(
				'~' + v.toLowerCase(),
				R.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  and
		//----------------------------------
		
		public static var $and:Array = [
			[ '0', '123', '0' ],
			[ '0', '-123', '0' ],
			[ '123', '0', '0' ],
			[ '-123', '0', '0' ],
			[ '-123', '-123', '-123' ],
			[ '9012345678', 'ffffff0000000912345678', '12345678' ],
			[ '9012345678', '-ffffff0000000912345678', '9000000008' ],
			[ '-9012345678', 'ffffff0000000912345678', 'ffffff0000000900000008' ],
			[ '-9012345678', '-ffffff0000000912345678', '-ffffff0000009912345678' ],
			[ 'ffffff0000000912345678', '9012345678', '12345678' ],
			[ 'ffffff0000000912345678', '-9012345678', 'ffffff0000000900000008' ],
			[ '-ffffff0000000912345678', '9012345678', '9000000008' ],
			[ '-ffffff0000000912345678', '-9012345678', '-ffffff0000009912345678' ]
		];
		
		[Test( order="6", dataProvider="$and" )]
		public function and(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1 ).and( BigInteger.fromString( v2 ) ).toString();
			Assert.assertEquals(
				v1.toLowerCase() + ' & ' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  andNot
		//----------------------------------
		
		public static var $andNot:Array = [
			[ '0', '123', '0' ],
			[ '0', '-123', '0' ],
			[ '123', '0', '123' ],
			[ '-123', '0', '-123' ],
			[ '-123', '-123', '0' ],
			[ '9012345678', 'ffffff0000000912345678', '9000000000' ],
			[ '9012345678', '-ffffff0000000912345678', '12345670' ],
			[ '-9012345678', 'ffffff0000000912345678', '-ffffff0000009912345680' ],
			[ '-9012345678', '-ffffff0000000912345678', 'ffffff0000000900000000' ],
			[ 'ffffff0000000912345678', '9012345678', 'ffffff0000000900000000' ],
			[ 'ffffff0000000912345678', '-9012345678', '12345670' ],
			[ '-ffffff0000000912345678', '9012345678', '-ffffff0000009912345680' ],
			[ '-ffffff0000000912345678', '-9012345678', '9000000000' ]
		];
		
		[Test( order="7", dataProvider="$andNot" )]
		public function andNot(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1 ).andNot( BigInteger.fromString( v2 ) ).toString();
			Assert.assertEquals(
				v1.toLowerCase() + ' & ~' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  or
		//----------------------------------
		
		public static var $or:Array = [
			[ '0', '123', '123' ],
			[ '0', '-123', '-123' ],
			[ '123', '0', '123' ],
			[ '-123', '0', '-123' ],
			[ '-123', '-123', '-123' ],
			[ '9012345678', 'ffffff0000000912345678', 'ffffff0000009912345678' ],
			[ '9012345678', '-ffffff0000000912345678', '-ffffff0000000900000008' ],
			[ '-9012345678', 'ffffff0000000912345678', '-9000000008' ],
			[ '-9012345678', '-ffffff0000000912345678', '-12345678' ],
			[ 'ffffff0000000912345678', '9012345678', 'ffffff0000009912345678' ],
			[ 'ffffff0000000912345678', '-9012345678', '-9000000008' ],
			[ '-ffffff0000000912345678', '9012345678', '-ffffff0000000900000008' ],
			[ '-ffffff0000000912345678', '-9012345678', '-12345678' ]
		];
		
		[Test( order="8", dataProvider="$or" )]
		public function or(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1 ).or( BigInteger.fromString( v2 ) ).toString();
			Assert.assertEquals(
				v1.toLowerCase() + ' | ' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  xor
		//----------------------------------
		
		public static var $xor:Array = [
			[ '0', '123', '123' ],
			[ '0', '-123', '-123' ],
			[ '123', '0', '123' ],
			[ '-123', '0', '-123' ],
			[ '-123', '-123', '0' ],
			[ '9012345678', 'ffffff0000000912345678', 'ffffff0000009900000000' ],
			[ '9012345678', '-ffffff0000000912345678', '-ffffff0000009900000010' ],
			[ '-9012345678', 'ffffff0000000912345678', '-ffffff0000009900000010' ],
			[ '-9012345678', '-ffffff0000000912345678', 'ffffff0000009900000000' ],
			[ 'ffffff0000000912345678', '9012345678', 'ffffff0000009900000000' ],
			[ 'ffffff0000000912345678', '-9012345678', '-ffffff0000009900000010' ],
			[ '-ffffff0000000912345678', '9012345678', '-ffffff0000009900000010' ],
			[ '-ffffff0000000912345678', '-9012345678', 'ffffff0000009900000000' ]
		];
		
		[Test( order="9", dataProvider="$xor" )]
		public function xor(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1 ).xor( BigInteger.fromString( v2 ) ).toString();
			Assert.assertEquals(
				v1.toLowerCase() + ' ^ ' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  shiftRight
		//----------------------------------
		
		public static var $shiftRight:Array = [
			[ '0', 123, '0' ],
			[ '123', 0, '123' ],
			[ 'ffffffff', 32, '0' ],
			[ '123ffffffff', 32, '123' ],
			[ '12345678ffffffff', 8, '12345678ffffff' ],
			[ '12345678ffffffff', 33, '91a2b3c' ],
			[ 'f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', 55, '1f24d95a0cab448dcbf43f323159f4fc74b' ],
			[ '-123', 0, '-123' ],
			[ '-ffffffff', 32, '-1' ],
			[ '-123ffffffff', 32, '-124' ],
			[ '-12345678ffffffff', 8, '-12345679000000' ],
			[ '-12345678ffffffff', 33, '-91a2b3d' ],
			[ '-f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', 55, '-1f24d95a0cab448dcbf43f323159f4fc74c' ]
		];
		
		[Test( order="10", dataProvider="$shiftRight" )]
		public function shiftRight(v:String, n:uint, result:String):void {
			var R:String = BigInteger.fromString( v ).shiftRight( n ).toString();
			Assert.assertEquals(
				v.toLowerCase() + ' >> ' + n,
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  shiftLeft
		//----------------------------------
		
		public static var $shiftLeft:Array = [
			[ '0', 123, '0' ],
			[ '123', 0, '123' ],
			[ '12', 123, '90000000000000000000000000000000' ],
			[ '123456', 24, '123456000000' ],
			[ '1234567890', 17, '2468acf1200000' ],
			[ '1234567890', 26, '48d159e240000000' ],
			[ '-123', 0, '-123' ],
			[ '-12', 123, '-90000000000000000000000000000000' ],
			[ '-123456', 24, '-123456000000' ],
			[ '-1234567890', 17, '-2468acf1200000' ],
			[ '-1234567890', 26, '-48d159e240000000' ]
		];
		
		[Test( order="11", dataProvider="$shiftLeft" )]
		public function shiftLeft(v:String, n:uint, result:String):void {
			var R:String = BigInteger.fromString( v ).shiftLeft( n ).toString();
			Assert.assertEquals(
				v.toLowerCase() + ' << ' + n,
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  compare
		//----------------------------------
		
		public static var $compare:Array = [
			[ '-123', '-123', 0 ],
			[ '-123', '0', -1 ],
			[ '-123', '123', -1 ],
			[ '0', '-123', 1 ],
			[ '0', '0', 0 ],
			[ '0', '123', -1 ],
			[ '123', '-123', 1 ],
			[ '123', '0', 1 ],
			[ '123', '123', 0 ],
			[ '987654321', '123456789', 1 ],
			[ '123456789', '987654321', -1 ],
			[ '987654321', '987654321', 0 ]
		];
		
		[Test( order="12", dataProvider="$compare" )]
		public function compare(v1:String, v2:String, result:int):void {
			var F:Function = function(R:int):String {
				if ( R == 1 ) return '>';
				else if ( R == -1 ) return '<';
				else return '==';
			}
			var R:int = BigInteger.fromString( v1 ).compare( BigInteger.fromString( v2 ) );
			Assert.assertEquals(
				v1.toLowerCase() + ' ' + F( R ) + ' ' + v2.toLowerCase(),
				R, result
			);
		}
		
		//----------------------------------
		//  increment
		//----------------------------------
		
		public static var $inc:Array = [
			[ '-1234567800000010', '-123456780000000F' ],
			[ '-100000000', '-FFFFFFFF' ],
			[ '-123', '-122' ],
			[ '-1', '0' ],
			[ '0', '1' ],
			[ '123', '124' ],
			[ 'FFFFFFFF', '100000000' ],
			[ '123456780000000F', '1234567800000010' ]
		];
		
		[Test( order="13", dataProvider="$inc" )]
		public function inc(v:String, result:String):void {
			var R:BigInteger = BigInteger.fromString( v ).inc();
			Assert.assertEquals(
				v.toLowerCase() + '++',
				R.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  add
		//----------------------------------
		
		public static var $add:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '123456', '123', '123579' ],
			[ '654321', '11111234567812345678ffffffffffffffff', '111112345678123456790000000000654320' ],
			[ '654321', 'ffffffffffffffff', '10000000000654320' ],
			[ '0', '-123', '-123' ],
			[ '-123', '0', '-123' ],
			[ '-123456', '-123', '-123579' ],
			[ '-654321', '-11111234567812345678ffffffffffffffff', '-111112345678123456790000000000654320' ],
			[ '-654321', '-ffffffffffffffff', '-10000000000654320' ],
			[ '123456', '-123', '123333' ],
			[ '654321', '-11111234567812345678ffffffffffffffff', '-11111234567812345678ffffffffff9abcde' ],
			[ '654321', '-ffffffffffffffff', '-ffffffffff9abcde' ],
			[ '-123456', '123', '-123333' ],
			[ '-654321', '11111234567812345678ffffffffffffffff', '11111234567812345678ffffffffff9abcde' ],
			[ '-654321', 'ffffffffffffffff', 'ffffffffff9abcde' ]
		];
		
		[Test( order="14", dataProvider="$add" )]
		public function add(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1 ).add( BigInteger.fromString( v2 ) ).toString();
			Assert.assertEquals(
				v1.toLowerCase() + ' + ' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  decrement
		//----------------------------------
		
		public static var $dec:Array = [
			[ '-FFFFFFFF122FFFFFFFF', '-FFFFFFFF12300000000' ],
			[ '-122FFFFFFFF', '-12300000000' ],
			[ '-122', '-123' ],
			[ '0', '-1' ],
			[ '1', '0' ],
			[ '123', '122' ],
			[ '12300000000', '122FFFFFFFF' ],
			[ 'FFFFFFFF12300000000', 'FFFFFFFF122FFFFFFFF' ],
			[ '100000000', 'FFFFFFFF' ]
		];
		
		[Test( order="15", dataProvider="$dec" )]
		public function dec(v:String, result:String):void {
			var R:BigInteger = BigInteger.fromString( v ).dec();
			Assert.assertEquals(
				v.toLowerCase() + '--',
				R.toString().toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  sub
		//----------------------------------
		
		public static var $sub:Array = [
			[ '123', '0', '123' ],
			[ '123', '123', '0' ],
			[ '123', '12', '111' ],
			[ 'ff0000000000000123', 'ffff', 'feffffffffffff0124' ],
			[ 'ff0000000000000123', '122', 'ff0000000000000001' ],
			[ 'ff00000123', '122', 'ff00000001' ],
			[ '-123', '0', '-123' ],
			[ '-123', '-123', '0' ],
			[ '-123', '-12', '-111' ],
			[ '-ff0000000000000123', '-ffff', '-feffffffffffff0124' ],
			[ '-ff0000000000000123', '-122', '-ff0000000000000001' ],
			[ '-ff00000123', '-122', '-ff00000001' ],
			[ 'ff0000000000000123', '-ffff', 'ff0000000000010122' ],
			[ 'ff0000000000000123', '-122', 'ff0000000000000245' ],
			[ 'ff00000123', '-122', 'ff00000245' ],
			[ '-ff0000000000000123', 'ffff', '-ff0000000000010122' ],
			[ '-ff0000000000000123', '122', '-ff0000000000000245' ],
			[ '-ff00000123', '122', '-ff00000245' ]
		];
		
		[Test( order="17", dataProvider="$sub" )]
		public function sub(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1 ).sub( BigInteger.fromString( v2 ) ).toString();
			Assert.assertEquals(
				v1.toLowerCase() + ' - ' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  mult
		//----------------------------------
		
		public static var $mul:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '0' ],
			[ '1', '123456', '123456' ],
			[ '123456', '1', '123456' ],
			[ '400000000', '100', '40000000000' ],
			[ '400000000', '3', 'c00000000' ],
			[ '3', '400000000', 'c00000000' ],
			[ '1f24d95a0cab448dcbf43f323159f4fc74b', '80000000000000', 'f926cad0655a246e5fa1f9918acfa7e3a580000000000000' ],
			[ '123', '12', '1476' ],
			[ '123f77ffffff6', '13', '15ab5e7fffff42' ],
			[ '13', '123f77ffffff6', '15ab5e7fffff42' ],
			[ 'ffff0000', '11110000', '1110eeef00000000' ],
			[ 'ffff1111', '11110000', '1110f01243210000' ],
			[ '6ffffff77f321', '123f77ffffff6', '7fbc47f64d5901167855080b6' ],
			[ 'ffffffffffffffffffffffffffffffff', 'ffffffffffffffffffffffffffffffff', 'fffffffffffffffffffffffffffffffe00000000000000000000000000000001' ],
			[ '0', '-123', '0' ],
			[ '-123', '0', '0' ],
			[ '-1', '-123456', '123456' ],
			[ '-123456', '-1', '123456' ],
			[ '-400000000', '-100', '40000000000' ],
			[ '-400000000', '-3', 'c00000000' ],
			[ '-3', '-400000000', 'c00000000' ],
			[ '-1f24d95a0cab448dcbf43f323159f4fc74b', '-80000000000000', 'f926cad0655a246e5fa1f9918acfa7e3a580000000000000' ],
			[ '-123', '-12', '1476' ],
			[ '-123f77ffffff6', '-13', '15ab5e7fffff42' ],
			[ '-13', '-123f77ffffff6', '15ab5e7fffff42' ],
			[ '-ffff0000', '-11110000', '1110eeef00000000' ],
			[ '-ffff1111', '-11110000', '1110f01243210000' ],
			[ '-6ffffff77f321', '-123f77ffffff6', '7fbc47f64d5901167855080b6' ],
			[ '-ffffffffffffffffffffffffffffffff', '-ffffffffffffffffffffffffffffffff', 'fffffffffffffffffffffffffffffffe00000000000000000000000000000001' ],
			[ '1', '-123456', '-123456' ],
			[ '123456', '-1', '-123456' ],
			[ '400000000', '-100', '-40000000000' ],
			[ '400000000', '-3', '-c00000000' ],
			[ '3', '-400000000', '-c00000000' ],
			[ '1f24d95a0cab448dcbf43f323159f4fc74b', '-80000000000000', '-f926cad0655a246e5fa1f9918acfa7e3a580000000000000' ],
			[ '123', '-12', '-1476' ],
			[ '123f77ffffff6', '-13', '-15ab5e7fffff42' ],
			[ '13', '-123f77ffffff6', '-15ab5e7fffff42' ],
			[ 'ffff0000', '-11110000', '-1110eeef00000000' ],
			[ 'ffff1111', '-11110000', '-1110f01243210000' ],
			[ '6ffffff77f321', '-123f77ffffff6', '-7fbc47f64d5901167855080b6' ],
			[ 'ffffffffffffffffffffffffffffffff', '-ffffffffffffffffffffffffffffffff', '-fffffffffffffffffffffffffffffffe00000000000000000000000000000001' ],
			[ '-1', '123456', '-123456' ],
			[ '-123456', '1', '-123456' ],
			[ '-400000000', '100', '-40000000000' ],
			[ '-400000000', '3', '-c00000000' ],
			[ '-3', '400000000', '-c00000000' ],
			[ '-1f24d95a0cab448dcbf43f323159f4fc74b', '80000000000000', '-f926cad0655a246e5fa1f9918acfa7e3a580000000000000' ],
			[ '-123', '12', '-1476' ],
			[ '-123f77ffffff6', '13', '-15ab5e7fffff42' ],
			[ '-13', '123f77ffffff6', '-15ab5e7fffff42' ],
			[ '-ffff0000', '11110000', '-1110eeef00000000' ],
			[ '-ffff1111', '11110000', '-1110f01243210000' ],
			[ '-6ffffff77f321', '123f77ffffff6', '-7fbc47f64d5901167855080b6' ],
			[ '-ffffffffffffffffffffffffffffffff', 'ffffffffffffffffffffffffffffffff', '-fffffffffffffffffffffffffffffffe00000000000000000000000000000001' ]
		];
		
		[Test( order="19", dataProvider="$mul" )]
		public function mul(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1 ).mul( BigInteger.fromString( v2 ) ).toString();
			Assert.assertEquals(
				v1.toLowerCase() + ' * ' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  powInt
		//----------------------------------
		
		public static var $powInt:Array = [
			[ '123', 0x0, '1' ],
			[ '0', 0x5, '0' ],
			[ '123', 0x1, '123' ],
			[ '123', 0x41, '10304172a4351fa752179292cd2b73911b68e75b3b0016f3c17cd6bc645b8938c2e8c3d82c4ecab4f0da6a3f5707948149db3ddd98090dea8dccbebf441af13a76a023' ],
			[ 'fffff', 0x6, 'ffffa0000efffec0000effffa00001' ],
			[ '3', 0xff, '11f1b08e87ec42c5d83c3218fc83c41dcfd9f4428f4f92af1aaa80aa46162b1f71e981273601f4ad1dd4709b5aca650265a6ab' ],
			[ 'f00', 0x4d, '1c744e6621724dba25aea0207a6c11c8a22b3801df5b01f8658653f5f67a653a1c09c70576cf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ],
			[ '-123', 0x1, '-123' ],
			[ '-123', 0x41, '-10304172a4351fa752179292cd2b73911b68e75b3b0016f3c17cd6bc645b8938c2e8c3d82c4ecab4f0da6a3f5707948149db3ddd98090dea8dccbebf441af13a76a023' ],
			[ '-fffff', 0x6, 'ffffa0000efffec0000effffa00001' ],
			[ '-3', 0xff, '-11f1b08e87ec42c5d83c3218fc83c41dcfd9f4428f4f92af1aaa80aa46162b1f71e981273601f4ad1dd4709b5aca650265a6ab' ],
			[ '-f00', 0x4d, '-1c744e6621724dba25aea0207a6c11c8a22b3801df5b01f8658653f5f67a653a1c09c70576cf0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ]
		];
		
		[Test( order="20", dataProvider="$powInt" )]
		public function powInt(v:String, e:uint, result:String):void {
			var R:String = BigInteger.fromString( v ).powInt( e ).toString();
			Assert.assertEquals(
				'pow( ' + v.toLowerCase() + ', ' + e + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  divAndMod
		//----------------------------------
		
		public static var $divAndMod:Array = [
			[ '0', '123', '0', '0' ],
			[ '1234', '123456789', '0', '1234' ],
			[ '123', '1', '123', '0' ],
			[ '123', '123', '1', '0' ],
			[ '12', '123', '0', '12' ],
			[ '6f9', '7', 'ff', '0' ],
			[ '14eb', '8', '29d', '3' ],
			[ '123456789', '1', '123456789', '0' ],
			[ 'f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '80000000000000', '1f24d95a0cab448dcbf43f323159f4fc74b', '4066275d342e9f' ],
			[ '123456789', '3', '61172283', '0' ],
			[ '123456789', '7', '299c335c', '5' ],
			[ '1234567890ffffffff', 'ffffffffffff', '123456', '789100123455' ],
			[ '1234567890ffffffff', '9876543210', '1e9131ab', '859d1d7f4f' ],
			[ '1234567890ffffffff', '1234567890', '100000000', 'ffffffff' ],
			[ 'f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '320a7bd3df175319', '4fa9ca4ad127067c933000454773cd53c', '23f44e9492bce7c3' ],
			[ '0', '-123', '0', '0' ],
			[ '-1234', '-123456789', '0', '-1234' ],
			[ '-123', '-1', '123', '0' ],
			[ '-123', '-123', '1', '0' ],
			[ '-12', '-123', '0', '-12' ],
			[ '-6f9', '-7', 'ff', '0' ],
			[ '-14eb', '-8', '29d', '-3' ],
			[ '-123456789', '-1', '123456789', '0' ],
			[ '-f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '-80000000000000', '1f24d95a0cab448dcbf43f323159f4fc74b', '-4066275d342e9f' ],
			[ '-123456789', '-3', '61172283', '0' ],
			[ '-123456789', '-7', '299c335c', '-5' ],
			[ '-1234567890ffffffff', '-ffffffffffff', '123456', '-789100123455' ],
			[ '-1234567890ffffffff', '-9876543210', '1e9131ab', '-859d1d7f4f' ],
			[ '-1234567890ffffffff', '-1234567890', '100000000', '-ffffffff' ],
			[ '-f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '-320a7bd3df175319', '4fa9ca4ad127067c933000454773cd53c', '-23f44e9492bce7c3' ],
			[ '1234', '-123456789', '0', '1234' ],
			[ '123', '-1', '-123', '0' ],
			[ '123', '-123', '-1', '0' ],
			[ '12', '-123', '0', '12' ],
			[ '6f9', '-7', '-ff', '0' ],
			[ '14eb', '-8', '-29d', '3' ],
			[ '123456789', '-1', '-123456789', '0' ],
			[ 'f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '-80000000000000', '-1f24d95a0cab448dcbf43f323159f4fc74b', '4066275d342e9f' ],
			[ '123456789', '-3', '-61172283', '0' ],
			[ '123456789', '-7', '-299c335c', '5' ],
			[ '1234567890ffffffff', '-ffffffffffff', '-123456', '789100123455' ],
			[ '1234567890ffffffff', '-9876543210', '-1e9131ab', '859d1d7f4f' ],
			[ '1234567890ffffffff', '-1234567890', '-100000000', 'ffffffff' ],
			[ 'f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '-320a7bd3df175319', '-4fa9ca4ad127067c933000454773cd53c', '23f44e9492bce7c3' ],
			[ '-1234', '123456789', '0', '-1234' ],
			[ '-123', '1', '-123', '0' ],
			[ '-123', '123', '-1', '0' ],
			[ '-12', '123', '0', '-12' ],
			[ '-6f9', '7', '-ff', '0' ],
			[ '-14eb', '8', '-29d', '-3' ],
			[ '-123456789', '1', '-123456789', '0' ],
			[ '-f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '80000000000000', '-1f24d95a0cab448dcbf43f323159f4fc74b', '-4066275d342e9f' ],
			[ '-123456789', '3', '-61172283', '0' ],
			[ '-123456789', '7', '-299c335c', '-5' ],
			[ '-1234567890ffffffff', 'ffffffffffff', '-123456', '-789100123455' ],
			[ '-1234567890ffffffff', '9876543210', '-1e9131ab', '-859d1d7f4f' ],
			[ '-1234567890ffffffff', '1234567890', '-100000000', '-ffffffff' ],
			[ '-f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', '320a7bd3df175319', '-4fa9ca4ad127067c933000454773cd53c', '-23f44e9492bce7c3' ]
		];
		
		[Test( order="21", dataProvider="$divAndMod" )]
		public function divAndMod(v:String, m:String, result:String, rest:String):void {
			var R:Vector.<BigInteger> = BigInteger.fromString( v ).divAndMod( BigInteger.fromString( m ) );
			Assert.assertEquals(
				v.toLowerCase() + ' / ' + m.toLowerCase(),
				R.join( ',' ).toString().toLowerCase(), [ result, rest ].join( ',' ).toLowerCase()
			);
		}
		
		//----------------------------------
		//  divAndMod_error
		//----------------------------------
		
		public static var $divAndMod_error:Array = [
			[ '123456', '0' ]
		];
		
		[Test( order="22", dataProvider="$divAndMod_error", expects="ArgumentError" )]
		public function divAndMod_error(v:String, m:String):void {
			BigInteger.fromString( v ).divAndMod( BigInteger.fromString( m ) )
		}
		
		//----------------------------------
		//  div
		//----------------------------------
		
		[Test( order="23", dataProvider="$divAndMod" )]
		public function div(v:String, m:String, result:String, rest:String):void {
			var R:String = BigInteger.fromString( v ).div( BigInteger.fromString( m ) ).toString();
			Assert.assertEquals(
				v.toLowerCase() + ' / ' + m.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  div_error
		//----------------------------------
		
		[Test( order="24", dataProvider="$divAndMod_error", expects="ArgumentError" )]
		public function div_error(v:String, m:String):void {
			BigInteger.fromString( v ).div( BigInteger.fromString( m ) )
		}
		
		//----------------------------------
		//  mod
		//----------------------------------
		
		[Test( order="25", dataProvider="$divAndMod" )]
		public function mod(v:String, m:String, result:String, rest:String):void {
			var R:String = BigInteger.fromString( v ).mod( BigInteger.fromString( m ) ).toString();
			Assert.assertEquals(
				v.toLowerCase() + ' % ' + m.toLowerCase(),
				R.toLowerCase(), rest.toLowerCase()
			);
		}
		
		//----------------------------------
		//  mod_error
		//----------------------------------
		
		[Test( order="26", dataProvider="$divAndMod_error", expects="ArgumentError" )]
		public function mod_error(v:String, m:String):void {
			BigInteger.fromString( v ).mod( BigInteger.fromString( m ) )
		}
		
		//----------------------------------
		//  modPow
		//----------------------------------
		
		public static var $modPow:Array = [
			[ '0', '7B', '123', '0' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '1', '1873618', '561397' ],
			[ '123', '7B', '1', '0' ],
			[ '1', '7B', '123', '1' ],
			[ '123', '0', '123', '1' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400', '1267', 'b83' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400', '1873618', '9679' ],
			[ '1234', '43', '1873618', '7ed7d8' ],
			[ '1234', '43', '9832982309712532378643', '126ecd88d701d98ea61f4d' ],
			[ '1989746288117', '3039', '9832982309712532378643', '48a7483ca7ab708cdb412f' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '100E', '9832982309712532378643', '65076beaec746d529526e2' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '100E', '31277332fa4a8c2d', '1728dfa593045a85' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '400', '31277332fa4a8c2d', '14222a18073275b4' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400', '9832982309712532378643', '139d30ff985d42243a7432' ],
			[ '1989746288117', '303930393039', '9832982309712532378643', '1790cbdddcb66f5c389557' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '100E100E100E', '9832982309712532378643', '3834a321291e8cf75de38' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '100E100E100E', '31277332FA4A8C2D', '74de237ea79016e' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '400400400', '31277332fa4a8c2d', 'c9b06956092e766' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400400400', '9832982309712532378643', '12623b7f5433e8c64fcc9d' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', 'b41ef633dcf80686', '31277332fa4a8c2d', '2620ce0973b52dbb' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', 'b41ef633dcf80686', '9832982309712532378643', '5a786ece858b1f725ff591' ]
		];
		
		[Test( order="27", dataProvider="$modPow" )]
		public function modPow(v:String, e:String, m:String, result:String):void {
			var R:String = BigInteger.fromString( v ).modPow( BigInteger.fromString( e ), BigInteger.fromString( m ) ).toString();
			Assert.assertEquals(
				'pow( ' + v.toLowerCase() + ', ' + e.toLowerCase() + ' ) % ' + m.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  modPow_error
		//----------------------------------

		public static var $modPow_error:Array = [
			[ '1', '1', '0' ]
		];

		[Test( order="28", dataProvider="$modPow_error", expects="ArgumentError" )]
		public function modPow_error(v:String, e:String, m:String):void {
			BigInteger.fromString( v ).modPow( BigInteger.fromString( e ), BigInteger.fromString( m ) );
		}
		
		//----------------------------------
		//  modInv
		//----------------------------------

		public static var $modInv:Array = [
			[ '1', 'e14f', '1' ],
			[ 'e14f', '1', '0' ],
			[ '-1', 'e14f', 'e14e' ],
			[ '1586e', 'e14f', '7bfc' ],
			[ 'eccdae67', 'e14f', '52f4' ],
			[ '145efeca3', 'e14f', '48cb' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'e14f', 'ab38' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'e14f', '9fe1' ],
			[ 'e14f', '1586e', '9ae5' ],
			[ 'eccdae67', '1586e', '12eff' ],
			[ '145efeca3', '1586e', '560d' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '1586e', '6f6f' ],
			[ 'e14f', 'eccdae67', '959e4202' ],
			[ '1586e', 'eccdae67', '1c7c8f53' ],
			[ '145efeca3', 'eccdae67', '5f8c0dd2' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'eccdae67', '9f899f6c' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'eccdae67', '9fe20abc' ],
			[ 'e14f', '145efeca3', 'dca20de3' ],
			[ '1586e', '145efeca3', 'f481aa2e' ],
			[ 'eccdae67', '145efeca3', 'c26d0220' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '145efeca3', '856e5938' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '145efeca3', '45b6b7d5' ],
			[ 'e14f', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '327f82c50c4d3d7897dcfa31c089b128b61c13e27e7999131ebf30ec5314c7a0' ],
			[ '1586e', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '8e4b224873c5b5105dd01e56db44b5c16ffcdf74bde51ad27c43a309a998171c' ],
			[ 'eccdae67', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '44a231711a54743808d50cf0abf042d75d28f0e27f72f6d71dbeb57d16cbe83c' ],
			[ '145efeca3', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '7c3c6e3c42747a3f4e531f9f02269b3c4c9376c0d701109327518a3faae80fdc' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'd00324f2d4e8765986748d525e3b7519e07ffd758fcaacd0607403a273f0c9dd' ],
			[ 'e14f', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '319df884c124004c51f433f4bca5035e470b29f40536515c65ed6d8089a1b753' ],
			[ 'eccdae67', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '377fd5da5a9c50c67689155e2d07b69c5ea1e38bffd84c5d33efe92617e5e0b1' ],
			[ '145efeca3', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '8650344cdf7991778373880a9ca03a9119639dc9597b16e6a90374513a0d26ff' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '1e58bb4bf76ac0e0a52e921a619170cff71ac1fc33e846e8707ec1269ad82c1' ],
			[ '-1586e', 'e14f', '6553' ],
			[ '-eccdae67', 'e14f', '8e5b' ],
			[ '-145efeca3', 'e14f', '9884' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'e14f', '3617' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'e14f', '416e' ],
			[ '-e14f', '1586e', 'bd89' ],
			[ '-eccdae67', '1586e', '296f' ],
			[ '-145efeca3', '1586e', '10261' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '1586e', 'e8ff' ],
			[ '-e14f', 'eccdae67', '572f6c65' ],
			[ '-1586e', 'eccdae67', 'd0511f14' ],
			[ '-145efeca3', 'eccdae67', '8d41a095' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'eccdae67', '4d440efb' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'eccdae67', '4ceba3ab' ],
			[ '-e14f', '145efeca3', '694ddec0' ],
			[ '-1586e', '145efeca3', '516e4275' ],
			[ '-eccdae67', '145efeca3', '8382ea83' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '145efeca3', 'c081936b' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '145efeca3', '1003934ce' ],
			[ '-e14f', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '9fd966ecf1efa335bd96b881d484bb68d137ea32400edc821c9712a0a4c84b59' ],
			[ '-1586e', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '440dc7698a772b9df7a3945cb9c9b6d017571ea000a35ac2bf12a0834e44fbdd' ],
			[ '-eccdae67', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '8db6b840e3e86c764c9ea5c2e91e29ba2a2b0d323f157ebe1d978e0fe1112abd' ],
			[ '-145efeca3', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '561c7b75bbc8666f0720931492e7d1553ac08753e78765021404b94d4cf5031d' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '255c4bf29546a54ceff256136d2f777a6d4009f2ebdc8c4dae23fea83ec491c' ],
			[ '-e14f', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '793d8cca5d47052924a154fca82f59b50c919eb61973b7571be89897aa7ab24f' ],
			[ '-eccdae67', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '735baf74c3ceb4af000c739337cca676f4fae51e1ed1bc564de61cf21c3688f1' ],
			[ '-145efeca3', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '248b51023ef173fdf32200e6c83422823a392ae0c52ef1ccd8d291c6fa0f42a3' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'a8f5f99a5ef459676c429fcfbebb4606542b1c8a5b6b8444face1a05ca6ee6e1' ],
		];

		[Test( order="29", dataProvider="$modInv" )]
		public function modInv(v:String, m:String, result:String):void {
			var R:String = BigInteger.fromString( v ).modInv( BigInteger.fromString( m ) ).toString();
			Assert.assertEquals(
				'1 / ' + v.toLowerCase() + ' % ' + m.toLowerCase(),
				R.toLowerCase()
			);
		}
		
		//----------------------------------
		//  modInv_error
		//----------------------------------
		
		public static var $modInv_error:Array = [
			[ '1', '0' ],
			[ 'e14f', '-1' ],
			[ '0', 'e14f' ],
			[ '0', '-e14f' ],
			[ 'e14f', 'e14f' ],
			[ '1586e', '1586e' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '1586e' ],
			[ 'eccdae67', 'eccdae67' ],
			[ '145efeca3', '145efeca3' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '1586e', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ 'e14f', '-e14f' ],
			[ '1586e', '-e14f' ],
			[ 'eccdae67', '-e14f' ],
			[ '145efeca3', '-e14f' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-e14f' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-e14f' ],
			[ 'e14f', '-1586e' ],
			[ '1586e', '-1586e' ],
			[ 'eccdae67', '-1586e' ],
			[ '145efeca3', '-1586e' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-1586e' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-1586e' ],
			[ 'e14f', '-eccdae67' ],
			[ '1586e', '-eccdae67' ],
			[ 'eccdae67', '-eccdae67' ],
			[ '145efeca3', '-eccdae67' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-eccdae67' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-eccdae67' ],
			[ 'e14f', '-145efeca3' ],
			[ '1586e', '-145efeca3' ],
			[ 'eccdae67', '-145efeca3' ],
			[ '145efeca3', '-145efeca3' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-145efeca3' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-145efeca3' ],
			[ 'e14f', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '1586e', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ 'eccdae67', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '145efeca3', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ 'e14f', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '1586e', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ 'eccdae67', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '145efeca3', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-e14f', 'e14f' ],
			[ '-1586e', '1586e' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '1586e' ],
			[ '-eccdae67', 'eccdae67' ],
			[ '-145efeca3', '145efeca3' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '-1586e', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-e14f', '-e14f' ],
			[ '-1586e', '-e14f' ],
			[ '-eccdae67', '-e14f' ],
			[ '-145efeca3', '-e14f' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-e14f' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-e14f' ],
			[ '-e14f', '-1586e' ],
			[ '-1586e', '-1586e' ],
			[ '-eccdae67', '-1586e' ],
			[ '-145efeca3', '-1586e' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-1586e' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-1586e' ],
			[ '-e14f', '-eccdae67' ],
			[ '-1586e', '-eccdae67' ],
			[ '-eccdae67', '-eccdae67' ],
			[ '-145efeca3', '-eccdae67' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-eccdae67' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-eccdae67' ],
			[ '-e14f', '-145efeca3' ],
			[ '-1586e', '-145efeca3' ],
			[ '-eccdae67', '-145efeca3' ],
			[ '-145efeca3', '-145efeca3' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-145efeca3' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-145efeca3' ],
			[ '-e14f', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '-1586e', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '-eccdae67', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '-145efeca3', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '-e14f', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-1586e', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-eccdae67', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-145efeca3', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-d258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '-aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
		];
		
		[Test( order="30", dataProvider="$modInv_error", expects="ArgumentError" )]
		public function modInv_error(v:String, m:String):void {
			BigInteger.fromString( v ).modInv( BigInteger.fromString( m ) )
		}
		
		//----------------------------------
		//  isProbablePrime
		//----------------------------------
		
		public static var $isProbablePrime:Array = [
			[ 'e14f', 100, true ],
			[ 'eccdae67', 100, true ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 100, true ],
			[ '9814b69b58eb83c8a43eda490eb435d449f9e007504658dc09fa6108de5de7b6473e1873e5e5ad43ab39fc082c18611c2e1a0292fddab31e552ad8593366105f', 100, true ],
			[ '92cd745064716d98e61028b7c30b2eb78859e9fa79bebcfa9d8bffd17c89a4af1608bf47aea1c263a8f5c996cac8741962bb838cd66c96424b20d4027022f9bbaf7567d472b2e1a00e0e0367c23a078dbe188bdc469b8b78c45a1a0d56e30dad7237716f28814b7ac89fb20efbe3c2b2b2dd77991ae349cd89587be2eade30db', 100, true ],
			[ '1586e', 100, false ],
			[ '145efeca3', 100, false ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 100, false ],
			[ '566a649fadf8d776e57029cb357f9552b42a6c17c1f712d162eb623ee72160d0c3c57c9c1db8d2711b2c5b1880ba5857c2b9a037cb9a1dce10028ba78ba8c238', 100, false ],
			[ '57192bdb901752cc061a4f6a41f9c52495ce5cf1ef102a887bca3d3b099747ad170664e989c3e8ee37c307c56225fb41cc688c87fe69b669735e82baf2320a3f6ca583ff8d1911ac52adc616d18a7a27cff1ff2b3c24013e2a6215709f3a21cdd55c368b77d6b090b7f20c25ff8010109b17121cb0376eaa626cdbad0ca85a799', 100, false ],
		];
		
		[Test( order="33", dataProvider="$isProbablePrime" )]
		public function isProbablePrime(v:String, certainty:int, result:Boolean):void {
			var R:Boolean = BigInteger.fromString( v ).isProbablePrime( certainty );
			Assert.assertEquals( R, result );
		}

	}
	
}