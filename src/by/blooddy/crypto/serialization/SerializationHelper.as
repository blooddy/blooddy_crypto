////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.serialization {

	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					08.10.2010 2:05:14
	 */
	public final class SerializationHelper {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _EMPTY_ARR:Array = new Array();

		/**
		 * @private
		 */
		private static const _HASH_CLASS:Dictionary = new Dictionary( true );

		/**
		 * @private
		 */
		private static const _HASH_INSTANCE:Dictionary = new Dictionary( true );

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function getPropertyNames(o:Object):Array {
			if ( typeof o != 'object' || !o ) Error.throwError( TypeError, 2007, 'o' );
			var isClass:Boolean = o is Class;
			var arr:Array;
			var c:Object;
			if ( isClass ) {
				c = o as Class;
				arr = _HASH_CLASS[ c ];
			} else {
				c = o.constructor as Class;
				arr = _HASH_CLASS[ c ];
			}
			if ( !arr ) {
				arr = new Array();

				var n:String;
				var list:XMLList;
				for each ( var x:XML in describeType( o ).* ) {
					n = x.name();
					if (
						(
							(
								n ==  'accessor' &&
								x.@access.charAt( 0 ) == 'r'
							) ||
							n == 'variable' ||
							n == 'constant'
						) &&
						x.@uri.length() <= 0
					) {
						list = x.metadata;
						if ( list.length() <= 0 || list.( @name == 'Transient' ).length() <= 0 ) {
							arr.push( x.@name.toString() );
						}
					}
				}
				if ( isClass ) {
					_HASH_CLASS[ c ] = arr;
				} else {
					_HASH_INSTANCE[ c ] = arr;
				}
			}

			return arr.slice();
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		public function SerializationHelper() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}