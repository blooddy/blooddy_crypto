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
	public const PKCS1_V1_5:IPad = new PKCS1_V1_5$();
		
}

//==============================================================================
//
//  Inner definitions
//
//==============================================================================

import by.blooddy.crypto.security.pad.IPad;

import flash.errors.IllegalOperationError;
import flash.utils.ByteArray;

/**
 * @private
 */
internal final class PKCS1_V1_5$ implements IPad {
	
	//--------------------------------------------------------------------------
	//
	//  Constructor
	//
	//--------------------------------------------------------------------------
	
	public function PKCS1_V1_5$() {
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
		throw new IllegalOperationError( '', 1001 );
	}
	
	/**
	 * @inheritDoc
	 */
	public function unpad(bytes:ByteArray):ByteArray {
		throw new IllegalOperationError( '', 1001 );
	}
	
}