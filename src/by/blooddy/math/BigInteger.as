////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {

	import by.blooddy.math.utils.BigUint;
	import by.blooddy.system.Memory;
	
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
		//  Initialization
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		$private static function init():void {

			ONE._value = new BigValue();
			ONE._value.writeInt( 0x01 );
			TEN._value = new BigValue();
			TEN._value.writeInt( 0x0A );
			NEGATIVE_ONE._value = new BigValue();
			NEGATIVE_ONE._value.writeInt( 0x01 );
			NEGATIVE_ONE._value.negative = true;

			var i:uint = 2;
			for ( ; i <= 9; ++i ) {
				_PATTERNS[ i ] = new RegExp( '^\\s*(-)?([0-' + ( i - 1 ) + ']+)\\s*$' );
			}
			_PATTERNS[ i++ ] = /^\s*(-)?(\d+)(?:\.\d+)?\s*$/;
			_PATTERNS[ i++ ] = /^\s*(-)?([\da]+)\s*$/i;
			for ( ; i <= 15; ++i ) {
				_PATTERNS[ i ] = new RegExp( '^\\s*(-)?([\\da-' + ( i - 1 ).toString( i ) + ']+)\\s*$', 'i' );
			}
			_PATTERNS[ i++ ] = /^\s*(-)?(?:0x)?([\da-f]+)\s*$/i;
			for ( ; i <= 36; ++i ) {
				_PATTERNS[ i ] = new RegExp( '^\\s*(-)?([\\da-' + ( i - 1 ).toString( i ) + ']+)\\s*$', 'i' );
			}

		}

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
		private static const _mem:ByteArray = new ByteArray();
		
		/**
		 * @private
		 */
		private static const _PATTERNS:Vector.<RegExp> = new Vector.<RegExp>( 37, true );

		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------

		public static const NEGATIVE_ONE:BigInteger =	new BigInteger(); // see $private::init()
		
		public static const ZERO:BigInteger =			new BigInteger(); // see $private::init()

		public static const ONE:BigInteger =			new BigInteger(); // see $private::init()

		public static const TEN:BigInteger =			new BigInteger(); // see $private::init()

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

		/**
		 * @throws	RangeError
		 */
		public static function fromString(value:String, radix:uint=16):BigInteger {
			if ( radix < 2 || radix > 36 ) Error.throwError( RangeError, 1003, radix );
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
						case value is ByteArray:		return getValueFromByteArray( value );
						case value is Vector.<uint>:	return getValueFromVector( value );
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
			if ( !value ) return null;
			var pattern:RegExp = _PATTERNS[ radix ];
			var m:Array = value.match( pattern );
			if ( !m ) throw new ArgumentError();
			var result:BigValue = new BigValue();
			result.negative = Boolean( m[ 1 ] );
			value = m[ 2 ];
			// TODO: optimize 2,4,16
			var len:uint = value.length;
			var list:Vector.<uint> = new Vector.<uint>();
			var i:uint = 0;
			var j:uint;
			var l:uint;
			var c:uint;
			var r:uint;
			while ( i < len ) {
				c = parseInt( value.charAt( i ), radix );
				r = 0;
				l = j;
				j = 0;
				while ( j < l ) {
					r += list[ j ] * radix;
					c += r & 0xFFFF;
					list[ j ] = c & 0xFFFF;
					r >>>= 16;
					c >>>= 16;
					++j;
				}
				while ( c > 0 || r > 0 ) {
					c += r & 0xFFFF;
					list[ j ] = c & 0xFFFF;
					r >>>= 16;
					c >>>= 16;
					++j;
				}
				++i;
			}
			for each ( c in list ) {
				result.writeShort( c );
			}
			if ( result.length & 3 ) {
				result.writeShort( 0 );
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
		private static function getValueFromVector(value:Vector.<uint>, negative:Boolean=false):BigValue {
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
		private static function getValueFromByteArray(value:ByteArray, negative:Boolean=false):BigValue {
			if ( value.length == 0 ) return null;
			var result:BigValue = new BigValue();
			var i:uint;
			switch ( value.endian ) {
				case Endian.LITTLE_ENDIAN:
					result.writeBytes( value );
					break;
				case Endian.BIG_ENDIAN:
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

		/**
		 * @private
		 */
		private static function getValueFromBigUint(value:BigUint, negative:Boolean=false):BigValue {
			if ( value.len ) {
				var result:BigValue = new BigValue();
				_mem.position = value.pos;
				_mem.readBytes( result, 0, value.len );
				return result;
			} else {
				return null;
			}
		}

		/**
		 * @private
		 */
		private static function _increment(value:BigValue):void {
			var i:uint = 0;
			while ( value[ i ] == 0xFF ) {
				value[ i++ ] = 0;
			}
			if ( i >= value.length ) {
				value.length += 4;
			}
			++value[ i ];
		}

		/**
		 * @private
		 */
		private static function _decrement(value:BigValue):void {
			var i:uint;
			while ( value[ i ] == 0 ) {
				value[ i++ ] = 0xFF;
			}
			--value[ i ];
			if ( i >= value.length - 4 ) {
				value.position = value.length - 4;
				while ( value.length > 0 && value.readInt() == 0 ) {
					value.length -= 4;
					value.position -= 4;
				}
			}
		}

		/**
		 * @private
		 */
		private static function _getFirstNonzeroDigit(v:BigUint):uint {
			var i:uint = 0;
			while ( Memory.getI32( i ) == 0 ) {
				++i;
			}
			return i;
		}
		
		/**
		 * @private
		 */
		private static function _add_negative(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var i1:uint = _getFirstNonzeroDigit( v1 );
			var i2:uint = _getFirstNonzeroDigit( v2 );
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			
			var i:uint = ( i1 > i2 ? i1 : i2 );
			
			throw new IllegalOperationError( 'TODO' );
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 *
		 * @throws	RangeError
		 * @throws	ArgumentError
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
							if ( radix < 2 || radix > 36 ) Error.throwError( RangeError, 1003, radix );
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

		public function valueOf():Number {
			return this.toNumber();
		}

		public function toNumber():Number {
			if ( this._value ) {
				this._value.position = 0;
				var result:Number = this._value.readUnsignedInt();
				var i:uint = 1;
				while ( this._value.bytesAvailable ) {
					result += this._value.readUnsignedInt() * Math.pow( 0xFFFFFFFF, i );
				}
				return ( this._value.negative ? -result : result );
			} else {
				return 0;
			}
		}

		/**
		 * @throws	RangeError
		 */
		public function toString(radix:uint=16):String {
			if ( radix < 2 || radix > 36 ) Error.throwError( RangeError, 1003, radix );
			if ( this._value ) {
				var list:Vector.<uint> = new Vector.<uint>();
				var v:uint;
				var c:uint;
				var r:uint;
				var i:uint = 0;
				var j:uint;
				var l:uint;
				this._value.position = this._value.length + 4;
				do {
					this._value.position -= 8;
					v = this._value.readUnsignedInt();
					i = 0;
					while ( i < 8 ) {
						c = v >>> 28;
						r = 0;
						l = j;
						j = 0;
						while ( j < l ) {
							r += list[ j ] << 4;
							c += r % radix;
							list[ j ] = c % radix;
							r /= radix;
							c /= radix;
							++j;
						}
						while ( c > 0 || r > 0 ) {
							c += r % radix;
							list[ j ] = c % radix;
							r /= radix;
							c /= radix;
							++j;
						}
						v <<= 4;
						++i;
					}
				} while ( this._value.position > 4 );

				var result:String = '';
				i = list.length;
				while ( i-- > 0 ) {
					result += list[ i ].toString( radix );
				}
				return ( this._value.negative ? '-' : '' ) + result;
			} else {
				return '0';
			}
		}

		public function toByteArray(endian:String=Endian.LITTLE_ENDIAN):ByteArray {
			var result:ByteArray = new ByteArray();
			result.endian = endian;
			if ( this._value ) {
				switch ( result.endian ) {
					case Endian.LITTLE_ENDIAN:
						result.writeBytes( this._value );
						--result.position;
						while ( result.readByte() == 0 ) {
							--result.length;
							--result.position;
						}
						break;
					case Endian.BIG_ENDIAN:
						this._value.position = this._value.length - 1;
						var c:uint = this._value.readUnsignedByte();
						if ( c == 0 ) { // в первом разряде есть ведущие нули. надо пропустить
							do {
								this._value.position -= 2;
								c = this._value.readUnsignedByte();
							} while ( c == 0 );
							result.writeByte( c );
							c = this._value.length - 4;
							while ( this._value.position > c ) {
								this._value.position -= 2;
								result.writeByte( this._value.readByte() );
							}
							this._value.position = this._value.length;
						} else {
							this._value.position = this._value.length + 4;
						}
						do {
							this._value.position -= 8;
							result.writeInt( this._value.readInt() );
						} while ( this._value.position >= 8 );
						break;
					default:
						throw new ArgumentError();
				}
				result.position = 0;
			}
			return result;
		}

		/**
		 * @return		-this;
		 */
		public function negate():BigInteger {
			if ( this._value ) {
				var result:BigInteger = new BigInteger();
				result._value = new BigValue();
				result._value.negative = !this._value.negative;
				result._value.writeBytes( this._value );
				return result;
			} else {
				return ZERO;
			}
		}

		public function getBitLength():uint {
			throw new IllegalOperationError( 'TODO' );
		}
		
		/**
		 * @return		this & ( 1 << n ) != 0
		 */
		public function testBit(n:uint):Boolean {
			if ( this._value ) {
				var s:uint = n >>> 3;
				if ( s >= this._value.length ) { // бит находится за пределами числа
					return this._value.negative;
				} else {
					if ( this._value.negative ) {
						var i:uint = 0;
						while ( !this._value[ i ] ) ++i;
						if ( i == s ) {
							s = -this._value[ s ];
						} else {
							s = ~this._value[ s ];
						}
					} else {
						s = this._value[ s ];
					}
					return ( s & ( 1 << ( n & 7 ) ) ) != 0;
				}
			} else {
				return false;
			}
		}

		/**
		 * @return		this | ( 1 << n )
		 */
		public function setBit(n:uint):BigInteger {
			if ( this.testBit( n ) ) {
				return this;
			} else {
				return this.flipBit( n );
			}
		}

		/**
		 * @return		this & ~( 1 << n )
		 */
		public function clearBit(n:uint):BigInteger {
			if ( this.testBit( n ) ) {
				return this.flipBit( n );
			} else {
				return this;
			}
		}

		/**
		 * @return		this ^ ( 1 << n )
		 */
		public function flipBit(n:uint):BigInteger {
			var value:BigValue = new BigValue();
			var s:uint = n >>> 3;
			var k:uint = 1 << ( n & 7 );
			if ( this._value ) {
				if ( this._value.length < s ) {
					value.length = s + 4 - ( s & 3 ); // заполняем ноликами
				}
				value.writeBytes( this._value );
				if ( this._value.negative ) {
					value.negative = this._value.negative;
					var i:uint = 0;
					while ( !this._value[ i ] ) ++i;
					if ( s > i ) {
						value[ s ] ^= k;
					} else if ( s < i ) {
						value[ s ] = -k;
						while ( ++s < i ) {
							value[ s ] = -1;
						}
						--value[ s ];
					} else {
						value[ s ] = -( ( -value[ s ] ) ^ k );
						if ( value[ s ] == 0 ) {
							while ( value[ ++s ] == 0xFF ) {
								value[ s ] = 0;
							}
							++value[ s ];
						}
					}
				} else {
					value[ s ] ^= k;
				}
				value.position -= 4;
				while ( value.length > 0 && value.readInt() == 0 ) {
					value.length -= 4;
					value.position -= 4;
				}
				if ( value.length == 0 ) {
					value = null;
				}
			} else {
				value.length = s + 4 - ( s & 3 );
				value[ s ] = k;
			}
			var result:BigInteger = new BigInteger();
			result._value = value;
			return result;
		}

		/**
		 * @return		~this
		 */
		public function not():BigInteger {
			if ( this._value ) {
				var result:BigInteger = this.increment();
				if ( result._value ) result._value.negative = !this._value.negative;
				return result;
			} else {
				return NEGATIVE_ONE;
			}
		}

		/**
		 * @return		this & v
		 */
		public function and(v:BigInteger):BigInteger {
			if ( !this._value || !v._value ) return ZERO;
			else {
				
				if ( !this._value.negative && !this._value.negative ) {

					var tmp:ByteArray = _domain.domainMemory;
					
					_mem.position = 0;
					_mem.writeBytes( this._value );
					_mem.writeBytes(    v._value );
					_mem.length = Math.max(
						_mem.position + Math.max( this._value.length, v._value.length ),
						ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH
					);
					_domain.domainMemory = _mem;

					var result:BigInteger = new BigInteger();
					result._value = getValueFromBigUint(
						BigUint.and(
							new BigUint( 0, this._value.length ),
							new BigUint( this._value.length, v._value.length ),
							this._value.length + v._value.length
						)
					);
					
					_domain.domainMemory = tmp;
					return result;

				}
				
			}
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

			var c1:int = ( this._value ? ( this._value.negative ? -1 : 1 ) : 0 );
			var c2:int = (    v._value ? (    v._value.negative ? -1 : 1 ) : 0 );

			if ( c1 > c2 ) return 1;
			else if ( c1 < c2 ) return -1;
			else if ( c1 == 0 ) return 0;
			else if ( this._value.length > v._value.length ) return 1;
			else if ( this._value.length < v._value.length ) return -1;
			else {

				var tmp:ByteArray = _domain.domainMemory;

				_mem.position = 0;
				_mem.writeBytes( this._value );
				_mem.writeBytes(    v._value );
				_mem.length = Math.max( _mem.position, ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH );
				_domain.domainMemory = _mem;
	
				var result:int = BigUint.compare( new BigUint( 0, this._value.length ), new BigUint( this._value.length, v._value.length ) );
	
				_domain.domainMemory = tmp;
				return c1 * result;

			}

		}

		/**
		 * @return		( this > v ? v : this )
		 */
		public function min(v:BigInteger):BigInteger {
			return ( this.compare( v ) < 0 ? this : v );
		}

		/**
		 * @return		( this < v ? v : this )
		 */
		public function max(v:BigInteger):BigInteger {
			return ( this.compare( v ) > 0 ? this : v );
		}

		/**
		 * @return		this + 1
		 */
		public function increment():BigInteger {
			if ( this._value ) {
				var value:BigValue = new BigValue();
				value.writeBytes( this._value );
				if ( this._value.negative ) {
					_decrement( value );
					if ( value.length <= 0 ) {
						return ZERO;
					} else {
						value.negative = true;
					}
				} else {
					_increment( value );
				}
				var result:BigInteger = new BigInteger();
				result._value = value;
				return result;
			} else {
				return ONE;
			}
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
			if ( this._value ) {
				var value:BigValue = new BigValue();
				value.writeBytes( this._value );
				if ( this._value.negative ) {
					_increment( value );
					value.negative = true;
				} else {
					_decrement( value );
					if ( value.length <= 0  ) {
						return ZERO;
					}
				}
				var result:BigInteger = new BigInteger();
				result._value = value;
				return result;
			} else {
				return NEGATIVE_ONE;
			}
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
		 * @return		[ this / m, this % m ]
		 * @throws		ArgumentError	m == 0
		 */
		public function divAndMod(m:BigInteger):Vector.<BigInteger> {
			throw new IllegalOperationError( 'TODO' );
		}

		/**
		 * @return		this / m
		 * @throws		ArgumentError	m == 0
		 */
		public function div(m:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}

		/**
		 * @return		this % m;
		 * @throws		ArgumentError	m == 0
		 */
		public function mod(m:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}

		/**
		 * @return		pow( this, e ) % m
		 * @throws		ArgumentError	m == 0
		 */
		public function modPowInt(e:int, m:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}

		/**
		 * @return		pow( this, e ) % m
		 * @throws		ArgumentError	m == 0
		 */
		public function modPow(e:BigInteger, m:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}

		/**
		 * @reutrn		gcd( this, v )
		 */
		public function gcd(v:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}

		/**
		 * @return		1 / this % m
		 * @throws		ArgumentError	this == 0 || m == 0
		 */
		public function modInverse(m:BigInteger):BigInteger {
			throw new IllegalOperationError( 'TODO' );
		}

		
		public function isProbablePrime(certainty:int):Boolean {
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
//  Initialization
//
////////////////////////////////////////////////////////////////////////////////

internal namespace $private;

BigInteger.$private::init();

////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: BigValue
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