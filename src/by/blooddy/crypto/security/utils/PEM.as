////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.utils {

	import by.blooddy.crypto.Base64;

	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					17.01.2011 1:16:58
	 * 
	 * @see						http://en.wikipedia.org/wiki/Privacy_Enhanced_Mail
	 */
	public final class PEM {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const CERTIFICATE:String =		'CERTIFICATE';

		public static const PUBLIC_KEY:String =			'PUBLIC KEY';

		public static const PRIVATE_KEY:String =		'PRIVATE KEY';

		public static const RSA_PRIVATE_KEY:String =	'RSA PRIVATE KEY';

		public static const RSA_PUBLIC_KEY:String =		'RSA PUBLIC KEY';

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static var _privateCall:Boolean = false;

		/**
		 * @private
		 */
		private static const _PEM:RegExp = /-----BEGIN ([\w ]+)-----(.*?)-----END \1-----/s;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public static function decode(str:String):PEM {
			var arr:Array = str.match( _PEM );
			if ( arr == null ) throw null;
			_privateCall = true;
			var result:PEM = new PEM();
			result.type = arr[ 1 ];
			// TODO: всякие разные свойства
			result.content = Base64.decode( arr[ 2 ] );
			return result;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		public function PEM() {
			super();
			if ( !_privateCall ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			_privateCall = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public var type:String;

		public var content:ByteArray;

	}

}