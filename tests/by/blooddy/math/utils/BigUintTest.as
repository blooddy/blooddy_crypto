////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.math.utils {

	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;

	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 */
	public final class BigUintTest {

		//--------------------------------------------------------------------------
		//
		//  Class initialization
		//
		//--------------------------------------------------------------------------
		
		Parameterized;

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const domain:ApplicationDomain = ApplicationDomain.currentDomain;

		//--------------------------------------------------------------------------
		//
		//  Initialization
		//
		//--------------------------------------------------------------------------

		[Before]
		public function beforeTest():void {
			var len:uint = 1 << 16;
			var mem:ByteArray = new ByteArray();
			// сейчайс заполним тут всё говницом
			mem.writeInt( 0x12345678 );
			do {
				mem.writeBytes( mem, 0, mem.position );
			} while ( mem.position < len );
			domain.domainMemory = mem;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  testBit
		//----------------------------------
		
		public static var $getBitLength:Array = [
			[ '0', 0 ],
			[ 'FF', 8 ],
			[ '123', 9 ],
			[ 'FF00123', 28 ],
			[ '123F77F1F3F5F', 49 ],
			[ 'FF00000000', 40 ]
		];
		
		[Test( order="0", dataProvider="$getBitLength" )]
		public function getBitLength(v:String, result:uint):void {
			var R:uint = BigUintStr.getBitLength( v );
			Assert.assertEquals(
				R, result
			);
		}

		//----------------------------------
		//  testBit
		//----------------------------------

		public static var $testBit:Array = [
			[ '0', 1, false ],
			[ '123', 40, false ],
			[ '123F77F1F3F5F', 32, true ],
			[ '123F77F1F3F5F', 31, false ]
		];

		[Test( order="1", dataProvider="$testBit" )]
		public function testBit(v:String, n:uint, result:Boolean):void {
			var R:Boolean = BigUintStr.testBit( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ' + '( 1 << ' + n + ' ) != 0',
				R, result
			);
		}

		//----------------------------------
		//  setBit
		//----------------------------------

		public static var $setBit:Array = [
			[ '987654321', 9, '987654321' ],
			[ 'FFFFFFFF111111', 256,	'100000000000000000000000000000000000000000000000000FFFFFFFF111111' ],
			[ '12345678', 2, '1234567C' ]
		];

		[Test( order="2", dataProvider="$setBit" )]
		public function setBit(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.setBit( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' | ' + '( 1 << ' + n + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  clearBit
		//----------------------------------

		public static var $clearBit:Array = [
			[ '0', 12, '0' ],
			[ '123', 90, '123' ],
			[ '123', 3, '123' ],
			[ '10000000123', 40, '123' ],
			[ '123', 8, '23' ]
		];

		[Test( order="3", dataProvider="$clearBit" )]
		public function clearBit(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.clearBit( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' & ~( 1 << ' + n + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  flipBit
		//----------------------------------

		public static var $flipBit:Array = [
			[ '100000000000123', 56, '123' ],
			[ '123', 56, '100000000000123' ],
			[ '12b', 3, '123' ]
		];

		[Test( order="4", dataProvider="$flipBit" )]
		public function flipBit(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.flipBit( v, n );
			Assert.assertEquals(
				'( 0x' + v.toLowerCase() + ' ^ ( 1 << ' + n + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}

//		//----------------------------------
//		//  not
//		//----------------------------------
//
//		public static var $not:Array = [
//			[ '0', '0' ],
//			[ 'FF00FF00FF00FF00', 'FF00FF00FF00FF' ]
//		];
//
//		[Test( order="5", dataProvider="$not" )]
//		public function not(v:String, result:String):void {
//			var R:String = BigUintStr.not( v );
//			Assert.assertEquals(
//				'~0x' + v.toLowerCase(),
//				R.toLowerCase(), result.toLowerCase()
//			);
//		}

		//----------------------------------
		//  and
		//----------------------------------

		public static var $and:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '0' ],
			[ '9012345678', 'FFFFFF0000000912345678', '12345678' ]
		];

		[Test( order="6", dataProvider="$and" )]
		public function and(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.and( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' & 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  andNot
		//----------------------------------

		public static var $andNot:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '123' ],
			[ '123', 'FFF', '0' ],
			[ 'FFFF00FF00', 'EE00', 'FFFF001100' ],
			[ '12345678FFFF00FF00', 'EE00', '12345678FFFF001100' ]
		];

		[Test( order="7", dataProvider="$andNot" )]
		public function andNot(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.andNot( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' & ~0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  or
		//----------------------------------

		public static var $or:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '654321', '123F77FFF0FF6', '123F77FFF4FF7' ],
			[ 'FFFFFF123F77FFF0FF6', '654321', 'FFFFFF123F77FFF4FF7' ]
		];

		[Test( order="8", dataProvider="$or" )]
		public function or(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.or( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' | 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  xor
		//----------------------------------

		public static var $xor:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '123F77FFFFFF6', '654321', '123F77F9ABCD7' ],
			[ 'FFFFFFFF123F77FFFFFF6', '654321', 'FFFFFFFF123F77F9ABCD7' ]
		];

		[Test( order="9", dataProvider="$xor" )]
		public function xor(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.xor( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' ^ 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  shiftRight
		//----------------------------------

		public static var $shiftRight:Array = [
			[ '0', 123, '0' ],
			[ '123', 0, '123' ],
			[ 'FFFFFFFF', 32, '0' ],
			[ '123FFFFFFFF', 32, '123' ],
			[ '12345678FFFFFFFF', 8, '12345678FFFFFF' ],
			[ '12345678FFFFFFFF', 33, '91A2B3C' ],
			[ 'F926CAD0655A246E5FA1F9918ACFA7E3A5C066275D342E9F', 55, '1F24D95A0CAB448DCBF43F323159F4FC74B' ],
		];

		[Test( order="10", dataProvider="$shiftRight" )]
		public function shiftRight(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.shiftRight( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' >> ' + n,
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  shiftLeft
		//----------------------------------

		public static var $shiftLeft:Array = [
			[ '0', 123, '0' ],
			[ '123', 0, '123' ],
			[ '12', 123, '90000000000000000000000000000000' ],
			[ '123456', 24, '123456000000' ],
			[ '1234567890', 17, '2468ACF1200000' ],
			[ '1234567890', 26, '48D159E240000000' ]
		];

		[Test( order="11", dataProvider="$shiftLeft" )]
		public function shiftLeft(v:String, n:uint, result:String):void {
			var R:String = BigUintStr.shiftLeft( v, n );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' << ' + n,
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  compare
		//----------------------------------

		public static var $compare:Array = [
			[ '123', '0', 1 ],
			[ '0', '123', -1 ],
			[ '987654321', '123456789', 1 ],
			[ '123456789', '987654321', -1 ],
			[ 'F87654321', 'F23456789', 1 ],
			[ 'F23456789', 'F87654321', -1 ],
			[ '123', '123', 0 ]
		];

		[Test( order="12", dataProvider="$compare" )]
		public function compare(v1:String, v2:String, result:int):void {
			var F:Function = function(R:int):String {
				if ( R == 1 ) return '>';
				else if ( R == -1 ) return '<';
				else return '==';
			}
			var R:int = BigUintStr.compare( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' ' + F( R ) + ' 0x' + v2.toLowerCase(),
				R, result
			);
		}

		//----------------------------------
		//  increment
		//----------------------------------

		public static var $increment:Array = [
			[ '0', '1' ],
			[ '123', '124' ],
			[ 'FFFFFFFF', '100000000' ],
			[ '123456780000000F', '1234567800000010' ],
			[ 'FF123456780000000F', 'FF1234567800000010' ]
		];

		[Test( order="13", dataProvider="$increment" )]
		public function increment(v:String, result:String):void {
			var R:String = BigUintStr.increment( v );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + '++',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  add
		//----------------------------------

		public static var $add:Array = [
			[ '0', '123', '123' ],
			[ '123', '0', '123' ],
			[ '123456', '123', '123579' ],
			[ '654321', '11111234567812345678FFFFFFFFFFFFFFFF', '111112345678123456790000000000654320' ],
			[ '654321', 'FFFFFFFFFFFFFFFF', '10000000000654320' ]
		];

		[Test( order="14", dataProvider="$add" )]
		public function add(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.add( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' + 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  decrement
		//----------------------------------

		public static var $decrement:Array = [
			[ '123', '122' ],
			[ '12300000000', '122FFFFFFFF' ],
			[ 'FFFFFFFF12300000000', 'FFFFFFFF122FFFFFFFF' ]
		];

		[Test( order="15", dataProvider="$decrement" )]
		public function decrement(v1:String, result:String):void {
			var R:String = BigUintStr.decrement( v1 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + '--',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  decrement_error
		//----------------------------------

		public static var $decrement_error:Array = [
			[ '0' ]
		];

		[Test( order="16", dataProvider="$decrement_error", expects="ArgumentError" )]
		public function decrement_error(v1:String):void {
			BigUintStr.decrement( v1 );
		}

		//----------------------------------
		//  sub
		//----------------------------------

		public static var $sub:Array = [
			[ '123', '0', '123' ],
			[ '123', '123', '0' ],
			[ '123', '12', '111' ],
			[ 'FF0000000000000123', 'FFFF', 'FEFFFFFFFFFFFF0124' ],
			[ 'FF0000000000000123', '122', 'FF0000000000000001' ],
			[ 'FF00000123', '122', 'FF00000001' ]
		];

		[Test( order="17", dataProvider="$sub" )]
		public function sub(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.sub( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' - 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  sub_error
		//----------------------------------

		public static var $sub_error:Array = [
			[ '0', '123' ],
			[ '12', '123' ],
			[ '123', '123FFFFFFFF' ],
			[ '1200000000', '2100000000' ]
		];

		[Test( order="18", dataProvider="$sub_error", expects="ArgumentError" )]
		public function sub_error(v1:String, v2:String):void {
			BigUintStr.sub( v1, v2 );
		}

		//----------------------------------
		//  mult
		//----------------------------------

		public static var $mult:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '0' ],
			[ '1', '123456', '123456' ],
			[ '123456', '1', '123456' ],
			[ '400000000', '100', '40000000000' ],
			[ '400000000', '3', 'C00000000' ],
			[ '3', '400000000', 'C00000000' ],
			[ '1F24D95A0CAB448DCBF43F323159F4FC74B', '80000000000000', 'F926CAD0FFDA246E5FA1F991FFCFA7E3A580000000000000' ],
			[ '123', '12', '1476' ],
			[ '123F77FFFFFF6', '13', '15AB5E7FFFFF42' ],
			[ '13', '123F77FFFFFF6', '15AB5E7FFFFF42' ],
			[ 'FFFF0000', '11110000', '1110EEEF00000000' ],
			[ 'FFFF1111', '11110000', '1110F01243210000' ],
			[ '6FFFFFF77F321', '123F77FFFFFF6', '7FBC47F64D5901167855080B6' ],
			[ 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000000000000000000001' ]
		];

		[Test( order="19", dataProvider="$mult" )]
		public function mult(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.mult( v1, v2 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + ' * 0x' + v2.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  powInt
		//----------------------------------
		
		public static var $powInt:Array = [
			[ '123', 0, '1' ],
			[ '0', 5, '0' ],
			[ '123', 1, '123' ],
			[ 'FFFFF', 6, 'FFFFA0000EFFFEC0000EFFFFA00001' ],
			[ '3', 0xFF, '11F1B08E87EC42C5D83C3218FC83C41DCFD9F4428F4F92AF1AAA80AA46162B1F71E981273601F4AD1DD4709B5ACA650265A6AB' ],
			[ 'F00', 77, '1C744E6621724DBA25AEA0207A6C11C8A22B3801DF5B01F8658653F5F67A653A1C09C70576CF0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000' ]
		];
		
		[Test( order="20", dataProvider="$powInt" )]
		public function powInt(v:String, e:uint, result:String):void {
			var R:String = BigUintStr.powInt( v, e );
			Assert.assertEquals(
				'pow( 0x' + v.toLowerCase() + ', ' + e + ' )',
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  divAndMod
		//----------------------------------

		public static var $divAndMod:Array = [
			[ '0', '123', '0', '0' ],
			[ '1234', '123456789', '0', '1234' ],
			[ '123', '1', '123', '0' ],
			[ '123', '123', '1', '0' ],
			[ '12', '123', '0', '12' ],
			[ '6F9', '7', 'FF', '0' ],
			[ '14EB', '8', '29D', '3' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '1873618', 'be99f26089e05b74604cadadfcce4e5721020e52b4d9', '561397' ],
			[ '123456789', '1', '123456789', '0' ],
			[ 'F926CAD0655A246E5FA1F9918ACFA7E3A5C066275D342E9F', '80000000000000', '1F24D95A0CAB448DCBF43F323159F4FC74B', '4066275D342E9F' ],
			[ '123456789', '3', '61172283', '0' ],
			[ '123456789', '7', '299C335C', '5' ],
			[ '1234567890FFFFFFFF', 'FFFFFFFFFFFF', '123456', '789100123455' ],
			[ '1234567890FFFFFFFF', '9876543210', '1E9131AB', '859D1D7F4F' ],
			[ '1234567890FFFFFFFF', '1234567890', '100000000', 'FFFFFFFF' ],
			[ 'F926CAD0655A246E5FA1F9918ACFA7E3A5C066275D342E9F', '320A7BD3DF175319', '4FA9CA4AD127067C933000454773CD53C', '23F44E9492BCE7C3' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '9832982309712532378643', '1e9ecc3998da5aba2f4b0739b7d17', '500a2f008e90adfe8f06ea' ]
		];

		[Test( order="21", dataProvider="$divAndMod" )]
		public function divAndMod(v:String, m:String, result:String, rest:String):void {
			var R:Array = BigUintStr.divAndMod( v, m );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' / 0x' + m.toLowerCase(),
				R.join( ',' ).toString().toLowerCase(), [ result, rest ].join( ',' ).toLowerCase()
			);
		}

		//----------------------------------
		//  divAndMod_error
		//----------------------------------

		public static var $divAndMod_error:Array = [
			[ '123456', '0' ]
		];

		[Test( order="22", dataProvider="$divAndMod_error", expects="ArgumentError" )]
		public function divAndMod_error(v:String, m:String):void {
			BigUintStr.divAndMod( v, m );
		}

		//----------------------------------
		//  div
		//----------------------------------

		[Test( order="23", dataProvider="$divAndMod" )]
		public function div(v:String, m:String, result:String, rest:String):void {
			var R:String = BigUintStr.div( v, m );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' / 0x' + m.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  div_error
		//----------------------------------

		[Test( order="24", dataProvider="$divAndMod_error", expects="ArgumentError" )]
		public function div_error(v:String, m:String):void {
			BigUintStr.div( v, m );
		}

		//----------------------------------
		//  mod
		//----------------------------------

		[Test( order="25", dataProvider="$divAndMod" )]
		public function mod(v:String, m:String, result:String, rest:String):void {
			var R:String = BigUintStr.mod( v, m );
			Assert.assertEquals(
				'0x' + v.toLowerCase() + ' % 0x' + m.toLowerCase(),
				R.toLowerCase(), rest.toLowerCase()
			);
		}

		//----------------------------------
		//  mod_error
		//----------------------------------

		[Test( order="26", dataProvider="$divAndMod_error", expects="ArgumentError" )]
		public function mod_error(v:String, m:String):void {
			BigUintStr.mod( v, m );
		}

		//----------------------------------
		//  modPowInt
		//----------------------------------

		public static var $modPowInt:Array = [
			[ '0', 123, '123', '0' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', 1, '1873618', '561397' ],
			[ '123', 123, '1', '0' ],
			[ '1', 123, '123', '1' ],
			[ '123', 0, '123', '1' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', 1024, '1267', 'b83' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', 1024, '1873618', '9679' ],
			[ '1234', 67, '1873618', '7ed7d8' ],
			[ '1234', 67, '9832982309712532378643', '126ecd88d701d98ea61f4d' ],
			[ '1989746288117', 12345, '9832982309712532378643', '48a7483ca7ab708cdb412f' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', 0x100E, '9832982309712532378643', '65076beaec746d529526e2' ],
			[ 'A4490A31763DEA84E0D24086FBD81A296C7AB7D5ABBB9FAB', 0x100E, '31277332FA4A8C2D', '1728dfa593045a85' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', 1024, '31277332fa4a8c2d', '14222a18073275b4' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', 1024, '9832982309712532378643', '139d30ff985d42243a7432' ]
		];

		[Test( order="27", dataProvider="$modPowInt" )]
		public function modPowInt(v:String, e:uint, m:String, resut:String):void {
			var R:String = BigUintStr.modPowInt( v, e, m );
			Assert.assertEquals(
				'pow( 0x' + v.toLowerCase() + ', ' + e + ' ) % ' + '0x' + m.toLowerCase(),
				R.toLowerCase(), resut.toLowerCase()
			);
		}

		[Test( order="28", dataProvider="$divAndMod_error", expects="ArgumentError" )]
		public function modPowInt_error(v:String, e:uint, m:String):void {
			BigUintStr.modPowInt( v, e, m );
		}
		
	}

}