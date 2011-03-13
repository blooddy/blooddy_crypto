////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security {

	import by.blooddy.crypto.security.pad.IPad;
	
	import flash.utils.ByteArray;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					16.01.2011 21:41:32
	 */
	public interface IPublicKey extends IKey {

		function verify(message:ByteArray, pad:IPad=null):ByteArray;

	}

}