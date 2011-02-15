package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.security.IPrivateKey;

	import flash.utils.ByteArray;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					19.01.2011 14:39:19
	 */
	public interface IRSAPrivateKey extends IRSAPublicKey, IPrivateKey {

		function decrypt(bytes:ByteArray):ByteArray;

	}

}