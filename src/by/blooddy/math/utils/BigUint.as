////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import by.blooddy.system.Memory;

	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					21.01.2011 14:11:39
	 */
	public final class BigUint {

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
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @return		v & ( 1 << n ) != 0
		 */
		public static function testBit(v:BigUint, n:uint):Boolean {
			var p:uint = v.pos;
			var l:uint = v.len;
			if ( l == 0 ) {
				return false;
			} else {
				var s:uint = n >>> 3;
				if ( s >= l ) { // бит находится за пределами числа
					return false;
				} else {
					return ( Memory.getUI8( p + s ) & ( 1 << ( n & 7 ) ) ) != 0;
				}
			}
		}

		/**
		 * @return		v | ( 1 << n )
		 */
		public static function setBit(v:BigUint, n:uint, pos:uint):BigUint {
			var p:uint = v.pos;
			var l:uint = v.len;
			var s:uint = n >>> 3;
			s -= s & 3;
			var k:uint = 1 << ( n & 31 );
			if ( s < l && ( Memory.getI32( p + s ) & k ) != 0 ) { // бит уже установлен
				return v;
			} else {
				var mem:ByteArray = _domain.domainMemory;
				if ( l > 4 ) {
					mem.position = p;
					mem.readBytes( mem, pos, l );
				} else if ( l > 0 ) {
					Memory.setI32( pos, Memory.getI32( p ) );
				}
				p = pos + l;
				s += pos;
				if ( p < s ) { // результат длинее оригинала: надо заполнить нулями
					BigUint$.fillZero( mem, p, s, l );
					p = s;
				}
				if ( p == s ) {
					Memory.setI32( p, k );
					p += 4;
				} else {
					Memory.setI32( s, Memory.getI32( s ) | k );
				}
				return new BigUint( pos, p - pos );
			}
		}

		/**
		 * @return		v & ~( 1 << n )
		 */
		public static function clearBit(v:BigUint, n:uint, pos:uint):BigUint {
			var l:uint = v.len;
			if ( l == 0 ) { // нечего чистить
				return v;
			} else {
				var s:uint = n >>> 3;
				s -= s & 3;
				var k:uint = 1 << ( n & 31 );
				var p:uint = v.pos;
				if ( s >= l || ( Memory.getI32( p + s ) & k ) == 0 ) { // бит и так пустой
					return v;
				} else {
					// копируем
					if ( l > 4 ) {
						var mem:ByteArray = _domain.domainMemory;
						mem.position = p;
						mem.readBytes( mem, pos, l );
					} else {
						Memory.setI32( pos, Memory.getI32( p ) );
					}
					p = pos + s;
					Memory.setI32( p, Memory.getI32( p ) ^ k );
					if ( s == l - 4 ) { // подчистить надо только если исправляли последний разряд
						CRYPTO::inline {
							BigUint$.clean( pos, l );
						}
						CRYPTO::debug {
							return _clean( pos, l );
						}
					}
					return new BigUint( pos, l );
				}
			}
		}

		/**
		 * @return		v ^ ( 1 << n )
		 */
		public static function flipBit(v:BigUint, n:uint, pos:uint):BigUint {
			var p:uint = v.pos;
			var l:uint = v.len;
			// копируем
			var mem:ByteArray = _domain.domainMemory;
			if ( l > 4 ) {
				mem.position = p;
				mem.readBytes( mem, pos, l );
			} else if ( l > 0 ) {
				Memory.setI32( pos, Memory.getI32( p ) );
			}
			var s:uint = n >>> 3;
			s += pos - ( s & 3 );
			p = pos + l;
			var k:uint;
			if ( p < s ) { // результат длинее оригинала: надо заполнить нулями
				BigUint$.fillZero( mem, p, s, k );
			}
			k = 1 << ( n & 31 );
			if ( p == s ) {
				Memory.setI32( p, k );
				return new BigUint( pos, p - pos + 4 );
			} else {
				Memory.setI32( s, Memory.getI32( s ) ^ k );
				if ( s == pos + l - 4 ) { // подчистить надо только если исправляли последний разряд
					CRYPTO::inline {
						BigUint$.clean( pos, l );
					}
					CRYPTO::debug {
						return _clean( pos, l );
					}
				}
				return new BigUint( pos, l );
			}
		}

		/**
		 * @return		~v1
		 */
		public static function not(v:BigUint, pos:uint):BigUint {
			var p:uint = v.pos;
			var l:uint = v.len;
			if ( l == 0 ) {
				return v;
			} else {
				var len:uint = 0;
				l -= 4;
				while ( len < l ) {
					Memory.setI32( pos + len, ~Memory.getI32( p + len ) );
					len += 4;
				}
				var k:int = Memory.getI32( p + len );
				var i:uint = 0x80000000;
				while ( ( k & i ) == 0 ) {
					i >>>= 1;
				}
				--i;
				Memory.setI32( pos + len, ( ~k ) & i );
				len += 4;
				CRYPTO::inline {
					BigUint$.clean( pos, len );
					return new BigUint( pos, len );
				}
				CRYPTO::debug {
					return _clean( pos, len );
				}
			}
		}

		/**
		 * @return		v1 & v2
		 */
		public static function and(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l1 == 0 ) {
				return v1;
			} else if ( l2 == 0 ) {
				return v2;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var l:uint = ( l1 < l2 ? l1 : l2 );
				var len:uint = 0;
				do {
					Memory.setI32( pos + len, Memory.getI32( p1 + len ) & Memory.getI32( p2 + len ) );
					len += 4;
				} while ( len < l );
				CRYPTO::inline {
					BigUint$.clean( pos, len );
					return new BigUint( pos, len );
				}
				CRYPTO::debug {
					return _clean( pos, len );
				}
			}
		}

		/**
		 * @return		v1 & ~v2
		 */
		public static function andNot(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l1 == 0 || l2 == 0 ) {
				return v1;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				l2 = ( l1 < l2 ? l1 : l2 );
				var len:uint = 0;
				do {
					Memory.setI32( pos + len, Memory.getI32( p1 + len ) & ( ~Memory.getI32( p2 + len ) ) );
					len += 4;
				} while ( len < l2 );
				if ( len < l1 ) {
					if ( l1 - len == 4 ) {
						Memory.setI32( pos + len, Memory.getI32( p1 + len ) );
					} else {
						var mem:ByteArray = _domain.domainMemory;
						mem.position = p1 + len;
						mem.readBytes( mem, pos + len, l1 - len );
					}
					len = l1;
				} else {
					CRYPTO::inline {
						BigUint$.clean( pos, len );
					}
					CRYPTO::debug {
						return _clean( pos, len );
					}
				}
				return new BigUint( pos, len );
			}
		}

		/**
		 * @return		v1 | v2
		 */
		public static function or(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l1 == 0 ) {
				return v2;
			} else if ( l2 == 0 ) {
				return v1;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var len:uint;
				if ( l2 > l1 ) { // меняем местами
					len = p1; p1 = p2; p2 = len;
					len = l1; l1 = l2; l2 = len;
				}
				len = 0;
				do {
					Memory.setI32( pos + len, Memory.getI32( p1 + len ) | Memory.getI32( p2 + len ) );
					len += 4;
				} while ( len < l2 );
				if ( len < l1 ) { // записываем остаток первого
					if ( l1 - len == 4 ) {
						Memory.setI32( pos + len, Memory.getI32( p1 + len ) );
					} else {
						var mem:ByteArray = _domain.domainMemory;
						mem.position = p1 + len;
						mem.readBytes( mem, pos + len, l1 - len );
					}
					len = l1;
				}
				return new BigUint( pos, len );
			}
		}

		/**
		 * @return		v1 ^ v2
		 */
		public static function xor(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l1 == 0 ) {
				return v2;
			} else if ( l2 == 0 ) {
				return v1;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var len:uint;
				if ( l2 > l1 ) { // меняем местами
					len = p1; p1 = p2; p2 = len;
					len = l1; l1 = l2; l2 = len;
				}
				len = 0;
				do {
					Memory.setI32( pos + len, Memory.getI32( p1 + len ) ^ Memory.getI32( p2 + len ) );
					len += 4;
				} while ( len < l2 );
				if ( len < l1 ) { // копируем остаток первого числа
					if ( l1 - len == 4 ) {
						Memory.setI32( pos + len, Memory.getI32( p1 + len ) );
					} else {
						var mem:ByteArray = _domain.domainMemory;
						mem.position = p1 + len;
						mem.readBytes( mem, pos + len, l1 - len );
					}
					len = l1;
				} else { // если числа одинаковой длинны, то надо подчистить
					CRYPTO::inline {
						BigUint$.clean( pos, len );
					}
					CRYPTO::debug {
						return _clean( pos, len );
					}
				}
				return new BigUint( pos, len );
			}
		}

		/**
		 * @return		v >> n
		 */
		public static function shiftRight(v:BigUint, n:uint, pos:uint):BigUint {
			var l:uint = v.len;
			if ( l == 0 || n == 0 ) {
				return v;
			} else {
				var s:uint = n >>> 3;
				if ( s >= l ) {
					return new BigUint();
				} else {
					var p:uint = v.pos;
					var r1:uint = n & 31;
					if ( r1 == 0 ) { // сдвиг кратен 32. можно просто откусить кусок исходного числа
						return new BigUint( p + s, l - s );
					} else {
						var len:uint;
						if ( !( r1 & 7 ) ) { // сдвиг кратен 8. копируем байты, а потом дописываем нолики
							len = l - s;
							if ( len <= 4 ) {
								Memory.setI32( pos, Memory.getI32( p + s ) );
							} else {
								var mem:ByteArray = _domain.domainMemory;
								mem.position = p + s;
								mem.readBytes( mem, pos, len );
							}
							Memory.setI32( pos + len, 0 );
							len += s & 3;
						} else {
							s -= s & 3;
							var i:uint = len = l - s;
							s += p;
							var r2:uint = 32 - r1;
							var t1:uint;
							var t2:uint = 0;
							do {
								i -= 4;
								t1 = Memory.getI32( s + i );
								Memory.setI32( pos + i, ( t1 >>> r1 ) | t2 );
								t2 = t1 << r2;
							} while ( i > 0 );
						}
						CRYPTO::inline {
							BigUint$.clean( pos, len );
							return new BigUint( pos, len );
						}
						CRYPTO::debug {
							return _clean( pos, len );
						}
					}
				}
			}
		}

		/**
		 * @return		v << n
		 */
		public static function shiftLeft(v:BigUint, n:uint, pos:uint):BigUint {
			var l:uint = v.len;
			if ( n == 0 || l == 0 ) {
				return v;
			} else {
				var len:uint = 0;
				var p:uint = v.pos;
				var s:uint = n >>> 3;
				var k:uint = s & 3;
				s += pos - k;
				var mem:ByteArray = _domain.domainMemory;
				if ( pos < s ) { // заполначем начало ноликами
					BigUint$.fillZero( mem, pos, s, len );
					len = s - pos;
				}
				if ( !( n & 7 ) ) { // сдвиг кратен 8. копируем байты, а потом дописываем нолики
					if ( k != 0 ) {
						Memory.setI32( pos + len, 0 );
						len += k;
					}
					mem.position = p;
					mem.readBytes( mem, pos + len, l );
					len += l;
					if ( k != 0 ) {
						Memory.setI32( pos + len, 0 );
						len += ( 4 - k );
						CRYPTO::inline {
							BigUint$.clean( pos, len );
						}
						CRYPTO::debug {
							return _clean( pos, len );
						}
					}
				} else {
					var i:uint = 0;
					var r1:uint = n & 31;
					var r2:uint = 32 - r1;
					var t1:int;
					var t2:int = 0;
					do {
						t1 = Memory.getI32( p + i );
						Memory.setI32( s + i, ( t1 << r1 ) | t2 );
						t2 = t1 >> r2;
						i += 4;
					} while ( i < l );
					if ( t2 != 0 ) {
						Memory.setI32( s + i, t2 );
						i += 4;
					}
					len += i;
				}
				return new BigUint( pos, len );
			}
		}

		/**
		 * @return		( v1 > v2 ? 1 : ( v2 > v1 ? -1 : 0 )
		 */
		public static function compare(v1:BigUint, v2:BigUint):int {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l1 > l2 ) return 1;
			else if ( l2 > l1 ) return -1;
			else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var i:uint = l1;
				var c1:uint;
				var c2:uint;
				do {
					i -= 4;
					c1 = Memory.getI32( p1 + i );
					c2 = Memory.getI32( p2 + i );
					if ( c1 > c2 ) {
						return 1;
					} else if ( c2 > c1 ) {
						return -1;
					}
				} while ( i > 0 );
			}
			return 0;
		}

		/**
		 * @return		( v1 > v2 ? v2 : v1 )
		 */
		public static function min(v1:BigUint, v2:BigUint):BigUint {
			return ( compare( v1, v2 ) > 0 ? v2 : v1 );
		}

		/**
		 * @return		( v1 < v2 ? v2 : v1 )
		 */
		public static function max(v1:BigUint, v2:BigUint):BigUint {
			return ( compare( v1, v2 ) < 0 ? v2 : v1 );
		}

		/**
		 * @return		v1 + 1
		 */
		public static function increment(v:BigUint, pos:uint):BigUint {
			var l:uint = v.len;
			if ( l == 0 ) {
				Memory.setI32( pos, 1 );
				return new BigUint( pos, 4 );
			} else {
				var p:uint = v.pos;
				var c:int;
				var len:uint = 0;
				do {
					c = Memory.getI32( p + len );
					Memory.setI32( pos + len, c + 1 );
					len += 4;
				} while ( c == -1 && len < l );
				if ( c == -1 ) {
					Memory.setI32( pos + len, 1 );
					len += 4;
				} else if ( len < l ) {
					if ( l - len == 4 ) {
						Memory.setI32( pos + len, Memory.getI32( p + len ) );
					} else {
						var mem:ByteArray = _domain.domainMemory;
						mem.position = p + len;
						mem.readBytes( mem, pos + len, l - len );
					}
					len = l;
				}
				return new BigUint( pos, len );
			}
		}

		/**
		 * @return		v1 + v2
		 */
		public static function add(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l1 == 0 ) {
				return v2;
			} else if ( l2 == 0 ) {
				return v1;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var len:uint;
				var temp:Number;
				if ( l1 == 4 && l2 == 4 ) { // короткое суммирование
					temp = Memory.getI32( p1 ) + Memory.getI32( p2 );
					Memory.setI32( pos, temp );
					if ( temp > 0xFFFFFFFF ) {
						Memory.setI32( pos, temp - 0x100000000 );
						len = 8;
					} else {
						len = 4;
					}
				} else {
					if ( l2 > l1 ) { // меняем местами
						len = p1; p1 = p2; p2 = len;
						len = l1; l1 = l2; l2 = len;
					}
					temp = 0;
					len = 0;
					do { // прибавляем к первому по 4 байтика от второго
						temp += uint( Memory.getI32( p1 + len ) ) + uint( Memory.getI32( p2 + len ) );
						Memory.setI32( pos + len, temp );
						temp = ( temp >= 0x100000000 ? 1 : 0 );
						len += 4;
					} while ( len < l2 );
					while ( temp > 0 && len < l1 ) { // прибавляем к первому остаток
						temp += uint( Memory.getI32( p1 + len ) );
						Memory.setI32( pos + len, temp );
						temp = ( temp >= 0x100000000 ? 1 : 0 );
						len += 4;
					}
					if ( temp > 0 ) { // если остался остаток, то первое число закончилось
						Memory.setI32( pos + len, 1 );
						len += 4;
					} else if ( len < l1 ) {  // копируем остаток первого числа
						if ( l1 - len == 4 ) {
							Memory.setI32( pos + len, Memory.getI32( p1 + len ) );
						} else {
							var mem:ByteArray = _domain.domainMemory;
							mem.position = p1 + len;
							mem.readBytes( mem, pos + len, l1 - len );
						}
						len = l1;
					}
				}
				return new BigUint( pos, len );
			}
		}

		/**
		 * @return		v1 - 1
		 * @throws		ArgumentError	v1 == 0
		 */
		public static function decrement(v:BigUint, pos:uint):BigUint {
			var l:uint = v.len;
			if ( l == 0 ) {
				throw new ArgumentError();
			} else {
				var p:uint = v.pos;
				var c:int;
				var len:uint = 0;
				do {
					c = Memory.getI32( p + len );
					Memory.setI32( pos + len, c - 1 );
					len += 4;
				} while ( c == 0 && len < l );
				if ( len < l ) {  // копируем остаток первого числа
					if ( l - len == 4 ) {
						Memory.setI32( pos + len, Memory.getI32( p + len ) );
					} else {
						var mem:ByteArray = _domain.domainMemory;
						mem.position = p + len;
						mem.readBytes( mem, pos + len, l - len );
					}
					len = l;
				}
				return new BigUint( pos, len );
			}
		}

		/**
		 * @return		v1 - v2
		 * @throws		ArgumentError	v2 > v1
		 */
		public static function sub(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l2 == 0 ) {
				return v1;
			} else if ( l1 == 0 ) {
				throw new ArgumentError();
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				if ( l1 == 4 && l2 == 4 ) { // числа короткие
					var c1:uint = Memory.getI32( p1 );
					var c2:uint = Memory.getI32( p2 );
					if ( c1 == c2 ) {
						return new BigUint();
					} else  if ( c2 > c1 ) {
						throw new ArgumentError();
					} else {
						c1 -= c2;
						Memory.setI32( pos, c1 );
						return new BigUint( pos, 4 );
					}
				} else {
					if ( l2 > l1 ) {
						throw new ArgumentError();
					} else {
						var len:uint = 0;
						var temp:int = 0;
						do {
							temp += uint( Memory.getI32( p1 + len ) ) - uint( Memory.getI32( p2 + len ) );
							if ( temp < 0 ) {
								Memory.setI32( pos + len, 0x100000000 + temp );
								temp = -1;
							} else {
								Memory.setI32( pos + len, temp );
								temp = 0;
							}
							len += 4;
						} while ( len < l2 );
						if ( temp < 0 ) {
							if ( len < l1 ) {
								while ( ( temp = Memory.getI32( p1 + len ) ) == 0 ) {
									Memory.setI32( pos + len, -1 );
									len += 4;
								}
								Memory.setI32( pos + len, temp - 1 );
								len += 4;
							} else { // второе число оказалось больше первого
								throw new ArgumentError();
							}
						}
						if ( len < l1 ) {  // копируем остаток первого числа
							if ( l1 - len == 4 ) {
								Memory.setI32( pos + len, Memory.getI32( p1 + len ) );
							} else {
								var mem:ByteArray = _domain.domainMemory;
								mem.position = p1 + len;
								mem.readBytes( mem, pos + len, l1 - len );
							}
							len = l1;
						} else {
							CRYPTO::inline {
								BigUint$.clean( pos, len );
							}
							CRYPTO::debug {
								return _clean( pos, len );
							}
						}
						return new BigUint( pos, l1 );
					}
				}
			}
		}

		/**
		 * @return		v1 * v2
		 */
		public static function mult(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l1 == 0 ) {
				return v1;
			} else if ( l2 == 0 ) {
				return v2;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var e1:int, e2:int;
				var c1:uint, c2:uint;
				// смотрим является ли число степенью двойки
				CRYPTO::inline {
					// TODO: переиспользование e1/2 ?
					BigUint$.getShift( p1, l1, e1, c1 );
					BigUint$.getShift( p2, l2, e2, c2 );
					var mem:ByteArray;
				}
				CRYPTO::debug {
					e1 = _getShift( p1, l1 );
					e2 = _getShift( p2, l2 );
				}
				if ( e1 >= 0 || e2 >= 0 ) {	// одно из чисел степень двойки
					if ( e1 == 0 ) {		//	v1 == 1
						return v2;
					} else if ( e2 == 0 ) {	//	v2 == 1
						return v1;
					} else if ( e1 > 0 && e2 > 0 ) {
						// оба числа степень двойки, значит можно просто сдвинуть
						// еденицу на сумму степеней
						CRYPTO::inline {
							mem = _domain.domainMemory;
							e1 += e2;
							pos += 4;
							BigUint$.shiftLeftOne( mem, e1, pos, len, c1 );
							return new BigUint( pos, len );
						}
						CRYPTO::debug {
							return _shiftLeftOne( e1 + e2, pos + 4 );
						}
					} else if ( e1 > 0 ) {
						return shiftLeft( v2, e1, pos );
					} else {
						return shiftLeft( v1, e2, pos );
					}
				} else {
					var len:uint;
					var temp:uint;
					if ( l1 == 4 && Memory.getUI16( p1 + 2 ) == 0 ) l1 = 2;
					if ( l2 == 4 && Memory.getUI16( p2 + 2 ) == 0 ) l2 = 2;
					if ( l1 == 2 || l2 == 2 ) {
						if ( l1 == 2 && l2 == 2 ) { // оба числа короткие
							Memory.setI32( pos, Memory.getUI16( p2 ) * Memory.getUI16( p1 ) );
							return new BigUint( pos, 4 );
						} else {
							if ( l1 == 2 ) {
								c1 = Memory.getUI16( p1 );
								p1 = p2;
								l1 = l2;
							} else {
								c1 = Memory.getUI16( p2 );
							}
							CRYPTO::inline {
								BigUint$.mult_s( p1, l1, c1, pos, len, temp );
								return new BigUint( pos, len );
							}
							CRYPTO::debug {
								return _mult_s( p1, l1, c1, pos );
							}
						}
					} else {
						CRYPTO::inline {
							mem = _domain.domainMemory;
							var i:uint, j:uint;
							BigUint$.mult( mem, p1, l1, p2, l2, pos, len, c1, c2, i, j, temp );
							return new BigUint( pos, len );
						}
						CRYPTO::debug {
							return _mult( p1, l1, p2, l2, pos );
						}
					}
				}
			}
		}

		/**
		 * @return		pow( v, e )
		 */
		public static function powInt(v:BigUint, e:uint, pos:uint):BigUint {
			var l:uint = v.len;
			var p:uint = v.pos;
			var c:uint;
			if ( e == 0 ) {
				Memory.setI32( pos, 1 );
				return new BigUint( pos, 4 );
			} else if ( l == 0 || e == 1 ) {
				return v;
			} else {
				var _e:int;
				CRYPTO::inline {
					BigUint$.getShift( p, l, _e, c );
					var mem:ByteArray;
				}
				CRYPTO::debug {
					_e = _getShift( p, l );
				}
				if ( _e == 0 ) {	// v == 1
					return v;
				} else if ( _e > 0 ) {
					// число является степенью двойки.
					// просто делаем сдвиг еденицы
					CRYPTO::inline {
						mem = _domain.domainMemory;
						_e *= e;
						BigUint$.shiftLeftOne( mem, _e, pos, len, c );
						return new BigUint( pos, len );
					}
					CRYPTO::debug {
						return _shiftLeftOne( _e * e, pos );
					}
				} else {
					c = Memory.getI32( p );
					CRYPTO::inline {
						var pr:uint, lr:uint;
						var len:uint;
					}
					CRYPTO::debug {
						var d:BigUint;
					}
					var ei:uint = 1;
					var r:uint = 1;
					if ( l == 4 && c < 0x10000 ) { // исходное число достаточно коротко
						do {
							if ( ei & e ) {
								r *= c;
							}
							ei <<= 1;
							if ( ei <= e ) {
								c *= c;
							}
						} while ( ei <= e && c < 0x10000 );
						if ( ei <= e ) { // если результат не достигнут, то запишим временные значения
							Memory.setI32( pos, c );
							l = 4;
							p = pos;
							CRYPTO::debug {
								v = new BigUint( pos, l );
							}
							pos += l;
							if ( r >= 0x10000 ) { // запишим результат только если он привысит допустимый лимит
								Memory.setI32( pos, r );
								CRYPTO::inline {
									pr = pos;
									lr = 4;
								}
								CRYPTO::debug {
									d = new BigUint( pos, 4 );
								}
								pos += 4;
							}
						}
					}
					// если временный результат короткий, используем сокращённый алгоритм пока он не удлиннится
					CRYPTO::inline {
						mem = _domain.domainMemory;
						var c1:uint, c2:uint, i:uint, j:uint, temp:uint;
						while ( !lr && ei <= e ) {
							if ( ei & e ) {
								if ( r == 1 ) {
									pr = p;
									lr = l;
								} else {
									BigUint$.mult_s( p, l, r, pos, len, temp );
									pr = pos;
									lr = len;
									pos += len;
								}
							}
							ei <<= 1;
							if ( ei <= e ) {
								BigUint$.sqr( mem, p, l, pos, len, c1, c2, i, j, temp );
								p = pos;
								l = len;
								pos = p + l;
							}
						}
						if ( !lr ) {
							Memory.setI32( pos, r );
							pr = pos;
							lr = 4;
							pos += 4;
						}
					}
					CRYPTO::debug {
						while ( !d && ei <= e ) {
							if ( ei & e ) {
								if ( r == 1 ) {
									d = v;
								} else {
									d = _mult_s( p, l, r, pos );
									pos += d.len;
								}
							}
							ei <<= 1;
							if ( ei <= e ) {
								v = _sqr( p, l, pos );
								p = v.pos;
								l = v.len;
								pos = p + ( l << 1 );
							}
						}
						if ( !d ) {
							Memory.setI32( pos, r );
							d = new BigUint( pos, 4 );
							pos += 4;
						}
					}
					// и результат и промежуточное значение очень длинные
					while ( ei <= e ) {
						if ( ei & e ) {
							CRYPTO::inline {
								BigUint$.mult( mem, p, l, pr, lr, pos, len, c1, c2, i, j, temp );
								pr = pos;
								lr = len;
								pos += len;
							}
							CRYPTO::debug {
								d = _mult( p, l, d.pos, d.len, pos );
								pos = d.pos + d.len;
							}
						}
						ei <<= 1;
						if ( ei <= e ) {
							CRYPTO::inline {
								BigUint$.sqr( mem, p, l, pos, len, c1, c2, i, j, temp );
								p = pos;
								l = len;
								pos += l;
							}
							CRYPTO::debug {
								v = _sqr( p, l, pos );
								p = v.pos;
								l = v.len;
								pos = p + ( l << 1 );
							}
						}
					}
					CRYPTO::inline {
						return new BigUint( pr, lr );
					}
					CRYPTO::debug {
						return d;
					}
				}
			}
		}

		/**
		 * @param		v1
		 * @return		[ v1 / v2, v1 % v2 ]
		 * @throws		ArgumentError	v2 == 0
		 */
		public static function divAndMod(v1:BigUint, v2:BigUint, pos:uint):Vector.<BigUint> {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l2 == 0 ) {
				throw new ArgumentError();
			} else if ( l1 == 0 ) {
				return new <BigUint>[ v1, v1 ];
			} else if ( l2 > l1 ) {
				return new <BigUint>[ new BigUint(), v1 ];
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var c1:uint;
				var c2:uint;
				CRYPTO::inline {
					var len:uint;
					var posx:uint;
					var lenx:uint;
				}
				if ( l1 == 4 ) { // оба числа короткие
					c2 = Memory.getI32( p2 );
					if ( c2 == 1 ) {
						return new <BigUint>[ v1, new BigUint() ];
					} else {
						c1 = Memory.getI32( p1 );
						if ( c1 == c2 ) {
							Memory.setI32( pos, 1 );
							return new <BigUint>[ new BigUint( pos, 4 ), new BigUint() ];
						} else if ( c2 > c1 ) {
							return new <BigUint>[ new BigUint(), v1 ];
						} else {
							Memory.setI32( pos, c1 / c2 );
							var d:BigUint = new BigUint( pos, 4 );
							pos += 4;
							c1 %= c2;
							if ( c1 == 0 ) {
								return new <BigUint>[ d, new BigUint() ];
							} else {
								Memory.setI32( pos, c1 );
								return new <BigUint>[ d, new BigUint( pos, 4 ) ];
							}
						}
					}
				} else if ( l2 == 4 && Memory.getUI16( p2 + 2 ) == 0 ) { // второе число короткое
					c2 = Memory.getUI16( p2 );
					if ( c2 == 1 ) {
						return new <BigUint>[ v1, new BigUint() ];
					} else {
						CRYPTO::inline {
							BigUint$.divAndMod_s( p1, l1, c2, pos, len, posx, lenx, c1, l2 );
							return new <BigUint>[ new BigUint( pos, len ), new BigUint( posx, lenx ) ];
						}
						CRYPTO::debug {
							return _divAndMod_s( p1, l1, c2, pos );
						}
					}
				} else {
					CRYPTO::inline {
						var mem:ByteArray = _domain.domainMemory;
						var scale:uint, k:uint, t1:uint, t2:uint, t3:int, qGuess:int, borrow:int, carry:int, j:int, i:int;
						BigUint$.divAndMod( mem, p1, l1, p2, l2, pos, len, posx, lenx, scale, k, t1, t2, t3, qGuess, borrow, carry, c2, c1, j, i );
						return new <BigUint>[ new BigUint( pos, len ), new BigUint( posx, lenx ) ];
					}
					CRYPTO::debug {
						return _divAndMod( p1, l1, p2, l2, pos );
					}
				}
			}
		}

		/**
		 * @return		v1 / v2
		 * @throws		ArgumentError	v2 == 0
		 */
		public static function div(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l2 == 0 ) {
				throw new ArgumentError();
			} else if ( l2 > l1 ) {
				return new BigUint();
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var c1:uint;
				var c2:uint;
				CRYPTO::inline {
					var len:uint;
				}
				if ( l1 == 4 ) { // оба числа короткие
					c2 = Memory.getI32( p2 );
					if ( c2 == 1 ) {
						return v1;
					} else {
						c1 = Memory.getUI16( p1 );
						if ( c1 == c2 ) {
							Memory.setI32( pos, 1 );
							return new BigUint( pos, 4 );
						} else if ( c2 > c1 ) {
							return new BigUint();
						} else {
							c1 = c1 / c2;
							if ( c1 == 0 ) {
								return new BigUint();
							} else {
								Memory.setI32( pos, c1 );
								return new BigUint( pos, 4 );
							}
						}
					}
				} else {
					var i:int;
					CRYPTO::inline {
						BigUint$.getShift( p2, l2, i, c1 );
					}
					CRYPTO::debug {
						i = _getShift( p2, l2 );
					}
					if ( i == 0 ) {	// v2 == 1
						return v1;
					} else if ( i > 0 ) {
						// число является степенью двойки.
						// сдвигаем вправо
						return shiftRight( v1, i, pos );
					} else if ( l2 == 4 && Memory.getUI16( p2 + 2 ) == 0 ) { // второе число короткое
						c2 = Memory.getUI16( p2 );
						CRYPTO::inline {
							BigUint$.div_s( p1, l1, c2, pos, len, c1, l2 );
							return new BigUint( pos, len );
						}
						CRYPTO::debug {
							return _div_s( p1, l1, c2, pos );
						}
					} else {
						CRYPTO::inline {
							var mem:ByteArray = _domain.domainMemory;
							var scale:uint, k:uint, t1:uint, t2:uint, t3:int, qGuess:int, borrow:int, carry:int, j:int;
							BigUint$.div( mem, p1, l1, p2, l2, pos, len, scale, k, t1, t2, t3, qGuess, borrow, carry, c2, c1, j, i );
							return new BigUint( pos, len );
						}
						CRYPTO::debug {
							return _div( p1, l1, p2, l2, pos );
						}
					}
				}
			}
		}

		/**
		 * @return		v1 % v2;
		 * @throws		ArgumentError	v2 == 0
		 */
		public static function mod(v1:BigUint, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l2 == 0 ) {
				throw new ArgumentError();
			} else if ( l2 > l1 ) {
				return v1;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				var c1:uint;
				var c2:uint;
				if ( l1 == 4 ) { // оба числа короткие
					c2 = Memory.getI32( p2 );
					if ( c2 == 1 ) {
						return new BigUint();
					} else {
						c1 = Memory.getI32( p1 );
						if ( c1 == c2 ) {
							return new BigUint();
						} else if ( c2 > c1 ) {
							return v1;
						} else {
							c1 = c1 % c2;
							if ( c1 == 0 ) {
								return new BigUint();
							} else {
								Memory.setI32( pos, c1 );
								return new BigUint( pos, 4 );
							}
						}
					}
				} else if ( l2 == 4 && Memory.getUI16( p2 + 2 ) == 0 ) { // второе число короткое
					c2 = Memory.getUI16( p2 );
					if ( c2 == 1 ) {
						return new BigUint();
					} else {
						CRYPTO::inline {
							BigUint$.mod_s( p1, l1, c2, c1, l2 );
						}
						CRYPTO::debug {
							c1 = _mod_s( p1, l1, c2 );
						}
						if ( c1 == 0 ) {
							return new BigUint();
						} else {
							Memory.setI32( pos, c1 );
							return new BigUint( pos, 4 );
						}
					}
				} else {
					CRYPTO::inline {
						var mem:ByteArray = _domain.domainMemory;
						var len:uint;
						var scale:uint, k:uint, t1:uint, t2:uint, t3:int, qGuess:int, borrow:int, carry:int, j:int, i:int;
						BigUint$.mod( mem, p1, l1, p2, l2, pos, len, scale, k, t1, t2, t3, qGuess, borrow, carry, c2, c1, j, i );
						return new BigUint( pos, len );
					}
					CRYPTO::debug {
						return _mod( p1, l1, p2, l2, pos );
					}
				}
			}
		}

		/**
		 * @return		pow( v1, e ) % v2
		 * @throws		ArgumentError	v2 == 0
		 */
		public static function modPowInt(v1:BigUint, e:int, v2:BigUint, pos:uint):BigUint {
			var l1:uint = v1.len;
			var l2:uint = v2.len;
			if ( l2 == 0 ) {
				throw new ArgumentError();
			} else if ( l1 == 0 ) {
				return v1;
			} else {
				var p1:uint = v1.pos;
				var p2:uint = v2.pos;
				if ( l2 == 4 ) {
					var c:uint;// = _modPowInt_simple( p1, l1, e, uint( Memory.getI32( p2 ) ), pos );
					if ( c == 0 ) {
						return new BigUint();
					} else {
						Memory.setI32( pos, c );
						return new BigUint( pos, 4 );
					}
				} else if ( e < 256 || !( Memory.getUI8( p2 ) & 1 ) ) {

				} else {

				}
			}
			return null;
		}

		public function modPow(v:BigUint, e:BigUint, m:BigUint, pos:uint):BigUint {
			return null;
		}

		public function gcd(v:BigUint, a:BigUint, pos:uint):BigUint {
			return null;
		}

		public function modInverse(v:BigUint, m:BigUint, pos:uint):BigUint {
			return null;
		}

		public function isProbablePrime(v:BigUint, t:int):Boolean {
			return false;
		}

		public function primify(v:BigUint, bits:int, t:int):void {
		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		CRYPTO::debug
		/**
		 * @private
		 */
		private static function _fillZero(pos:uint, end:uint):void {
			Memory.setI32( pos, 0 );
			var mem:ByteArray = _domain.domainMemory;
			mem.position = pos + 4;
			if ( mem.position < end ) {
				Memory.setI32( mem.position, 0 );
				mem.position += 4;
				var i:uint = 8;
				while ( mem.position < end ) {
					mem.writeBytes( mem, pos, i );
					i <<= 1;
				}
			}
		}

		CRYPTO::debug
		/**
		 * @private
		 */
		private static function _clean(pos:uint, len:uint):BigUint {
			while ( len > 0 && Memory.getI32( pos + len - 4 ) == 0 ) {
				len -= 4;
			}
			return new BigUint( pos, len );
		}

		CRYPTO::debug
		/**
		 * @private
		 */
		private static function _getShift(pos:uint, len:uint):int {
			var c:uint = pos + len - 4;
			var e:int = Memory.getI32( c );
			if ( ( e & ( e - 1 ) ) == 0 ) {
				while ( c > pos ) {
					c -= 4;
					if ( Memory.getI32( c ) != 0 ) {
						return -1;
					}
				}
				e = int( Math.log( e ) * Math.LOG2E + 0.5 ) + ( ( len - 4 ) << 3 );
			} else {
				return -1;
			}
			return e;
		}

		/**
		 * @private
		 */
		private static function _getBitLengthInt(v:uint):uint {
			// Binary search
			return	( v < 0x00008000
					?	( v < 0x00000080
						?	( v < 0x00000008
							?	( v < 0x00000002
								?	( v < 0x00000001 ?  0 :  1 )
								:	( v < 0x00000004 ?  2 :  3 )
								)
							:	( v < 0x00000020
								?	( v < 0x00000010 ?  4 :  5 )
								:	( v < 0x00000040 ?  6 :  7 )
								)
							)
						:	( v < 0x00000800
							?	( v < 0x00000200
								?	( v < 0x00000100 ?  8 :  9 )
								:	( v < 0x00000400 ? 10 : 11 )
								)
							:	( v < 0x00002000
								?	( v < 0x00001000 ? 12 : 13 )
								:	( v < 0x00004000 ? 14 : 15 )
								)
							)
						)
					:	( v < 0x00800000
						?	( v < 0x00080000
							?	( v < 0x00020000
								?	( v < 0x00010000 ? 16 : 17 )
								:	( v < 0x00040000 ? 18 : 19 )
								)
							:	( v < 0x00200000
								?	( v < 0x00100000 ? 20 : 21 )
								:	( v < 0x00400000 ? 22 : 23 )
								)
							)
						:	( v < 0x08000000
							?	( v < 0x02000000
								?	( v < 0x01000000 ? 24 : 25 )
								:	( v < 0x04000000 ? 26 : 27 )
								)
							:	( v < 0x20000000
								?	( v < 0x10000000 ? 28 : 29 )
								:	( v < 0x40000000 ? 30 : ( v < 0x80000000 ? 31 : 32 ) )
								)
							)
						)
					);
		}

		/**
		 * @private
		 */
		private static function _getHighestBit(e:uint):uint {
			var i:uint = 0x80000000;
			while ( !( e & i ) && i > 0 ) {
				i >>>= 1;
			}
			return i;
		}

//		/**
//		 * @private
//		 * @return		v >> ( n << 8 )
//		 */
//		private static function _shiftRight(v:BigUint, n:uint, pos:uint):BigUint {
//			return new BigUint( v.pos + n, v.len - n );
//		}

//		/**
//		 * @private
//		 * @return		v << ( n << 8 )
//		 */
//		private static function _shiftLeft(v:BigUint, n:uint, pos:uint):BigUint {
//			var len:uint = 0;
//			do {
//				Memory.setI16( pos + len, 0 );
//				len += 2;
//			} while ( len < n );
//			var mem:ByteArray = domain.domainMemory;
//			mem.position = v.pos;
//			mem.readBytes( mem, pos + len, v.len );
//			return new BigUint( pos, v.len + len );
//		}

		CRYPTO::debug
		/**
		 * @private
		 */
		private static function _shiftLeftOne(n:uint, pos:uint):BigUint {
			var s:uint = n >>> 3;
			s -= s & 3;
			if ( s > 0 ) {
				s += pos;
				_fillZero( pos, s );
			}
			Memory.setI32( s, 1 << ( n & 31 ) );
			return new BigUint( pos, s - pos + 4 );
		}

		CRYPTO::debug
		/**
		 * @private
		 * @return		v1 * v2
		 */
		private static function _mult_s(p1:uint, l1:uint, v2:uint, pos:uint):BigUint {
			var len:uint = 0;
			var temp:uint = 0;
			do {
				temp += Memory.getUI16( p1 + len ) * v2;
				Memory.setI16( pos + len, temp );
				len += 2;
				temp >>>= 16;
			} while ( len < l1 );
			if ( temp > 0 ) {
				Memory.setI32( pos + len, temp );
				len += 4;
			}
			return new BigUint( pos, len );
		}

		CRYPTO::debug
		/**
		 * @private
		 * @return		v1 * v2
		 */
		private static function _mult(p1:uint, l1:uint, p2:uint, l2:uint, pos:uint):BigUint {
			var temp:uint = 0;
			var c1:uint = Memory.getUI16( p1 );
			var c2:uint = Memory.getUI16( p2 );
			var i:uint = 2;
			var j:uint = 2;
			if ( c1 && c2 ) {
				temp = c1 * c2;
				Memory.setI16( pos, temp );
				j = 2;
				while ( j < l2 ) {
					temp = ( temp >>> 16 ) + c1 * Memory.getUI16( p2 + j );
					Memory.setI16( pos + j, temp );
					j += 2;
				}
				Memory.setI16( pos + l2, temp >>> 16 );
			} else {
				if ( c1 ) i = 0;
				else {
					while ( i < l1 && Memory.getUI16( p1 + i ) == 0 ) {
						i += 2;
					}
				}
				if ( c2 ) j = 0;
				else {
					while ( j < l2 && Memory.getUI16( p2 + j ) == 0 ) {
						j += 2;
					}
				}
				if ( j > i ) {
					temp = p1; p1 = p2; p2 = temp;
					temp = l1; l1 = l2; l2 = temp;
					temp = c1; c1 = c2; c2 = temp;
					i = j;
				}
				_fillZero( pos, pos + l2 + i );
			}
			var len:uint;
			while ( i < l1 ) {
				c1 = Memory.getUI16( p1 + i );
				if ( c1 ) {
					len = pos + i;
					temp = c2 * c1 + Memory.getUI16( len );
					Memory.setI16( len, temp );
					j = 2;
					while ( j < l2 ) {
						len = pos + i + j;
						temp = ( temp >>> 16 ) + c1 * Memory.getUI16( p2 + j ) + Memory.getUI16( len );
						Memory.setI16( len, temp );
						j += 2;
					}
					Memory.setI16( pos + i + j, temp >>> 16 );
				} else {
					Memory.setI16( pos + i + l2, 0 );
				}
				i += 2;
			}
			len = i + j;
			return _clean( pos, len );
		}

		CRYPTO::debug
		/**
		 * @private
		 * @return		v * v
		 */
		private static function _sqr(p:uint, l:uint, pos:uint):BigUint {
			var c1:uint = Memory.getUI16( p );
			var temp:uint;
			var j:uint;
			var i:uint = 2;
			if ( c1 ) {
				temp = c1 * c1;
				Memory.setI16( pos, temp );
				j = 2;
				while ( j < l ) {
					temp = ( temp >>> 16 ) + c1 * Memory.getUI16( p + j );
					Memory.setI16( pos + j, temp );
					j += 2;
				}
				Memory.setI16( pos + j, temp >>> 16 );
			} else {
				while ( i < l && Memory.getUI16( p + i ) == 0 ) {
					i += 2;
				}
				_fillZero( pos, pos + l + i );
			}
			var len:uint;
			var c2:uint;
			while ( i < l ) {
				c2 = Memory.getUI16( p + i );
				if ( c2 ) {
					len = pos + i;
					temp = c2 * c1 + Memory.getUI16( len );
					Memory.setI16( len, temp );
					j = 2;
					while ( j < l ) {
						len = pos + i + j;
						temp = ( temp >>> 16 ) + c2 * Memory.getUI16( p + j ) + Memory.getUI16( len );
						Memory.setI16( len, temp );
						j += 2;
					}
					Memory.setI16( pos + i + j, temp >>> 16 );
				} else {
					Memory.setI16( pos + i + l, 0 );
				}
				i += 2;
			}
			len = i << 1;
			return _clean( pos, len );
		}

		CRYPTO::debug
		/**
		 * @private
		 * @reutrn		[ v1 / v2, v1 % v2 ]
		 */
		private static function _divAndMod_s(p1:uint, l1:uint, v2:uint, pos:uint):Vector.<BigUint> {
			var c:uint = 0;
			var i:uint = l1;
			do {
				i -= 2;
				c = Memory.getUI16( p1 + i ) | ( c << 16 );
				Memory.setI16( pos + i, c / v2 );
				c %= v2;
			} while ( i > 0 );
			var d:BigUint = _clean( pos, l1 );
			if ( c > 0 ) {
				pos += d.len;
				Memory.setI32( pos, c );
				return new <BigUint>[ d, new BigUint( pos, 4 ) ];
			} else {
				return new <BigUint>[ d, new BigUint() ];
			}
		}

		CRYPTO::debug
		/**
		 * @private
		 * @return		[ v1 / v2, v1 % v2 ]
		 */
		private static function _divAndMod(p1:uint, l1:uint, p2:uint, l2:uint, pos:uint):Vector.<BigUint> {

			var scale:uint = Memory.getUI16( p2 + l2 - 2 );
			if ( !scale ) scale = Memory.getUI16( p2 + l2 - 4 );
			scale = 0x10000 / ( scale + 1 ); // коэффициент нормализации

			var d:BigUint;
			var len:uint;
			var k:uint;
			if ( scale > 1 ) {
				// Нормализация
				CRYPTO::inline {
					BigUint$.mult_s( p1, l1, scale, pos, len, k );
					p1 = pos;
					l1 = len;
				}
				CRYPTO::debug {
					d = _mult_s( p1, l1, scale, pos );
					p1 = d.pos;
					l1 = d.len;
				}
				pos = p1 + l1;
				Memory.setI16( pos, 0 );
				pos += 2;
				CRYPTO::inline {
					BigUint$.mult_s( p2, l2, scale, pos, len, k );
					p2 = pos;
					l2 = len;
				}
				CRYPTO::debug {
					d = _mult_s( p2, l2, scale, pos );
					p2 = d.pos;
					l2 = d.len;
				}
				pos = p2 + l2;
			} else {
				var mem:ByteArray = _domain.domainMemory;
				mem.position = p1;
				mem.readBytes( mem, pos, l1 );
				p1 = pos;
				pos += l1;
				Memory.setI16( pos, 0 );
				pos += 2;
			}

			while ( Memory.getUI16( p1 + l1 - 2 ) == 0 ) l1 -= 2;
			while ( Memory.getUI16( p2 + l2 - 2 ) == 0 ) l2 -= 2;

			len = l1 - l2;

			// резервируем запасной разряд
			Memory.setI32( pos + len, 0 );

			var t1:uint, t2:uint, t3:int;
			var qGuess:int;				// догадка для частного и соответствующий остаток
			var borrow:int, carry:int;	// переносы

			var c2:uint = Memory.getUI16( p2 + l2 - 2 );
			var c4:uint = Memory.getUI16( p2 + l2 - 4 );

			// Главный цикл шагов деления. Каждая итерация дает очередную цифру частного.
			var j:int = len;	// i – индекс текущей цифры v1
			var i:int = l1;		// j - текущий сдвиг v2 относительно v1, используемый при вычитании,
								//     по совместительству - индекс очередной цифры частного.
			do {
				t1 = Memory.getI32( p1 + i - 2 )
				t2 = c2;

				qGuess = t1 / t2;
				k = t1 % t2;

				// Пока не будут выполнены условия (2) уменьшать частное.
				while ( k < 0x10000 ) {
					t2 = c4 * qGuess;
					t1 = ( k << 16 ) + Memory.getUI16( p1 + i - 4 );
					if ( ( t2 > t1 ) || ( qGuess == 0x10000 ) ) {
						// условия не выполнены, уменьшить qGuess
						// и досчитать новый остаток
						--qGuess;
						k += c2;
					} else {
						break;
					}
				}

				if ( qGuess ) {

					carry = 0;
					borrow = 0;

					// Теперь qGuess - правильное частное или на единицу больше q
					// Вычесть делитель v2, умноженный на qGuess из делимого v1,
					// начиная с позиции vJ+i
					k = 0;
					do {
						// получить в t1 цифру произведения v2*qGuess
						t1 = Memory.getUI16( p2 + k ) * qGuess + carry;
						carry = t1 >>> 16;
						t1 -= carry << 16;
						// Сразу же вычесть из v1
						t3 = Memory.getUI16( p1 + k + j ) - t1 + borrow;
						if ( t3 < 0 ) {
							Memory.setI16( p1 + k + j, t3 + 0x10000 )
							borrow = -1;
						} else {
							Memory.setI16( p1 + k + j, t3 )
							borrow = 0;
						}
						k += 2;
					} while ( k < l2 );

					if ( carry || borrow ) {
						// возможно, умноженое на qGuess число v2 удлинилось.
						// Если это так, то после умножения остался
						// неиспользованный перенос carry. Вычесть и его тоже.
						t3 = Memory.getUI16( p1 + k + j ) - carry + borrow;
						if ( t3 < 0 ) {
							Memory.setI16( p1 + k + j, t3 + 0x10000 );
							borrow = -1;
						} else {
							Memory.setI16( p1 + k + j, t3 );
							borrow = 0;
						}
					}

					// Прошло ли вычитание нормально ?
					if ( borrow ) { // Нет, последний перенос при вычитании borrow = -1,
						// значит, qGuess на единицу больше истинного частного
						Memory.setI16( pos + j, qGuess - 1 );
						// добавить одно, вычтенное сверх необходимого v2 к v1
						carry = 0;
						k = 0;
						do {
							t1 = Memory.getUI16( p1 + k + j ) + Memory.getUI16( p2 + k ) + carry;
							if ( t1 >= 0x10000 ) {
								Memory.setI16( p1 + k + j, t1 - 0x10000 );
								carry = 1;
							} else {
								Memory.setI16( p1 + k + j, t1 );
								carry = 0;
							}
							k += 2;
						} while ( k < l2 );
						Memory.setI16( p1 + k + j, Memory.getUI16( p1 + k + j ) + carry - 0x10000 );
					} else { // Да, частное угадано правильно
						Memory.setI16( pos + j, qGuess );
					}

				} else { // частное равно 0
					Memory.setI16( pos + j, 0 );
				}

				j -= 2;
				i -= 2;

			} while ( j >= 0 );

			if ( l1 & 3 ) l1 += 2;
			len += 2;
			if ( len & 3 ) len += 2;

			CRYPTO::inline {
				BigUint$.clean( p1, l1 );
				BigUint$.clean( pos, len );
				d = new BigUint( pos, len );
			}
			CRYPTO::debug {
				d = _clean( p1, l1 );
				p1 = d.pos;
				l1 = d.len;
				d = _clean( pos, len );
				len = d.len;
			}

			pos += len;
			if ( scale > 1 && l1 > 0 ) {
				CRYPTO::inline {
					BigUint$.div_s( p1, l1, scale, pos, len, carry, k );
					p1 = pos;
					l1 = len;
				}
				CRYPTO::debug {
					return new <BigUint>[ d, _div_s( p1, l1, scale, pos ) ];
				}
			}
			return new <BigUint>[ d, new BigUint( p1, l1 ) ];

		}

		CRYPTO::debug
		/**
		 * @private
		 * @reutrn		v1 / v2
		 */
		private static function _div_s(p1:uint, l1:uint, v2:uint, pos:uint):BigUint {
			var c:uint = 0;
			var i:uint = l1;
			do {
				i -= 2;
				c = Memory.getUI16( p1 + i ) | ( c << 16 );
				Memory.setI16( pos + i, c / v2 );
				c %= v2;
			} while ( i > 0 );
			return _clean( pos, l1 );
		}

		CRYPTO::debug
		/**
		 * @private
		 * @return		v1 / v2
		 */
		private static function _div(p1:uint, l1:uint, p2:uint, l2:uint, pos:uint):BigUint {

			var scale:uint = Memory.getUI16( p2 + l2 - 2 );
			if ( !scale ) scale = Memory.getUI16( p2 + l2 - 4 );
			scale = 0x10000 / ( scale + 1 ); // коэффициент нормализации

			var d:BigUint;
			var len:uint;0
			var k:uint;
			if ( scale > 1 ) {
				// Нормализация
				d = _mult_s( p1, l1, scale, pos );
				p1 = d.pos;
				l1 = d.len;
				pos = p1 + l1;
				Memory.setI16( pos, 0 );
				pos += 2;
				d = _mult_s( p2, l2, scale, pos );
				p2 = d.pos;
				l2 = d.len;
				pos = p2 + l2;
			} else {
				var mem:ByteArray = _domain.domainMemory;
				mem.position = p1;
				mem.readBytes( mem, pos, l1 );
				p1 = pos;
				pos += l1;
				Memory.setI16( pos, 0 );
				pos += 2;
			}

			while ( Memory.getUI16( p1 + l1 - 2 ) == 0 ) l1 -= 2;
			while ( Memory.getUI16( p2 + l2 - 2 ) == 0 ) l2 -= 2;

			len = l1 - l2;

			// резервируем запасной разряд
			Memory.setI32( pos + len, 0 );

			var t1:uint, t2:uint, t3:int;
			var qGuess:int;				// догадка для частного и соответствующий остаток
			var borrow:int, carry:int;	// переносы

			var c2:uint = Memory.getUI16( p2 + l2 - 2 );
			var c4:uint = Memory.getUI16( p2 + l2 - 4 );

			// Главный цикл шагов деления. Каждая итерация дает очередную цифру частного.
			var j:int = len;	// i – индекс текущей цифры v1
			var i:int = l1;		// j - текущий сдвиг v2 относительно v1, используемый при вычитании,
								//     по совместительству - индекс очередной цифры частного.
			do {
				t1 = Memory.getI32( p1 + i - 2 )
				t2 = c2;

				qGuess = t1 / t2;
				k = t1 % t2;

				// Пока не будут выполнены условия (2) уменьшать частное.
				while ( k < 0x10000 ) {
					t2 = c4 * qGuess;
					t1 = ( k << 16 ) + Memory.getUI16( p1 + i - 4 );
					if ( ( t2 > t1 ) || ( qGuess == 0x10000 ) ) {
						// условия не выполнены, уменьшить qGuess
						// и досчитать новый остаток
						--qGuess;
						k += c2;
					} else {
						break;
					}
				}

				if ( qGuess ) {

					carry = 0;
					borrow = 0;

					// Теперь qGuess - правильное частное или на единицу больше q
					// Вычесть делитель v2, умноженный на qGuess из делимого v1,
					// начиная с позиции vJ+i
					k = 0;
					do {
						// получить в t1 цифру произведения v2*qGuess
						t1 = Memory.getUI16( p2 + k ) * qGuess + carry;
						carry = t1 >>> 16;
						t1 -= carry << 16;
						// Сразу же вычесть из v1
						t3 = Memory.getUI16( p1 + k + j ) - t1 + borrow;
						if ( t3 < 0 ) {
							Memory.setI16( p1 + k + j, t3 + 0x10000 )
							borrow = -1;
						} else {
							Memory.setI16( p1 + k + j, t3 )
							borrow = 0;
						}
						k += 2;
					} while ( k < l2 );

					if ( carry || borrow ) {
						// возможно, умноженое на qGuess число v2 удлинилось.
						// Если это так, то после умножения остался
						// неиспользованный перенос carry. Вычесть и его тоже.
						t3 = Memory.getUI16( p1 + k + j ) - carry + borrow;
						if ( t3 < 0 ) {
							Memory.setI16( p1 + k + j, t3 + 0x10000 );
							borrow = -1;
						} else {
							Memory.setI16( p1 + k + j, t3 );
							borrow = 0;
						}
					}

					// Прошло ли вычитание нормально ?
					if ( borrow ) { // Нет, последний перенос при вычитании borrow = -1,
						// значит, qGuess на единицу больше истинного частного
						Memory.setI16( pos + j, qGuess - 1 );
						// добавить одно, вычтенное сверх необходимого v2 к v1
						carry = 0;
						k = 0;
						do {
							t1 = Memory.getUI16( p1 + k + j ) + Memory.getUI16( p2 + k ) + carry;
							if ( t1 >= 0x10000 ) {
								Memory.setI16( p1 + k + j, t1 - 0x10000 );
								carry = 1;
							} else {
								Memory.setI16( p1 + k + j, t1 );
								carry = 0;
							}
							k += 2;
						} while ( k < l2 );
						Memory.setI16( p1 + k + j, Memory.getUI16( p1 + k + j ) + carry - 0x10000 );
					} else { // Да, частное угадано правильно
						Memory.setI16( pos + j, qGuess );
					}

				} else { // частное равно 0
					Memory.setI16( pos + j, 0 );
				}

				j -= 2;
				i -= 2;

			} while ( j >= 0 );

			len += 2;
			if ( len & 3 ) len += 2;

			return _clean( pos, len );

		}

		CRYPTO::debug
		/**
		 * @private
		 * @return		v1 % v2
		 */
		private static function _mod_s(p1:uint, l1:uint, v2:uint):uint {
			var c:uint = 0;
			var i:uint = l1;
			do {
				i -= 2;
				c = ( Memory.getUI16( p1 + i ) | ( c << 16 ) ) % v2;
			} while ( i > 0 );
			return c;
		}

		CRYPTO::debug
		/**
		 * @private		v1 % v2
		 */
		private static function _mod(p1:uint, l1:uint, p2:uint, l2:uint, pos:uint):BigUint {

			var scale:uint = Memory.getUI16( p2 + l2 - 2 );
			if ( !scale ) scale = Memory.getUI16( p2 + l2 - 4 );
			scale = 0x10000 / ( scale + 1 ); // коэффициент нормализации

			var d:BigUint;
			var len:uint;
			var k:uint;
			if ( scale > 1 ) {
				// Нормализация
				d = _mult_s( p1, l1, scale, pos );
				p1 = d.pos;
				l1 = d.len;
				pos = p1 + l1;
				Memory.setI16( pos, 0 );
				pos += 2;
				d = _mult_s( p2, l2, scale, pos );
				p2 = d.pos;
				l2 = d.len;
				pos = p2 + l2;
			} else {
				var mem:ByteArray = _domain.domainMemory;
				mem.position = p1;
				mem.readBytes( mem, pos, l1 );
				p1 = pos;
				pos += l1;
				Memory.setI16( pos, 0 );
				pos += 2;
			}

			while ( Memory.getUI16( p1 + l1 - 2 ) == 0 ) l1 -= 2;
			while ( Memory.getUI16( p2 + l2 - 2 ) == 0 ) l2 -= 2;

			var t1:uint, t2:uint, t3:int;
			var qGuess:int;				// догадка для частного и соответствующий остаток
			var borrow:int, carry:int;	// переносы

			var c2:uint = Memory.getUI16( p2 + l2 - 2 );
			var c4:uint = Memory.getUI16( p2 + l2 - 4 );

			// Главный цикл шагов деления. Каждая итерация дает очередную цифру частного.
			var j:int = l1 - l2;	// i – индекс текущей цифры v1
			var i:int = l1;			// j - текущий сдвиг v2 относительно v1, используемый при вычитании,
									//     по совместительству - индекс очередной цифры частного.
			do {
				t1 = Memory.getI32( p1 + i - 2 )
				t2 = c2;

				qGuess = t1 / t2;
				k = t1 % t2;

				// Пока не будут выполнены условия (2) уменьшать частное.
				while ( k < 0x10000 ) {
					t2 = c4 * qGuess;
					t1 = ( k << 16 ) + Memory.getUI16( p1 + i - 4 );
					if ( ( t2 > t1 ) || ( qGuess == 0x10000 ) ) {
						// условия не выполнены, уменьшить qGuess
						// и досчитать новый остаток
						--qGuess;
						k += c2;
					} else {
						break;
					}
				}

				if ( qGuess ) {

					carry = 0;
					borrow = 0;

					// Теперь qGuess - правильное частное или на единицу больше q
					// Вычесть делитель v2, умноженный на qGuess из делимого v1,
					// начиная с позиции vJ+i
					k = 0;
					do {
						// получить в t1 цифру произведения v2*qGuess
						t1 = Memory.getUI16( p2 + k ) * qGuess + carry;
						carry = t1 >>> 16;
						t1 -= carry << 16;
						// Сразу же вычесть из v1
						t3 = Memory.getUI16( p1 + k + j ) - t1 + borrow;
						if ( t3 < 0 ) {
							Memory.setI16( p1 + k + j, t3 + 0x10000 )
							borrow = -1;
						} else {
							Memory.setI16( p1 + k + j, t3 )
							borrow = 0;
						}
						k += 2;
					} while ( k < l2 );

					if ( carry || borrow ) {
						// возможно, умноженое на qGuess число v2 удлинилось.
						// Если это так, то после умножения остался
						// неиспользованный перенос carry. Вычесть и его тоже.
						t3 = Memory.getUI16( p1 + k + j ) - carry + borrow;
						if ( t3 < 0 ) {
							Memory.setI16( p1 + k + j, t3 + 0x10000 );
							borrow = -1;
						} else {
							Memory.setI16( p1 + k + j, t3 );
							borrow = 0;
						}
					}

					// Прошло ли вычитание нормально ?
					if ( borrow ) { // Нет, последний перенос при вычитании borrow = -1,
						// добавить одно, вычтенное сверх необходимого v2 к v1
						carry = 0;
						k = 0;
						do {
							t1 = Memory.getUI16( p1 + k + j ) + Memory.getUI16( p2 + k ) + carry;
							if ( t1 >= 0x10000 ) {
								Memory.setI16( p1 + k + j, t1 - 0x10000 );
								carry = 1;
							} else {
								Memory.setI16( p1 + k + j, t1 );
								carry = 0;
							}
							k += 2;
						} while ( k < l2 );
						Memory.setI16( p1 + k + j, Memory.getUI16( p1 + k + j ) + carry - 0x10000 );
					}

				}

				j -= 2;
				i -= 2;

			} while ( j >= 0 );

			if ( l1 & 3 ) l1 += 2;

			d = _clean( p1, l1 );
			p1 = d.pos;
			l1 = d.len;

			if ( scale > 1 && l1 > 0 ) {
				return _div_s( p1, l1, scale, p1 + l1 );
			}
			return new BigUint( p1, l1 );

		}

		/**
		 * @private
		 * @return		pow( v1, e ) % v2;
		 */
		private static function _modPowInt_simple(p1:uint, l1:uint, e:uint, v2:uint, pos:uint):uint {
			var i:uint = _getHighestBit( e );
			var r:uint;
			if ( l1 == 4 ) {
				r = uint( Memory.getI32( p1 ) ) % v2;
			} else {
				r;// = _mod_s( p1, l1, v2 );
			}
			var g:uint = r;
			do {
				r = ( r * r ) % v2;
				i >>>= 1;
				if ( i & e ) {
					r = ( r * g ) % v2;
				}
			} while ( i > 1 );
			return r;
		}

		/**
		 * @private
		 * @return		pow( v1, e ) % v2;
		 */
		private static function _modPowInt_classic(p1:uint, l1:uint, e:uint, p2:uint, l2:uint, pos:uint):BigUint {
			var i:uint = _getHighestBit( e );
			var v:BigUint;
			if ( compare( new BigUint( p1, l1 ), new BigUint( p2, l2 ) ) ) {
//				v = _divAndMod( p1, l1, p2, l2, pos )[ 1 ];
				p1 = v.pos;
				l1 = v.len;
			}
			var p0:uint = pos;
			var p3:uint = p1;
			var l3:uint = l1;
			do {
//				v = _sqr( p1, l1, pos );
//				pos += _lx; // TODO: length check and optimize
//				_sqr( p1, l1, _pr, _lr ); // _r *= _r;
//				p1 = _pr;
//				l1 = _lr;
//				_div( p1, l1, p2, l2, _pr, _lr, _lx, 2 ); // _r %= v;
//				p1 = _pr;
//				l1 = _lx;
//				i >>>= 1;
//				if ( i & e != 0 ) {
//					_pr += _lx;
//					_mult( p1, l1, p3, l3, _pr, _lr ); // _r *= g;
//					p1 = _pr;
//					l1 = _lr;
//					_div( p1, l1, p2, l2, _pr, _lr, _lx, 2 ); // _r %= v;
//					p1 = _pr;
//					l1 = _lx;
//				}
			} while ( i > 1 );
//			_lr = _lx;
			return null;
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function BigUint(pos:uint=0, len:uint=0) {
			super();
			this.pos = pos;
			this.len = len;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * cursor position
		 */
		public var pos:uint;

		/**
		 * длинна блока в памяти.
		 * она обязательно должна быть кратна 4.
		 */
		public var len:uint;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function toString():String {
			return '[' + pos + ',' + len + ']';
		}

	}

}