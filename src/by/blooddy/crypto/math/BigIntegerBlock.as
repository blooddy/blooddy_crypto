////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.math {

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import avm2.intrinsics.memory.li16;
	import avm2.intrinsics.memory.li32;
	import avm2.intrinsics.memory.si16;
	import avm2.intrinsics.memory.si32;
	import avm2.intrinsics.memory.sxi8;
	
	import by.blooddy.utils.MemoryBlock;
	
	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					21.01.2011 14:11:39
	 */
	public class BigIntegerBlock {
		
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @return	v1 > v2 ? 1 : ( v2 > v1 ? -1 : 0 )
		 */
		public static function compare(v1:MemoryBlock, v2:MemoryBlock):int {

			var c1:int = v1.len;
			var c2:int = v2.len;

			     if ( c1 > c2 ) return  1;
			else if ( c2 > c1 ) return -1;
			else {
				
				var p1:int = v1.pos;
				var p2:int = v2.pos;
				
				var i:int = c1;
				do {
					
					i -= 4;
					
					c1 = li32( p1 + i );
					c2 = li32( p2 + i );
					
					if ( c1 > c2 ) return 1;
					else if ( c1 < c2 ) return -1;
					
				} while ( i > 0 );
				
			}
			
			return 0;
			
		}
		
		/**
		 * @return		v1 + v2
		 */
		public static function add(v1:MemoryBlock, v2:MemoryBlock, pos:int=-1):MemoryBlock {

			var l1:int = v1.len;
			var l2:int = v2.len;

			     if ( l1 == 0 ) return v2;
			else if ( l2 == 0 ) return v1;
			else {

				var p1:int = v1.pos;
				var p2:int = v2.pos;

				if ( pos < 0 ) pos = Math.max( p1, p2 ) + Math.max( l1, l2 );
				
				var i:int;
				var t:Number;

				if ( l2 > l1 ) { // меняем местами
					t = p1; p1 = p2; p2 = t;
					t = l1; l1 = l2; l2 = t;
				}

				i = 0;
				t = 0;
				
				do { // прибавляем к первому по 4 байтика от второго
					t += uint( li32( p1 + i ) ) + uint( li32( p2 + i ) );
					si32( t, pos + i );
					t = ( t >= 0x100000000 ? 1 : 0 );
					i += 4;
				} while ( i < l2 );
				
				while ( t > 0 && i < l1 ) { // прибавляем к первому остаток
					t += uint( li32( p1 + i ) );
					si32( t, pos + i );
					t = ( t >= 0x100000000 ? 1 : 0 );
					i += 4;
				}
				
				if ( t > 0 ) { // если остался остаток, то первое число закончилось
					
					si32( 1, pos + i );
					i += 4;
					
				} else if ( i < l1 ) { // копируем остаток первого числа

					if ( l1 == i + 4 ) {
						si32( li32( p1 + i ), pos + i );
					} else {
						var mem:ByteArray = _DOMAIN.domainMemory;
						mem.position = p1 + i;
						mem.readBytes( mem, pos + i, l1 - i );
					}
					i = l1;
				
				}
			
				return new MemoryBlock( pos, i );
				
			}

		}
		
		/**
		 * @return		v1 - v2
		 * @throws		ArgumentError	v2 > v1
		 */
		public static function sub(v1:MemoryBlock, v2:MemoryBlock, pos:int=-1):MemoryBlock {

			var l1:uint = v1.len;
			var l2:uint = v2.len;

			     if ( l2 == 0 ) return v1;
			else if ( l2 > l1 ) throw new ArgumentError();
			else {
				
				var p1:int = v1.pos;
				var p2:int = v2.pos;

				if ( pos < 0 ) pos = Math.max( p1, p2 ) + Math.max( l1, l2 );
				
				var i:int = 0;
				var t:Number = 0;
				
				do {
					t += uint( li32( p1 + i ) ) - uint( li32( p2 + i ) );
					if ( t < 0 ) {
						si32( t + 0x100000000, pos + i )
						t = -1;
					} else {
						si32( t, pos + i )
						t = 0;
					}
					i += 4;
				} while ( i < l2 );
				
				if ( t < 0 ) {
					if ( i < l1 ) {
						while ( ( t = li32( p1 + i ) ) == 0 ) {
							si32( -1, pos + i );
							i += 4;
						}
						si32( t - 1, pos + i );
						i += 4;
					} else { // второе число оказалось больше первого
						throw new ArgumentError();
					}
				}
				
				if ( i < l1 ) { // копируем остаток первого числа
					if ( l1 - i == 4 ) {
						si32( li32( p1 + i ), pos + i );
					} else {
						var mem:ByteArray = _DOMAIN.domainMemory;
						mem.position = p1 + i;
						mem.readBytes( mem, pos + i, l1 - i );
					}
					i = l1;
				} else {
					while ( i > 0 && li32( pos + i - 4 ) == 0 ) {
						i -= 4;
					}
				}
				
				return new MemoryBlock( pos, i );
				
			}

		}
		
		/**
		 * @return		v1 * v2
		 */
		public static function mul(v1:MemoryBlock, v2:MemoryBlock, pos:uint):MemoryBlock {
			
			var l1:uint = v1.len;
			var l2:uint = v2.len;

			     if ( l1 == 0 ) return v1;
			else if ( l2 == 0 ) return v2;
			else {
				
				var c1:int, c2:int;
				
				var p1:int = v1.pos;
				var p2:int = v2.pos;
				
				if ( pos < 0 ) pos = Math.max( p1, p2 ) + Math.max( l1, l2 );
				
				var i:int = 0;
				var t:Number = 0;
				
				if ( l1 == 4 && li16( p1 + 2 ) == 0 ) l1 = 2;
				if ( l2 == 4 && li16( p2 + 2 ) == 0 ) l2 = 2;
				
				if ( l1 == 2 || l2 == 2 ) {

					if ( l1 == 2 && l2 == 2 ) { // оба числа короткие

						si32( li16( p1 ) * li16( p2 ), pos );
						return new MemoryBlock( pos, 4 );

					} else {

						if ( l1 == 2 ) {
							c1 = uint( li16( p1 ) );
							p1 = p2;
							l1 = l2;
						} else {
							c1 = uint( li16( p2 ) );
						}

						return mul$s( new MemoryBlock( p1, l1 ), c1, pos );

					}

				} else {
					
					return mul$b( v1, v2, pos );
					
				}

			}
			
		}

		private static function mul$s(v1:MemoryBlock, v2:uint, pos:int):MemoryBlock {
			return new MemoryBlock( 0, 0 );
		}
		
		private static function mul$b(v1:MemoryBlock, v2:MemoryBlock, pos:int):MemoryBlock {
			return new MemoryBlock( 0, 0 );
		}
		
		private static function div$s(v1:MemoryBlock, v2:uint, pos:int):MemoryBlock {
			return new MemoryBlock( 0, 0 );
		}
		
		/**
		 * @return		v % m;
		 * @throws		ArgumentError	m == 0
		 */
		public static function mod(v:MemoryBlock, m:MemoryBlock, pos:int=-1):MemoryBlock {
			
			var l1:int = v.len;
			var l2:int = m.len;
			
			     if ( l2 == 0 ) throw new ArgumentError();
			else if ( l2 > l1 ) return v;
			else {
				
				var p1:int = v.pos;
				var p2:int = m.pos;
				
				if ( pos < 0 ) pos = Math.max( p1, p2 ) + Math.max( l1, l2 );

				var c1:uint;
				var c2:uint;
				
				if ( l1 == 4 ) { // первое число короткое

					c2 = li32( p2 );
					if ( c2 == 1 ) {
						return new MemoryBlock( 0, 0 );
					} else {
						c1 = li32( p1 );
						if ( c1 == c2 ) {
							return v;
						} else {
							c1 %= c2;
							if ( c1 == 0 ) {
								return new MemoryBlock( 0, 0 );
							} else {
								si32( pos, c1 );
								return new MemoryBlock( pos, 4 );
							}
						}
					}

				} else if ( l2 == 4 && li16( p2 + 2 ) == 0 ) { // второе число короткое
				
					c2 = li16( p2 ) & 0xFFFF;
					if ( c2 == 1 ) {
						return new MemoryBlock( 0, 0 );
					} else {
						c1 = mod$s( v, c2 );
						if ( c1 == 0 ) {
							return new MemoryBlock( 0, 0 );
						} else {
							si32( pos, c1 );
							return new MemoryBlock( pos, 4 );
						}
					}
					
				} else {
					
					return mod$b( v, m, pos );
					
				}

			}
			
		}
		
		/**
		 * @internal
		 * @return		v % m;
		 * @throws		ArgumentError	m == 0
		 */
		private static function mod$s(v:MemoryBlock, m:uint):uint {
			var c:int = 0;
			var p:int = v.pos;
			var i:int = v.len;
			do {
				i -= 2;
				c = ( li16( p + i ) | ( c << 16 ) ) % m;
			} while ( i > 0 );
			return c;
		}
		
		/**
		 * @internal
		 * @return		v % m;
		 * @throws		ArgumentError	m == 0
		 */
		private static function mod$b(v:MemoryBlock, m:MemoryBlock, pos:int):MemoryBlock {
			
			var p1:int = v.pos;
			var p2:int = m.pos;
			var l1:int = v.len;
			var l2:int = m.len;
			
			var scale:int = li16( p2 + l2 - 2 ) & 0xFFFF;
			if ( !scale ) scale = li16( p2 + l2 - 4 ) & 0xFFFF;
			scale = 0x10000 / ( scale + 1 ); // коэффициент нормализации
			
			var d:MemoryBlock;
			var k:uint;
			if ( scale > 1 ) {
				// Нормализация
				d = mul$s( v, scale, pos );
				p1 = d.pos;
				l1 = d.len;
				pos = p1 + l1;
				si16( 0, pos );
				pos += 2;
				d = mul$s( m, scale, pos );
				p2 = d.pos;
				l2 = d.len;
				pos = p2 + l2;
			} else {
				var mem:ByteArray = _DOMAIN.domainMemory;
				mem.position = p1;
				mem.readBytes( mem, pos, l1 );
				p1 = pos;
				pos += l1;
				si16( 0, pos );
				pos += 2;
			}
			
			while ( li16( p1 + l1 - 2 ) == 0 ) l1 -= 2;
			while ( li16( p2 + l2 - 2 ) == 0 ) l2 -= 2;
			
			var t1:uint, t2:uint, t3:int;
			var qGuess:int;				// догадка для частного и соответствующий остаток
			var borrow:int, carry:int;	// переносы
			
			var c2:uint = li16( p2 + l2 - 2 ) & 0xFFFF;
			var c4:uint = li16( p2 + l2 - 4 ) & 0xFFFF;
			
			// Главный цикл шагов деления. Каждая итерация дает очередную цифру частного.
			var j:int = l1 - l2;	// i – индекс текущей цифры v1
			var i:int = l1;			// j - текущий сдвиг v2 относительно v1, используемый при вычитании,
			//     по совместительству - индекс очередной цифры частного.
			do {
				t1 = li32( p1 + i - 2 )
				t2 = c2;
				
				qGuess = t1 / t2;
				k = t1 % t2;
				
				// Пока не будут выполнены условия (2) уменьшать частное.
				while ( k < 0x10000 ) {
					t2 = c4 * qGuess;
					t1 = ( k << 16 ) + ( li16( p1 + i - 4 ) & 0xFFFF );
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
						t1 = ( li16( p2 + k ) & 0xFFFF ) * qGuess + carry;
						carry = t1 >>> 16;
						t1 -= carry << 16;
						// Сразу же вычесть из v1
						t3 = ( li16( p1 + k + j ) & 0xFFFF ) - t1 + borrow;
						if ( t3 < 0 ) {
							si16( t3 + 0x10000, p1 + k + j );
							borrow = -1;
						} else {
							si16( t3, p1 + k + j );
							borrow = 0;
						}
						k += 2;
					} while ( k < l2 );
					
					if ( carry || borrow ) {
						// возможно, умноженое на qGuess число v2 удлинилось.
						// Если это так, то после умножения остался
						// неиспользованный перенос carry. Вычесть и его тоже.
						t3 = ( li16( p1 + k + j ) & 0xFFFF ) - carry + borrow;
						if ( t3 < 0 ) {
							si16( t3 + 0x10000, p1 + k + j );
							borrow = -1;
						} else {
							si16( t3, p1 + k + j );
							borrow = 0;
						}
					}
					
					// Прошло ли вычитание нормально ?
					if ( borrow ) { // Нет, последний перенос при вычитании borrow = -1,
						// добавить одно, вычтенное сверх необходимого v2 к v1
						carry = 0;
						k = 0;
						do {
							t1 = ( li16( p1 + k + j ) & 0xFFFF ) + ( li16( p2 + k ) & 0xFFFF ) + carry;
							if ( t1 >= 0x10000 ) {
								si16( t1 - 0x10000, p1 + k + j );
								carry = 1;
							} else {
								si16( t1, p1 + k + j );
								carry = 0;
							}
							k += 2;
						} while ( k < l2 );
						si16( ( li16( p1 + k + j ) & 0xFFFF ) + carry - 0x10000, p1 + k + j );
					}
					
				}
				
				j -= 2;
				i -= 2;
				
			} while ( j >= 0 );
			
			if ( l1 & 3 ) l1 += 2;
			
			while ( l1 > 0 && li32( p1 + l1 - 4 ) == 0 ) {
				l1 -= 4;
			}

			if ( scale > 1 && l1 > 0 ) {
				return div$s( new MemoryBlock( p1, l1), scale, p1 + l1 );
			} else {
				return new MemoryBlock( p1, l1 );
			}
			
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * Constructor
		 */
		public function BigIntegerBlock() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}
	
}