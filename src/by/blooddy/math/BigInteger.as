////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {

	import by.blooddy.math.utils.BigUint;
	
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

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const ZERO:BigInteger =	new BigInteger( 0x00 );

		public static const ONE:BigInteger =	new BigInteger( 0x01 );

		public static const TWO:BigInteger =	new BigInteger( 0x02 );

		public static const TEN:BigInteger =	new BigInteger( 0x0A );
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function fromNumber(value:Number):BigInteger {
			return fromBigValue(
				getValueFromNumber( value )
			);
		}
		
		public static function fromString(value:String, radix:uint=16):BigInteger {
			return fromBigValue(
				getValueFromString( value, radix )
			);
		}

		public static function fromByteArray(value:ByteArray, negative:Boolean=false):BigInteger {
			return fromBigValue(
				getValueFromByteArray( value, negative )
			);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function fromBigValue(value:BigValue):BigInteger {
			switch ( value ) {
				case ZERO._value:	return ZERO;
				case ONE._value:	return ONE;
				case TWO._value:	return TWO;
				case TEN._value:	return TEN;
			}
			var result:BigInteger = new BigInteger();
			result._value = value;
			return result;
		}

		/**
		 * private
		 */
		private static function getValue(value:*):BigValue {
			switch ( typeof value ) {
				case 'number':	return getValueFromNumber( value );
				case 'string':	return getValueFromString( value, 16 );
				case 'object':
					switch ( true ) {
						case value is ByteArray:	return getValueFromByteArray( value, false );
						case value is BigInteger:	return ( value as BigInteger )._value;
					}
			}
			throw new ArgumentError();
		}

		/**
		 * @private
		 */
		private static function getValueFromNumber(value:Number):BigValue {
			if ( !isFinite( value ) ) throw new ArgumentError();
			if ( value == 0 )		return ZERO._value;
			else if ( value == 1 )	return ONE._value;
			else if ( value == 2 )	return TWO._value;
			else if ( value == 10 )	return TEN._value;
			else {
				var result:BigValue;
				if ( result is uint ) {
					result = new BigValue();
					result.writeUnsignedInt( value );
				} else if ( value is int ) {
					result = new BigValue();
					result.negative = value < 0; 
					result.writeInt( result.negative ? Math.abs( value ) : value );
				} else {
					result = getValueFromString( value.toString( 16 ), 16 );
				}
				return result;
			}
		}

		/**
		 * @private
		 */
		private static function getValueFromString(value:String, radix:uint):BigValue {
			if ( radix < 2 || radix > 32 ) throw new ArgumentError();
			if ( !value ) return ZERO._value;
			var result:BigValue;
			// TODO: normalize
			if ( result && result.length == 0 ) result = null;
			return result;
		}

		/**
		 * @private
		 */
		private static function getValueFromByteArray(value:ByteArray, negative:Boolean):BigValue {
			if ( value.length == 0 ) return ZERO._value;
			var result:BigValue;
			switch ( value.endian ) {
				case Endian.LITTLE_ENDIAN:
					result = new BigValue();
					result.writeBytes( value );
					break;
				case Endian.BIG_ENDIAN:
//					result = new BigValue();
					// TODO: read big endian
					break;
				default:
					throw new ArgumentError();
			}
			// TODO: normalize
			if ( result && result.length == 0 ) result = null;
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
				var bytes:ByteArray;
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
						switch ( true ) {
							case value is ByteArray:
								var negative:Boolean;
								if ( args.length > 1 ) {
									if ( typeof args[ 1 ] != 'boolean' ) throw new ArgumentError();
									if ( l != 2 ) throw new ArgumentError();
									negative = args[ 1 ];
								}
								this._value = getValueFromByteArray( value, negative );
								break;
							case value is BigInteger:
								this._value = value._value;
								break;
//							case args[ 0 ] is Array:
//							case args[ 0 ] is Vector.<*>:
//								break;
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
			return NaN;
		}

		public function toString(radix:uint=16):String {
			return null;
		}

		public function toBytes(endian:String=Endian.LITTLE_ENDIAN):ByteArray {
			return null;
		}

	}

}

import flash.utils.ByteArray;

/**
 * @private
 */
internal final class BigValue extends ByteArray {

	public function BigValue() {
		super();
	}

	public var negative:Boolean;

}