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
		//  testBit
		//----------------------------------
		
		public static var $testBit:Array = BigUintTest.$testBit;
		
		[Test( order="1", dataProvider="$testBit" )]
		public function testBit(v:String, n:uint, result:Boolean):void {
			var R:Boolean = BigInteger.fromString( v, 16 ).testBit( n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ' + '( 1 << ' + n + ' ) != 0',
				R, result
			);
		}
		
		//----------------------------------
		//  setBit
		//----------------------------------
		
		public static var $setBit:Array = BigUintTest.$setBit;
		
		[Test( order="2", dataProvider="$setBit" )]
		public function setBit(v:String, n:uint, result:String):void {
			var R:BigInteger = BigInteger.fromString( v, 16 ).setBit( n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ' + '( 1 << ' + n + ' )',
				R.toString( 16 ).toLowerCase(), result.toLowerCase()
			);
		}
		
	}
	
}