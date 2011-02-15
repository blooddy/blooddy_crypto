package by.blooddy.crypto {

	import by.blooddy.system.Memory;
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					28.01.2011 20:07:33
	 */
	public class CRC32 {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _TABLE:ByteArray = createTable();

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function hash(bytes:ByteArray):uint {

			var len:uint = bytes.length;
			if ( len > 0 ) {

				len += 1024;

				var app:ApplicationDomain = ApplicationDomain.currentDomain;

				var tmp:ByteArray = app.domainMemory;
				var mem:ByteArray = new ByteArray();
				mem.writeBytes( _TABLE );
				mem.writeBytes( bytes );

				app.domainMemory = mem;

				var c:uint = 0xFFFFFFFF;
				var i:uint = 1024;
				do {
					c = Memory.getI32( ( ( ( c ^ Memory.getUI8( i ) ) & 0xFF ) << 2 ) ) ^ ( c >>> 8 );
				} while ( ++i < len );

				app.domainMemory = tmp;

				return c ^ 0xFFFFFFFF;

			} else {

				return 0;

			}

		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function createTable():ByteArray {

			var app:ApplicationDomain = ApplicationDomain.currentDomain;

			var tmp:ByteArray = app.domainMemory;
			var mem:ByteArray = new ByteArray();
			mem.length = Math.max( 1024, ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH );

			app.domainMemory = mem;

			var c:uint;
			var j:uint;
			var i:uint;
			for ( i=0; i<256; ++i ) {
				c = i;
				for ( j=0; j<8; ++j ) {
					if ( c & 1 == 1 ) {
						c = 0xEDB88320 ^ ( c >>> 1 );
					} else {
						c >>>= 1;
					}
				}
				Memory.setI32( i << 2, c );
			}

			app.domainMemory = tmp;

			mem.length = 1024;

			return mem;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function CRC32() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}

	}

}