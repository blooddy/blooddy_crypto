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
import by.blooddy.crypto.security.utils.ARC4Random;
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
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function $PKCS1_V1_5() {
		super();
		if ( PKCS1_V1_5 ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
	}

	//--------------------------------------------------------------------------
	//
	//  Properties
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	public var type:uint = 0x02;

	/**
	 * @private
	 */
	private var _maxDataSize:uint;

	/**
	 * @private
	 */
	public override function get maxDataSize():uint {
		return this._maxDataSize;
	}

	public override function set blockSize(value:uint):void {
		if ( value <= 11 ) throw new ArgumentError();
		super.blockSize = value;
		this._maxDataSize = value - 11;
	}

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

		if ( block.len > this._maxDataSize ) throw new ArgumentError();

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
				ARC4Random.readPool( k, ks );
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