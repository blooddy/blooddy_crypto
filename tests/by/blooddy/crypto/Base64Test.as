////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
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
		//  decode
		//----------------------------------
		
		public static var $decode:Array = [
			[
				'QmFzZTY0INCx0YPQutCy0LDQu9GM0L3QviDQvtC30L3QsNGH0LDQtdGCIOKAlCDQv9C+0LfQuNGG0LjQvtC90L3QsNGPINGB0LjRgdGC0LXQvNCwINGB0YfQuNGB0LvQtdC90LjRjyDRgSDQvtGB0L3QvtCy0LDQvdC40LXQvCA2NC4='
			],
			[
				'Q mF\nzZ\rTY\t0INCx0YPQutCy0LDQu9GM0L3QviDQvtC30L3QsNGH0LDQtdGCIOKAlCDQv9C+0LfQuNGG0LjQvtC90L3QsNGPINGB0LjRgdGC0LXQvNCwINGB0YfQuNGB0LvQtdC90LjRjyDRgSDQvtGB0L3QvtCy0LDQvdC40LXQvCA2NC4======'
			]
		];

		[Test( order="1", dataProvider="$decode" )]
		public function decode(str:String):void {
			var R1:ByteArray = Base64.decode( str );
			var R2:ByteArray = new ByteArray();
			R2.writeUTFBytes( 'Base64 буквально означает — позиционная система счисления с основанием 64.' );
			Assert.assertObjectEquals( R1, R2 );
		}
		
		//----------------------------------
		//  testBit
		//----------------------------------
		
		public static var $decode_error:Array = [
			[
				'QmFzZTY=0INCx0YPQutCy0LDQu9GM0L3QviDQvtC30L3QsNGH0LDQtdGCIOKAlCDQv9C+0LfQuNGG0LjQvtC90L3QsNGPINGB0LjRgdGC0LXQvNCwINGB0YfQuNGB0LvQtdC90LjRjyDRgSDQvtGB0L3QvtCy0LDQvdC40LXQvCA2NC4='
			],
			[
				'QmFzZTY!0INCx0YPQutCy0LDQu9GM0L3QviDQvtC30L3QsNGH0LDQtdGCIOKAlCDQv9C+0LfQuNGG0LjQvtC90L3QsNGPINGB0LjRgdGC0LXQvNCwINGB0YfQuNGB0LvQtdC90LjRjyDRgSDQvtGB0L3QvtCy0LDQvdC40LXQvCA2NC4='
			]
		];
		
		[Test( order="2", dataProvider="$decode_error", expects="VerifyError" )]
		public function decode_error(str:String):void {
			Base64.decode( str );
		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function getBytesFromString(str:String):ByteArray {
			var result:ByteArray = new ByteArray();
			var l:uint = str.length;
			for ( var i:uint = 0; i<l; ++i ) {
				result[ i ] = str.charCodeAt( i );
			}
			return result;
		}

//		/**
//		 * @private
//		 */
//		private static function equalsBytes(b1:ByteArray, b2:ByteArray):Boolean {
//			
//		}
		
	}

}