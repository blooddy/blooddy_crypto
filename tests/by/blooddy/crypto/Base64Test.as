////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
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
	 * @playerversion			Flash 10.1
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
		//  isValid
		//----------------------------------

		public static var $isValid:Array = [
			[ 'm\n\tnog\r   otexta', true ],
			[ 'mn!ogotext',	false ],
			[ 'mno==gotex',	false ]
		];
		
		[Test( order="1", dataProvider="$isValid" )]
		public function isValid(str:String, result: Boolean):void {
			Assert.assertEquals( Base64.isValid( str ), result );
		}
		
		//----------------------------------
		//  encode
		//----------------------------------
		
		public static var $encode:Array = [
			[ 'mnogotexta',	0, 'bW5vZ290ZXh0YQ==' ],
			[ 'mnogotext',	0, 'bW5vZ290ZXh0' ],
			[ 'mnogotex',	0, 'bW5vZ290ZXg=' ],
			[
				'Base64 is a group of similar encoding schemes that represent binary data in an ASCII string format by translating it into a radix-64 representation',
				0,
				'QmFzZTY0IGlzIGEgZ3JvdXAgb2Ygc2ltaWxhciBlbmNvZGluZyBzY2hlbWVzIHRoYXQgcmVwcmVzZW50IGJpbmFyeSBkYXRhIGluIGFuIEFTQ0lJIHN0cmluZyBmb3JtYXQgYnkgdHJhbnNsYXRpbmcgaXQgaW50byBhIHJhZGl4LTY0IHJlcHJlc2VudGF0aW9u'
			],
			[
				'Base64 is a group of similar encoding schemes that represent binary data in an ASCII string format by translating it into a radix-64 representation',
				76,
				'QmFzZTY0IGlzIGEgZ3JvdXAgb2Ygc2ltaWxhciBlbmNvZGluZyBzY2hlbWVzIHRoYXQgcmVwcmVz\r\n' +
				'ZW50IGJpbmFyeSBkYXRhIGluIGFuIEFTQ0lJIHN0cmluZyBmb3JtYXQgYnkgdHJhbnNsYXRpbmcg\r\n' +
				'aXQgaW50byBhIHJhZGl4LTY0IHJlcHJlc2VudGF0aW9u'
			]
		];
		
		[Test( order="2", dataProvider="$encode" )]
		public function encode(str:String, newLines:uint, result:String):void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );
			var R:String = Base64.encode( bytes, newLines );
			Assert.assertEquals( R, result );
		}
		
		//----------------------------------
		//  decode
		//----------------------------------
		
		public static var $decode:Array = [
			[
				'QmFzZTY0IGlzIGEgZ3JvdXAgb2Ygc2ltaWxhciBlbmNvZGluZyBzY2hlbWVzIHRoYXQgcmVwcmVzZW50IGJpbmFyeSBkYXRhIGluIGFuIEFTQ0lJIHN0cmluZyBmb3JtYXQgYnkgdHJhbnNsYXRpbmcgaXQgaW50byBhIHJhZGl4LTY0IHJlcHJlc2VudGF0aW9u',
				'Base64 is a group of similar encoding schemes that represent binary data in an ASCII string format by translating it into a radix-64 representation'
			],
			[
				'QmF zZT\tY0I\rGlz\nIGEgZ3JvdXAgb2Ygc2ltaWxhciBlbmNvZGluZyBzY2hlbWVzIHRoYXQgcmVwcmVzZW50IGJpbmFyeSBkYXRhIGluIGFuIEFTQ0lJIHN0cmluZyBmb3JtYXQgYnkgdHJhbnNsYXRpbmcgaXQgaW50byBhIHJhZGl4LTY0IHJlcHJlc2VudGF0aW9u=====',
				'Base64 is a group of similar encoding schemes that represent binary data in an ASCII string format by translating it into a radix-64 representation'
			]
		];

		[Test( order="3", dataProvider="$decode" )]
		public function decode(str:String, result:String):void {
			var R1:ByteArray = Base64.decode( str );
			var R2:ByteArray = new ByteArray();
			R2.writeUTFBytes( result );
			Assert.assertObjectEquals( R1, R2 );
		}
		
		//----------------------------------
		//  decode_error
		//----------------------------------
		
		public static var $decode_error:Array = [
			[
				'QmFzZTY=0INCx0YPQutCy0LDQu9GM0L3QviDQvtC30L3QsNGH0LDQtdGCIOKAlCDQv9C+0LfQuNGG0LjQvtC90L3QsNGPINGB0LjRgdGC0LXQvNCwINGB0YfQuNGB0LvQtdC90LjRjyDRgSDQvtGB0L3QvtCy0LDQvdC40LXQvCA2NC4='
			],
			[
				'QmFzZTY!0INCx0YPQutCy0LDQu9GM0L3QviDQvtC30L3QsNGH0LDQtdGCIOKAlCDQv9C+0LfQuNGG0LjQvtC90L3QsNGPINGB0LjRgdGC0LXQvNCwINGB0YfQuNGB0LvQtdC90LjRjyDRgSDQvtGB0L3QvtCy0LDQvdC40LXQvCA2NC4='
			]
		];
		
		[Test( order="4", dataProvider="$decode_error", expects="VerifyError" )]
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