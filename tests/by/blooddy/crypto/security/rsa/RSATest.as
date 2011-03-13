////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.security.pad.IPad;
	import by.blooddy.crypto.security.pad.NONE;
	import by.blooddy.crypto.security.pad.PKCS1_V1_5;
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;
	
	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					13.03.2011 22:47:50
	 */
	public class RSATest {
		
		//--------------------------------------------------------------------------
		//
		//  Class initialization
		//
		//--------------------------------------------------------------------------
		
		Parameterized;
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const KEY_PAIR:RSAKeyPair = RSAKeyDecoder.decodePEM(
			"-----BEGIN RSA PRIVATE KEY-----\n" +
			"MGQCAQACEQDJG3bkuB9Ie7jOldQTVdzPAgMBAAECEQCOGqcPhP8t8mX8cb4cQEaR\n" +
			"AgkA5WTYuAGmH0cCCQDgbrto0i7qOQIINYr5btGrtccCCQCYy4qX4JDEMQIJAJll\n" +
			"OnLVtCWk\n" +
			"-----END RSA PRIVATE KEY-----"
		);

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  encrypt_decrypt
		//----------------------------------
		
		public static var $encrypt_decrypt:Array = [
			[ 'big big line!!! big big line!!!', PKCS1_V1_5 ],
			[ 'big big line!!! big big line!!!', NONE ]
		];
		
		[Test( order="1", dataProvider="$encrypt_decrypt" )]
		public function encrypt_decrypt(message:String, pad:IPad):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( message );
			
			bytes = KEY_PAIR.privateKey.decrypt(
				KEY_PAIR.publicKey.encrypt( bytes, pad ),
				pad
			);

			Assert.assertEquals(
				bytes.readUTFBytes( bytes.length ),
				message
			);
		}
		
		//----------------------------------
		//  sign_verify
		//----------------------------------
		
		[Test( order="2", dataProvider="$encrypt_decrypt" )]
		public function sign_verify(message:String, pad:IPad):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( message );
			
			bytes = KEY_PAIR.publicKey.verify(
				KEY_PAIR.privateKey.sign( bytes, pad ),
				pad
			);
			
			Assert.assertEquals(
				bytes.readUTFBytes( bytes.length ),
				message
			);
		}
		
	}
	
}