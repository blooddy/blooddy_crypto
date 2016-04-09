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
			var R:BigInteger = BigInteger.fromString( v, 16 ).negate();
			Assert.assertEquals(
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
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
			var R:BigInteger = BigInteger.fromString( v, 16 ).inc();
			Assert.assertEquals(
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
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
			var R:BigInteger = BigInteger.fromString( v, 16 ).dec();
			Assert.assertEquals(
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
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
			var R:BigInteger = BigInteger.fromString( v1, 16 ).add( BigInteger.fromString( v2, 16 ) );
			Assert.assertEquals(
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
			);
		}
		
	}
	
}