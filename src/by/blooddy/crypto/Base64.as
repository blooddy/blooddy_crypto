////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;
	import flash.errors.IllegalOperationError;

	/**
	 * Encodes and decodes binary data using
	 * <a herf="http://www.faqs.org/rfcs/rfc4648.html">Base64</a> encoding algorithm.
	 *
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 */
	public class Base64 {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Encodes the <code>bytes</code> while conditionally inserting line breaks.
		 *
		 * @param	bytes			The data to be encoded.
		 *
		 * @param	insertNewLines	If <code>true</code> passed, the resulting
		 * 							string will contain line breaks.
		 *
		 * @return					The data encoded.
		 */
		public static function encode(bytes:ByteArray, insertNewLines:Boolean=false):String {
			throw new IllegalOperationError( 'TODO: plz, implement this!' );
		}

		/**
		 * Decodes the <code>source</code> string previously encoded using Base64
		 * algorithm.
		 *
		 * @param	str				The string containing encoded data.
		 *
		 * @return					The array of bytes obtained by decoding the <code>source</code>
		 * 							string.
		 *
		 * @throws	VerifyError		страка не валидна
		 */
		public static function decode(str:String):ByteArray {
			throw new IllegalOperationError( 'TODO: plz, implement this!' );
		}

	}

}