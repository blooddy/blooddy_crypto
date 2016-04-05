////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.utils {
	
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
		public var pos:uint;
		
		/**
		 * Block length
		 */
		public var len:uint;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toString():String {
			return '[' + pos + ',' + len + ']';
		}
		
	}
	
}