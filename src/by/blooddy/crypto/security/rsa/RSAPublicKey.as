////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.security.pad.IPad;
	import by.blooddy.math.utils.BigUint;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					16.01.2011 22:03:30
	 */
	public class RSAPublicKey implements IRSAPublicKey {

		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------

		use namespace $internal;

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		$internal static var internalCall:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function RSAPublicKey() {
			super();
			if ( !internalCall ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			internalCall = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		$internal var bytes:ByteArray;

		/**
		 * @private
		 */
		$internal var n:BigUint;

		/**
		 * @private
		 */
		$internal var e:uint;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inhertDoc
		 */
		public function encrypt(bytes:ByteArray, pad:IPad=null):ByteArray {
			return null;
		}

		public function toString():String {
			var result:String;
			if ( this.bytes ) {
				result =	'[RSAPublicKey' +
								' n="' + bigUintToString( this.n ) + '"' +
								' e="' + this.e.toString( 16 ) + '"' +
							']';
			} else {
				result =	'[RSAPublicKey empty]';
			}
			return result;
		}

		//--------------------------------------------------------------------------
		//
		//  Internal methods
		//
		//--------------------------------------------------------------------------

		$internal function bigUintToString(v:BigUint):String {
			if ( v.len == 0 ) return '0';
			var p:uint = v.pos;
			var i:uint = p + v.len - 1;
			while ( this.bytes[ i ] == 0 ) {
				--i;
			}
			var result:String = this.bytes[ i ].toString( 16 );
			var c:uint;
			while ( i > p ) {
				--i;
				c = this.bytes[ i ];
				result += ( c <= 0xF ? '0' : '' ) + c.toString( 16 );
			}
			return result;
		}
	}

}
