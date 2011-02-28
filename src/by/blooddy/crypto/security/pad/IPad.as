package by.blooddy.crypto.security.pad {

	import flash.utils.ByteArray;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					28.02.2011 19:59:31
	 */
	public interface IPad {

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Add padding to the array
		 */
		function pad(bytes:ByteArray, blockSize:uint):void;

		/**
		 * Remove padding from the array.
		 */
		function unpad(bytes:ByteArray, blockSize:uint):void;

	}

}