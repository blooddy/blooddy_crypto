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
		
	}
	
}