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
			[ '1234567890', 26, '48D159E240000000' ],
			[ '1F24D95A0CAB448DCBF43F323159F4FC74B', 55, 'f926cad0655a246e5fa1f9918acfa7e3a580000000000000' ]
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

		public static var $inc:Array = [
			[ '0', '1' ],
			[ '123', '124' ],
			[ 'FFFFFFFF', '100000000' ],
			[ '123456780000000F', '1234567800000010' ],
			[ 'FF123456780000000F', 'FF1234567800000010' ]
		];

		[Test( order="13", dataProvider="$inc" )]
		public function inc(v:String, result:String):void {
			var R:String = BigUintStr.inc( v );
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

		public static var $dec:Array = [
			[ '123', '122' ],
			[ '12300000000', '122FFFFFFFF' ],
			[ 'FFFFFFFF12300000000', 'FFFFFFFF122FFFFFFFF' ]
		];

		[Test( order="15", dataProvider="$dec" )]
		public function dec(v1:String, result:String):void {
			var R:String = BigUintStr.dec( v1 );
			Assert.assertEquals(
				'0x' + v1.toLowerCase() + '--',
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  decrement_error
		//----------------------------------

		public static var $dec_error:Array = [
			[ '0' ]
		];

		[Test( order="16", dataProvider="$dec_error", expects="ArgumentError" )]
		public function dec_error(v1:String):void {
			BigUintStr.dec( v1 );
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
			[ 'FF00000123', '122', 'FF00000001' ],
			[ 'ffffffffffffffff', '654321', 'ffffffffff9abcde' ]
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
		//  mul
		//----------------------------------

		public static var $mul:Array = [
			[ '0', '123', '0' ],
			[ '123', '0', '0' ],
			[ '1', '123456', '123456' ],
			[ '123456', '1', '123456' ],
			[ '400000000', '100', '40000000000' ],
			[ '400000000', '3', 'C00000000' ],
			[ '3', '400000000', 'C00000000' ],
			[ '1F24D95A0CAB448DCBF43F323159F4FC74B', '80000000000000', 'f926cad0655a246e5fa1f9918acfa7e3a580000000000000' ],
			[ '123', '12', '1476' ],
			[ '123F77FFFFFF6', '13', '15AB5E7FFFFF42' ],
			[ '13', '123F77FFFFFF6', '15AB5E7FFFFF42' ],
			[ 'FFFF0000', '11110000', '1110EEEF00000000' ],
			[ 'FFFF1111', '11110000', '1110F01243210000' ],
			[ '6FFFFFF77F321', '123F77FFFFFF6', '7FBC47F64D5901167855080B6' ],
			[ 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF', 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFE00000000000000000000000000000001' ],
		];

		[Test( order="19", dataProvider="$mul" )]
		public function mul(v1:String, v2:String, result:String):void {
			var R:String = BigUintStr.mul( v1, v2 );
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
			[ '1cf12af3c311', '1873618', '12f065', '34eb99' ],
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
		//  modPow
		//----------------------------------

		public static var $modPow:Array = [
			[ '0', '7B', '123', '0' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '1', '1873618', '561397' ],
			[ '123', '7B', '1', '0' ],
			[ '1', '7B', '123', '1' ],
			[ '123', '0', '123', '1' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400', '1267', 'b83' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400', '1873618', '9679' ],
			[ '1234', '43', '1873618', '7ed7d8' ],
			[ '1234', '43', '9832982309712532378643', '126ecd88d701d98ea61f4d' ],
			[ '1989746288117', '3039', '9832982309712532378643', '48a7483ca7ab708cdb412f' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '100E', '9832982309712532378643', '65076beaec746d529526e2' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '100E', '31277332fa4a8c2d', '1728dfa593045a85' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '400', '31277332fa4a8c2d', '14222a18073275b4' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400', '9832982309712532378643', '139d30ff985d42243a7432' ],
			[ '1989746288117', '303930393039', '9832982309712532378643', '1790cbdddcb66f5c389557' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '100E100E100E', '9832982309712532378643', '3834a321291e8cf75de38' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '100E100E100E', '31277332FA4A8C2D', '74de237ea79016e' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', '400400400', '31277332fa4a8c2d', 'c9b06956092e766' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', '400400400', '9832982309712532378643', '12623b7f5433e8c64fcc9d' ],
			[ 'a4490a31763dea84e0d24086fbd81a296c7ab7d5abbb9fab', 'b41ef633dcf80686', '31277332fa4a8c2d', '2620ce0973b52dbb' ],
			[ '12345678901abcdef12345678901abcdef12345678901abcdef', 'b41ef633dcf80686', '9832982309712532378643', '5a786ece858b1f725ff591' ]
		];

		[Test( order="27", dataProvider="$modPow" )]
		public function modPow(v:String, e:String, m:String, result:String):void {
			var R:String = BigUintStr.modPow( v, e, m );
			Assert.assertEquals(
				'pow( 0x' + v.toLowerCase() + ', 0x' + e + ' ) % ' + '0x' + m.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}

		//----------------------------------
		//  modPow_error
		//----------------------------------

		public static var $modPow_error:Array = [
			[ '1', '1', '0' ]
		];

		[Test( order="28", dataProvider="$modPow_error", expects="ArgumentError" )]
		public function modPow_error(v:String, e:String, m:String):void {
			BigUintStr.modPow( v, e, m );
		}
		
		//----------------------------------
		//  modInv
		//----------------------------------
		
		public static var $modInv:Array = [
			[ '1', 'e14f', '1' ],
			[ 'e14f', '1', '0' ],
			[ '1586e', 'e14f', '7bfc' ],
			[ 'eccdae67', 'e14f', '52f4' ],
			[ '145efeca3', 'e14f', '48cb' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'e14f', 'ab38' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'e14f', '9fe1' ],
			[ 'e14f', '1586e', '9ae5' ],
			[ 'eccdae67', '1586e', '12eff' ],
			[ '145efeca3', '1586e', '560d' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '1586e', '6f6f' ],
			[ 'e14f', 'eccdae67', '959e4202' ],
			[ '1586e', 'eccdae67', '1c7c8f53' ],
			[ '145efeca3', 'eccdae67', '5f8c0dd2' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'eccdae67', '9f899f6c' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'eccdae67', '9fe20abc' ],
			[ 'e14f', '145efeca3', 'dca20de3' ],
			[ '1586e', '145efeca3', 'f481aa2e' ],
			[ 'eccdae67', '145efeca3', 'c26d0220' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '145efeca3', '856e5938' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '145efeca3', '45b6b7d5' ],
			[ 'e14f', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '327f82c50c4d3d7897dcfa31c089b128b61c13e27e7999131ebf30ec5314c7a0' ],
			[ '1586e', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '8e4b224873c5b5105dd01e56db44b5c16ffcdf74bde51ad27c43a309a998171c' ],
			[ 'eccdae67', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '44a231711a54743808d50cf0abf042d75d28f0e27f72f6d71dbeb57d16cbe83c' ],
			[ '145efeca3', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', '7c3c6e3c42747a3f4e531f9f02269b3c4c9376c0d701109327518a3faae80fdc' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'd00324f2d4e8765986748d525e3b7519e07ffd758fcaacd0607403a273f0c9dd' ],
			[ 'e14f', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '319df884c124004c51f433f4bca5035e470b29f40536515c65ed6d8089a1b753' ],
			[ 'eccdae67', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '377fd5da5a9c50c67689155e2d07b69c5ea1e38bffd84c5d33efe92617e5e0b1' ],
			[ '145efeca3', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '8650344cdf7991778373880a9ca03a9119639dc9597b16e6a90374513a0d26ff' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '1e58bb4bf76ac0e0a52e921a619170cff71ac1fc33e846e8707ec1269ad82c1' ],
		];
		
		[Test( order="29", dataProvider="$modInv" )]
		public function modInv(v:String, m:String, result:String):void {
			var R:String = BigUintStr.modInv( v, m );
			Assert.assertEquals(
				'1 / 0x' + v.toLowerCase() + ' % 0x' + m.toLowerCase(),
				R.toLowerCase(), result.toLowerCase()
			);
		}
		
		//----------------------------------
		//  modInv_error
		//----------------------------------
		
		public static var $modInv_error:Array = [
			[ '1', '0' ],
			[ '0', 'e14f' ],
			[ 'e14f', 'e14f' ],
			[ '1586e', '1586e' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', '1586e' ],
			[ 'eccdae67', 'eccdae67' ],
			[ '145efeca3', '145efeca3' ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9' ],
			[ '1586e', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2' ],
		];
		
		[Test( order="30", dataProvider="$modInv_error", expects="ArgumentError" )]
		public function modInv_error(v:String, m:String):void {
			BigUintStr.modInv( v, m );
		}
		
		//----------------------------------
		//  isProbablePrime
		//----------------------------------
		
		public static var $isProbablePrime:Array = [
			[ 'e14f', 100, true ],
			[ 'eccdae67', 100, true ],
			[ 'd258e9b1fe3ce0ae5573b2b3950e6c918753fe14be8875953b56438cf7dd12f9', 100, true ],
			[ '9814b69b58eb83c8a43eda490eb435d449f9e007504658dc09fa6108de5de7b6473e1873e5e5ad43ab39fc082c18611c2e1a0292fddab31e552ad8593366105f', 100, true ],
			[ '92cd745064716d98e61028b7c30b2eb78859e9fa79bebcfa9d8bffd17c89a4af1608bf47aea1c263a8f5c996cac8741962bb838cd66c96424b20d4027022f9bbaf7567d472b2e1a00e0e0367c23a078dbe188bdc469b8b78c45a1a0d56e30dad7237716f28814b7ac89fb20efbe3c2b2b2dd77991ae349cd89587be2eade30db', 100, true ],
			[ '1586e', 100, false ],
			[ '145efeca3', 100, false ],
			[ 'aadb854f1e6b0575769588f164d45d13539cc8aa1eaa08b381d60618341c69a2', 100, false ],
			[ '566a649fadf8d776e57029cb357f9552b42a6c17c1f712d162eb623ee72160d0c3c57c9c1db8d2711b2c5b1880ba5857c2b9a037cb9a1dce10028ba78ba8c238', 100, false ],
			[ '57192bdb901752cc061a4f6a41f9c52495ce5cf1ef102a887bca3d3b099747ad170664e989c3e8ee37c307c56225fb41cc688c87fe69b669735e82baf2320a3f6ca583ff8d1911ac52adc616d18a7a27cff1ff2b3c24013e2a6215709f3a21cdd55c368b77d6b090b7f20c25ff8010109b17121cb0376eaa626cdbad0ca85a799', 100, false ],
		];
		
		[Test( order="33", dataProvider="$isProbablePrime" )]
		public function isProbablePrime(v:String, certainty:int, result:Boolean):void {
			var R:Boolean = BigUintStr.isProbablePrime( v, certainty );
			Assert.assertEquals( R, result );
		}

	}

}