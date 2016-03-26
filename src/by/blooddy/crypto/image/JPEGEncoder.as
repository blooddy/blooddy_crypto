////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image {

	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * Encodes image data using
	 * <a href="http://www.w3.org/Graphics/JPEG/itu-t81.pdf">JPEG</a> compression method.
	 *
	 * @author					BlooDHounD
	 * @version					2.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 */
	public final class JPEGEncoder {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _NATIVE:Boolean = ApplicationDomain.currentDomain.hasDefinition( 'flash.display.PNGEncoderOptions' );
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Creates a JPEG image from the specified <code>BitmapData</code>.
		 *
		 * @param	image		The <code>BitmapData</code> to be encoded.
		 *
		 * @param	quality		The compression level, possible values are 1 through 100 inclusive.
		 *
		 * @return 				a <code>ByteArray</code> representing the JPEG encoded image data.
		 *
		 * @throws	TypeError
		 */
		public static function encode(image:BitmapData, quality:uint=60):ByteArray {

			if ( image == null ) Error.throwError( TypeError, 2007, 'image' );
			if ( quality > 100 ) Error.throwError( RangeError, 2006, 'quality' );

			if ( _NATIVE ) {
				return image.encode( image.rect, new JPEGEncoderOptions( quality ) );
			} else {
				return JPEGEncoder$.encode( image, quality );
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
		public function JPEGEncoder() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}

import flash.display.BitmapData;
import flash.errors.IllegalOperationError;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;

/**
 * @private
 */
internal final class JPEGEncoder$ {

	//--------------------------------------------------------------------------
	//
	//  Encode
	//
	//--------------------------------------------------------------------------
	
	internal static function encode(image:BitmapData, qulity:uint):ByteArray {
		
		var tmp:ByteArray = _DOMAIN.domainMemory;
		
		var mem:ByteArray = new ByteArray();

		_DOMAIN.domainMemory = mem;

		throw new IllegalOperationError();
		
		_DOMAIN.domainMemory = tmp;
		
		return mem;

	}

	//--------------------------------------------------------------------------
	//  encode main methods
	//--------------------------------------------------------------------------
	
	private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
	
}