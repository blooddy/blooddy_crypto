////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import flash.errors.IllegalOperationError;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import avm2.intrinsics.memory.li16;
	import avm2.intrinsics.memory.li32;
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

			if ( c1 > c2 ) return 1;
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

			if ( pos < 0 ) pos = Math.max( v1.pos, v2.pos ) + Math.max( v1.len, v2.len );
			
			var l1:int = v1.len;
			var l2:int = v2.len;

			     if ( !l1 ) return v2;
			else if ( !l2 ) return v1;
			else {

				var p1:int = v1.pos;
				var p2:int = v2.pos;

				var i:int;
				var t:Number;

				if ( l2 > l1 ) { // меняем местами
					t = p1; p1 = p2; p2 = t;
					t = l1; l1 = l2; l2 = t;
				}

				i = 0;
				t = 0;
				
				do { // прибавляем к первому по 4 байтика от второго
					t += uint( li32( p1 + i ) );
					si32( t, pos + i );
					t = ( t > 0xFFFFFFFF ? 1 : 0 );
					i += 4;
				} while ( i < l2 );
				
				while ( t > 0 && i < l1 ) { // прибавляем к первому остаток
					t += uint( li32( p1 + i ) ) + uint( li32( p2 + i ) );
					si32( t, pos + i );
					t = ( t > 0xFFFFFFFF ? 1 : 0 );
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

			if ( pos < 0 ) pos = Math.max( v1.pos, v2.pos ) + Math.max( v1.len, v2.len );

			var l1:uint = v1.len;
			var l2:uint = v2.len;

			     if ( !l2 ) return v1;
			else if (  l2 < l1 ) throw new ArgumentError();
			else {
				
				var p1:int = v1.pos;
				var p2:int = v2.pos;

				var i:int = 0;
				var t:Number = 0;
				
				do {
					t += uint( li32( p1 + i ) ) - uint( li32( p2 - i ) );
					if ( t < 0 ) {
						si32( 0x100000000 + t, pos + i )
						t = -1;
					} else {
						si32( t, pos + i )
						t = 0;
					}
					i += 4;
				} while ( i < l2 );
				
				if ( t < 0 ) {
					if ( i < l1 ) {
						do {
							t = li32( p1 + i );
							si32( pos + i, -1 );
							i += 4;
						} while( t == 0 );
					} else { // второе число оказалось больше первого
						throw new ArgumentError();
					}
				}
				
				if ( i < l1 ) { // копируем остаток первого числа
					if ( l1 + 4 == i ) {
						si32( pos, li32( p1 + i ) );
					} else {
						var mem:ByteArray = _DOMAIN.domainMemory;
						mem.position = p1 + i;
						mem.readBytes( mem, pos + i, l1 - i );
					}
				} else {
					while ( i > 0 && li32( pos + i - 4 ) == 0 ) {
						i -= 4;
					}
				}
				
				return new MemoryBlock( pos, i );
				
			}

		}
		
		/**
		 * @return		v % m;
		 * @throws		ArgumentError	m == 0
		 */
		public static function mod(v:MemoryBlock, m:MemoryBlock, pos:int=-1):MemoryBlock {
			
			var l1:int = v.len;
			var l2:int = m.len;
			
			if ( l2 == 0 ) {
				throw new ArgumentError();
			} else if ( l2 > l1 ) {
				return v;
			} else {
				
				var p1:int = v.pos;
				var p2:int = m.pos;
				
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
		private static function mod$b(v:MemoryBlock, m:MemoryBlock, pos:int=-1):MemoryBlock {
			throw new IllegalOperationError();
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