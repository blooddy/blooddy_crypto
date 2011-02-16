////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;
	
	import org.flexunit.runners.Parameterized;

	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 */
	public class Base64Test {

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
		//  testBit
		//----------------------------------
		
		public static var $decode:Array = [
			[ 'f////4/vlP+K8qP/gefA/3////+R0+qiet7/0XT///+Y/+HBd/+t/1v/nf9q/8X/cf///3L//8uH7P+qo9jjv47/3eRe//z/V//W/1//2f9I////Sv///5H47+3F28Ksl+vF51v//P9J////V////0j///9X////mvrX/r/hsdl/////Uv///03///92//b/f////4i2/+ixyOXcuN+y4YDt/8to////af///4D//7GO//t8qLr/iqm//9yh+rv/rbvHt472/7d2/+W1df//jYb1/364tNR7ncvp4X3/wv+mzri4mv6npIT/bJh2/7q1d///uJ3D/6mW0+rnjdnX/g==' ]
		];
		
		[Test( order="1", dataProvider="$decode" )]
		public function decode(str:String):void {
			var bytes:ByteArray = Base64.decode( str );
		}
		
	}

}