////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;

	import flexunit.framework.Assert;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 */
	public class CRC32Test {

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		[Test]
		public function hash():void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( 'тестовая запсь для подсчёта crc' );
			Assert.assertEquals(
				CRC32.hash( bytes ),
				0x49C523BC
			);
		}

	}

}