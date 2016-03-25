////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image {

	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import by.blooddy.crypto.image.palette.IPalette;

	/**
	 * Encodes image data using 8 bits of color information per pixel.
	 *
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 */
	public final class PNG8Encoder extends PNGEncoder {

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
		 * @param	palette			The color patette to use.
		 * 							If <code>null</code> given, the
		 * 							<code>by.blooddy.crypto.image.palette.MedianCutPalette</code>
		 * 							will be used.
		 *
		 * @return					The sequence of bytes containing the encoded image.
		 *
		 * @throws	TypeError		
		 * @throws	ArgumentError	No such filter.
		 *
		 * @see 					by.blooddy.crypto.image.palette.IPalette
		 * @see 					by.blooddy.crypto.image.palette.MedianCutPalette
		 * @see 					by.blooddy.crypto.image.PNGFilter
		 */
		public static function encode(image:BitmapData, filter:uint=0, palette:IPalette=null):ByteArray {
			throw new IllegalOperationError();
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
		public function PNG8Encoder() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}