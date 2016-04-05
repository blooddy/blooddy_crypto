////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;
	
	import avm2.intrinsics.memory.li32;
	
	import by.blooddy.utils.MemoryBlock;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					21.01.2011 14:11:39
	 */
	public class BigIntegerBlock {
		
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
		
		/**
		 * @return	v1 > v2 ? 1 : ( v2 > v1 ? -1 : 0 )
		 */
		public static function compare(v1:MemoryBlock, v2:MemoryBlock):int {

			var c1:int = v1.len;
			var c2:int = v2.len;

			if ( c1 > c2 ) return 1;
			else if ( c2 > c1 ) return -1;
			else {
				
				var p1:int = v1.pos;
				var p2:int = v2.pos;
				
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
		
		/**
		 * @return		v1 + v2
		 */
		public static function add(v1:MemoryBlock, v2:MemoryBlock, result:int=-1):MemoryBlock {
			return null;
		}
		
		/**
		 * @return		v1 - v2
		 */
		public static function sub(v1:MemoryBlock, v2:MemoryBlock, result:int=-1):MemoryBlock {
			return null;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function BigIntegerBlock() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}
	
}