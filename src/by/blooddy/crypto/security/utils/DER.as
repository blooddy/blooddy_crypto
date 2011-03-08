////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.utils {

	import by.blooddy.system.Memory;
	
	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					17.01.2011 1:16:42
	 * 
	 * @see						http://en.wikipedia.org/wiki/Distinguished_Encoding_Rules
	 */
	public final dynamic class DER {

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const BOOLEAN:uint =				 1;

		public static const INTEGER:uint =				 2;

		public static const BIT_STRING:uint =			 3;

		public static const OCTET_STRING:uint =			 4;

		public static const NULL:uint =					 5;

		public static const OBJECT_IDENTIFIER:uint =	 6;

		public static const OBJECT_DESCRIPTOR:uint =	 7;

		public static const EXTERNAL:uint =				 8;

		public static const REAL:uint =					 9;

		public static const ENUMERATED:uint =			10;

		public static const EMBEDDED_PDV:uint =			11;

		public static const UTF8_STRING:uint =			12;

		public static const RELATIVE_OID:uint =			13;

		public static const SEQUENCE:uint =				16;

		public static const SET:uint =					17;

		public static const NUMERIC_STRING:uint =		18;

		public static const PRINTABLE_STRING:uint =		19;

		public static const TELETEX_STRING:uint =		20;

		public static const VIDEOTEX_STRING:uint =		21;

		public static const IA5_STRING:uint =			22;

		public static const UTC_TIME:uint =				23;

		public static const GENERALIZED_TIME:uint =		24;

		public static const GRAPHIC_STRING:uint =		25;

		public static const VISIBLE_STRING:uint =		26;

		public static const GENERAL_STRING:uint =		27;

		public static const UNIVERSAL_STRING:uint =		28;

		public static const CHARACTER_STRING:uint =		29;

		public static const BMP_STRING:uint =			30;

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static var _privateCall:Boolean = false;

		/**
		 * @private
		 */
		private static var _position:uint;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function readMemory(position:uint, length:uint):DER {
			var v:uint;

			if ( position >= length ) throw null;

			// type
			var type:uint = Memory.getUI8( position );
			++position;
			//var c:uint = type & 0x20;
			var cv:uint = type & 0xC0;
			type &= 0x1F;
			if ( type == 0x1F ) {
				// multibyte tag. blah.
				type = 0;
				do {
					if ( position >= length ) throw null;
					if ( type > 0x1FFFFF ) throw null; // more than 4 bytes dont suported
					v = Memory.getUI8( position );
					++position;
					type = ( type << 7 ) | ( v & 0x7F );
				} while ( v & 0x80 != 0 );
			}
			// length
			var len:uint = Memory.getUI8( position );
			++position;
			if ( len >= 0x80 ) {
				// long form of length
				v = len & 0x7f;
				if ( position + v > length ) throw null;
				len = 0;
				while ( v-- > 0 ) {
					if ( len > 0xFFFFFF ) throw null; // more than 4 bytes dont suported
					len = ( len << 8 ) | Memory.getUI8( position );
					++position;
				}
			}

			var end:uint = position + len;
			if ( end > length ) throw null;

			var result:DER;

			if ( cv ) {	// application, context, private

				position = end;
				// skip not universal tags

			} else {				// universal

				_privateCall = true;
				result = new DER();
				result.type = type;
				result.block = new MemoryBlock( position, len );

				var t:DER;

				// data
				if ( type == SEQUENCE ) {
					result.seq = new Vector.<DER>();
					while( position < end ) {
						t = readMemory( position, end );
						if ( t ) result.seq.push( t );
						position = _position;
					}
				} else if ( type == OBJECT_IDENTIFIER ) {
					if ( len < 1 ) throw null;
					v = Memory.getUI8( position );
					++position;
					var arr:Vector.<uint> = new Vector.<uint>();
					arr.push( int( v / 40 ) );
					arr.push(      v % 40   );
					var u:uint = 0;
					while ( position < end ) {
						v = Memory.getUI8( position );
						++position;
						u = ( u << 7 ) | ( v & 0x7F );
						if ( ( v & 0x80 ) == 0 ) {
							arr.push( u );
							u = 0;
						}
					}
					result.oid = arr.join( '.' );
				} else {
					if ( type == BIT_STRING ) {
						while ( Memory.getUI8( position ) == 0 ) {
							++position;
							--len;
						}
						result.block.pos = position;
						result.block.len = len;
					}
					position = end;
				}

			}

			_position = position;
			return result;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 * Constructor
		 */
		public function DER() {
			super();
			if ( !_privateCall ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			_privateCall = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public var type:uint;

		public var block:MemoryBlock;

	}

}