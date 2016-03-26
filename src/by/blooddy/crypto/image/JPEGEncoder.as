////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image {

	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.getQualifiedClassName;

	/**
	 * Encodes image data using
	 * <a href="http://www.w3.org/Graphics/JPEG/itu-t81.pdf">JPEG</a> compression method.
	 *
	 * @author					BlooDHounD
	 * @version					2.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 */
	public final class JPEGEncoder {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static const _NATIVE:Boolean = ApplicationDomain.currentDomain.hasDefinition( 'flash.display.PNGEncoderOptions' );
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * Creates a JPEG image from the specified <code>BitmapData</code>.
		 * 
		 * Used <code>flash.display.BitmapData.encode</code>, if posible.
		 *
		 * @param	image		The <code>BitmapData</code> to be encoded.
		 *
		 * @param	quality		The compression level, possible values are 1 through 100 inclusive.
		 *
		 * @return 				a <code>ByteArray</code> representing the JPEG encoded image data.
		 *
		 * @see					flash.display.JPEGEncoderOptions
		 */
		public static function encode(image:BitmapData, quality:uint=60):ByteArray {

			if ( image == null ) Error.throwError( TypeError, 2007, 'image' );
			if ( quality > 100 ) Error.throwError( RangeError, 2006, 'quality' );

			if ( _NATIVE ) {
				return image.encode( image.rect, new JPEGEncoderOptions( quality ) );
			} else {
				return JPEGEncoder$.encode( image, quality );
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
		public function JPEGEncoder() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}

import flash.display.BitmapData;
import flash.errors.IllegalOperationError;
import flash.system.ApplicationDomain;
import flash.utils.ByteArray;

import avm2.intrinsics.memory.li8;
import avm2.intrinsics.memory.si16;
import avm2.intrinsics.memory.si32;
import avm2.intrinsics.memory.si8;

/**
 * @private
 */
internal final class JPEGEncoder$ {

	//--------------------------------------------------------------------------
	//
	//  Encode
	//
	//--------------------------------------------------------------------------
	
	internal static function encode(image:BitmapData, qulity:uint):ByteArray {
		
		var tmp:ByteArray = _DOMAIN.domainMemory;
		
		var mem:ByteArray = new ByteArray();

		_DOMAIN.domainMemory = mem;

		throw new IllegalOperationError();
		
		_DOMAIN.domainMemory = tmp;
		
		return mem;

	}

	//--------------------------------------------------------------------------
	//  encode main methods
	//--------------------------------------------------------------------------
	
	private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;
	
}

/**
 * @private
 */
internal final class JPEGTable$ {
	
	//--------------------------------------------------------------------------
	//
	//  Table
	//
	//--------------------------------------------------------------------------
	
	/**
	 * <table>
	 *	<tr><th>     0</th><td>QuantTable				</td><td>			</td></tr>
	 *	<tr><th>  1154</th><td>ZigZag					</td><td>			</td></tr>
	 *	<tr><th>  1218</th><td>HuffmanTable				</td><td>			</td></tr>
	 *	<tr><th>  3212</th><td>CategoryTable			</td><td>			</td></tr>
	 *	<tr><th>199817</th><td>							</td><td>			</td></tr>
	 * </table>
	 */
	internal static function getTable(quality:uint=60):ByteArray {
		
		var quants:ByteArray = _QUANTS[ quality ];
		if ( !quants ) {
			_QUANTS[ quality ] = quants = createQuantTable( quality );
		}

		var result:ByteArray = new ByteArray();
		result.writeBytes( quants );
		result.writeBytes( _TABLE );
		result.position = 0;

		return result;

	}
	
	//--------------------------------------------------------------------------
	//  table main methods
	//--------------------------------------------------------------------------
	
	private static const _DOMAIN:ApplicationDomain = ApplicationDomain.currentDomain;

	private static const _QUANTS:Vector.<ByteArray> = new Vector.<ByteArray>( 100, true );

	private static const _TMP:ByteArray = new ByteArray();
	
	private static const _TABLE:ByteArray = ( function():ByteArray {
		var table:ByteArray = new ByteArray();
		table.writeBytes( createZigZagTable() );
		table.writeBytes( createHuffmanTable() );
		table.writeBytes( createCategoryTable() );
		return table;
	}() );
	
	/**
	 * <table>
	 *	<tr><th>   0</th><td>0							</td><td>[1]{1}		</td></tr>
	 *	<tr><th>   1</th><td>YTable						</td><td>[1]{64}	</td></tr>
	 *	<tr><th>  64</th><td>0							</td><td>[1]{1}		</td></tr>
	 *	<tr><th>  65</th><td>UVTable					</td><td>[1]{64}	</td></tr>
	 *	<tr><th> 130</th><td>fdtbl_Y					</td><td>[8]{64}	</td></tr>
	 *	<tr><th> 642</th><td>fdtbl_UV					</td><td>[8]{64}	</td></tr>
	 * 	<tr><th>1154</th><td>							</td><td>			</td></tr>
	 * </table>
	 */
	private static function createQuantTable(quality:uint):ByteArray {
		return null;
	}
	
	/**
	 * <table>
	 *	<tr><th> 0</th><td>ZigZag						</td><td>[1]{64}	</td></tr>
	 *	<tr><th>64</th><td>								</td><td>			</td></tr>
	 * </table>
	 */
	private static function createZigZagTable():ByteArray {
		var mem:ByteArray = new ByteArray();
		mem.writeUTFBytes( '\x00\x01\x05\x06\x0e\x0f\x1b\x1c\x02\x04\x07\x0d\x10\x1a\x1d\x2a\x03\x08\x0c\x11\x19\x1e\x29\x2b\x09\x0b\x12\x18\x1f\x28\x2c\x35\x0a\x13\x17\x20\x27\x2d\x34\x36\x14\x16\x21\x26\x2e\x33\x37\x3c\x15\x22\x25\x2f\x32\x38\x3b\x3d\x23\x24\x30\x31\x39\x3a\x3e\x3f' );
		return mem;
	}
	
	/**
	 * <table>
	 *	<tr><th>   0</th><td>0							</td><td>[1]{1}		</td></tr>
	 *	<tr><th>   1</th><td>std_dc_luminance_nrcodes	</td><td>[1]{16}	</td></tr>
	 *	<tr><th>  17</th><td>std_dc_luminance_values	</td><td>[1]{12}	</td></tr>
	 *	<tr><th>  29</th><td>0							</td><td>[1]{1}		</td></tr>
	 *	<tr><th>  30</th><td>std_ac_luminance_nrcodes	</td><td>[1]{16}	</td></tr>
	 *	<tr><th>  47</th><td>std_ac_luminance_values	</td><td>[1]{162}	</td></tr>
	 *	<tr><th> 208</th><td>0							</td><td>[1]{1}		</td></tr>
	 *	<tr><th> 209</th><td>std_dc_chrominance_nrcodes	</td><td>[1]{16}	</td></tr>
	 *	<tr><th> 225</th><td>std_dc_chrominance_values	</td><td>[1]{12}	</td></tr>
	 *	<tr><th> 237</th><td>0							</td><td>[1]{1}		</td></tr>
	 *	<tr><th> 238</th><td>std_ac_chrominance_nrcodes	</td><td>[1]{16}	</td></tr>
	 *	<tr><th> 254</th><td>std_ac_chrominance_values	</td><td>[1]{162}	</td></tr>
	 *	<tr><th> 416</th><td>YDC_HT						</td><td>[1,2]{12}	</td></tr>
	 *	<tr><th> 452</th><td>YAC_HT						</td><td>[1,2]{251}	</td></tr>
	 *	<tr><th>1205</th><td>UVDC_HT					</td><td>[1,2]{12}	</td></tr>
	 *	<tr><th>1241</th><td>UVAC_HT					</td><td>[1,2]{251}	</td></tr>
	 *	<tr><th>1994</th><td>							</td><td>			</td></tr>
	 * </table>
	 */
	private static function createHuffmanTable():ByteArray {
		
		var tmp:ByteArray = _DOMAIN.domainMemory;
		
		var mem:ByteArray = new ByteArray();
		mem.length = Math.max( 1994, ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH );
		
		_DOMAIN.domainMemory = mem;
		
		var i:int;
		var arr:Vector.<uint>;
		
		// std_dc_luminance_nrcodes
		mem.position++;
		mem.writeUTFBytes( '\x00\x01\x05\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00' );
		// std_dc_luminance_values
		mem.writeUTFBytes( '\x00\x01\x02\x03\x04\x05\x06\x07\x08\x09\x0a\x0b' );
		// std_ac_luminance_nrcodes
		mem.position++;
		mem.writeUTFBytes( '\x00\x02\x01\x03\x03\x02\x04\x03\x05\x05\x04\x04\x00\x00\x01\x7d' );
		// std_ac_luminance_values
		arr = new <uint>[ 0x00030201, 0x12051104, 0x06413121, 0x07615113, 0x32147122, 0x08a19181, 0xc1b14223, 0xf0d15215, 0x72623324, 0x160a0982, 0x1a191817, 0x28272625, 0x35342a29, 0x39383736, 0x4544433a, 0x49484746, 0x5554534a, 0x59585756, 0x6564635a, 0x69686766, 0x7574736a, 0x79787776, 0x8584837a, 0x89888786, 0x9493928a, 0x98979695, 0xa3a29a99, 0xa7a6a5a4, 0xb2aaa9a8, 0xb6b5b4b3, 0xbab9b8b7, 0xc5c4c3c2, 0xc9c8c7c6, 0xd4d3d2ca, 0xd8d7d6d5, 0xe2e1dad9, 0xe6e5e4e3, 0xeae9e8e7, 0xf4f3f2f1, 0xf8f7f6f5, 0x0000faf9 ];
		i = 0;
		do {
			si32( arr[ i ], 46 + ( i << 2 ) );
		} while ( ++i < 41 );
		
		mem.position = 208;
		// std_dc_chrominance_nrcodes
		mem.position++;
		mem.writeUTFBytes( '\x00\x03\x01\x01\x01\x01\x01\x01\x01\x01\x01\x00\x00\x00\x00\x00' );
		// std_dc_chrominance_values
		mem.writeBytes( mem, 17, 12 );
		// std_ac_chrominance_nrcodes
		mem.position++;
		mem.writeUTFBytes( '\x00\x02\x01\x02\x04\x04\x03\x04\x07\x05\x04\x04\x00\x01\x02\x77' );
		// std_ac_chrominance_values
		arr = new <uint>[ 0x03020100, 0x21050411, 0x41120631, 0x71610751, 0x81322213, 0x91421408, 0x09c1b1a1, 0xf0523323, 0xd1726215, 0x3424160a, 0x17f125e1, 0x261a1918, 0x2a292827, 0x38373635, 0x44433a39, 0x48474645, 0x54534a49, 0x58575655, 0x64635a59, 0x68676665, 0x74736a69, 0x78777675, 0x83827a79, 0x87868584, 0x928a8988, 0x96959493, 0x9a999897, 0xa5a4a3a2, 0xa9a8a7a6, 0xb4b3b2aa, 0xb8b7b6b5, 0xc3c2bab9, 0xc7c6c5c4, 0xd2cac9c8, 0xd6d5d4d3, 0xdad9d8d7, 0xe5e4e3e2, 0xe9e8e7e6, 0xf4f3f2ea, 0xf8f7f6f5, 0x0000faf9 ];
		i = 0;
		do {
			si32( arr[ i ], 254 + ( i << 2 ) );
		} while ( ++i < 41 );
		
		computeHuffmanTable(   0, 416 );	// YDC_HT
		computeHuffmanTable(  29, 452 );	// YAC_HT
		computeHuffmanTable( 208, 1205 );	// UVDC_HT
		computeHuffmanTable( 237, 1241 );	// UVAC_HT
		
		_DOMAIN.domainMemory = tmp;
		
		return mem;
		
	}

	/**
	 * <table>
	 *	<tr><th>     0</th><td>cat						</td><td>[1,2]{65534}	</td></tr>
	 *	<tr><th>196605</th><td>							</td><td>				</td></tr>
	 * </table>
	 */
	private static function createCategoryTable():ByteArray {

		var tmp:ByteArray = _DOMAIN.domainMemory;
		
		var mem:ByteArray = new ByteArray();
		mem.length = Math.max( 0xFFFF * 3, ApplicationDomain.MIN_DOMAIN_MEMORY_LENGTH );

		_DOMAIN.domainMemory = mem;
		
		var low:int = 1;
		var upp:int = 2;
		
		var p:uint;
		var i:int;
		var l:int;
		var cat:uint = 1;
		do {
			
			// Positive numbers
			i = low;
			l = upp;
			do {
				p = ( 32767 + i ) * 3;
				si8( cat, p );
				si16( i, p + 1 );
			} while ( ++i < l );
			
			// Negative numbers
			i = - upp + 1;
			l = - low;
			do {
				p = ( 32767 + i ) * 3;
				si8( cat, p );
				si16( upp - 1 + i, p + 1 );
			} while ( ++i <= l );
			
			low <<= 1;
			upp <<= 1;
			
		} while ( ++cat <= 15 );
		
		_DOMAIN.domainMemory = tmp;
		
		return mem;

	}

	public static function computeHuffmanTable(toRead:int, toWrite:int):void {
		
		var codeValue:int = 0;
		var pos_in_table:int = 0;
		
		var i:uint;
		var j:uint;
		var l:uint;
		var p:uint;
		
		i = 1;
		do {
			
			l = li8( toRead + i );
			j = 1;
			while ( j <= l ) {
				
				p = toWrite + li8( toRead + 17 + pos_in_table ) * 3;
				
				si8( i, p );
				si16( codeValue, p + 1 );
				
				++pos_in_table;
				++codeValue;
				++j;
				
			}
			
			codeValue <<= 1;
			
		} while ( ++i <= 16 );

	}
	
}