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
		
		[Test( order="-3", dataProvider="$fromString" )]
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

		[Test( order="-2", dataProvider="$fromNumber" )]
		public function fromNumber(v:Number):void {
			var bi:BigInteger = BigInteger.fromNumber( v );
			Assert.assertEquals(
				bi.toString( 16 ), v.toString( 16 )
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
		
		[Test( order="-1", dataProvider="$fromVector" )]
		public function fromVector(v:Vector.<uint>, negative:Boolean, result:String):void {
			var bi:BigInteger = BigInteger.fromVector( v, negative );
			Assert.assertEquals(
				bi.toString( 16 ).toLowerCase(), result.toLowerCase()
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
		
		[Test( order="0", dataProvider="$negate" )]
		public function negate(v:String, result:String):void {
			var R:BigInteger = BigInteger.fromString( v, 16 ).negate();
			Assert.assertEquals(
				'-0x' + v.toLowerCase(),
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
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
			var R:Boolean = BigInteger.fromString( v, 16 ).testBit( n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ( 1 << ' + n + ' ) != 0',
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
			var R:BigInteger = BigInteger.fromString( v, 16 ).setBit( n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' | ' + '( 1 << ' + n + ' )',
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
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
			var R:BigInteger = BigInteger.fromString( v, 16 ).clearBit( n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ~( 1 << ' + n + ' )',
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
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
			var R:BigInteger = BigInteger.fromString( v, 16 ).flipBit( n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' ^ ( 1 << ' + n + ' )',
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
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
			var R:BigInteger = BigInteger.fromString( v, 16 ).not();
			Assert.assertEquals(
				'~0x' + v.toLowerCase(),
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
		
		[Test( order="12", dataProvider="$compare" )]
		public function compare(v1:String, v2:String, result:int):void {
			var F:Function = function(R:int):String {
				if ( R == 1 ) return '>';
				else if ( R == -1 ) return '<';
				else return '==';
			}
			var R:int = BigInteger.fromString( v1, 16 ).compare( BigInteger.fromString( v2, 16 ) );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' ' + F( R ) + ' 0x' + v2.toLowerCase(),
				R, result
			);
		}
		
	}
	
}