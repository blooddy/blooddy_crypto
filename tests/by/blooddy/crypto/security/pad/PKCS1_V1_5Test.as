////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.pad {
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;
	
	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					02.03.2011 18:13:49
	 */
	public class PKCS1_V1_5Test {

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
		//  decodeDER
		//----------------------------------
		
		public static var $pad_unpad:Array = [
			[ 'коротенькая строчка' ]
		];

		[Test( order="1", dataProvider="$pad_unpad" )]
		public function pad_unpad(source:String):void {
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( source );

			PKCS1_V1_5.blockSize = 256;

			bytes = PKCS1_V1_5.pad( bytes );
			bytes = PKCS1_V1_5.unpad( bytes );

			Assert.assertEquals( bytes.readUTFBytes( bytes.length ), source );

		}
		
	}
	
}