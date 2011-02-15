////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security {

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					16.01.2011 22:10:07
	 */
	public class KeyPair {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function KeyPair(publicKey:IPublicKey, privateKey:IPrivateKey) {
			super();
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
		private var _publicKey:IPublicKey;

		public function get publicKey():IPublicKey {
			return this._publicKey;
		}

		/**
		 * @private
		 */
		private var _privateKey:IPrivateKey;

		public function get privateKey():IPrivateKey {
			return this._privateKey;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toString():String {
			return	'[KeyPair (' +
						String( this._privateKey ) + ',' +
						String( this._publicKey ) +
					')]';
		}
		
	}

}