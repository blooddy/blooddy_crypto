////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import apparat.inline.Macro;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					12.01.2011 17:03:08
	 */
	public final class IntUtils extends Macro {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		CRYPTO::inline
		/**
		 * rotation is separate from addition to prevent recomputation
		 */
		public static function rol(a:int, s:int, r:int):void {
			r = ( a << s ) | ( a >>> ( 32 - s ) );
		}
		CRYPTO::debug
		/**
		 * rotation is separate from addition to prevent recomputation
		 */
		public static function rol(a:int, s:int):int {
			return ( a << s ) | ( a >>> ( 32 - s ) );
		}

		CRYPTO::inline
		public static function ror(x:int, n:int, r:int):void {
			r = ( x << ( 32 - n ) ) | ( x >>> n );
		}
		CRYPTO::debug
		public static function ror(x:int, n:int):int {
			return ( x << ( 32 - n ) ) | ( x >>> n );
		}

	}

}