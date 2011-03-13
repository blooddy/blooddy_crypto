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
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					16.01.2011 22:05:04
	 */
	public class RSAPrivateKey extends RSAPublicKey implements IRSAPrivateKey {

		//--------------------------------------------------------------------------
		//
		//  Namespaces
		//
		//--------------------------------------------------------------------------

		use namespace $internal;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 * Constructor
		 */
		public function RSAPrivateKey() {
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		$internal var d:BigUint;

		/**
		 * @private
		 */
		$internal var p:BigUint;

		/**
		 * @private
		 */
		$internal var q:BigUint;

		/**
		 * @private
		 */
		$internal var dp:BigUint;

		/**
		 * @private
		 */
		$internal var dq:BigUint;

		/**
		 * @private
		 */
		$internal var invq:BigUint;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function sign(message:ByteArray, pad:IPad=null):ByteArray {
			return null;
		}
	
		/**
		 * @inheritDoc
		 */
		public function decrypt(message:ByteArray, pad:IPad=null):ByteArray {

			if ( !pad ) pad = PKCS1_V1_5;

			var _blockSize:uint = pad.blockSize;
			var _type:uint;
			if ( pad === PKCS1_V1_5 ) {
				_type = pad[ 'type' ];
				pad[ 'type' ] = 0x02;
			}
			
			var tmp:ByteArray = _domain.domainMemory;
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( this.bytes );
			mem.writeBytes( message );
			mem.length += 65e4;
			// TODO: buffer for result
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_domain.domainMemory = mem;
			
			try {
				
				var ob:uint = ( BigUint.getBitLength( this.n ) + 7 ) / 8;
				var ib:uint = ob - 11;
	
				if ( message.length % ob ) throw new ArgumentError();
	
				pad.blockSize = ob;
				
				var mpad:MemoryPad = pad as MemoryPad;
				
				var i:uint = this.bytes.length;
				var p:uint = i + message.length;
	
				var pos:uint = p;
				
				var mb:MemoryBlock;
				var bu:BigUint;
				var block:ByteArray;

				while ( i < p ) {

					bu = RSA.toBigUint( i, ob, pos );
					bu = RSA.DP( this, bu, pos + bu.len );
					RSA.fromBigUint( bu, pos );
	
					// pad block
					if ( mpad ) {
						mb = mpad.unpadMemory( new MemoryBlock( pos, bu.len ), pos + bu.len );
					} else {
						if ( block ) block.length = 0;
						else block = new ByteArray();
						block.writeBytes( mem, pos, bu.len );
						block = pad.unpad( block );
						block.position = 0;
						block.readBytes( mem, pos + bu.len );
						mb = new MemoryBlock( pos, block.length );
					}
	
					mem.position = mb.pos;
					mem.readBytes( mem, pos, mb.len );
	
					pos += mb.len;
					i += ob;
	
				}
			
			} finally {

				_domain.domainMemory = tmp;
				if ( pad === PKCS1_V1_5 ) {
					pad[ 'type' ] = _type;
				}
				pad.blockSize = _blockSize;

			}

			var result:ByteArray = new ByteArray();
			mem.position = p;
			mem.readBytes( result, 0, pos - p );
			return result;

		}

		public function getPublicKey():RSAPublicKey {
			internalCall = true;
			var result:RSAPublicKey = new RSAPublicKey();
			result.bytes = this.bytes;
			result.n = this.n;
			result.e = this.e;
			return result;
		}

		public override function toString():String {
			var result:String;
			if ( this.bytes ) {

				var tmp:ByteArray = _domain.domainMemory;
				var mem:ByteArray;
				if ( this.bytes.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) {
					mem = new ByteArray();
					mem.writeBytes( this.bytes );
					mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
				} else {
					mem = this.bytes;
				}
				_domain.domainMemory = mem;
				
				result =	'[RSAPrivateKey' +
								' n="' + bigUintToString( this.n ) + '"' +
								' e="' + bigUintToString( this.e ) + '"' +
								' d="' + bigUintToString( this.d ) + '"' +
								' P="' + bigUintToString( this.p ) + '"' +
								' Q="' + bigUintToString( this.q ) + '"' +
								' dP="' + bigUintToString( this.dp ) + '"' +
								' dQ="' + bigUintToString( this.dq ) + '"' +
								' iQ="' + bigUintToString( this.invq ) + '"' +
							']';
				
				_domain.domainMemory = tmp;
				
			} else {

				result =	'[RSAPrivateKey empty]';

			}
			return result;
		}

	}

}
