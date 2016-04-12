////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.math {

	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import avm2.intrinsics.memory.li16;
	import avm2.intrinsics.memory.li32;
	import avm2.intrinsics.memory.li8;
	import avm2.intrinsics.memory.si16;
	import avm2.intrinsics.memory.si32;
	
	import by.blooddy.math.utils.BigUint;
	import by.blooddy.utils.MemoryBlock;
	
	[Exclude( kind="method", name="$getIntBitLength" )]
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
		
		//--------------------------------------------------------------------------
		//  Bits
		//--------------------------------------------------------------------------

		public static function getBitLength(v:MemoryBlock):uint {
			var l:int = v.len;
			if ( l == 0 ) {
				return 0;
			} else {
				l -= 4;
				return ( l << 3 ) + $getIntBitLength( li32( v.pos + l ) );
			}
		}
		
		/**
		 * @internal
		 */
		internal static function $getIntBitLength(v:int):int {
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
		 * @return		v & ( 1 << n ) != 0
		 */
		public static function testBit(v:MemoryBlock, n:uint):Boolean {
			var l:int = v.len;
			if ( l != 0 ) {
				var s:int = n >>> 3;
				if ( s < l ) {
					return li8( v.pos + s ) & ( 1 << ( n & 7 ) );
				}
			}
			return false;
		}
		
		/**
		 * @return		v ^ ( 1 << n )
		 */
		public static function flipBit(v:MemoryBlock, n:uint, pos:int=-1):MemoryBlock {

			var p:int = v.pos;
			var l:int = v.len;

			var s:int = n >>> 3; s -= s & 3;
			var k:int = ( l <= s ? 0 : li32( p + s ) ) ^ ( 1 << ( n & 31 ) );

			if ( k == 0 && s == l - 4 ) {

				return new MemoryBlock( p, s );

			} else {
				
				if ( pos < 0 ) pos = p + l;
				
				var mem:ByteArray = _DOMAIN.domainMemory;
				mem.position = p;
				mem.readBytes( mem, pos, l );
				
				if ( l < s ) { // результат длинее оригинала: надо заполнить нулями
					zeroFill( pos + l, l - s );
					l = s;
				}
				
				si32( k, pos + s );
				
				return new MemoryBlock( pos, l );
				
			}
			
		}

		//--------------------------------------------------------------------------
		//  Math
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
		public static function mul(v1:MemoryBlock, v2:MemoryBlock, pos:int=-1):MemoryBlock {
			
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
				
				if ( l1 == 4 && li16( p1 + 2 ) == 0 ) l1 = 2;
				if ( l2 == 4 && li16( p2 + 2 ) == 0 ) l2 = 2;
				
				if ( l1 == 2 || l2 == 2 ) {

					if ( l1 == 2 && l2 == 2 ) { // оба числа короткие

						si32( li16( p1 ) * li16( p2 ), pos );
						return new MemoryBlock( pos, 4 );

					} else {

						if ( l1 == 2 ) {
							c1 = li16( p1 ) & 0xFFFF;
							p1 = p2;
							l1 = l2;
						} else {
							c1 = li16( p2 ) & 0xFFFF;
						}

						return mul$s( p1, l1, c1, pos );

					}

				} else {
					
					return mul$b( v1.pos, v1.len, v2.pos, v2.len, pos );
					
				}

			}
			
		}

		/**
		 * @internal
		 * @return		v1 * v2;
		 */
		private static function mul$s(p1:int, l1:int, v2:int, pos:int):MemoryBlock {
			
			if ( v2 == 1 ) {
					
				return new MemoryBlock( p1, l1 );
					
			} else {

				var i:int = 0;
				var t:uint = 0;
				
				do {
					t += li16( p1 + i ) * v2;
					si16( t, pos + i );
					t >>>= 16;
					i += 2;
				} while ( i < l1 );
				
				if ( t > 0 ) {
					si32( t, pos + i );
					i += 4;
				}
				
				return new MemoryBlock( pos, i );
				
			}

		}
		
		/**
		 * @internal
		 * @return		v1 * v2;
		 */
		private static function mul$b(p1:int, l1:int, p2:int, l2:int, pos:int):MemoryBlock {
			
			var t:uint = 0;

			var c1:int = li16( p1 ) & 0xFFFF;
			var c2:int = li16( p2 ) & 0xFFFF;

			var i:int = 2;
			var j:int = 2;
	
			if ( c1 && c2 ) {

				t = c1 * c2;
				si16( t, pos );
				j = 2;

				while ( j < l2 ) {
					t = ( t >>> 16 ) + c1 * ( li16( p2 + j ) & 0xFFFF );
					si16( t, pos + j );
					j += 2;
				}
				si16( t >>> 16, pos + l2 );

			} else {

				if ( c1 ) i = 0;
				else {
					while ( i < l1 && li16( p1 + i ) == 0 ) {
						i += 2;
					}
				}

				if ( c2 ) j = 0;
				else {
					while ( j < l2 && li16( p2 + j ) == 0 ) {
						j += 2;
					}
				}

				if ( j > i ) {
					t = p1; p1 = p2; p2 = t;
					t = l1; l1 = l2; l2 = t;
					t = c1; c1 = c2; c2 = t;
					i = j;
				}

				zeroFill( pos, pos + l2 + i );

			}

			var len:int;
			while ( i < l1 ) {
				c1 = li16( p1 + i ) & 0xFFFF;
				if ( c1 ) {
					len = pos + i;
					t = c2 * c1 + ( li16( len ) & 0xFFFF );
					si16( t, len );
					j = 2;
					while ( j < l2 ) {
						len = pos + i + j;
						t = ( t >>> 16 ) + c1 * ( li16( p2 + j ) & 0xFFFF ) + ( li16( len ) & 0xFFFF );
						si16( t, len );
						j += 2;
					}
					si16( t >>> 16, pos + i + j );
				} else {
					si16( 0, pos + i + l2 );
				}
				i += 2;
			}

			len = i + j;
			while ( len > 0 && li32( pos + len - 4 ) == 0 ) {
				len -= 4;
			}
			
			return new MemoryBlock( pos, len );
		}

		/**
		 * @return		v * v
		 */
		private static function sqr$(p:int, l:int, pos:int):MemoryBlock {

			var c1:int = li16( p ) & 0xFFFF;
			var t:uint;
			var j:int;
			var i:int = 2;
			if ( c1 ) {
				t = c1 * c1;
				si16( t, pos );
				j = 2;
				while ( j < l ) {
					t = ( t >>> 16 ) + c1 * ( li16( p + j ) & 0xFFFF );
					si16( t, pos + j );
					j += 2;
				}
				si16( t >>> 16, pos + j );
			} else {
				while ( i < l && li16( p + i ) == 0 ) {
					i += 2;
				}
				zeroFill( pos, pos + l + i );
			}
			var len:int;
			var c2:int;
			while ( i < l ) {
				c2 = li16( p + i ) & 0xFFFF;
				if ( c2 ) {
					len = pos + i;
					t = c2 * c1 + ( li16( len ) & 0xFFFF );
					si16( t, len );
					j = 2;
					while ( j < l ) {
						len = pos + i + j;
						t = ( t >>> 16 ) + c2 * ( li16( p + j ) & 0xFFFF ) + ( li16( len ) & 0xFFFF );
						si16( t, len );
						j += 2;
					}
					si16( t >>> 16, pos + i + j );
				} else {
					si16( 0, pos + i + l );
				}
				i += 2;
			}

			len = i << 1;
			while ( len > 0 && li32( pos + len - 4 ) == 0 ) {
				len -= 4;
			}
			
			return new MemoryBlock( pos, len );
			
		}
		
		/**
		 * @return		v / m
		 * @throws		ArgumentError	m == 0
		 */
		public static function div(v:MemoryBlock, m:MemoryBlock, pos:int=-1):MemoryBlock {

			var l1:int = v.len;
			var l2:int = m.len;

			if ( l2 == 0 ) {
				throw new ArgumentError();
			} else if ( l2 > l1 ) {
				return new MemoryBlock();
			} else {

				var p1:int = v.pos;
				var p2:int = m.pos;
				
				if ( pos < 0 ) pos = Math.max( p1, p2 ) + Math.max( l1, l2 );
				
				var c1:uint;
				var c2:uint;

				if ( l1 == 4 ) { // оба числа короткие

					c2 = li32( p2 );
					if ( c2 == 1 ) {
						return v;
					} else {
						c1 = li16( p1 ) & 0xFFFF;
						if ( c1 == c2 ) {
							si32( 1, pos );
							return new MemoryBlock( pos, 4 );
						} else if ( c2 > c1 ) {
							return new MemoryBlock();
						} else {
							c1 /= c2;
							if ( c1 == 0 ) {
								return new MemoryBlock();
							} else {
								si32( c1, pos );
								return new MemoryBlock( pos, 4 );
							}
						}
					}

				} else {

					if ( l2 == 4 && li16( p2 + 2 ) == 0 ) { // второе число короткое
						c2 = li16( p2 ) & 0xFFFF;
						if ( c2 == 1 ) {
							return v;
						} else {
							return div$s( p1, l1, c2, pos );
						}
					} else {
						return divAndMod$b( p1, l1, p2, l2, pos, 1 )[ 0 ];
					}

				}

			}
		}
		
		/**
		 * @internal
		 * @return		v1 / v2
		 */
		private static function div$s(p1:int, l1:int, v2:int, pos:int):MemoryBlock {
			
			var c:int = 0;
			var i:int = l1;

			do {
				i -= 2;
				c |= li16( p1 + i ) & 0xFFFF;
				si16( c / v2, pos + i );
				c = ( c % v2 ) << 16;
			} while ( i > 0 );
	
			while ( l1 > 0 && li32( pos + l1 - 4 ) == 0 ) {
				l1 -= 4;
			}

			return new MemoryBlock( pos, l1 );

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
				
				if ( l1 == 4 ) { // оба числа короткие

					c2 = li32( p2 );
					if ( c2 == 1 ) {
						return new MemoryBlock();
					} else {
						c1 = li32( p1 );
						if ( c1 == c2 ) {
							return new MemoryBlock();
						} else if ( c2 > c1 ) {
							return v;
						} else {
							c1 %= c2;
							if ( c1 == 0 ) {
								return new MemoryBlock();
							} else {
								si32( c1, pos );
								return new MemoryBlock( pos, 4 );
							}
						}
					}

				} else if ( l2 == 4 && li16( p2 + 2 ) == 0 ) { // второе число короткое
				
					c2 = li16( p2 ) & 0xFFFF;
					if ( c2 == 1 ) {
						return new MemoryBlock();
					} else {
						c1 = mod$s( v.pos, v.len, c2 );
						if ( c1 == 0 ) {
							return new MemoryBlock();
						} else {
							si32( c1, pos );
							return new MemoryBlock( pos, 4 );
						}
					}
					
				} else {
					
					return divAndMod$b( v.pos, v.len, m.pos, m.len, pos, 2 )[ 1 ];
					
				}

			}
			
		}
		
		/**
		 * @internal
		 * @return		v % m;
		 */
		private static function mod$s(p1:int, l1:int, m:int):int {
			var c:int = 0;
			var i:int = l1;
			do {
				i -= 2;
				c = ( ( li16( p1 + i ) & 0xFFFF ) | ( c << 16 ) ) % m;
			} while ( i > 0 );
			return c;
		}
		
		/**
		 * @return		[ v / m, v % m ]
		 * @throws		ArgumentError	m == 0
		 */
		public static function divAndMod(v:MemoryBlock, m:MemoryBlock, pos:int=-1):Vector.<MemoryBlock> {

			var l1:int = v.len;
			var l2:int = m.len;

			if ( l2 == 0 ) {
				throw new ArgumentError();
			} else if ( l1 == 0 ) {
				return new <MemoryBlock>[ v, v ];
			} else if ( l2 > l1 ) {
				return new <MemoryBlock>[ new MemoryBlock(), v ];
			} else {

				var p1:int = v.pos;
				var p2:int = m.pos;

				if ( pos < 0 ) pos = Math.max( p1, p2 ) + Math.max( l1, l2 );

				var c1:uint;
				var c2:uint;

				if ( l1 == 4 ) { // оба числа короткие
					c2 = li32( p2 );
					if ( c2 == 1 ) {
						return new <MemoryBlock>[ v, new MemoryBlock() ];
					} else {
						c1 = li32( p1 );
						if ( c1 == c2 ) {
							si32( 1, pos );
							return new <MemoryBlock>[ new MemoryBlock( pos, 4 ), new MemoryBlock() ];
						} else if ( c2 > c1 ) {
							return new <MemoryBlock>[ new MemoryBlock(), v ];
						} else {
							si32( c1 / c2, pos );
							var d:MemoryBlock = new MemoryBlock( pos, 4 );
							pos += 4;
							c1 %= c2;
							if ( c1 == 0 ) {
								return new <MemoryBlock>[ d, new MemoryBlock() ];
							} else {
								si32( c1, pos );
								return new <MemoryBlock>[ d, new MemoryBlock( pos, 4 ) ];
							}
						}
					}
				} else if ( l2 == 4 && li16( p2 + 2 ) == 0 ) { // второе число короткое
					c2 = li16( p2 );
					if ( c2 == 1 ) {
						return new <MemoryBlock>[ v, new MemoryBlock() ];
					} else {
						return divAndMod$s( p1, l1, c2, pos );
					}
				} else {
					return divAndMod$b( p1, l1, p2, l2, pos, 3 );
				}
			}
		}
		
		/**
		 * @internal
		 * @reutrn		[ v1 / v2, v1 % v2 ]
		 */
		private static function divAndMod$s(p1:int, l1:int, v2:uint, pos:int):Vector.<MemoryBlock> {

			var c:int = 0;
			var i:int = l1;
			do {
				i -= 2;
				c = li16( p1 + i ) | ( c << 16 );
				si16( c / v2, pos + i );
				c %= v2;
			} while ( i > 0 );

			while ( l1 > 0 && li32( p1 + l1 - 4 ) == 0 ) {
				l1 -= 4;
			}

			var d:MemoryBlock = new MemoryBlock( pos, l1 );

			var r:MemoryBlock;
			if ( c > 0 ) {
				pos += l1;
				si32( c, pos );
				r = new MemoryBlock( pos, 4 );
			} else {
				r = new MemoryBlock();
			}

			return new <MemoryBlock>[ d, r ];
			
		}
		
		/**
		 * @internal
		 * @reutrn		[ v1 / v2, v1 % v2 ]
		 */
		private static function divAndMod$b(p1:int, l1:int, p2:int, l2:int, pos:int, flag:int):Vector.<MemoryBlock> {

			var scale:int = li16( p2 + l2 - 2 ) & 0xFFFF;
			if ( !scale ) scale = li16( p2 + l2 - 4 ) & 0xFFFF;
			scale = 0x10000 / ( scale + 1 ); // коэффициент нормализации
			
			var d:MemoryBlock;
			var r:MemoryBlock;

			var k:int;
			if ( scale > 1 ) {
				// Нормализация
				d = mul$s( p1, l1, scale, pos );
				p1 = d.pos;
				l1 = d.len;
				pos = p1 + l1;
				si16( 0, pos );
				pos += 2;
				d = mul$s( p2, l2, scale, pos );
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
			
			var len:int = l1 - l2;
			
			// резервируем запасной разряд
			si32( 0, pos + len );
			
			var t1:uint, t2:int, t3:int;
			var qGuess:int;				// догадка для частного и соответствующий остаток
			var borrow:int, carry:int;	// переносы
			
			var c2:int = li16( p2 + l2 - 2 ) & 0xFFFF;
			var c4:int = li16( p2 + l2 - 4 ) & 0xFFFF;
			
			// Главный цикл шагов деления. Каждая итерация дает очередную цифру частного.
			var j:int = len;	// i – индекс текущей цифры v1
			var i:int = l1;		// j - текущий сдвиг v2 относительно v1, используемый при вычитании,
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
						// значит, qGuess на единицу больше истинного частного
						si16( qGuess - 1, pos + j );
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
					} else { // Да, частное угадано правильно
						si16( qGuess, pos + j );
					}
					
				} else { // частное равно 0
					si16( 0, pos + j );
				}
				
				j -= 2;
				i -= 2;
				
			} while ( j >= 0 );
			
			if ( flag & 1 ) {
				len += 2;
				if ( len & 3 ) len += 2;
				while ( len > 0 && li32( pos + len - 4 ) == 0 ) {
					len -= 4;
				}
				d = new MemoryBlock( pos, len );
				pos += len;
			}

			if ( flag & 2 ) {
				if ( l1 & 3 ) l1 += 2;
				while ( l1 > 0 && li32( p1 + l1 - 4 ) == 0 ) {
					l1 -= 4;
				}
				if ( scale > 1 && l1 > 0 ) {
					r = div$s( p1, l1, scale, pos );
				} else {
					r = new MemoryBlock( p1, l1 );
				}
			}
			
			return new <MemoryBlock>[ d, r ];

		}
		
		/**
		 * @return		pow( v, e )
		 */
		public static function pow(v:MemoryBlock, e:uint, pos:int=-1):MemoryBlock {
			
			var p:int = v.pos;
			var l:int = v.len;
			
			if ( pos < 0 ) pos = p + l;
			
			if ( e == 0 ) {
				si32( 1, pos );
				return new MemoryBlock( pos, 4 );
			} else if ( l == 0 || e == 1 ) {
				return v;
			} else {
				
				var c:uint = li32( p );
				var r:uint = 1;

				var d:MemoryBlock;

				if ( l == 4 && c < 0x10000 ) { // исходное число достаточно коротко
					do {
						if ( e & 1 ) {
							r *= c;
						}
						e >>>= 1;
						c *= c;
					} while ( e > 0 && c < 0x10000 );
					if ( e > 0 ) { // если результат не достигнут, то запишим временные значения
						si32( c, pos );
						l = 4;
						p = pos;
						v = new MemoryBlock( pos, l );
						pos += l;
						if ( r >= 0x10000 ) { // запишим результат только если он привысит допустимый лимит
							si32( r, pos );
							d = new MemoryBlock( pos, 4 );
							pos += 4;
						}
					}
				}
				// если временный результат короткий, используем сокращённый алгоритм пока он не удлиннится
				while ( !d && e > 0 ) {
					if ( e & 1 ) {
						if ( r == 1 ) {
							d = v;
						} else {
							d = mul$s( p, l, r, pos );
							pos += d.len;
						}
					}
					e >>>= 1;
					if ( e > 0 ) {
						v = sqr$( p, l, pos );
						p = v.pos;
						l = v.len;
						pos = p + ( l << 1 );
					}
				}
				if ( !d ) {
					si32( r, pos );
					d = new MemoryBlock( pos, 4 );
					pos += 4;
				}
				// и результат и промежуточное значение очень длинные
				while ( e > 0 ) {
					if ( e & 1 ) {
						d = mul$b( p, l, d.pos, d.len, pos );
						pos = d.pos + d.len;
					}
					e >>>= 1;
					if ( e > 0 ) {
						v = sqr$( p, l, pos );
						p = v.pos;
						l = v.len;
						pos = p + ( l << 1 );
					}
				}
				return d;
			}
			
		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static function zeroFill(pos:int, end:int):void {
			si32( 0, pos );
			if ( pos + 4 < end ) {
				var mem:ByteArray = _DOMAIN.domainMemory;
				mem.position = pos + 4;
				si32( 0, mem.position );
				mem.position += 4;
				var i:uint = 8;
				while ( mem.position < end ) {
					mem.writeBytes( mem, pos, i );
					i <<= 1;
				}
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