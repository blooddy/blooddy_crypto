////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;
	
	import by.blooddy.crypto.events.ProcessEvent;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	import org.flexunit.runners.Parameterized;

	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
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
			[ 'тестовая запись для подсчёта crc', 0xF7D05FA0 ]
		];

		[Test( dataProvider="$hash" )]
		public function hash(str:String, result:uint):void {

			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );

			Assert.assertEquals( CRC32.hashBytes( bytes ), result );

		}

		[Test( async, dataProvider="$hash" )]
		public function asyncHash(str:String, result:uint):void {
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );

			var hash:CRC32 = new CRC32();
			hash.hashBytes( bytes );
			hash.addEventListener( ProcessEvent.COMPLETE, Async.asyncHandler( this, function(event:ProcessEvent, data:*):void {
				Assert.assertEquals( event.data, result );
			}, 1e3 ) );
			Async.registerFailureEvent( this, hash, ProcessEvent.ERROR );
			
		}
		
	}

}