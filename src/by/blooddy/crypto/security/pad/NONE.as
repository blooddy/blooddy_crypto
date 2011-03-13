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
	 * @created					13.03.2011 21:48:46
	 */
	public const NONE:IPad = new $NONE();
	
}

//==============================================================================
//
//  Inner definitions
//
//==============================================================================

import by.blooddy.crypto.security.pad.MemoryPad;
import by.blooddy.crypto.security.pad.NONE;
import by.blooddy.crypto.security.utils.MemoryBlock;

import flash.utils.ByteArray;
import flash.utils.getQualifiedClassName;

/**
 * @private
 */
internal final class $NONE extends MemoryPad {

	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	/**
	 * @private
	 */
	public function $NONE() {
		super();
		if ( NONE ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
	}
	
	//--------------------------------------------------------------------------
	//
	//  Methods
	//
	//--------------------------------------------------------------------------

	/**
	 * @private
	 */
	public override function pad(bytes:ByteArray):ByteArray {
		if ( bytes.length <= 0 || bytes.length > super.maxDataSize ) throw new ArgumentError();
		return bytes;
	}

	/**
	 * @private
	 */
	public override function unpad(bytes:ByteArray):ByteArray {
		if ( bytes.length <= 0 || bytes.length > super.blockSize ) throw new ArgumentError();
		return bytes;
	}
	
	/**
	 * @private
	 */
	public override function padMemory(block:MemoryBlock, pos:uint):MemoryBlock {
		if ( block.len <= 0 || block.len > super.maxDataSize ) throw new ArgumentError();
		return block;
	}
	
	/**
	 * @private
	 */
	public override function unpadMemory(block:MemoryBlock, pos:uint):MemoryBlock {
		if ( block.len <= 0 || block.len > super.blockSize ) throw new ArgumentError();
		return block;
	}
	
	public function toString():String {
		return '[object NONE]';
	}
	
}