package by.blooddy.crypto.security.rsa {

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					18.01.2011 16:12:03
	 */
	public class RSAKeyPair {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function RSAKeyPair(publicKey:RSAPublicKey, privateKey:RSAPrivateKey) {
			super();
			if ( !publicKey && privateKey ) {
				publicKey = privateKey.getPublicKey();
			}
			this._publicKey = publicKey;
			this._privateKey = privateKey;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _publicKey:RSAPublicKey;

		public function get publicKey():RSAPublicKey {
			return this._publicKey;
		}

		/**
		 * @private
		 */
		private var _privateKey:RSAPrivateKey;

		public function get privateKey():RSAPrivateKey {
			return this._privateKey;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function toString():String {
			return	'[RSAKeyPair (' +
						String( this._privateKey ) + ',' +
						String( this._publicKey ) +
					')]';
		}

	}

}