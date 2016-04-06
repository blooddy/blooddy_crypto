////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.utils {
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	
	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					03.03.2011 13:24:51
	 */
	public class MemoryBlock {
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function MemoryBlock(pos:uint, len:uint) {
			super();
			this.pos = pos;
			this.len = len;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * Block position
		 */
		public var pos:int;
		
		/**
		 * Block length
		 */
		public var len:int;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function get():ByteArray {
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes( _DOMAIN.domainMemory, this.pos, this.len );
			return bytes;
		}
		
		public function toString():String {
			return '[' + pos + ',' + len + ']';
		}
		
	}
	
}