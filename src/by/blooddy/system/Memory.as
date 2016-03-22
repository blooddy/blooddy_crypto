////////////////////////////////////////////////////////////////////////////////
//
//  © 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.system {
	
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;
	
	import avm2.intrinsics.memory.lf32;
	import avm2.intrinsics.memory.lf64;
	import avm2.intrinsics.memory.li16;
	import avm2.intrinsics.memory.li32;
	import avm2.intrinsics.memory.li8;
	import avm2.intrinsics.memory.sf32;
	import avm2.intrinsics.memory.sf64;
	import avm2.intrinsics.memory.si16;
	import avm2.intrinsics.memory.si32;
	import avm2.intrinsics.memory.si8;
	import avm2.intrinsics.memory.sxi1;
	import avm2.intrinsics.memory.sxi16;
	import avm2.intrinsics.memory.sxi8;
	
	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					11.02.2011 22:55:39
	 */
	public final class Memory {
		
		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------
		
		[Inline]
		public static function get data():ByteArray {
			return ApplicationDomain.currentDomain.domainMemory;
		}
		
		[Inline]
		public static function set data(value:ByteArray):void {
			ApplicationDomain.currentDomain.domainMemory = data;
		}

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		[Inline]
		public static function getUI8(address:int):int {
			return li8( address );
		}
		
		[Inline]
		public static function getUI16(address:uint):int {
			return li16( address );
		}
		
		[Inline]
		public static function getI32(address:int):int {
			return li32( address );
		}
		
		[Inline]
		public static function getF32(address:int):Number {
			return lf32( address );
		}
		
		[Inline]
		public static function getF64(address:int):Number {
			return lf64( address );
		}
		
		[Inline]
		public static function setI8(address:int, value:int):void {
			si8( value, address );
		}
		
		[Inline]
		public static function setI16(address:int, value:int):void {
			si16( value, address );
		}
		
		[Inline]
		public static function setI32(address:int, value:int):void {
			si32( value, address );
		}
		
		[Inline]
		public static function setF32(address:int, value:Number):void {
			sf32( value, address );
		}
		
		[Inline]
		public static function setF64(address:int, value:Number):void {
			sf64( value, address );
		}
		
		[Inline]
		public static function sign1(value:int):int {
			return sxi1( value );
		}
		
		[Inline]
		public static function sign8(value:int):int {
			return sxi8( value );
		}
		
		[Inline]
		public static function sign16(value:int):int {
			return sxi16( value );
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
		public function Memory() {
			super();
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}