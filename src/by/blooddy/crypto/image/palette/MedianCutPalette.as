////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image.palette {

	import flash.display.BitmapData;
	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;

	/**
	 * This class provides a palette that can be used in <code>PNGEncoder</code>.
	 * 
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					04.07.2010 1:48:54
	 * 
	 * @see						http://en.wikipedia.org/wiki/Color_quantization
	 */
	public class MedianCutPalette implements IPalette {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Creates new <code>MedianCutPalette</code>.
		 * 
		 * @param	image		The source image to use when creating the palette.
		 * 
		 * @param	maxColors	The maximum number of collors to be stored inside
		 * 						the palette. The possible range is from 2 to 256 inclusive.
		 * 
		 * @throws	TypeError	The <code>image</code> parameter must 
		 * 						not be <code>null</code>.
		 * 
		 * @throws	RangeError	The number of colors is out of bounds.
		 */
		public function MedianCutPalette(image:BitmapData, maxColors:uint=256) {
			super();
			throw new IllegalOperationError();
		}
		

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _list:Vector.<uint>;

		/**
		 * @private
		 */
		private var _hash:Array;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @inheritDoc
		 */
		public function getList():Vector.<uint> {
			return this._list.slice();
		}

		/**
		 * @private
		 */
		public function getHash():Object {
			var bytes:ByteArray = new ByteArray();
			bytes.writeObject( this._hash );
			bytes.position = 0;
			return bytes.readObject();
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIndexByColor(color:uint):uint {
			return this._hash[ color ];
		}

	}

}