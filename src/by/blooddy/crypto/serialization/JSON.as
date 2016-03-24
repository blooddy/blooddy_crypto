////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.serialization {

	import flash.system.ApplicationDomain;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author					BlooDHounD
	 * @version					3.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					01.10.2010 15:53:38
	 * 
	 * @see						http://www.json.org
	 */
	public final class JSON {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		[Deprecated( replacement="stringify" )]
		/**
		 * @param	value
		 * 
		 * @return
		 * 
		 * @throws	StackOverflowError	
		 */
		public static function encode(value:*):String {
			return JSON$Encoder.encode( value );
		}

		/**
		 * @param	value
		 * 
		 * @return
		 * 
		 * @throws	StackOverflowError	
		 */
		public static const stringify:Function = ( ApplicationDomain.currentDomain.hasDefinition( 'JSON' )
			? ApplicationDomain.currentDomain.getDefinition( 'JSON' ).stringify
			: encode
		);
		
		[Deprecated( replacement="parse" )]
		/**
		 * @param	value
		 * 
		 * @return
		 * 
		 * @throws	TypeError			
		 * @throws	SyntaxError
		 */
		public static function decode(value:String):* {
			return JSON$Decoder.decode( value );
		}
		
		/**
		 * @param	value
		 * 
		 * @return
		 * 
		 * @throws	TypeError			
		 * @throws	SyntaxError
		 */
		public static const parse:Function = ( ApplicationDomain.currentDomain.hasDefinition( 'JSON' )
			? ApplicationDomain.currentDomain.getDefinition( 'JSON' ).parse
			: decode
		);
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function JSON() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}

import flash.errors.StackOverflowError;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Endian;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import avm2.intrinsics.memory.li16;
import avm2.intrinsics.memory.li32;
import avm2.intrinsics.memory.li8;

import by.blooddy.crypto.serialization.SerializationHelper;

/**
 * @private
 */
internal final class JSON$Encoder {

	//--------------------------------------------------------------------------
	//
	//  Encode
	//
	//--------------------------------------------------------------------------
	
	internal static function encode(value:*):String {

		var bytes:ByteArray = new ByteArray();
		bytes.endian = Endian.LITTLE_ENDIAN;

		writeValue( new Dictionary(), bytes, value );
		
		bytes.position = 0;
		return bytes.readUTFBytes( bytes.length );

	}
	
	//--------------------------------------------------------------------------
	//  encode variables
	//--------------------------------------------------------------------------
	
	private static const _TMP:ByteArray = new ByteArray();
	
	private static const _ESCAPE:Vector.<int> = ( function():Vector.<int> {
		
		var escape:Vector.<int> = new Vector.<int>( 0x100, true );
		
		var j:int = 0;
		
		for ( ; j < 0x0A; ++j ) {
			escape[ j ] = ( j + 0x30 ) | 0x30303000;	// 000[0-9]
		}
		for ( ; j < 0x10; ++j ) {
			escape[ j ] = ( j + 0x37 ) | 0x30303000;	// 000[A-F]
		}
		for ( ;j < 0x1A; ++j ) {
			escape[ j ] = ( j + 0x20 ) | 0x30303100;	// 00[1][0-9]
		}
		for ( ;j < 0x20; ++j ) {
			escape[ j ] = ( j + 0x27 ) | 0x30303100;	// 00[1][A-F]
		}
		for ( ;j < 0x100; ++j ) {
			escape[ j ] = j;
		}
		
		escape[ 0x08 ] = 0x625C; // \b
		escape[ 0x09 ] = 0x745C; // \t
		escape[ 0x0A ] = 0x6E5C; // \n
		escape[ 0x0B ] = 0x765C; // \v
		escape[ 0x0C ] = 0x665C; // \f
		escape[ 0x0D ] = 0x725C; // \r
		escape[ 0x22 ] = 0x225C; // \"
		escape[ 0x2F ] = 0x2F5C; // \/
		escape[ 0x5C ] = 0x5C5C; // \\
		
		return escape;
		
	}() );
	
	private static const _VALID_KEY:Object = {
		'number':		true,
		'string':		true,
		'object':		false,
		'boolean':		false,
		'undefined':	false,
		'xml':			false,
		'function':		false
	};
	
	//--------------------------------------------------------------------------
	//  encode main methods
	//--------------------------------------------------------------------------
	
	private static function writeValue(hash:Dictionary, bytes:ByteArray, value:*):void {
		_TYPE_WPRITERS[ typeof value ]( hash, bytes, value );
	}
	
	private static function writeNull(hash:Dictionary, bytes:ByteArray, value:*):void {
		bytes.writeInt( 0x6C6C756E );	// null
	}
	
	//--------------------------------------------------------------------------
	//  encode type writers
	//--------------------------------------------------------------------------
	
	private static const _TYPE_WPRITERS:Object = {
		'number':		writeTypeNumber,
		'string':		writeTypeString,
		'object':		writeTypeObject,
		'boolean':		writeTypeBoolean,
		'undefined':	writeNull,
		'xml':			writeTypeXML,
		'function':		writeTypeFunction
	};
	
	private static function writeTypeNumber(hash:Dictionary, bytes:ByteArray, value:Number):void {
		if ( isFinite( value ) ) {
			bytes.writeUTFBytes( value.toString() );
		} else {
			writeNull( hash, bytes, null );
		}
	}
	
	private static function writeTypeString(hash:Dictionary, bytes:ByteArray, value:String):void {
		if ( value ) {
			
			bytes.writeByte( 0x22 );	// "
			
			var escape:Vector.<int> = _ESCAPE;
			
			var tmp:ByteArray = _TMP;
			tmp.length = 0;
			tmp.position = 0;
			tmp.writeUTFBytes( value );

			var i:int = 0;
			var j:int = 0;
			var l:int = 0;
			var len:uint = tmp.length;
			
			var c:int = 0;
			
			do {
				
				c = escape[ tmp[ i ] ];
				if ( c > 0x100 ) {
					l = i - j;
					if ( l > 0 ) {
						bytes.writeBytes( tmp, j, i );
					}
					j = i + 1;
					if ( c > 0x10000 ) {
						bytes.writeShort( 0x755C );	// \u
						bytes.writeInt( c );
					} else {
						bytes.writeShort( c );
					}
				}
				
			} while ( ++i < len );
			
			l = i - j;
			if ( l > 0 ) {
				bytes.writeBytes( tmp, j, l );
			}
			
			bytes.writeByte( 0x22 );	// "
			
		} else {
			
			bytes.writeShort( 0x2222 );	// ""
		
		}
	}
	
	private static function writeTypeObject(hash:Dictionary, bytes:ByteArray, value:Object):void {
		if ( value ) {
			
			if ( value in hash ) {
				Error.throwError( StackOverflowError, 1129 );
			}
			
			hash[ value ] = true;

			var v:*;

			if (
				'toJSON' in value &&
				typeof value.toJSON == 'function' &&
				( v = value.toJSON( null ) ) != value
			) {
				
				writeValue( hash, bytes, v );
				
			} else {
			
				var write:Function = _CLASS_WRITERS[ value.constructor ];
				if ( write ) {
					
					write( hash, bytes, value );
	
				} else {
				
					bytes.writeByte( 0x7B );	// {
					
					var k:String;
					var f:Boolean = false;
					
					if ( value.constructor != Object ) {
						
						for each ( k in SerializationHelper.getPropertyNames( value ) ) {
	
							try {
								v = value[ k ];
							} catch ( _:* ) {
								continue;
							}
							if ( typeof v != 'function' ) {
	
								if ( f ) bytes.writeByte( 0x2C );	// ,
								else f = true;
		
								writeTypeString( hash, bytes, k );
								bytes.writeByte( 0x3A );	// :
								writeValue( hash, bytes, v );
								
							}
	
						}
						
					}
					
					if ( value is Dictionary ) {
						var validKey:Object = _VALID_KEY;
						for ( k in value ) {
							if ( validKey[ typeof k ] ) {						
								
								v = value[ k ];
								if ( typeof v != 'function' ) {
									
									if ( f ) bytes.writeByte( 0x2C );	// ,
									else f = true;
									
									writeTypeString( hash, bytes, k );
									bytes.writeByte( 0x3A );	// :
									writeValue( hash, bytes, v );
	
								}
								
							}
						}
					} else {
						for ( k in value ) {
	
							v = value[ k ];
							if ( typeof v != 'function' ) {
								
								if ( f ) bytes.writeByte( 0x2C );	// ,
								else f = true;
								
								writeTypeString( hash, bytes, k );
								bytes.writeByte( 0x3A );	// :
								writeValue( hash, bytes, v );
	
							}
						}
					}
					
					bytes.writeByte( 0x7D );	// }
						
				}
				
			}
			
			delete hash[ value ];
			
		} else {
			
			writeNull( hash, bytes, null );
			
		}
	}
	
	private static function writeTypeBoolean(hash:Dictionary, bytes:ByteArray, value:Boolean):void {
		if ( value ) {
			bytes.writeInt( 0x65757274 );	// true
		} else {
			bytes.writeInt( 0x736C6166 );	// fals
			bytes.writeByte( 0x65 );		// e
		}
	}
	
	private static function writeTypeXML(hash:Dictionary, bytes:ByteArray, value:XML):void {
		if ( 'toJSON' in value ) {
			writeValue( hash, bytes, value.toJSON( null ) );
		} else {
			writeTypeString( hash, bytes, value.toXMLString() );
		}
	}
	
	private static function writeTypeFunction(hash:Dictionary, bytes:ByteArray, value:*):void {
		writeNull( hash, bytes, null );
	}
	
	//--------------------------------------------------------------------------
	//  encode class writers
	//--------------------------------------------------------------------------
	
	private static const _CLASS_WRITERS:Dictionary = new Dictionary();
	_CLASS_WRITERS[ Object ] = null;
	_CLASS_WRITERS[ Array ] =			writeClassArray;
	_CLASS_WRITERS[ Vector.<*> ] =		writeClassVector;
	_CLASS_WRITERS[ Vector.<int> ] =	writeClassVectorInt;
	_CLASS_WRITERS[ Vector.<uint> ] =	writeClassVectorUint;
	_CLASS_WRITERS[ Vector.<Number> ] =	writeClassVectorNumber;
	_CLASS_WRITERS[ XMLDocument ] =		writeClassXMLDocument;
	_CLASS_WRITERS[ XMLNode ] =			writeClassXMLNode;
//	_CLASS_WRITERS[ Date ] =			writeClassDate;
	_CLASS_WRITERS[ Dictionary ] =		writeClassDictionary;
//	_CLASS_WRITERS[ RegExp ] = 			writeClassRegExp;
	_CLASS_WRITERS[ ByteArray ] =		writeClassByteArray;
	
	private static function writeClassObject(hash:Dictionary, bytes:ByteArray, value:Object):void {
		
		bytes.writeByte( 0x7B );	// {
		
		var k:String;
		var v:*;
		var f:Boolean;
		
		for ( k in value ) {
			
			v = value[ k ];
			if ( typeof v != 'function' ) {

				if ( f ) bytes.writeByte( 0x2C );	// ,
				else f = true;
				
				writeTypeString( hash, bytes, k );
				bytes.writeByte( 0x3A );	// :
				writeValue( hash, bytes, v );

			}
			
		}
		
		bytes.writeByte( 0x7D );	// }

	}
	
	private static function writeClassArray(hash:Dictionary, bytes:ByteArray, value:Array):void {

		bytes.writeByte( 0x5B );	// [
		
		var l:uint = value.length;
		if ( l > 0 ) {
			writeValue( hash, bytes, value[ 0 ] );
			var i:int = 0;
			while ( ++i < l ) {
				bytes.writeByte( 0x2C );	// ,
				writeValue( hash, bytes, value[ i ] );
			}
		}
		
		bytes.writeByte( 0x5D );	// ]
	
	}

	private static function writeClassVector(hash:Dictionary, bytes:ByteArray, value:Vector.<*>):void {

		bytes.writeByte( 0x5B );	// [
		
		var l:uint = value.length;
		if ( l > 0 ) {
			var i:int = 0;
			if ( value is Vector.<String> ) {
				
				if ( value[ 0 ] == null ) {
					writeNull( hash, bytes, null );
				} else {
					writeTypeString( hash, bytes, value[ 0 ] );
				}
				while ( ++i < l ) {
					bytes.writeByte( 0x2C );	// ,
					if ( value[ i ] == null ) {
						writeNull( hash, bytes, null );
					} else {
						writeTypeString( hash, bytes, value[ i ] );
					}
				}

			} else if ( value is Vector.<Boolean> ) {
				
				writeTypeBoolean( hash, bytes, value[ 0 ] );
				while ( ++i < l ) {
					bytes.writeByte( 0x2C );	// ,
					writeTypeBoolean( hash, bytes, value[ i ] );
				}

			} else {

				writeValue( hash, bytes, value[ 0 ] );
				while ( ++i < l ) {
					bytes.writeByte( 0x2C );	// ,
					writeValue( hash, bytes, value[ i ] );
				}

			}
		}
		
		bytes.writeByte( 0x5D );	// ]
		
	}

	private static function writeClassVectorInt(hash:Dictionary, bytes:ByteArray, value:Vector.<int>):void {

		bytes.writeByte( 0x5B );	// [
		
		var l:uint = value.length;
		if ( l > 0 ) {
			writeTypeNumber( hash, bytes, value[ 0 ] );
			var i:int = 0;
			while ( ++i < l ) {
				bytes.writeByte( 0x2C );	// ,
				writeTypeNumber( hash, bytes, value[ i ] );
			}
		}
		
		bytes.writeByte( 0x5D );	// ]

	}
	
	private static function writeClassVectorUint(hash:Dictionary, bytes:ByteArray, value:Vector.<uint>):void {
		
		bytes.writeByte( 0x5B );	// [
		
		var l:uint = value.length;
		if ( l > 0 ) {
			writeTypeNumber( hash, bytes, value[ 0 ] );
			var i:int = 0;
			while ( ++i < l ) {
				bytes.writeByte( 0x2C );	// ,
				writeTypeNumber( hash, bytes, value[ i ] );
			}
		}
		
		bytes.writeByte( 0x5D );	// ]
		
	}

	private static function writeClassVectorNumber(hash:Dictionary, bytes:ByteArray, value:Vector.<Number>):void {

		bytes.writeByte( 0x5B );	// [
		
		var l:uint = value.length;
		if ( l > 0 ) {
			writeTypeNumber( hash, bytes, value[ 0 ] );
			var i:int = 0;
			while ( ++i < l ) {
				bytes.writeByte( 0x2C );	// ,
				writeTypeNumber( hash, bytes, value[ i ] );
			}
		}
		
		bytes.writeByte( 0x5D );	// ]

	}
	
	private static function writeClassXMLDocument(hash:Dictionary, bytes:ByteArray, value:XMLDocument):void {
		writeTypeXML( hash, bytes, new XML( value.childNodes.length > 0 ? value : new XML() ) );
	}
	
	private static function writeClassXMLNode(hash:Dictionary, bytes:ByteArray, value:XMLNode):void {
		writeTypeXML( hash, bytes, new XML( value ) );
	}

	private static function writeClassDate(hash:Dictionary, bytes:ByteArray, value:Date):void {
		writeTypeString( hash, bytes, value.toString() );
	}

	private static function writeClassDictionary(hash:Dictionary, bytes:ByteArray, value:Dictionary):void {
		
		bytes.writeByte( 0x7B );	// {
		
		var validKey:Object = _VALID_KEY;
		
		var k:*;
		var v:*;
		var f:Boolean;
		
		for ( k in value ) {
			if ( validKey[ typeof k ] ) {

				v = value[ k ];
				if ( typeof v != 'function' ) {
					
					if ( f ) bytes.writeByte( 0x2C );	// ,
					else f = true;
					
					writeTypeString( hash, bytes, k );
					bytes.writeByte( 0x3A );	// :
					writeValue( hash, bytes, v );

				}

			}
		}
		
		bytes.writeByte( 0x7D );	// }

	}

	private static function writeClassRegExp(hash:Dictionary, bytes:ByteArray, value:RegExp):void {
		writeTypeString( hash, bytes, String( value ) );
	}

	private static function writeClassByteArray(hash:Dictionary, bytes:ByteArray, value:ByteArray):void {
		writeNull( hash, bytes, value );
	}
}

/**
 * @private
 */
internal final class JSON$Decoder {

	//--------------------------------------------------------------------------
	//
	//  Decode
	//
	//--------------------------------------------------------------------------
	
	internal static function decode(value:String):* {
		var result:*;
		if ( value ) {
			
			var tmp:ByteArray = _DOMAIN.domainMemory;
			
			var mem:ByteArray = new ByteArray();
			mem.writeUTFBytes( value );
			mem.writeByte( 0 ); // EOF
			
			if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
			_DOMAIN.domainMemory = mem;
			
			_POS = 0;
			
			var c:int = skip( mem, li8( 0 ) & 0xFF );
			if ( c != 0 ) {
			
				result = readValue( mem, c );
				
				c = skip( mem, li8( _POS ) & 0xFF );
				if ( c != 0 ) {
					readError( mem, c );
				}
				
			}
			
			_DOMAIN.domainMemory = tmp;
			
		}
		return result;
	}
	
	//--------------------------------------------------------------------------
	//  decode variables
	//--------------------------------------------------------------------------
	
	private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
	
	private static const _TMP:ByteArray = new ByteArray();
	
	private static const _SKIP:Vector.<Boolean> = ( function():Vector.<Boolean> {
		
		var skip:Vector.<Boolean> = new Vector.<Boolean>( 0x100, true );
		
		skip[ 0x08 ] = true;	/* BACKSPACE */
		skip[ 0x09 ] = true;	/* TAB */
		skip[ 0x0A ] = true;	/* NEWLINE */
		skip[ 0x0B ] = true;	/* VERTICAL_TAB */
		skip[ 0x0C ] = true;	/* FORM_FEED */
		skip[ 0x0D ] = true;	/* CARRIAGE_RETURN */
		skip[ 0x20 ] = true;	/* SPACE */
		
		skip[ 0x2F ] = true;	/* SLASH */
		
		return skip;
		
	}() );
	
	private static const _NEWLINE:Vector.<Boolean> = ( function():Vector.<Boolean> {
		
		var newline:Vector.<Boolean> = new Vector.<Boolean>( 0x100, true );
		
		newline[ 0x00 ] = true;	/* EOS */
		newline[ 0x0A ] = true;	/* NEWLINE */
		newline[ 0x0D ] = true;	/* CARRIAGE_RETURN */
		
		return newline;
		
	}() );
	
	private static const _ESCAPE:Vector.<int> = ( function():Vector.<int> {
	
		var escape:Vector.<int> = new Vector.<int>( 0x100, true );
		
		for ( var i:int = 0; i<0x100; ++i ) {
			escape[ i ] = i;
		}
		
		escape[ 0x62 ] = 0x08;
		escape[ 0x74 ] = 0x09;
		escape[ 0x6E ] = 0x0A;
		escape[ 0x76 ] = 0x0B;
		escape[ 0x66 ] = 0x0C;
		escape[ 0x72 ] = 0x0D;
		escape[ 0x22 ] = 0x22;
		escape[ 0x27 ] = 0x27;
		escape[ 0x5C ] = 0x5C;
		
		return escape;
	
	}() );
	
	private static const _DEC:Vector.<Boolean> = ( function():Vector.<Boolean> {
		
		var dec:Vector.<Boolean> = new Vector.<Boolean>( 0x100, true );
		
		for ( var i:int = 0x30; i<=0x39; ++i ) { // 0..9
			dec[ i ] = true;
		}
		
		return dec;
		
	}() );
	
	private static const _HEX:Vector.<Boolean> = ( function():Vector.<Boolean> {
		
		var hex:Vector.<Boolean> = new Vector.<Boolean>( 0x100, true );

		var i:int = 0;

		for ( i=0x30; i<=0x39; ++i ) { // 0..9
			hex[ i ] = true;
		}
		for ( i=0x41; i<=0x46; ++i ) { // A..F
			hex[ i ] = true;
		}
		for ( i=0x61; i<=0x66; ++i ) { // a..f
			hex[ i ] = true;
		}
		
		return hex;
		
	}() );

	private static const _IDENTIFIER:Vector.<Boolean> = ( function():Vector.<Boolean> {
		
		var identifier:Vector.<Boolean> = new Vector.<Boolean>( 0x100, true );
		
		var i:int = 0;
		
		identifier[ 0x24 ] = true;
		for ( i=0x30; i<=0x39; ++i ) { // 0..9
			identifier[ i ] = true;
		}
		for ( i=0x41; i<=0x5A; ++i ) { // A..Z
			identifier[ i ] = true;
		}
		identifier[ 0x5F ] = true;
		for ( i=0x61; i<=0x7A; ++i ) { // a..z
			identifier[ i ] = true;
		}
		for ( i=0x80; i<0x100; ++i ) {
			identifier[ i ] = true;
		}

		return identifier;
		
	}() );
	
	private static const _NOT_VALID_IDENTIFIER:Object = {
		'null': true,
		'true': true,
		'false': true
	};

	private static const _VALUE_READERS:Vector.<Function> = ( function():Vector.<Function> {
		var readers:Vector.<Function> = new Vector.<Function>( 0x100, true );
		
		for ( var i:int = 0; i<0x100; ++i ) {
			readers[ i ] = readError;
		}
		
		readers[ 0x22 ] = readString;	/* DOUBLE_QUOTE */
		readers[ 0x27 ] = readString;	/* SINGLE_QUOTE */

		readers[ 0x2D ] = readDash;			/* DASH */
		readers[ 0x2E ] = readDot;			/* DOT */
		readers[ 0x30 ] = readNumberZero;	/* ZERO */
		readers[ 0x31 ] = readNumber;		/* ONE */
		readers[ 0x32 ] = readNumber;		/* TWO */
		readers[ 0x33 ] = readNumber;		/* THREE */	
		readers[ 0x34 ] = readNumber;		/* FOUR */
		readers[ 0x35 ] = readNumber;		/* FIVE */
		readers[ 0x36 ] = readNumber;		/* SIX */
		readers[ 0x37 ] = readNumber;		/* SEVEN */
		readers[ 0x38 ] = readNumber;		/* EIGHT */
		readers[ 0x39 ] = readNumber;		/* NINE */
		
		readers[ 0x5B ] = readArray;		/* LEFT_BRACKET */
		
		readers[ 0x7B ] = readObject;		/* LEFT_BRACE */
		
		readers[ 0x6E ] = readNull;			/* n */
		readers[ 0x74 ] = readTrue;			/* t */
		readers[ 0x66 ] = readFalse;		/* f */
		readers[ 0x4E ] = readNaN;			/* N */
		readers[ 0x75 ] = readUndefined;	/* u */
		
		return readers;
	}() );
	
	private static const _IDENTIFIER_READERS:Vector.<Function> = ( function():Vector.<Function> {
		var readers:Vector.<Function> = _VALUE_READERS.slice(); readers.fixed = true;
		
		readers[ 0x5B ] = readError;		/* LEFT_BRACKET */
		readers[ 0x7B ] = readError;		/* LEFT_BRACE */

		var i:int;
		
		readers[ 0x24 ] = readIdentifier;
		for ( i=0x41; i<=0x5A; ++i ) { // A..Z
			readers[ i ] = readIdentifier;
		}
		readers[ 0x5F ] = readIdentifier;
		for ( i=0x61; i<=0x7A; ++i ) { // a..z
			readers[ i ] = readIdentifier;
		}
		for ( i=0x80; i<0x100; ++i ) {
			readers[ i ] = readIdentifier;
		}
		
		return readers;
	}() );

	private static var _POS:int;
	
	//--------------------------------------------------------------------------
	//  decode main methods
	//--------------------------------------------------------------------------

	private static function skip(mem:ByteArray, c:int):int {
		if ( _SKIP[ c ] ) {
			var pos:int = _POS;
			do {
				if ( c == 0x2F /* SLASH */  ) {
					c = li8( ++pos ) & 0xFF;
					if ( c == 0x2F /* SLASH */ ) {
						do {
							c = li8( ++pos ) & 0xFF;
						} while ( !_NEWLINE[ c ] );
					} else if ( c == 0x2A /* ASTERISK */ ) {
						do {
							c = li8( ++pos ) & 0xFF;
							if ( c == 0 /* EOS */ ) {
								readError( mem, c );
							}
						} while ( ( c != 0x2A || ( li8( pos + 1 ) & 0xFF ) != 0x2F ) );
						++pos;
					} else {
						readError( mem, c );
					}
				}
			} while ( _SKIP[ c = li8( ++pos ) & 0xFF ] );
			_POS = pos;
		}
		return c;
	}
	
	private static function readError(mem:ByteArray, c:int):* {
		Error.throwError( SyntaxError, 1132 );
	}
	
	private static function readValue(mem:ByteArray, c:int):* {
		return _VALUE_READERS[ c ]( mem, c );
	}
	
	private static function readString(mem:ByteArray, to:int):String {
		
		var pos:int = _POS + 1;
		var p:int = pos;
		
		var escape:Vector.<int> = _ESCAPE;
		var hex:Vector.<Boolean> = _HEX;
		
		var tmp:ByteArray = _TMP;
		tmp.position = 0;
		tmp.length = 0;

		var l:int = 0;
		
		var c:int = 0;
		if ( ( c = li8( pos ) & 0xFF ) != to ) {
			var newline:Vector.<Boolean> = _NEWLINE;
			do {
			
				if ( c == 0x5C /* BACK_SLASH */ ) { // escape
					
					l = pos - p;
					if ( l > 0 ) {
						tmp.writeBytes( mem, p, l );
					}
					
					c = li8( ++pos ) & 0xFF;
					
					if ( c == 0x75 /* u */ ) {
						
						if ( 
							hex[ li8( pos + 1 ) & 0xFF ] &&
							hex[ li8( pos + 2 ) & 0xFF ] && 
							hex[ li8( pos + 3 ) & 0xFF ] && 
							hex[ li8( pos + 4 ) & 0xFF ] 
						) {
							mem.position = pos + 1;
							c = parseInt( mem.readUTFBytes( 4 ), 16 );
							if ( c > 0xFF ) {
								tmp.writeShort( c );
							} else {
								tmp.writeByte( c );
							}
							pos += 4;
						} else {
							tmp.writeByte( c );
						}
						
					} else if ( c == 0x78 /* x */ ) {
						
						if ( 
							hex[ li8( pos + 1 ) & 0xFF ] &&
							hex[ li8( pos + 2 ) & 0xFF ] 
						) {
							mem.position = pos + 1;
							tmp.writeByte( parseInt( mem.readUTFBytes( 2 ), 16 ) );
							pos += 2;
						} else {
							tmp.writeByte( c );
						}
	
					} else {
						tmp.writeByte( escape[ c ] );
					}
					
					p = pos + 1;
					
				} else if ( newline[ c ] ) {
					readError( mem, c );
				}

			} while ( ( c = li8( ++pos ) & 0xFF ) != to );

		}

		l = pos - p;
		if ( l > 0 ) {
			tmp.writeBytes( mem, p, l );
		}

		_POS = pos + 1;

		if ( tmp.length ) {

			tmp.position = 0;
			return tmp.readUTFBytes( tmp.length );

		} else {

			return '';

		}

	}
	
	private static function readNumberZero(mem:ByteArray, c:int):Number {

		var result:Number = 0;
		
		var pos:int = _POS;
		var p:int = pos;
		
		var num:Vector.<Boolean>;

		c = li8( ++pos ) & 0xFF;
		if ( c == 0x78 /* x */ || c == 0x58 /* X */ ) {

			num = _HEX;
			
			while ( num[ li8( ++pos ) & 0xFF ] ) {}
			
			p += 2;
			c = pos - p;
			if ( c > 0 ) {
				mem.position = p;
				result = parseInt( mem.readUTFBytes( c ), 16 );
			} else {
				readError( mem, c );
			}
			
		} else {
			
			num = _DEC;

			if ( num[ c ] ) {
				while ( num[ c = li8( ++pos ) & 0xFF ] ) {}
			}
			if ( c == 0x2E /* DOT */ ) {
				if ( num[ c = li8( ++pos ) & 0xFF ] ) {
					while ( num[ c = li8( pos++ ) & 0xFF ] ) {}
				} else {
					readError( mem, c );
				}
			}
			if ( c == 0x65 /* e */ || c == 0x45 /* E */ ) {
				c = li8( ++pos ) & 0xFF;
				if ( c == 0x2D /* DASH */ || c == 0x2B /* PLUS */ ) {
					c = li8( ++pos ) & 0xFF;
				}
				if ( num[ c ] ) {
					while ( num[ c = li8( ++pos ) & 0xFF ] ) {}
				} else {
					readError( mem, c );
				}
			}
			
			if ( pos > p + 1 ) {
				mem.position = p;
				result = parseFloat( mem.readUTFBytes( pos - p ) );
			}
			
		}

		_POS = pos;
		
		return result;

	}
	
	private static function readNumber(mem:ByteArray, c:int):Number {

		var pos:int = _POS;
		var p:int = pos;
		
		var num:Vector.<Boolean> = _DEC;
		
		while ( num[ c = li8( ++pos ) & 0xFF ] ) {}
		if ( c == 0x2E /* DOT */ ) {
			if ( num[ c = li8( ++pos ) & 0xFF ] ) {
				while ( num[ c = li8( pos++ ) & 0xFF ] ) {}
			} else {
				readError( mem, c );
			}
		}
		if ( c == 0x65 /* e */ || c == 0x45 /* E */ ) {
			c = li8( ++pos ) & 0xFF;
			if ( c == 0x2D /* DASH */ || c == 0x2B /* PLUS */ ) {
				c = li8( ++pos ) & 0xFF;
			}
			if ( num[ c ] ) {
				while ( num[ c = li8( ++pos ) & 0xFF ] ) {}
			} else {
				readError( mem, c );
			}
		}
		
		_POS = pos;

		mem.position = p;
		return parseFloat( mem.readUTFBytes( pos - p ) );

	}
	
	private static function readDot(mem:ByteArray, c:int):Number {
		
		var pos:int = _POS;
		var p:int = pos;
		
		var num:Vector.<Boolean> = _DEC;
		
		if ( num[ c = li8( ++pos ) & 0xFF ] ) {
			while ( num[ c = li8( ++pos ) & 0xFF ] ) {}
		} else {
			readError( mem, c );
		}
		if ( c == 0x65 /* e */ || c == 0x45 /* E */ ) {
			c = li8( ++pos ) & 0xFF;
			if ( c == 0x2D /* DASH */ || c == 0x2B /* PLUS */ ) {
				c = li8( ++pos ) & 0xFF;
			}
			if ( num[ c ] ) {
				while ( num[ c = li8( ++pos ) & 0xFF ] ) {}
			} else {
				readError( mem, c );
			}
		}
		
		_POS = pos;
		
		mem.position = p;
		return parseFloat( mem.readUTFBytes( pos - p ) );
		
	}
	
	private static function readDash(mem:ByteArray, c:int):Number {
		return -readValue( mem, skip( mem, li8( ++_POS ) ) );
	}
	
	private static function readArray(mem:ByteArray, c:int):Array {

		var result:Array = [];
		
		do {
			
			c = skip( mem, li8( ++_POS ) & 0xFF );
			if ( c == 0x2C /* COMMA */ ) {
				result.push( undefined );
			} else if ( c != 0x5D /* RIGHT_BRACKET */ ) {
				result.push( readValue( mem, c ) );
				c = skip( mem, li8( _POS ) & 0xFF );
			}
			
		} while ( c == 0x2C /* COMMA */ );
		
		if ( c != 0x5D /* RIGHT_BRACKET */ ) {
			readError( mem, c );
		}

		++_POS;
		
		return result;

	}
	
	private static function readObject(mem:ByteArray, c:int):Object {

		var result:Object = {};
		
		var key:String;
		
		do {
	
			c = skip( mem, li8( ++_POS ) & 0xFF );
			if ( c != 0x7D /* RIGHT_BRACE */ ) {
				key = _IDENTIFIER_READERS[ c ]( mem, c );
				c = skip( mem, li8( _POS ) & 0xFF );
				
				if ( c != 0x3A /* COLON */ ) readError( mem, c );
				c = skip( mem, li8( ++_POS ) & 0xFF );
	
				result[ key ] = readValue( mem, c );
				c = skip( mem, li8( _POS ) & 0xFF );

			}
					
		} while ( c == 0x2C /* COMMA */ );

		if ( c != 0x7D /* RIGHT_BRACE */ ) {
			readError( mem, c );
		}

		++_POS;

		return result;

	}

	private static function readNull(mem:ByteArray, c:int):* {
		if ( li32( _POS ) != 0x6C6C756E ) { // null
			readError( mem, c );
		}
		_POS += 4;
		return null;
	}
	
	private static function readTrue(mem:ByteArray, c:int):Boolean {
		if ( li32( _POS ) != 0x65757274 ) { // true
			readError( mem, c );
		}
		_POS += 4;
		return true;
	}
	
	private static function readFalse(mem:ByteArray, c:int):Boolean {
		if ( li32( _POS + 1 ) != 0x65736C61 ) { // alse
			readError( mem, c );
		}
		_POS += 5;
		return false;
	}
	
	private static function readNaN(mem:ByteArray, c:int):Number {
		if ( li16( _POS + 1 ) != 0x4E61 ) { // aN
			readError( mem, c );
		}
		_POS += 3;
		return Number.NaN;
	}
	
	private static function readUndefined(mem:ByteArray, c:int):* {
		if (
			li32( _POS + 1 ) != 0x6665646E || // ndef
			li32( _POS + 5 ) != 0x64656E69    // ined
		) {
			readError( mem, c );
		}
		_POS += 9;
		return undefined;
	}

	private static function readIdentifier(mem:ByteArray, c:int):String {
		
		var pos:int = _POS;
		var p:int = pos;
		
		var identifier:Vector.<Boolean> = _IDENTIFIER;
		
		do {
			c = li8( ++pos ) & 0xFF;
		} while ( identifier[ c ] );

		_POS = pos;

		mem.position = p;
		var result:String = mem.readUTFBytes( pos - p );
		if ( result in _NOT_VALID_IDENTIFIER ) {
			readError( mem, li8( p ) );
		}
		return result;

	}
	
}