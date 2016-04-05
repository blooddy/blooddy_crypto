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
		
		public static const NEGATIVE_ONE:BigInteger = valueOf( -1 );
		
		public static const ZERO:BigInteger = valueOf( 0 );

		public static const ONE:BigInteger = valueOf( 1 );

		public static const TEN:BigInteger = valueOf( 10 );

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		public static function valueOf(...arguments):BigInteger {
			throw new IllegalOperationError();
		}
		
		public static function fromNumber(value:Number):BigInteger {
			var result:BigInteger = new BigInteger();
			setNumber( result, value );
			return result;
		}

		public static function fromString(value:String, radix:uint=16):BigInteger {
			if ( radix < 2 || radix > 36 ) Error.throwError( RangeError, 1003, radix );
			var result:BigInteger = new BigInteger();
			throw new IllegalOperationError();
		}
		
		public static function fromVector(value:Vector.<uint>, negative:Boolean=false):BigInteger {
			throw new IllegalOperationError();
		}
		
		public static function fromByteArray(value:ByteArray, negative:Boolean=false):BigInteger {
			throw new IllegalOperationError();
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
						target._negative = true;
						target._value = new ByteArray();
						target._value.writeInt( -value );
					}
				} else if ( value ) {
					value = uint( value );
					if ( value ) {
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
		private static function setString(target:BigInteger, value:String, radix:uint=10):void {
			throw new IllegalOperationError();
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
		 * @private
		 */
		private var _negative:Boolean = false;
		
		/**
		 * @return		this < 0 ? true : false;
		 */
		public function get negative():Boolean {
			return this._negative;
		}

		/**
		 * @return		this ? ( this < 0 ? -1: 1 ) : 0; 
		 */
		public function get sign():int {
			return ( this._value
				? ( this._negative ? -1 : 1 )
				: 0
			);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		public function toNumber():Number {
			throw new IllegalOperationError();
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