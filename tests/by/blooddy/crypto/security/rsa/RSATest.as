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
		private static const _keys:Vector.<String> = new <String>[
			"-----BEGIN RSA PRIVATE KEY-----\n" +
			"MGQCAQACEQDJG3bkuB9Ie7jOldQTVdzPAgMBAAECEQCOGqcPhP8t8mX8cb4cQEaR\n" +
			"AgkA5WTYuAGmH0cCCQDgbrto0i7qOQIINYr5btGrtccCCQCYy4qX4JDEMQIJAJll\n" +
			"OnLVtCWk\n" +
			"-----END RSA PRIVATE KEY-----"
		];

		/**
		 * @private
		 */
		private static const _padds:Vector.<IPad> = new <IPad>[
			NONE,
			PKCS1_V1_5
		];
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  encrypt_decrypt
		//----------------------------------

		public static function $encrypt_decrypt():Array {
			var result:Array = new Array();
			var arr:Array;
			for each ( var key:String in _keys ) {
				for each ( var pad:IPad in _padds ) {
					result.push( [
						RSAKeyDecoder.decodePEM( key ),
						'big big line!!! big big line!!!',
						pad
					] );
				}
			}
			return result;
		}
		
		[Test( order="1", dataProvider="$encrypt_decrypt" )]
		public function encrypt_decrypt(keyPair:RSAKeyPair, message:String, pad:IPad):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( message );
			
			bytes = keyPair.privateKey.decrypt(
				keyPair.publicKey.encrypt( bytes, pad ),
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
		public function sign_verify(keyPair:RSAKeyPair, message:String, pad:IPad):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( message );
			
			bytes = keyPair.publicKey.verify(
				keyPair.privateKey.sign( bytes, pad ),
				pad
			);
			
			Assert.assertEquals(
				bytes.readUTFBytes( bytes.length ),
				message
			);
		}
		
	}
	
}