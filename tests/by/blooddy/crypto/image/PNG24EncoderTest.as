////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.async.Async;
	import org.flexunit.runners.Parameterized;
	
	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					Mar 28, 2016 5:34:45 AM
	 */
	public class PNG24EncoderTest {
		
		Parameterized;

		[Embed(source="png24.png")]
		private static const _PNG24_CLASS:Class;
		private static const _PNG24_BITMAP:BitmapData = ( new _PNG24_CLASS() as Bitmap ).bitmapData;
		
		[Embed(source="png24-transparent.png")]
		private static const _PNG24_TRANSPARENT_CLASS:Class;
		private static const _PNG24_TRANSPARENT_BITMAP:BitmapData = ( new _PNG24_TRANSPARENT_CLASS() as Bitmap ).bitmapData;

		public static var $encode:Array = [
			[ false, 0 ],
			[ false, 1 ],
			[ false, 2 ],
			[ false, 3 ],
			[ false, 4 ]
//			[ true, 0 ],
//			[ true, 1 ],
//			[ true, 2 ],
//			[ true, 3 ],
//			[ true, 4 ]
		];
		
		[Test( async, dataProvider="$encode" )]
		public function encode(transparent:Boolean, filter:uint):void {
			
			var bitmap:BitmapData = ( transparent ? _PNG24_TRANSPARENT_BITMAP : _PNG24_BITMAP );
			
			var bytes:ByteArray = PNG24Encoder.encode( bitmap, filter );
			
			var loader:Loader = new Loader();
			loader.loadBytes( bytes );
			loader.contentLoaderInfo.addEventListener( Event.COMPLETE, Async.asyncHandler( this, function(event:Event, data:*):void {
				Assert.assertEquals(
					bitmap.compare( ( loader.content as Bitmap ).bitmapData ),
					0
				);
			}, 1e3 ) );
			
		}
		
	}
	
}