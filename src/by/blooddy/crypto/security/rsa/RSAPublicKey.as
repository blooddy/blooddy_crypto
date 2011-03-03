////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.security.pad.IPad;
	import by.blooddy.crypto.security.pad.PKCS1_V1_5;
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

		/**
		 * @private
		 */
		private static const _CURRENT_DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;

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
		public function verify(bytes:ByteArray):Boolean {
			return false;
		}

		/**
		 * @inhertDoc
		 */
		public function encrypt(bytes:ByteArray, pad:IPad=null):ByteArray {
			if ( !pad ) pad = PKCS1_V1_5;

			var tmp:ByteArray = _CURRENT_DOMAIN.domainMemory;
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( this.bytes );
			mem.writeBytes( bytes );
			mem.length += 65e4;
			// TODO: buffer for result
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_CURRENT_DOMAIN.domainMemory = mem;

			var ob:uint = this.getBlockLength();
			var ib:uint = ob - 11;

			pad.blockSize = ob;

			var s:uint = this.bytes.length;
			var e:uint = s + bytes.length;
			var i:uint = s;

			var p:uint = e;
			var pos:uint = p;

			var bu:BigUint;
			var block:ByteArray;

			while ( i < e ) {

				if ( i + ib >= e ) ib = e - i;

				// optimize to memory
				block = new ByteArray();
				block.writeBytes( mem, i, ib );
				block = pad.pad( block );
				block.position = 0;
				block.readBytes( mem, pos );

				bu = BigUint.modPowInt( new BigUint( pos, ob ), this.e, this.n, pos + ob );

				mem.position = bu.pos;
				mem.readBytes( mem, pos, bu.len );

				i += ib;
				pos += ob;

			}

			_CURRENT_DOMAIN.domainMemory = tmp;

			var result:ByteArray = new ByteArray();
			mem.position = p;
			mem.readBytes( result, 0, pos - p );
			return result;
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

		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function getBlockLength():uint {
			return ( BigUint.getBitLength( this.n ) + 7 ) / 8;
		}

	}

}
