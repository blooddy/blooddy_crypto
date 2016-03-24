////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {
	
	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					12.01.2011 17:03:08
	 */
	public final class IntUtils {
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		[Inline]
		/**
		 * rotation is separate from addition to prevent recomputation
		 */
		public static function rol(a:int, s:int):int {
			return ( a << s ) | ( a >>> ( 32 - s ) );
		}
		
		[Inline]
		public static function ror(x:int, n:int):int {
			return ( x << ( 32 - n ) ) | ( x >>> n );
		}
		
		[Inline]
		public static function abs(x:int):uint {
			return ( x < 0 ? -x : x );
		}
		
	}
	
}