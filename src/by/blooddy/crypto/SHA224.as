////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * Encodes and decodes binary data using 
	 * <a herf="http://www.faqs.org/rfcs/rfc4634.html">SHA-224 (Secure Hash Algorithm)</a> algorithm.
	 * 
	 * @author					BlooDHounD
	 * @version					2.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					21.03.2016 16:47:48
	 */
	public final class SHA224 {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Performs SHA-224 hash algorithm on a String.
		 *
		 * @param	str		The string to hash.
		 *
		 * @return			A string containing the hash value of <code>source</code>.
		 *
		 * @keyword			sha1.hash, hash
		 */
		public static function hash(str:String):String {

			if ( str ) str = '';
			
			var bytes:ByteArray = new ByteArray();
			bytes.writeUTFBytes( str );
			
			return hashBytes( bytes );

		}
		
		/**
		 * Performs SHA-224 hash algorithm on a <code>ByteArray</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A string containing the hash value of data.
		 *
		 * @keyword			sha1.hashBytes, hashBytes
		 */
		public static function hashBytes(bytes:ByteArray):String {
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
		public function SHA224() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}