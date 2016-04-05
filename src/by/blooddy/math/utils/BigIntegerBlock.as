////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import flash.system.ApplicationDomain;
	
	import avm2.intrinsics.memory.li32;
	
	import by.blooddy.utils.MemoryBlock;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					21.01.2011 14:11:39
	 */
	public class BigIntegerBlock extends MemoryBlock {
		
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
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function compare(v:BigIntegerBlock):int {

			var c1:int = this.len;
			var c2:int =    v.len;

			if ( c1 > c2 ) return 1;
			else if ( c2 > c1 ) return -1;
			else {
				
				var p1:int = this.pos;
				var p2:int =    v.pos;
				
				var i:int = c1;
				do {
					
					i -= 4;
					
					c1 = li32( p1 + i );
					c2 = li32( p2 + i );
					
					if ( c1 > c2 ) return 1;
					else if ( c1 < c2 ) return -1;
					
				} while ( i > 0 );
				
			}
			
			return 0;
			
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function BigIntegerBlock(pos:uint, len:uint) {
			super( pos, len );
		}
		
	}
	
}