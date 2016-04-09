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
		
	}
	
}