////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image {

	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * Encodes image data using 
	 * <a href="http://www.w3.org/TR/PNG-Compression.html">PNG</a> compression 
	 * algorithm. This class may use 
	 * different compression techniques provided in <code>PNG8Encoder</code> and
	 * <code>PNG24Encoder</code>.
	 * 
	 * @see	by.blooddy.crypto.image.PNG8Encoder
	 * @see	by.blooddy.crypto.image.PNG24Encoder
	 * @see	by.blooddy.crypto.image.palette.IPalette
	 * @see	by.blooddy.crypto.image.PNGFilter
	 * @see	flash.display.BitmapData#encode
	 * 
	 * @author					BlooDHounD
	 * @version					2.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					05.07.2010 17:44:26
	 */
	public final class PNGEncoder {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const NATIVE:Boolean = ApplicationDomain.currentDomain.hasDefinition( 'flash.display.PNGEncoderOptions' );

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Creates a PNG-encoded byte sequence from the specified <code>BitmapData</code>
		 * 
		 * @param	image			The <code>BitmapData</code> of the image you wish to encode.
		 * 
		 * @param	filter			The encoding algorithm you wish to apply while encoding.
		 * 							Use the constants provided in 
		 * 							<code>by.blooddy.crypto.image.PNGFilter</code> class.
		 * 
		 * @see						by.blooddy.crypto.image.PNGFilter
		 * @see						flash.display.BitmapData#encode
		 * 
		 * @return					The sequence of bytes containing the encoded image.
		 * 
		 * @throws	TypeError		
		 * @throws	ArgumentError	No such filter.
		 */
		public static function encode(image:BitmapData, filter:uint=0):ByteArray {
			if ( NATIVE ) {
				return image.encode( image.rect, new PNGEncoderOptions( filter == PNGFilter.NONE ) );
			} else {
				var size:uint = image.width * image.height;
				if ( size >= 32 && size <= 64 ) return PNG8Encoder.encode( image, filter );
				else return PNG24Encoder.encode( image, filter );
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		public function PNGEncoder() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}