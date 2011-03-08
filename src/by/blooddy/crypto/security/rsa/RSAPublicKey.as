////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.security.pad.IPad;
	import by.blooddy.crypto.security.pad.MemoryPad;
	import by.blooddy.crypto.security.pad.PKCS1_V1_5;
	import by.blooddy.crypto.security.utils.MemoryBlock;
	import by.blooddy.math.utils.BigUint;
	import by.blooddy.system.Memory;
	
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
		private static const _domain:ApplicationDomain = ApplicationDomain.currentDomain;

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

			var tmp:ByteArray = _domain.domainMemory;
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( this.bytes );
			mem.writeBytes( bytes );
			mem.length += 65e4;
			// TODO: buffer for result
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_domain.domainMemory = mem;

			var ob:uint = this.getBlockLength();
			var ib:uint = ob - 11;

			pad.blockSize = ob;

			var mpad:MemoryPad = pad as MemoryPad;
			
			var s:uint = this.bytes.length;
			var e:uint = s + bytes.length;
			var i:uint = s;
			var j:uint;

			var p:uint = e;
			var pos:uint = p;

			var bu:BigUint;
			var block:ByteArray;

			while ( i < e ) {

				if ( i + ib >= e ) ib = e - i;

				// pad block
				if ( mpad ) {
					mpad.padMemory( new MemoryBlock( i, ib ), pos );
				} else {
					if ( block ) block.length = 0;
					else block = new ByteArray();
					block.writeBytes( mem, i, ib );
					block = pad.pad( block );
					block.position = 0;
					block.readBytes( mem, pos );
				}

				// create BigUint
				// TODO: create method
				j = 0;
				do {
					Memory.setI8( pos + ob + j, Memory.getUI8( pos + ob - j - 1 ) );
				} while ( ++j < ob );
				while ( j & 3 ) {
					Memory.setI8( pos + ob + j, 0 );
					++j;
				}
				while ( j > 0 && Memory.getI32( pos + ob + j - 4 ) == 0 ) {
					j -= 4;
				}
				
				bu = BigUint.modPowInt( new BigUint( pos + ob, j ), this.e, this.n, pos + ob + j );

				mem.position = bu.pos;
				mem.readBytes( mem, pos, bu.len );

				i += ib;
				pos += ob;

			}

			// reverse
			// TODO: create method
			i = pos - p;
			do {
				--i;
				Memory.setI8( pos + i, Memory.getUI8( pos - i - 1 ) );
			} while ( i > 0 );
			
			_domain.domainMemory = tmp;

			var result:ByteArray = new ByteArray();
			mem.position = pos;
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
