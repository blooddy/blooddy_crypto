////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.math {
	
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
		//  negate
		//----------------------------------
		
		public static var $negate:Array = [
			[ '0', '0' ],
			[ 'FF00FF00FF00FF', '-FF00FF00FF00FF' ],
			[ '-FF00FF00FF00FF', 'FF00FF00FF00FF' ]
		];
		
		[Test( dataProvider="$negate" )]
		public function negate(v:String, result:String):void {
			var R:String = BigInteger.fromString( v, 16 ).negate().toString( 16 );
			Assert.assertEquals(
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
		
		[Test( dataProvider="$compare" )]
		public function compare(v1:String, v2:String, result:int):void {
			var R:int = BigInteger.fromString( v1, 16 ).compare( BigInteger.fromString( v2, 16 ) );
			Assert.assertEquals(
				R, result
			);
		}
		
		//----------------------------------
		//  inc
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
		
		[Test( dataProvider="$inc" )]
		public function inc(v:String, result:String):void {
			var R:String = BigInteger.fromString( v, 16 ).inc().toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  dec
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
		
		[Test( dataProvider="$dec" )]
		public function dec(v:String, result:String):void {
			var R:String = BigInteger.fromString( v, 16 ).dec().toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
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
		
		[Test( dataProvider="$add" )]
		public function add(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1, 16 ).add( BigInteger.fromString( v2, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
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
		
		[Test( dataProvider="$sub" )]
		public function sub(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1, 16 ).sub( BigInteger.fromString( v2, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  mul
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
		
		[Test( dataProvider="$mul" )]
		public function mul(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1, 16 ).mul( BigInteger.fromString( v2, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  div
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
		
		[Test( dataProvider="$divAndMod" )]
		public function div(v:String, m:String, result:String, rest:String):void {
			var R:String = BigInteger.fromString( v, 16 ).div( BigInteger.fromString( m, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		[Test( dataProvider="$divAndMod" )]
		public function mod(v:String, m:String, result:String, rest:String):void {
			var R:String = BigInteger.fromString( v, 16 ).mod( BigInteger.fromString( m, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), rest.toLowerCase()
			);
		}

		[Test( dataProvider="$divAndMod" )]
		public function divAndMod(v:String, m:String, result:String, rest:String):void {
			var R:Vector.<BigInteger> = BigInteger.fromString( v, 16 ).divAndMod( BigInteger.fromString( m, 16 ) );
			Assert.assertEquals(
				[ R[ 0 ].toString( 16 ), R[ 1 ].toString( 16 ) ].join( ',' ).toString().toLowerCase(),
				[ result, rest ].join( ',' ).toLowerCase()
			);
		}

		//----------------------------------
		//  pow
		//----------------------------------
		
		public static var $pow:Array = [
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
		
		[Test( dataProvider="$pow" )]
		public function pow(v:String, e:uint, result:String):void {
			var R:String = BigInteger.fromString( v, 16 ).pow( e ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  testBit
		//----------------------------------
		
		public static var $getBitLength:Array = [
			[ '0', 0 ],
			[ 'FF', 8 ],
			[ '123', 9 ],
			[ 'FF00123', 28 ],
			[ '123F77F1F3F5F', 49 ],
			[ 'FF00000000', 40 ]
		];
		
		[Test( dataProvider="$getBitLength" )]
		public function getBitLength(v:String, result:uint):void {
			var R:uint = BigInteger.fromString( v, 16 ).bitLength;
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
			[ '100000', 20, true ]
		];
		
		[Test( dataProvider="$testBit" )]
		public function testBit(v:String, n:uint, result:Boolean):void {
			var R:Boolean = BigInteger.fromString( v ).testBit( n );
			Assert.assertEquals(
				R, result
			);
		}
		
		//----------------------------------
		//  flipBit
		//----------------------------------
		
		public static var $flipBit:Array = [
			[ '00000000', 8, ( 0x00000000 ^ ( 1 << 8 ) ).toString( 16 ) ],
			[ '00000100', 8, ( 0x00000100 ^ ( 1 << 8 ) ).toString( 16 ) ],
			[ '00800000', 11, ( 0x00800000 ^ ( 1 << 11 ) ).toString( 16 ) ],
			[ '00000800', 27, ( 0x00000800 ^ ( 1 << 27 ) ).toString( 16 ) ]
		];
		
		[Test( dataProvider="$flipBit" )]
		public function flipBit(v:String, n:uint, result:String):void {
			var R:BigInteger = BigInteger.fromString( v, 16 ).flipBit( n );
			Assert.assertEquals(
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  setBit
		//----------------------------------
		
		public static var $setBit:Array = [
			[ '987654321', 9, '987654321' ],
			[ 'FFFFFFFF111111', 256, '100000000000000000000000000000000000000000000000000FFFFFFFF111111' ],
			[ '12345678', 2, '1234567C' ]
		];
		
		[Test( dataProvider="$setBit" )]
		public function setBit(v:String, n:uint, result:String):void {
			var R:BigInteger = BigInteger.fromString( v, 16 ).setBit( n );
			Assert.assertEquals(
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  clearBit
		//----------------------------------
		
		public static var $clearBit:Array = [
			[ '0', 12, '0' ],
			[ '123', 90, '123' ],
			[ '123', 8, '23' ]
		];
		
		[Test( dataProvider="$clearBit" )]
		public function clearBit(v:String, n:uint, result:String):void {
			var R:BigInteger = BigInteger.fromString( v, 16 ).clearBit( n );
			Assert.assertEquals(
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  and
		//----------------------------------
		
		public static var $and:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '0' ],
			[ '9012345678', 'ffffff0000000912345678', '12345678' ],
			[ 'ffffff0000000912345678', '9012345678', '12345678' ],
		];
		
		[Test( dataProvider="$and" )]
		public function and(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1, 16 ).and( BigInteger.fromString( v2, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  andNot
		//----------------------------------
		
		public static var $andNot:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '123' ],
			[ '9012345678', 'ffffff0000000912345678', '9000000000' ],
			[ 'ffffff0000000912345678', '9012345678', 'ffffff0000000900000000' ],
		];
		
		[Test( dataProvider="$andNot" )]
		public function andNot(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1, 16 ).andNot( BigInteger.fromString( v2, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  or
		//----------------------------------
		
		public static var $or:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '9012345678', 'ffffff0000000912345678', 'ffffff0000009912345678' ],
			[ 'ffffff0000000912345678', '9012345678', 'ffffff0000009912345678' ],
		];
		
		[Test( dataProvider="$or" )]
		public function or(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1, 16 ).or( BigInteger.fromString( v2, 16 ) ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  xor
		//----------------------------------
		
		public static var $xor:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '9012345678', 'ffffff0000000912345678', 'ffffff0000009900000000' ],
			[ 'ffffff0000000912345678', '9012345678', 'ffffff0000009900000000' ],
		];
		
		[Test( dataProvider="$xor" )]
		public function xor(v1:String, v2:String, result:String):void {
			var R:String = BigInteger.fromString( v1, 16 ).xor( BigInteger.fromString( v2, 16 ) ).toString( 16 );
			Assert.assertEquals(
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
			[ 'f926cad0655a246e5fa1f9918acfa7e3a5c066275d342e9f', 55, '1f24d95a0cab448dcbf43f323159f4fc74b' ]
		];
		
		[Test( order="10", dataProvider="$shiftRight" )]
		public function shiftRight(v:String, n:uint, result:String):void {
			var R:String = BigInteger.fromString( v, 16 ).shiftRight( n ).toString( 16 );
			Assert.assertEquals(
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
			[ '1234567890', 26, '48d159e240000000' ]
		];
		
		[Test( dataProvider="$shiftLeft" )]
		public function shiftLeft(v:String, n:uint, result:String):void {
			var R:String = BigInteger.fromString( v, 16 ).shiftLeft( n ).toString( 16 );
			Assert.assertEquals(
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
	}
	
}