////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;
	
	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					07.03.2011 18:16:57
	 */
	public class SHA256Test {
		
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
			[ 'e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855', '' ],
			[ 'ca978112ca1bbdcafac231b39a23dc4da786eff8147c4e72b9807785afee48bb', 'a' ],
			[ 'ba7816bf8f01cfea414140de5dae2223b00361a396177a9cb410ff61f20015ad', 'abc' ],
			[ 'f7846f55cf23e14eebeab5b4e1550cad5b509e3348fbc4efa3a1413d393cb650', 'message digest' ],
			[ '71c480df93d6ae2f1efad1447c66c9525e316218cf51fc8d9ed832f2daf18b73', 'abcdefghijklmnopqrstuvwxyz' ],
			[ 'db4bfcbd4da0cd85a60c3c37d3fbd8805c77f15fc6b1fdfe614ee0a7c8fdb4c0', 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789' ],
			[ 'f371bc4a311f2b009eef952dd83ca80e2b60026c8e935592d0f9c308453c813e', '12345678901234567890123456789012345678901234567890123456789012345678901234567890' ]
		];
		
		[Test( dataProvider="$hash" )]
		public function hash(result:String, str:String):void {
			Assert.assertEquals( SHA256.hash( str ), result );
		}
		
	}
	
}