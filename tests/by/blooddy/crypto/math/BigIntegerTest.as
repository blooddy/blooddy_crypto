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

	}
	
}