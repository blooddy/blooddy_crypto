////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {
	
	import by.blooddy.math.utils.BigUint;
	
	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					09.02.2011 2:45:56
	 */
	public class BigInteger {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _domain:ApplicationDomain = ApplicationDomain.currentDomain;

		/**
		 * @private
		 */
		private static const _PATTERN:RegExp = /(^\s+|\s+$)/g;

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const ZERO:BigInteger =	new BigInteger();

		public static const ONE:BigInteger =	new BigInteger();

		public static const TWO:BigInteger =	new BigInteger();

		public static const TEN:BigInteger =	new BigInteger();

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		public static function fromNumber(value:Number):BigInteger {
			var result:BigInteger = new BigInteger();
			result._value = getValueFromNumber( value )
			return result;
		}
		
		public static function fromString(value:String, radix:uint=16):BigInteger {
			var result:BigInteger = new BigInteger();
			result._value = getValueFromString( value, radix )
			return result;
		}
		
		public static function fromVector(value:Vector.<uint>, negative:Boolean=false):BigInteger {
			var result:BigInteger = new BigInteger();
			result._value = getValueFromVector( value, negative )
			return result;
		}
		
		public static function fromByteArray(value:ByteArray, negative:Boolean=false):BigInteger {
			var result:BigInteger = new BigInteger();
			result._value = getValueFromByteArray( value, negative )
			return result;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		$private static function init():void {
			ONE._value = new BigValue();
			ONE._value.writeInt( 0x01 );
			TWO._value = new BigValue();
			TWO._value.writeInt( 0x02 );
			TEN._value = new BigValue();
			TEN._value.writeInt( 0x0A );
		}

		/**
		 * @private
		 */
		private static function fromBigValue(value:BigValue):BigInteger {
			var result:BigInteger = new BigInteger();
			result._value = value;
			return result;
		}
		
		/**
		 * private
		 */
		private static function getValue(value:*):BigValue {
			switch ( typeof value ) {
				case 'number':		return getValueFromNumber( value );
				case 'string':		return getValueFromString( value, 16 );
				case 'object':
					switch ( true ) {
						case value is ByteArray:		return getValueFromByteArray( value, false );
						case value is Vector.<uint>:	return getValueFromVector( value, false );
						case value is BigInteger:		return ( value as BigInteger )._value;
						case null:						return null;
					}
				case 'undefined':	return null;
			}
			throw new ArgumentError();
		}
		
		/**
		 * @private
		 */
		private static function getValueFromNumber(value:Number):BigValue {
			if ( !isFinite( value ) ) throw new ArgumentError();
			if ( value <= uint.MAX_VALUE && value >= int.MIN_VALUE ) {
				var result:BigValue = new BigValue();
				if ( value < 0 ) {
					result.negative = true; 
					value = -int( value );
				} else {
					value = uint( value );
				}
				if ( value == 0 ) return null;
				else {
					result.writeInt( value );
					return result;
				}
			} else {
				return getValueFromString( value.toString( 16 ), 16 );
			}
		}
		
		/**
		 * @private
		 */
		private static function getValueFromString(value:String, radix:uint):BigValue {
			if ( radix < 2 || radix > 32 ) throw new ArgumentError();
			if ( !value ) return null;
			var result:BigValue = new BigValue();
			value = value.replace( _PATTERN, '' );
			var len:uint = value.length;
			if ( !len ) return null;
			var p:uint = 0;
			if ( value.charAt( 0 ) == '-' ) {
				result.negative = true;
				++p;
			}
			var size:uint = ( 0xFF ).toString( radix ).length;
			if ( radix == 2 || radix == 4 || radix == 16 ) {
				if (
					radix == 16 &&
					len - p >= 2 &&
					value.charAt( p ) == '0' &&
					value.charAt( p + 1 ).toLocaleLowerCase() == 'x'
				) {
					p += 2;
				}
				var i:uint = len;
				var j:uint = p;
//				var i:int = v.length;
//				do {
//					Memory.setI32( p, parseInt( v.substring( Math.max( 0, i - 8 ), i ), 16 ) );
//					i -= 8;
//					p += 4;
//				} while ( i > 0 );
//				i = p - pos;
			} else {
				var c:uint = 0;
				result.writeInt( c );
			}
			result.position -= 4;
			while ( result.length > 0 && result.readInt() == 0 ) {
				result.length -= 4;
				result.position -= 4;
			}
			if ( result.length == 0 ) return null;
			return result;
		}
		
		/**
		 * @private
		 */
		private static function getValueFromVector(value:Vector.<uint>, negative:Boolean):BigValue {
			if ( value.length == 0 ) return null;
			var result:BigValue = new BigValue();
			for each ( var v:uint in value ) {
				result.writeInt( v );
			}
			if ( v == 0 ) {
				do {
					result.length -= 4;
					result.position -= 4;
				} while ( result.length > 0 && result.readInt() == 0 );
			}
			if ( result.length == 0 ) return null;
			return result;
		}
		
		/**
		 * @private
		 */
		private static function getValueFromByteArray(value:ByteArray, negative:Boolean):BigValue {
			if ( value.length == 0 ) return null;
			var result:BigValue;
			var i:uint;
			switch ( value.endian ) {
				case Endian.LITTLE_ENDIAN:
					result = new BigValue();
					result.writeBytes( value );
					break;
				case Endian.BIG_ENDIAN:
					result = new BigValue();
					if ( value.length >= 4 ) {
						value.position = value.length + 4;
						do {
							value.position -= 8;
							result.writeInt( value.readInt() );
						} while ( value.position >= 8 );
						value.position -= 4;
					} else {
						value.position = value.length;
					}
					if ( value.position > 0 ) {
						++value.position;
						do {
							value.position -= 2;
							result.writeByte( value.readByte() );
						} while ( value.position >= 2 );
					}
					break;
				default:
					throw new ArgumentError();
			}
			while ( result.length & 3 ) {
				result.writeByte( 0 );
			}
			result.position -= 4;
			while ( result.length > 0 && result.readInt() == 0 ) {
				result.length -= 4;
				result.position -= 4;
			}
			if ( result.length == 0 ) return null;
			return result;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 */
		public function BigInteger(...args) {
			super();
			var l:uint = args.length;
			if ( l > 0 ) {
				var value:* = args[ 0 ];
				switch ( typeof value ) {
					
					case 'number':
						if ( l != 1 ) throw new ArgumentError();
						this._value = getValueFromNumber( value );
						break;
					
					case 'string':
						var radix:uint;
						if ( l > 1 ) {
							if ( typeof args[ 1 ] != 'number' ) throw new ArgumentError();
							if ( l != 2 ) throw new ArgumentError();
							radix = args[ 1 ];
							if ( radix < 2 || radix > 32 ) throw new ArgumentError();
						} else {
							radix = 16;
						}
						this._value = getValueFromString( value, radix );
						break;
					
					case 'object':
						var negative:Boolean;
						switch ( true ) {
							case value is ByteArray:
								if ( args.length > 1 ) {
									if ( typeof args[ 1 ] != 'boolean' ) throw new ArgumentError();
									if ( l != 2 ) throw new ArgumentError();
									negative = args[ 1 ];
								}
								this._value = getValueFromByteArray( value, negative );
								break;
							case value is Vector.<uint>:
								if ( args.length > 1 ) {
									if ( typeof args[ 1 ] != 'boolean' ) throw new ArgumentError();
									if ( l != 2 ) throw new ArgumentError();
									negative = args[ 1 ];
								}
								this._value = getValueFromVector( value as Vector.<uint>, negative );
								break;
							case value is BigInteger:
								this._value = value._value;
								break;
						}
						break;
					
					default:
						throw new ArgumentError();
						
				}
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private var _value:BigValue;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function get sign():int {
			return	(
				this._value
				?	( this._value.negative ? -1 : 1 )
				:	0
			);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toNumber():Number {
			throw new IllegalOperationError( 'TODO' );
		}
		
		public function toString(radix:uint=16):String {
			throw new IllegalOperationError( 'TODO' );
		}
		
		public function toBytes(endian:String=Endian.LITTLE_ENDIAN):ByteArray {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		v & ( 1 << n ) != 0
		 */
		public function testBit(n:uint):Boolean {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this | ( 1 << n )
		 */
		public function setBit(n:uint):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this & ~( 1 << n )
		 */
		public function clearBit(n:uint):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this ^ ( 1 << n )
		 */
		public function flipBit(n:uint):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		~this
		 */
		public function not():BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this & v
		 */
		public function and(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this & ~v
		 */
		public function andNot(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this | v
		 */
		public function or(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this ^ v
		 */
		public function xor(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this >> n
		 */
		public function shiftRight(n:uint):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this << n
		 */
		public function shiftLeft(n:uint):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		( this > v ? 1 : ( v > this ? -1 : 0 )
		 */
		public function compare(v:BigInteger):int {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		( this > v ? v : this )
		 */
		public function min(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		( this < v ? v : this )
		 */
		public function max(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this + 1
		 */
		public function increment():BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this + v
		 */
		public function add(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this - 1
		 */
		public function decrement():BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this - v
		 */
		public function sub(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this * v
		 */
		public function mult(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		pow( this, e )
		 */
		public function powInt(e:uint):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		[ this / v, this % v ]
		 * @throws		ArgumentError	v == 0
		 */
		public function divAndMod(v:BigInteger):Vector.<BigInteger> {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this / v
		 * @throws		ArgumentError	v == 0
		 */
		public function div(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this % v;
		 * @throws		ArgumentError	v == 0
		 */
		public function mod(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		pow( this, e ) % v
		 * @throws		ArgumentError	v == 0
		 */
		public function modPowInt(e:int, v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		pow( this, e ) % v
		 * @throws		ArgumentError	v == 0
		 */
		public function modPow(e:BigInteger, v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		public function gcd(v:BigInteger, a:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		public function modInverse(v:BigInteger, m:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}
		
		public function isProbablePrime(v:BigInteger, t:int):Boolean {
			throw new IllegalOperationError( 'TODO' );
		}
		
		public function primify(v:BigInteger, bits:int, t:int):void {
			throw new IllegalOperationError( 'TODO' );
		}
		
	}
	
}

//==============================================================================
//
//  Inner definitions
//
//==============================================================================

import by.blooddy.math.BigInteger;

import flash.utils.ByteArray;
import flash.utils.Endian;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper namespace: $private
//
////////////////////////////////////////////////////////////////////////////////

internal namespace $private;

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: EventContainer
//
////////////////////////////////////////////////////////////////////////////////

/**
 * @private
 */
internal final class BigValue extends ByteArray {
	
	public function BigValue() {
		super();
		super.endian = Endian.LITTLE_ENDIAN;
	}
	
	public var negative:Boolean;
	
}

////////////////////////////////////////////////////////////////////////////////
//
//  Initialization
//
////////////////////////////////////////////////////////////////////////////////

BigInteger.$private::init();