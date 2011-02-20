////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import apparat.inline.Macro;
	
	import by.blooddy.system.Memory;
	
	import flash.utils.ByteArray;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					31.01.2011 10:59:37
	 */
	internal final class BigUint$ extends Macro { // internal?

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		[Inline( "direct_copy" )]
		public static function fillZero(mem:ByteArray, pos:uint, end:uint, i:uint):void {
			Memory.setI32( pos, 0 );
			mem.position = pos + 4;
			if ( mem.position < end ) {
				Memory.setI32( mem.position, 0 );
				mem.position += 4;
				i = 8;
				while ( mem.position < end ) {
					mem.writeBytes( mem, pos, i );
					i <<= 1;
				}
			}
		}
		
		[Inline( "direct_copy" )]
		public static function clean(pos:uint, len:uint):void {
			while ( len > 0 && Memory.getI32( pos + len - 4 ) == 0 ) {
				len -= 4;
			}
		}

		[Inline( "direct_copy" )]
		public static function getShift(pos:uint, len:uint, e:int, c:uint):void {
			c = pos + len - 4;
			e = Memory.getI32( c );
			if ( ( e & ( e - 1 ) ) == 0 ) {
				while ( c > pos ) {
					c -= 4;
					if ( Memory.getI32( c ) != 0 ) {
						e = -1;
						break;
					}
				}
				if ( e != -1 ) {
					e = int( Math.log( e ) * Math.LOG2E + 0.5 ) + ( ( len - 4 ) << 3 );
				}
			} else {
				e = -1;
			}
		}

		[Inline( "direct_copy" )]
		/**
		 * result = 1 << n
		 */
		public static function shiftLeftOne(
			mem:ByteArray,
			n:uint, pos:uint, len:uint,
			s:uint
		):void {
			var len:uint = 0;
			var s:uint = n >>> 3;
			s -= s & 3;
			if ( s > 0 ) {
				s += pos;
				BigUint$.fillZero( mem, pos, s, len );
			}
			Memory.setI32( s, 1 << ( n & 31 ) );
			len = s - pos + 4;
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 * v2
		 */
		public static function mult_s(
			p1:uint, l1:uint, v2:uint, pos:uint, len:uint,
			temp:uint
		):void {
			len = 0;
			temp = 0;
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
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 * v2
		 */
		public static function mult(
			mem:ByteArray,
			p1:uint, l1:uint, p2:uint, l2:uint, pos:uint, len:uint,
			c1:uint, c2:uint, i:uint, j:uint, temp:uint
		):void {
			temp = 0;
			c1 = Memory.getUI16( p1 );
			c2 = Memory.getUI16( p2 );
			i = 2;
			j = 2;
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
				temp = pos + l2 + i;
				BigUint$.fillZero( mem, pos, temp, j ); 
			}
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
			BigUint$.clean( pos, len );
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v * v
		 */
		public static function sqr(
			mem:ByteArray,
			p:uint, l:uint, pos:uint, len:uint,
			c1:uint, c2:uint, i:uint, j:uint, temp:uint
		):void {
			c1 = Memory.getUI16( p );
			i = 2;
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
				temp = pos + l + i;
				BigUint$.fillZero( mem, pos, temp, j ); 
			}
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
			BigUint$.clean( pos, len );
		}

		[Inline( "direct_copy" )]
		/**
		 * result = [ v1 / v2, v1 % v2 ]
		 */
		public static function divAndMod_s(
			p1:uint, l1:uint, v2:uint, pos:uint, len:uint, posx:uint, lenx:uint,
			c:uint, i:uint
		):void {
			c = 0;
			i = l1;
			do {
				i -= 2;
				c = Memory.getUI16( p1 + i ) | ( c << 16 );
				Memory.setI16( pos + i, c / v2 );
				c %= v2;
			} while ( i > 0 );
			len = l1;
			BigUint$.clean( pos, len );
			if ( c > 0 ) {
				posx = pos + len;
				lenx = 4;
				Memory.setI32( posx, c );
			} else {
				lenx = 0;
			}
		}

		[Inline( "direct_copy" )]
		/**
		 * @return		[ v1 / v2, v1 % v2 ]
		 */
		public static function divAndMod(
			mem:ByteArray,
			p1:uint, l1:uint, p2:uint, l2:uint, pos:uint, len:uint, posx:uint, lenx:uint,
			scale:uint, k:uint, t1:uint, t2:uint, t3:int, qGuess:int, borrow:int, carry:int, c2:uint, c4:uint, j:int, i:int
		):void {
			
			scale = Memory.getUI16( p2 + l2 - 2 );
			if ( !scale ) scale = Memory.getUI16( p2 + l2 - 4 );
			scale = 0x10000 / ( scale + 1 ); // коэффициент нормализации
			
			if ( scale > 1 ) {
				// Нормализация
				BigUint$.mult_s( p1, l1, scale, pos, len, t1 );
				p1 = pos;
				l1 = len;
				pos = p1 + l1;
				Memory.setI16( pos, 0 ); // буфер
				pos += 2;
				BigUint$.mult_s( p2, l2, scale, pos, len, t1 );
				p2 = pos;
				l2 = len;
				pos = p2 + l2;
			} else {
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
			
			c2 = Memory.getUI16( p2 + l2 - 2 );
			c4 = Memory.getUI16( p2 + l2 - 4 );
			
			// Главный цикл шагов деления. Каждая итерация дает очередную цифру частного.
			// qGuess - догадка для частного и соответствующий остаток
			// borrow, carry - переносы
			// i – индекс текущей цифры v1
			// j - текущий сдвиг v2 относительно v1, используемый при вычитании,
			//     по совместительству - индекс очередной цифры частного.
			j = len;
			i = l1;
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
			
			BigUint$.clean( p1, l1 );
			BigUint$.clean( pos, len );
			
			if ( scale > 1 && l1 > 0 ) {
				posx = pos + len;
				BigUint$.div_s( p1, l1, scale, posx, lenx, c2, k );
			} else {
				posx = p1;
				lenx = l1;
			}
			
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 / v2
		 */
		public static function div_s(
			p1:uint, l1:uint, v2:uint, pos:uint, len:uint,
			c:uint, i:uint
		):void {
			c = 0;
			i = l1;
			do {
				i -= 2;
				c = Memory.getUI16( p1 + i ) | ( c << 16 );
				Memory.setI16( pos + i, c / v2 );
				c %= v2;
			} while ( i > 0 );
			len = l1;
			BigUint$.clean( pos, len );
		}

		[Inline( "direct_copy" )]
		/**
		 * result = v1 / v2
		 */
		public static function mod_s(
			p1:uint, l1:uint, v2:uint,
			c:uint, i:uint
		):void {
			c = 0;
			i = l1;
			do {
				i -= 2;
				c = ( Memory.getUI16( p1 + i ) | ( c << 16 ) ) % v2;
			} while ( i > 0 );
		}

	}

}