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
		 * Dispatched result in <code>ProcessEvent</code>.
		 *
		 * @param	str		The string to hash.
		 *
		 * @return			A string containing the hash value of <code>str</code>.
		 */
		function hash(str:String):String;
		
		/**
		 * Asynchronously performs hash algorithm on a <code>ByteArray</code>.
		 * Dispatched result in <code>ProcessEvent</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A string containing the hash value of <code>bytes</code>.
		 */
		function hashBytes(bytes:ByteArray):String;
		
		/**
		 * Asynchronously performs hash algorithm on a <code>ByteArray</code>.
		 * Dispatched <code>ByteArray</code> result in <code>ProcessEvent</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 * 
		 * @return			A <code>ByteArray</code> containing the hash value of <code>bytes</code>.
		 */
		function digest(bytes:ByteArray):ByteArray;
		
	}
	
}