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

import by.blooddy.crypto.security.pad.MemoryPad;
import by.blooddy.crypto.security.pad.PKCS1_V1_5;
import by.blooddy.crypto.security.utils.MemoryBlock;
import by.blooddy.system.Memory;

import flash.utils.ByteArray;
import flash.utils.getQualifiedClassName;

/**
 * @private
 */
internal final class $PKCS1_V1_5 extends MemoryPad {

	//--------------------------------------------------------------------------
	//
	//  Class variables
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	private static var _pool:ByteArray;

	/**
	 * @private
	 */
	private static var _i:uint = 0;
	
	/**
	 * @private
	 */
	private static var _j:uint = 0;
	
	//--------------------------------------------------------------------------
	//
	//  Class methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	private static function readPool(pos:uint, len:uint):void {

		var mem:ByteArray = _domain.domainMemory;

		var i:uint;
		var j:uint;
		var t:uint;

		var p:uint = pos + len;

		if ( _pool ) { // возможно есть пул созданный в прошлый запуск
			
			mem.position = p;
			mem.writeBytes( _pool );

		} else {

			// create target pool
			var k:uint = p + 256;
			mem.position = k;
			mem.writeUTFBytes( '\x01\x00\x02\x00\x03\x00\x04\x00\x05\x00\x06\x00\x07\x00\x08\x00\x09\x00\x0a\x00\x0b\x00\x0c\x00\x0d\x00\x0e\x00\x0f\x00\x10\x00\x11\x00\x12\x00\x13\x00\x14\x00\x15\x00\x16\x00\x17\x00\x18\x00\x19\x00\x1a\x00\x1b\x00\x1c\x00\x1d\x00\x1e\x00\x1f\x00\x20\x00\x21\x00\x22\x00\x23\x00\x24\x00\x25\x00\x26\x00\x27\x00\x28\x00\x29\x00\x2a\x00\x2b\x00\x2c\x00\x2d\x00\x2e\x00\x2f\x00\x30\x00\x31\x00\x32\x00\x33\x00\x34\x00\x35\x00\x36\x00\x37\x00\x38\x00\x39\x00\x3a\x00\x3b\x00\x3c\x00\x3d\x00\x3e\x00\x3f\x00\x40\x00\x41\x00\x42\x00\x43\x00\x44\x00\x45\x00\x46\x00\x47\x00\x48\x00\x49\x00\x4a\x00\x4b\x00\x4c\x00\x4d\x00\x4e\x00\x4f\x00\x50\x00\x51\x00\x52\x00\x53\x00\x54\x00\x55\x00\x56\x00\x57\x00\x58\x00\x59\x00\x5a\x00\x5b\x00\x5c\x00\x5d\x00\x5e\x00\x5f\x00\x60\x00\x61\x00\x62\x00\x63\x00\x64\x00\x65\x00\x66\x00\x67\x00\x68\x00\x69\x00\x6a\x00\x6b\x00\x6c\x00\x6d\x00\x6e\x00\x6f\x00\x70\x00\x71\x00\x72\x00\x73\x00\x74\x00\x75\x00\x76\x00\x77\x00\x78\x00\x79\x00\x7a\x00\x7b\x00\x7c\x00\x7d\x00\x7e\x00\x7f\x00' );
			Memory.setI16( mem.position, 0x0080 );

			// seed
			Memory.setI32( k, Memory.getI32( k ) ^ ( new Date() ).getTime() );
			
			// create start pool
			mem.position = p;
			mem.writeUTFBytes( '\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b\x0c\x0d\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x20\x21\x22\x23\x24\x25\x26\x27\x28\x29\x2a\x2b\x2c\x2d\x2e\x2f\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39\x3a\x3b\x3c\x3d\x3e\x3f\x40\x41\x42\x43\x44\x45\x46\x47\x48\x49\x4a\x4b\x4c\x4d\x4e\x4f\x50\x51\x52\x53\x54\x55\x56\x57\x58\x59\x5a\x5b\x5c\x5d\x5e\x5f\x60\x61\x62\x63\x64\x65\x66\x67\x68\x69\x6a\x6b\x6c\x6d\x6e\x6f\x70\x71\x72\x73\x74\x75\x76\x77\x78\x79\x7a\x7b\x7c\x7d\x7e\x7f' );
			p = mem.position;
			t = 0x7F7E7D7C;
			do {
				t += 0x04040404;
				Memory.setI32( p, t );
				p += 4;
			} while ( p < k );
			p = k - 256;

			// use target pool
			i = 0;
			j = 0;
			do {
				t = Memory.getUI8( p + i );
				j += t + Memory.getUI8( k + i );
				if ( j > 0xFF ) j &= 0xFF;
				Memory.setI8( p + i, Memory.getUI8( p + j ) );
				Memory.setI8( p + j, t );
			} while ( ++i < 256 );

		}

		// read bytes from pool
		i = _i;
		j = _j;
		
		var ti:uint;
		var tj:uint;
		
		do {

			do {
				if ( ++i > 0xFF ) i &= 0xFF;
				ti = Memory.getUI8( p + i );
				j += ti;
				if ( j > 0xFF ) j &= 0xFF;
				tj = Memory.getUI8( p + j );
				Memory.setI8( p + i, tj );
				Memory.setI8( p + j, ti );
				t = Memory.getUI8( p + ( ( ti + tj ) & 0xFF ) );
			} while ( t == 0 );
			Memory.setI8( pos, t );
			++pos;

		} while ( pos < len );
		
		_i = i;
		_j = j;

		// сохраняем пул, что бы не создавать его в следущий раз
		if ( !_pool ) _pool = new ByteArray();
		mem.position = p;
		mem.readBytes( _pool, 0, 256 );

	}

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function $PKCS1_V1_5() {
		super();
		if ( PKCS1_V1_5 ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	public var type:uint = 0x02;

	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public override function padMemory(block:MemoryBlock, pos:uint):MemoryBlock {

		var blockSize:uint = super.blockSize;

		if ( block.len + 3 > blockSize ) throw new ArgumentError();

		Memory.setI16( pos, 0x0200 );

		var k:uint = pos + 2;
		var ks:uint = pos + blockSize - block.len - 1;

		switch ( this.type ) {
			case 0x01:
				// blocktype 1: all padding bytes are 0xFF
				do {
					Memory.setI8( k, 0xFF );
				} while ( ++k < ks );
				break;
			case 0x02:
				// blocktype 2: padding bytes are random non-zero bytes
				// generate non-zero padding bytes
				readPool( k, ks );
				break;
			default:
				throw new ArgumentError();
		}

		Memory.setI8( ks, 0 );

		var mem:ByteArray = _domain.domainMemory;
		mem.position = block.pos;
		mem.readBytes( mem, ks + 1, block.len );
	
		return new MemoryBlock( pos, blockSize );

	}
	
	/**
	 * @private
	 */
	public override function unpadMemory(block:MemoryBlock, pos:uint):MemoryBlock {

		var blockSize:uint = super.blockSize;

		if ( block.len != blockSize ) throw new ArgumentError();

		var k:uint = block.pos;
		var ks:uint = k + blockSize;
		
		if ( Memory.getUI8( k++ ) != 0 ) throw new ArgumentError();
		if ( Memory.getUI8( k++ ) != this.type ) throw new ArgumentError();

		switch ( this.type ) { // type
			case 0x01:
				while ( k < ks && Memory.getUI8( k++ ) == 0xFF  ) {}
				if ( Memory.getUI8( k ) != 0 ) throw new ArgumentError();
				break;
			case 0x02:
				while ( k < ks && Memory.getUI8( k++ ) != 0 ) {}
				break;
		}

		return new MemoryBlock( k, ks - k );

	}

	public function toString():String {
		return '[object PKCS1_V1_5]';
	}
	
}