////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {
	
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
		
		[Test( order="1", dataProvider="$fromNumber" )]
		public function fromNumber(v:Number):void {
			var bi:BigInteger = BigInteger.fromNumber( v );
			Assert.assertEquals(
				bi.toString( 16 ), v.toString( 16 )
			);
		}
		
	}
	
}