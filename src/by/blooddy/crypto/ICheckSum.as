////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.utils.ByteArray;
	
	/**
	 * The <code>ICheckSum</code> interface defines methods for calculating checksum.
	 * 
	 * @see		https://en.wikipedia.org/wiki/Checksum
	 * @see		by.blooddy.crypto.ICheckSumAsync
	 * 
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					Apr 1, 2016 10:16:48 AM
	 */
	public interface ICheckSum {
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Performs checksum algorithm on a <code>String</code>.
		 *
		 * @param	str		The <code>String</code> to checksum.
		 *
		 * @return			A <code>uint</code> containing the checksum value of <code>str</code>.
		 * 
		 * @see				by.blooddy.crypto.ICheckSumAsync#hash()
		 */
		function hash(str:String):uint;
		
		/**
		 * Performs checksum algorithm on a <code>ByteArray</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 *
		 * @return			A <code>uint</code> containing the checksum value of <code>bytes</code>.
		 * 
		 * @see				by.blooddy.crypto.ICheckSumAsync#hashBytes()
		 */
		function hashBytes(bytes:ByteArray):uint;
		
	}
	
}