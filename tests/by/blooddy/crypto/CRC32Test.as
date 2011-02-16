////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;

	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 */
	public final class CRC32Test {

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
			[ 'тестовая запсь для подсчёта crc', 0x49C523BC ]
		];

		[Test( dataProvider="$hash" )]
		public function hash(str:String, result:uint):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );
			Assert.assertEquals( CRC32.hash( bytes ), result );
		}

	}

}