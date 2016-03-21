package by.blooddy.crypto {

	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;
	
	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					21.03.2016 15:54:46
	 */
	public class SHA1Test {

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
		
		public static var $hash:Array = [
			[ 'da39a3ee5e6b4b0d3255bfef95601890afd80709', '' ],
			[ '86f7e437faa5a7fce15d1ddcb9eaeaea377667b8', 'a' ],
			[ 'a9993e364706816aba3e25717850c26c9cd0d89d', 'abc' ],
			[ 'c12252ceda8be8994d5fa0290a47231c1d16aae3', 'message digest' ],
			[ '32d10c7b8cf96570ca04ce37f2a19d84240d3a89', 'abcdefghijklmnopqrstuvwxyz' ],
			[ '761c457bf73b14d27e9e9265c46f4b4dda11f940', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ],
			[ '50abf5706a150990a08b2c5ea40fa0e585554732', '12345678901234567890123456789012345678901234567890123456789012345678901234567890' ]
		];
		
		[Test( dataProvider="$hash" )]
		public function hash(result:String, str:String):void {
			Assert.assertEquals( SHA1.hash( str ), result );
		}
		
	}

}