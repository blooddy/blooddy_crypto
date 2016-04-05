////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math {

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	
	import avm2.intrinsics.memory.li16;
	import avm2.intrinsics.memory.li32;
	import avm2.intrinsics.memory.li8;
	import avm2.intrinsics.memory.si16;
	import avm2.intrinsics.memory.si8;
	
	import by.blooddy.math.utils.BigIntegerBlock;
	import by.blooddy.utils.MemoryBlock;
	
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
		private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
		
		/**
		 * @private
		 */
		private static const _TMP:ByteArray = new ByteArray();
		
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
						target._value.endian = Endian.LITTLE_ENDIAN;
						target._value.writeInt( -value );
					}
				} else if ( value ) {
					value = uint( value );
					if ( value ) {
						target._sign = 1;
						target._value = new ByteArray();
						target._value.endian = Endian.LITTLE_ENDIAN;
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

					var tmp:ByteArray = _DOMAIN.domainMemory;

					var len:int = value.length;

					var i:int = Math.ceil( len / ( ( Math.LN2 / Math.log( radix ) ) * 8 ) );
					if ( i & 3 ) i += 4 - ( i & 3 );

					var mem:ByteArray = new ByteArray();
					mem.length = Math.max( i, ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH );
					
					_DOMAIN.domainMemory = mem;
					
					var c:int = 0;
					
					var r:int;
					var l:int;
					var j:int;
					
					i = 0;
					while ( i < len ) {
						
						c = parseInt( value.charAt( i ), radix );
						
						r = 0;
						l = j;
						j = 0;
						
						while ( j < l ) {
							r += li16( j ) * radix;
							c += r & 0xFFFF;
							si16( c, j );
							r >>>= 16;
							c >>>= 16;
							j += 2;
						}

						while ( c > 0 || r > 0 ) {
							c += r;
							si16( c, j );
							r >>>= 16;
							c >>>= 16;
							j += 2;
						}

						++i;

					}

					if ( j & 3 ) j += 2;

					while ( !li32( j - 4 ) ) j -= 4;

					_DOMAIN.domainMemory = tmp;
					
					if ( j > 0 ) {

						mem.endian = Endian.LITTLE_ENDIAN;
						mem.length = j;

						target._value = mem;
						target._sign = m[ 1 ] ? -1 : 1;

					}
					
				}
				
			}
		}
		
		/**
		 * @private
		 */
		private static function _inc(bytes:ByteArray):void {
			var i:int = 0;
			while ( bytes[ i ] == 0xFF ) {
				bytes[ i++ ] = 0;
			}
			if ( i >= bytes.length ) {
				bytes.position = bytes.length;
				bytes.writeInt( 0 );
			}
			++bytes[ i ];
		}
		
		/**
		 * @private
		 */
		private static function _dec(bytes:ByteArray):void {
			var i:int = 0;
			while ( bytes[ i ] == 0 ) {
				bytes[ i++ ] = 0xFF;
			}
			--bytes[ i ];
			if ( i + 4 >= bytes.length ) {
				i = bytes.length;
				if ( !bytes[ i - 1 ] && !bytes[ i - 2 ] && !bytes[ i - 3 ] && !bytes[ i - 4 ] ) {
					bytes.length -= 4;
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
					case 'object':
						if ( arguments[ 0 ] is BigInteger ) {
							this._sign = ( arguments[ 0 ] as BigInteger )._sign;
							this._value = ( arguments[ 0 ] as BigInteger )._value;
							break;
						}
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
		
		public function valueOf():Number {
			return this.toNumber();
		}
		
		public function toNumber():Number {
			if ( this._value ) {
				var result:Number = 0;

				var k:Number = 1;

				this._value.position = 0;
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
			if ( this._value ) {
				
				var tmp:ByteArray = _DOMAIN.domainMemory;

				var pos:int = Math.ceil( this._value.length * ( ( Math.LN2 / Math.log( radix ) ) * 8 ) );
				
				var mem:ByteArray = new ByteArray();
				mem.position = pos;
				mem.writeBytes( this._value );

				var k:int = mem.length;

				if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
				
				_DOMAIN.domainMemory = mem;

				var i:int = 0;
				var v:int = 0;
				var c:int = 0;
				
				var r:int = 0;
				var l:int = 0;
				var j:int = pos;
				
				do {
					
					v = li32( k -= 4 );

					i = 0;
					while ( i < 8 ) {
						c = v >>> 28;
						r = 0;
						l = j;
						j = pos;
						while ( j > l ) {
							--j;
							r += li8( j ) << 4;
							c += r % radix;
							si8( c % radix, j );
							r /= radix;
							c /= radix;
						}
						while ( c > 0 || r > 0 ) {
							--j;
							c += r % radix;
							si8( c % radix, j );
							r /= radix;
							c /= radix;
						}
						v <<= 4;
						++i;
					}
					
				} while ( k > pos );

				mem.position = pos;
				mem.writeUTFBytes( '0123456789abcdefghijklmnopqrstuvwxyz' );
				
				i = pos;
				do {
					--i;
					si8( li8( pos + li8( i ) ), i );
				} while ( i > j );
				
				_DOMAIN.domainMemory = tmp;

				mem.position = j;
				return mem.readUTFBytes( pos - j );

			} else {
				return '0';
			}
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
		 * @return		Math.abs( this )
		 */
		public function abs():BigInteger {
			if ( this._sign < 0 ) {
				return this.negate();
			} else {
				return this;
			}
		}
		
		/**
		 * @return		-this
		 */
		public function negate():BigInteger {
			var result:BigInteger = new BigInteger();
			result._sign *= -1;
			result._value = this._value;
			return result;
		}
		
		/**
		 * @return		this > v ? 1 : ( v > this ? -1 : 0 )
		 */
		public function compare(v:BigInteger):int {
			
			var c1:int = this._sign;
			var c2:int =    v._sign;
			
			     if ( c1 > c2 ) return 1;
			else if ( c1 < c2 ) return -1;
			else if ( !c1 ) return 0;
			else {
				
				c1 = this._value.length;
				c2 =    v._value.length;

				     if ( c1 > c2 ) return 1;
				else if ( c2 < c1 ) return -1;
				else {
					
					var tmp:ByteArray = _DOMAIN.domainMemory;
					
					var mem:ByteArray = _TMP;
					
					mem.writeBytes( this._value );
					mem.writeBytes(    v._value );
					
					if ( mem.length < ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH ) mem.length = ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH;
					
					_DOMAIN.domainMemory = mem;
					
					var result:int = (
						new BigIntegerBlock(               0, this._value.length )
					).compare(
						new BigIntegerBlock( v._value.length, this._value.length )
					);
					
					_DOMAIN.domainMemory = tmp;
					
					mem.length = 0;
					
					return result;
					
				}

			}
			
			return 0;
			
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
			if ( this._value ) {
				
				var bytes:ByteArray = new ByteArray();
				bytes.writeBytes( this._value );
				
				if ( this._sign < 0 ) {
					
					_dec( bytes );
					
					if ( this._value.length <= 0 ) {
						return ZERO;
					}
					
				} else {
					
					_inc( bytes );
					
				}
				
				var result:BigInteger = new BigInteger();
				result._sign = this._sign;
				result._value = bytes;
				return result;
				
			} else {
				return ONE;
			}
		}

		/**
		 * @return		this - 1
		 */
		public function dec():BigInteger {
			if ( this._value ) {
				
				var bytes:ByteArray = new ByteArray();
				bytes.writeBytes( this._value );
				
				if ( this._sign < 0 ) {
					
					_inc( bytes );
					
					if ( bytes.length <= 0 ) {
						return ZERO;
					}
					
				} else {
					
					_dec( bytes );
					
				}

				var result:BigInteger = new BigInteger();
				result._sign = this._sign;
				result._value = bytes;
				return result;

			} else {
				return NEGATIVE_ONE;
			}
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