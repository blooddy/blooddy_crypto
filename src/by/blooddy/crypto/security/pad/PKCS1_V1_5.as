////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.pad {
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					01.03.2011 3:47:51
	 */
	public const PKCS1_V1_5:IPad = new $PKCS1_V1_5();

}

//==============================================================================
//
//  Inner definitions
//
//==============================================================================

import by.blooddy.crypto.security.pad.IPad;

import flash.errors.IllegalOperationError;
import flash.utils.ByteArray;
import flash.utils.Endian;

/**
 * @private
 */
internal final class $PKCS1_V1_5 implements IPad {

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function $PKCS1_V1_5() {
		super();
	}
	
	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private var _blockSize:uint;
	
	/**
	 * @inheritDoc
	 */
	public function get blockSize():uint {
		return this._blockSize;
	}
	
	/**
	 * @private
	 */
	public function set blockSize(value:uint):void {
		this._blockSize = blockSize;
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @inheritDoc
	 */
	public function pad(bytes:ByteArray):ByteArray {
		var result:ByteArray = new ByteArray();
		var psSize:uint = this._blockSize - 3 - bytes.length;
		var k:uint = 0;
		result[ k++ ] = 0;
		result[ k++ ] = 0x02; // type
//		if ( type == 0x01 ) {
//			// blocktype 1: all padding bytes are 0xff
//			while ( psSize-- > 0 ) {
//				result[k++] = 0xFF;
//			}
//		} else if ( type == 0x02 ) {
			// blocktype 2: padding bytes are random non-zero bytes
			// generate non-zero padding bytes
			var i:int = -1;
			var b:uint;
			while ( psSize-- > 0 ) {
				do {
					b = ARC4Random.nextByte();
				} while ( b == 0 );
				result[ k++ ] = b;
			}
//		} else {
//			throw new ArgumentError();
//		}
		result[ k++ ] = 0;
		result.position = k;
		result.writeBytes( bytes );
		return result;
	}
	
	/**
	 * @inheritDoc
	 */
	public function unpad(bytes:ByteArray):ByteArray {
		if ( bytes.length != this._blockSize ) throw new ArgumentError();
		if ( bytes[ 0 ] != 0 ) throw new ArgumentError();
		var type:uint = bytes[ 1 ];
		var i:uint = 2;
		switch ( type ) {
			case 0x01:
				while ( bytes[ i ] == 0xFF && i < this._blockSize  ) {
					++i;
				}
				if ( bytes[ i ] != 0 ) throw new ArgumentError();
				break;
			case 0x02:
				while ( bytes[ i ] != 0 && i < this._blockSize ) {
					++i;
				}
				break;
			default:
				throw new ArgumentError();
		}
		
		var result:ByteArray = new ByteArray();
		bytes.position = i;
		bytes.readBytes( result );
		return result;
	}

	public function toString():String {
		return '[object PKCS1_V1_5]';
	}
	
}

/**
 * @private
 */
internal final class ARC4Random {

	/**
	 * @private
	 */
	private static const _POOL:ByteArray = new ByteArray();

	/**
	 * @private
	 */
	private static var _i:uint = 0;

	/**
	 * @private
	 */
	private static var _j:uint = 0;

	public static function nextByte():uint {
		if ( ++_i > 0xFF ) _i &= 0xFF;
		var ti:uint = _POOL[ _i ];
		_j += ti;
		if ( _j > 0xFF ) _j &= 0xFF;
		var tj:uint = _POOL[ _j ];
		_POOL[ _i ] = tj;
		_POOL[ _j ] = ti;
		return _POOL[ ( ti + tj ) & 0xFF ];
	}
	
	/**
	 * @private
	 */
	private static function init():void {

		// create target pool
		var tmp:ByteArray = new ByteArray();
		tmp.writeUTFBytes( '\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x09\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x56\x00\x57\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x67\x00\x68\x00\x69\x00\x6a\x00\x6b\x00\x6c\x00\x6d\x00\x6e\x00\x6f\x00\x70\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00' );
		tmp.writeShort( 0x8000 );

		// seed
		var t:uint = ( new Date() ).getTime();
		tmp[ 0 ] ^=   t         & 0xFF;
		tmp[ 1 ] ^= ( t >>  8 ) & 0xFF;
		tmp[ 2 ] ^= ( t >> 16 ) & 0xFF;
		tmp[ 3 ] ^= ( t >> 24 ) & 0xFF;

		// create start pool
		_POOL.endian = Endian.LITTLE_ENDIAN;
		_POOL.writeUTFBytes( '\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f' );
		t = 0x7F7E7D7C;
		do {
			t += 0x04040404;
			_POOL.writeInt( t );
		} while ( _POOL.length < 0x100 );
		
		// use target pool
		var i:uint = 0;
		var j:uint = 0;
		do {
			t = _POOL[ i ];
			j += t + tmp[ i ];
			if ( j > 0xFF ) j &= 0xFF;
			_POOL[ i ] = _POOL[ j ];
			_POOL[ j ] = t;
		} while ( ++i < 256 );

	}
	init();

}