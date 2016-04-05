////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {

	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					09.02.2011 2:45:56
	 */
	public class BigInteger {
		
		//--------------------------------------------------------------------------
		//
		//  Class constants
		//
		//--------------------------------------------------------------------------
		
		public static const NEGATIVE_ONE:BigInteger = new BigInteger( -1 );
		
		public static const ZERO:BigInteger = new BigInteger( 0 );

		public static const ONE:BigInteger = new BigInteger( 1 );

		public static const TEN:BigInteger = new BigInteger( 10 );

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _PATTERNS:Vector.<RegExp> = ( function():Vector.<RegExp> {

			var result:Vector.<RegExp> = new Vector.<RegExp>( 37, true );
			
			var i:int = 2;
			for ( ; i <= 9; ++i ) {
				result[ i ] = new RegExp( '^\\s*(-)?([0-' + ( i - 1 ) + ']+)\\s*$' );
			}
			result[ i++ ] = /^\s*(-)?(\d+)(?:\.\d+)?\s*$/;
			result[ i++ ] = /^\s*(-)?([\da]+)\s*$/i;
			for ( ; i <= 15; ++i ) {
				result[ i ] = new RegExp( '^\\s*(-)?([\\da-' + ( i - 1 ).toString( i ) + ']+)\\s*$', 'i' );
			}
			result[ i++ ] = /^\s*(-)?(?:0x)?([\da-f]+)\s*$/i;
			for ( ; i <= 36; ++i ) {
				result[ i ] = new RegExp( '^\\s*(-)?([\\da-' + ( i - 1 ).toString( i ) + ']+)\\s*$', 'i' );
			}
			
			return result;

		}() );
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		public static function fromNumber(value:Number):BigInteger {
			var result:BigInteger = new BigInteger();
			setNumber( result, value );
			return result;
		}

		public static function fromString(value:String, radix:uint=16):BigInteger {
			if ( radix < 2 || radix > 36 ) Error.throwError( RangeError, 1003, radix );
			var result:BigInteger = new BigInteger();
			setString( result, value, radix );
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
		private static function setNumber(target:BigInteger, value:Number):void {
			if ( value <= uint.MAX_VALUE && value >= int.MIN_VALUE ) {
				if ( value < 0 ) {
					value = int( value );
					if ( value ) {
						target._sign = -1;
						target._value = new ByteArray();
						target._value.writeInt( -value );
					}
				} else if ( value ) {
					value = uint( value );
					if ( value ) {
						target._sign = 1;
						target._value = new ByteArray();
						target._value.writeUnsignedInt( value );
					}
				}
			} else {
				setString( target, value.toString( 16 ), 16 );
			}
		}
		
		/**
		 * @private
		 */
		private static function setString(target:BigInteger, value:String, radix:uint):void {
			if ( value ) {

				var m:Array = value.match( _PATTERNS[ radix ] );
				if ( !m ) throw new ArgumentError();
				if ( m[ 2 ] != 0 ) {

					var bytes:ByteArray = new ByteArray();
					
					var i:int = value.length;
					
					var c:int = 1;
					var k:int = 0;
					do {
						c *= radix;
						++k;
					} while ( c < 0xFFFF );
					
					c = 0;
					while ( ( i -= k ) >= 0 ) {
						c += parseInt( value.substr( i, k ), radix );
						bytes.writeShort( c );
						c >>>= 16;
					}
					
					k += i;
					if ( k ) c += parseInt( value.substr( 0, k ), radix );
					if ( c ) bytes.writeShort( c );
					
					if ( bytes.length & 3 ) {
						bytes.writeShort( 0 );
					}
					
					i = bytes.length;
					do {
						--i;
					} while ( i > 0 && !bytes[ i ] );
					
					if ( i & 3 ) {
						i += 4 - ( i & 3 );
					}
					
					if ( i > 0 ) {

						bytes.length = i;

						target._value = bytes;
						target._sign = m[ 1 ] ? -1 : 1;

					}
					
				}
				
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor
		 * @throws	ArgumentError
		 */
		public function BigInteger(...arguments) {

			super();
			
			if ( arguments.length > 0 ) {
				switch ( typeof arguments[ 0 ] ) {
					case 'number':
						setNumber( this, arguments[ 0 ] );
						break;
					case 'string':
						setString( this, arguments[ 0 ], arguments[ 1 ] );
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
		private var _value:ByteArray;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @return		this < 0 ? true : false;
		 */
		public function get negative():Boolean {
			return this._sign < 0;
		}

		private var _sign:int = 0;
		
		/**
		 * @return		this ? ( this < 0 ? -1: 1 ) : 0; 
		 */
		public function get sign():int {
			return this._sign;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toNumber():Number {
			if ( this._value ) {
				var result:Number = 0;

				var k:Number = 1;
				while( this._value.bytesAvailable ) {
					result += this._value.readUnsignedInt() * k;
					k *= 0xFFFFFFFF;
				}

				return result;
			} else {
				return 0;
			}
		}
		
		public function toString(radix:uint=10):String {
			if ( radix < 2 || radix > 36 ) Error.throwError( RangeError, 1003, radix );
			var result:BigInteger = new BigInteger();
			throw new IllegalOperationError();
		}
		
		public function toByteArray(endian:String=Endian.LITTLE_ENDIAN):ByteArray {
			throw new IllegalOperationError();
		}

		//--------------------------------------------------------------------------
		//  Bits
		//--------------------------------------------------------------------------
		
		public function getBitLength():uint {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this & ( 1 << n ) != 0
		 */
		public function testBit(n:uint):Boolean {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this | ( 1 << n )
		 */
		public function setBit(n:uint):BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @return		this & ~( 1 << n )
		 */
		public function clearBit(n:uint):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this ^ ( 1 << n )
		 */
		public function flipBit(n:uint):BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @return		~this
		 */
		public function not():BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @return		this & v
		 */
		public function and(v:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this & ~v
		 */
		public function andNot(v:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this | v
		 */
		public function or(v:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this ^ v
		 */
		public function xor(v:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this >> n
		 */
		public function shiftRight(n:uint):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this << n
		 */
		public function shiftLeft(n:uint):BigInteger {
			throw new IllegalOperationError();
		}
		
		//--------------------------------------------------------------------------
		//  Math
		//--------------------------------------------------------------------------
		
		/**
		 * @return		-this;
		 */
		public function negate():BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this > v ? 1 : ( v > this ? -1 : 0 )
		 */
		public function compare(v:BigInteger):int {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this > v ? v : this
		 */
		public function min(v:BigInteger):BigInteger {
			return ( this.compare( v ) < 0 ? this : v );
		}
		
		/**
		 * @return		this < v ? v : this
		 */
		public function max(v:BigInteger):BigInteger {
			return ( this.compare( v ) > 0 ? this : v );
		}
		
		/**
		 * @return		this + 1
		 */
		public function inc():BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @return		this - 1
		 */
		public function dec():BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @return		this + v
		 */
		public function add(v:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this - v
		 */
		public function sub(v:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @return		this % m;
		 * @throws		ArgumentError	m == 0
		 */
		public function mod(m:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return		this / m
		 * @throws		ArgumentError	m == 0
		 */
		public function div(m:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @return		[ this / m, this % m ]
		 * @throws		ArgumentError	m == 0
		 */
		public function divAndMod(m:BigInteger):Vector.<BigInteger> {
			throw new IllegalOperationError();
		}

		/**
		 * @return		pow( this, e )
		 */
		public function powInt(e:uint):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @return	pow( this, e ) % m
		 * @throws	ArgumentError	m == 0
		 */
		public function modPow(e:BigInteger, m:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}

		/**
		 * @reutrn	gcd( this, v )
		 */
		public function gcd(v:BigInteger):BigInteger {
			throw new IllegalOperationError();
		}
		
		/**
		 * @param	certainty
		 */
		public function isProbablePrime(certainty:int):Boolean {
			throw new IllegalOperationError();
		}
		
	}
	
}