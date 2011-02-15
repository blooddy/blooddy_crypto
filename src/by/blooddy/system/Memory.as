////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.system {
	
	import apparat.inline.Inlined;
	import apparat.memory.Memory;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					11.02.2011 22:55:39
	 */
	public final class Memory extends Inlined {
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		[Inline]
		public static function getUI8(address:uint):int {
			CRYPTO::apparat {
				return apparat.memory.Memory.readUnsignedByte( address );
			}
			CRYPTO::yogda {
				return Memory$.getUI8( address );
			}
		}
		
		[Inline]
		public static function getUI16(address:uint):int {
			CRYPTO::apparat {
				return apparat.memory.Memory.readUnsignedShort( address );
			}
			CRYPTO::yogda {
				return Memory$.getUI16( address );
			}
		}
		
		[Inline]
		public static function getI32(address:uint):int {
			CRYPTO::apparat {
				return apparat.memory.Memory.readInt( address );
			}
			CRYPTO::yogda {
				return Memory$.getI32( address );
			}
		}
		
		[Inline]
		public static function getF32(address:uint):Number {
			CRYPTO::apparat {
				return apparat.memory.Memory.readFloat( address );
			}
			CRYPTO::yogda {
				return Memory$.getF32( address );
			}
		}
		
		[Inline]
		public static function getF64(address:uint):Number {
			CRYPTO::apparat {
				return apparat.memory.Memory.readDouble( address );
			}
			CRYPTO::yogda {
				return Memory$.getF64( address );
			}
		}
		
		[Inline]
		public static function setI8(address:uint, value:int):void {
			CRYPTO::apparat {
				apparat.memory.Memory.writeByte( value, address );
			}
			CRYPTO::yogda {
				Memory$.setI8( value, address );
			}
		}
		
		[Inline]
		public static function setI16(address:uint, value:int):void {
			CRYPTO::apparat {
				apparat.memory.Memory.writeShort( value, address );
			}
			CRYPTO::yogda {
				Memory$.setI16( value, address );
			}
		}
		
		[Inline]
		public static function setI32(address:uint, value:int):void {
			CRYPTO::apparat {
				apparat.memory.Memory.writeInt( value, address );
			}
			CRYPTO::yogda {
				Memory$.setI32( value, address );
			}
		}
		
		[Inline]
		public static function setF32(address:uint, value:Number):void {
			CRYPTO::apparat {
				apparat.memory.Memory.writeFloat( value, address );
			}
			CRYPTO::yogda {
				Memory$.setF32( value, address );
			}
		}
		
		[Inline]
		public static function setF64(address:uint, value:Number):void {
			CRYPTO::apparat {
				apparat.memory.Memory.writeDouble( value, address );
			}
			CRYPTO::yogda {
				Memory$.setF64( value, address );
			}
		}
		
		[Inline]
		public static function sign1(value:int):int {
			CRYPTO::apparat {
				return apparat.memory.Memory.signExtend1( value );
			}
			CRYPTO::yogda {
				return Memory$.sign1( value );
			}
		}
		
		[Inline]
		public static function sign8(value:int):int {
			CRYPTO::apparat {
				return apparat.memory.Memory.signExtend8( value );
			}
			CRYPTO::yogda {
				return Memory$.sign8( value );
			}
		}
		
		[Inline]
		public static function sign16(value:int):int {
			CRYPTO::apparat {
				return apparat.memory.Memory.signExtend16( value );
			}
			CRYPTO::yogda {
				return Memory$.sign16( value );
			}
		}
		
	}

}

//==============================================================================
//
//  Inner definitions
//
//==============================================================================

import flash.system.ApplicationDomain;
import flash.utils.Endian;
import flash.utils.ByteArray;
	
////////////////////////////////////////////////////////////////////////////////
//
//  Helper class: Memory$
//
////////////////////////////////////////////////////////////////////////////////

CRYPTO::yogda
/**
 * @private
 */
internal final class Memory$ {
	
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
	
	[Inline(bytecode="0x35")]
	public static function getUI8(address:uint):int {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		var result:int = mem.readUnsignedByte();
		mem.endian = endian;
		return result;
	}
	
	[Inline(bytecode="0x36")]
	public static function getUI16(address:uint):int {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		var result:int = mem.readUnsignedShort();
		mem.endian = endian;
		return result;
	}
	
	[Inline(bytecode="0x37")]
	public static function getI32(address:uint):int {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		var result:int = mem.readInt();
		mem.endian = endian;
		return result;
	}
	
	[Inline(bytecode="0x38")]
	public static function getF32(address:uint):Number {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		var result:Number = mem.readFloat();
		mem.endian = endian;
		return result;
	}
	
	[Inline(bytecode="0x39")]
	public static function getF64(address:uint):Number {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		var result:Number = mem.readDouble();
		mem.endian = endian;
		return result;
	}
	
	[Inline(bytecode="0x3A")]
	public static function setI8(value:int, address:uint):void {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		mem.writeByte( value );
		mem.endian = endian;
	}
	
	[Inline(bytecode="0x3B")]
	public static function setI16(value:int, address:uint):void {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		mem.writeShort( value );
		mem.endian = endian;
	}
	
	[Inline(bytecode="0x3C")]
	public static function setI32(value:int, address:uint):void {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		mem.writeInt( value );
		mem.endian = endian;
	}
	
	[Inline(bytecode="0x3D")]
	public static function setF32(value:Number, address:uint):void {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		mem.writeFloat( value );
		mem.endian = endian;
	}
	
	[Inline(bytecode="0x3E")]
	public static function setF64(value:Number, address:uint):void {
		var mem:ByteArray = _domain.domainMemory;
		var endian:String = mem.endian;
		mem.endian = Endian.LITTLE_ENDIAN;
		mem.position = address;
		mem.writeDouble( value );
		mem.endian = endian;
	}
	
	[Inline(bytecode="0x50")]
	public static function sign1(value:int):int {
		if ( ( value & 0x1 ) != 0 ) {
			value &= 0x0;
			value -= 0x1;
		}
		return value;
	}
	
	[Inline(bytecode="0x51")]
	public static function sign8(value:int):int {
		if ( ( value & 0x80 ) != 0 ) {
			value &= 0x7F;
			value -= 0x80;
		}			
		return value;
	}
	
	[Inline(bytecode="0x52")]
	public static function sign16(value:int):int {
		if ( ( value & 0x8000 ) != 0 ) {
			value &= 0x7fff;
			value -= 0x8000;
		}
		return value;
	}
	
}