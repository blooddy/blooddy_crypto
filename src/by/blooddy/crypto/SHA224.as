////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;

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
	public final class SHA224 extends SHA2 {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _H:Vector.<int> = Vector.<int>( new <uint>[
			0xc1059ed8, 0x367cd507, 0x3070dd17, 0xf70e5939,
			0xffc00b31, 0x68581511, 0x64f98fa7, 0xbefa4fa4
		] );
		
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
		 * @keyword			sha224.hash, hash
		 */
		public static function hash(str:String):String {
			return $hash( str, _H );
		}
		
		/**
		 * Performs SHA-224 hash algorithm on a <code>ByteArray</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A string containing the hash value of data.
		 *
		 * @keyword			sha224.hashBytes, hashBytes
		 */
		public static function hashBytes(bytes:ByteArray):String {
			return $hashBytes( bytes, _H );
		}

		/**
		 * Performs SHA-224 hash algorithm on a <code>ByteArray</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A <code>ByteArray</code> containing the hash value of data.
		 *
		 * @keyword			sha224.digest, digest
		 */
		public static function digest(bytes:ByteArray):ByteArray {
			return $digest( bytes, _H );
		}
		
	}

}