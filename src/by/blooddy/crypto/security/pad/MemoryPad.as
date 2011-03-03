////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.pad {
	
	import apparat.memory.MemoryBlock;
	
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					03.03.2011 12:57:42
	 */
	public class MemoryPad implements IPad {
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		protected static const _CURRENT_DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function MemoryPad() {
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
		public final function get blockSize():uint {
			return this._blockSize;
		}

		/**
		 * @private
		 */
		public final function set blockSize(value:uint):void {
			this._blockSize = value;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public final function pad(bytes:ByteArray):ByteArray {

			if ( bytes.length <= 0 || bytes.length > this._blockSize ) throw new ArgumentError();
			
			var tmp:ByteArray = _CURRENT_DOMAIN.domainMemory;

			var mem:ByteArray = new ByteArray();
			mem.writeBytes( bytes );
			mem.length += this._blockSize + 1024; // запас на всякие расходные расчёты
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_CURRENT_DOMAIN.domainMemory = mem;

			var block:MemoryPadBlock;
			try {

				block = this.padMemory( new MemoryPadBlock( 0, bytes.length ), bytes.length );

			} finally {
				_CURRENT_DOMAIN.domainMemory = tmp;
			}

			var result:ByteArray = new ByteArray();
			mem.position = block.pos;
			mem.readBytes( result, 0, block.len );
			return result;

		}

		/**
		 * @inheritDoc
		 */
		public final function unpad(bytes:ByteArray):ByteArray {

			if ( bytes.length <= 0 || bytes.length != this._blockSize ) throw new ArgumentError();
			
			var tmp:ByteArray = _CURRENT_DOMAIN.domainMemory;
			
			var mem:ByteArray = new ByteArray();
			mem.writeBytes( bytes );
			mem.length += this._blockSize + 1024; // запас на всякие расходные расчёты
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_CURRENT_DOMAIN.domainMemory = mem;
			
			var block:MemoryPadBlock;
			try {
				
				block = this.unpadMemory( new MemoryPadBlock( 0, bytes.length ), bytes.length );
				
			} finally {
				_CURRENT_DOMAIN.domainMemory = tmp;
			}
			
			var result:ByteArray = new ByteArray();
			mem.position = block.pos;
			mem.readBytes( result, 0, block.len );
			return result;

		}

		public function padMemory(block:MemoryPadBlock, pos:uint):MemoryPadBlock {
			throw new IllegalOperationError( '', 1001 );
		}

		public function unpadMemory(block:MemoryPadBlock, pos:uint):MemoryPadBlock {
			throw new IllegalOperationError( '', 1001 );
		}
		
	}

}