////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image {

	import flash.display.BitmapData;
	import flash.display.PNGEncoderOptions;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * Encodes image data using 24 bits of color information per pixel.
	 *
	 * @author					BlooDHounD
	 * @version					2.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 */
	public final class PNG24Encoder extends PNGEncoder {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Creates a PNG image from the specified <code>BitmapData</code>
		 *
		 * @param	image			The <code>BitmapData</code> to be converted to PNG format.
		 *
		 * @param	filter			The encoding algorithm to use when processing the image.
		 * 							Use the constants provided in
		 * 							<code>by.blooddy.crypto.image.PNGFilter</code> class.
		 *
		 * @return					a <code>ByteArray</code> containing the PNG encoded image data.
		 *
		 * @throws	TypeError		
		 * @throws	ArgumentError	No such filter.
		 *
		 * @see						by.blooddy.crypto.image.PNGFilter
		 */
		public static function encode(image:BitmapData, filter:uint=0):ByteArray {
			if ( _NATIVE ) {
				return image.encode( image.rect, new PNGEncoderOptions( filter == PNGFilter.NONE ) );
			} else {
				throw new IllegalOperationError();
			}
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function PNG24Encoder() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}