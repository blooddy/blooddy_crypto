////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;
	
	/**
	 * The <code>IHashSum</code> interface defines methods for calculating hash-sum.
	 * 
	 * @see		https://en.wikipedia.org/wiki/Hashsum
	 * @see		by.blooddy.crypto.IHashSumAsync
	 * 
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					Apr 1, 2016 10:16:48 AM
	 */
	public interface IHashSum {
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Performs hash algorithm on a <code>String</code>.
		 *
		 * @param	str		The <code>String</code> to hash.
		 *
		 * @return			A <code>String</code> containing the hash value of <code>str</code>.
		 * 
		 * @see				by.blooddy.crypto.IHashSumAsync#hash()
		 */
		function hash(str:String):String;
		
		/**
		 * Performs hash algorithm on a <code>ByteArray</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A <code>String</code> containing the hash value of <code>bytes</code>.
		 * 
		 * @see				by.blooddy.crypto.IHashSumAsync#hashBytes()
		 */
		function hashBytes(bytes:ByteArray):String;
		
		/**
		 * Performs hash algorithm on a <code>ByteArray</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 * 
		 * @return			A <code>ByteArray</code> containing the hash value of <code>bytes</code>.
		 * 
		 * @see				by.blooddy.crypto.IHashSumAsync#digest()
		 */
		function digest(bytes:ByteArray):ByteArray;
		
	}
	
}