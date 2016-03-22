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
	 * @playerversion			Flash 10
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
			return JSON$.encode( value );
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
			return JSON$.decode( value );
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

import flash.errors.IllegalOperationError;
import flash.errors.StackOverflowError;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Endian;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import by.blooddy.crypto.serialization.SerializationHelper;

/**
 * @private
 */
internal final class JSON$ {

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
			tmp.writeUTFBytes( value );

			var i:int = 0;
			var j:int = 0;
			var l:int = 0;
			var len:uint = tmp.length;
			
			var c:int = 0;
			
			do {
				
				c = _ESCAPE[ tmp[ i ] ];
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
			
			tmp.length = 0;
			tmp.position = 0;
			
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

	//--------------------------------------------------------------------------
	//
	//  Decode
	//
	//--------------------------------------------------------------------------
	
	internal static function decode(value:String):* {
		throw new IllegalOperationError();
	}
	
}