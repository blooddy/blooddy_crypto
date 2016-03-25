////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image.palette {

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					25.09.2010 0:22:29
	 * 
	 * @see						http://en.wikipedia.org/wiki/List_of_palettes#RGB_arrangements
	 */
	public class LevelsPalette implements IPalette {

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Creates new <code>LevelsPalette</code>.
		 * 
		 * @param	rLevel
		 * @param	gLevel
		 * @param	bLevel
		 * @param	transparent
		 * 
		 * @throws	RangeError
		 */
		public function LevelsPalette(rLevel:uint=8, gLevel:uint=8, bLevel:uint=4, transparent:Boolean=false) {
			super();

			var maxColors:uint = rLevel * gLevel * bLevel + ( transparent ? 1 : 0 );
			if ( maxColors < 2 || maxColors > 256 ) Error.throwError( RangeError, 2006 );

			this._rRatio = gLevel * bLevel;
			this._gRatio = bLevel;

			var rc:Number = 0xFF / ( rLevel - 1 );
			var gc:Number = 0xFF / ( gLevel - 1 );
			var bc:Number = 0xFF / ( bLevel - 1 );

			this._rc = rc;
			this._gc = gc;
			this._bc = bc;

			var ri:uint;
			var gi:uint;
			var bi:uint;
			var i:int = -1;
			var c:uint;

			this._list = new Vector.<uint>( maxColors, true );

			for ( ri=0; ri<rLevel; ++ri ) {
				for ( gi=0; gi<gLevel; ++gi ) {
					for ( bi=0; bi<bLevel; ++bi ) {

						c =	( Math.round( ri * rc ) << 16 ) |
							( Math.round( gi * gc ) <<  8 ) |
							  Math.round( bi * bc )         |
							  0xFF000000                    ;

						this._hash[ c ] = i;

						this._list[ ++i ] =	c;

					}
				}
			}

			if ( transparent ) {
				this._list[ ++i ] = 0x00000000;
				this._transparent = false;
			}

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
		private const _hash:Array = new Array();

		/**
		 * @private
		 */
		private var _transparent:Boolean;

		/**
		 * @private
		 */
		private var _rRatio:uint;

		/**
		 * @private
		 */
		private var _gRatio:uint;

		/**
		 * @private
		 */
		private var _rc:uint;

		/**
		 * @private
		 */
		private var _gc:uint;

		/**
		 * @private
		 */
		private var _bc:uint;

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
		 * @inheritDoc
		 */
		public function getHash():Object {
			return null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function getIndexByColor(color:uint):uint {
			if ( this._transparent && color < 0x33000000 ) {

				return this._list.length - 1;

			} else {

				color &= 0xFFFFFF;

				if ( color in this._hash ) {

					return this._hash[ color ];

				} else {

					var i:uint =	( ( color & 0x00FF0000 ) >>> 16 ) / this._rc * this._rRatio +
									( ( color & 0x0000FF00 )  >>  8 ) / this._gc * this._gRatio +
									  ( color & 0x000000FF )          / this._bc;

					this._hash[ color ] = i;

					return i;

				}

			}
		}

	}

}