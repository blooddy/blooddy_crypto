////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.image.palette {

	/**
	 * The base interface for creating color palletes to be used in PNG8 encoders.
	 * 
	 * @see						by.blooddy.crypto.image.PNG8Encoder
	 * 
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					27.06.2010 22:35:21
	 */
	public interface IPalette {

		/**
		 * Returns the list of the colors used in the palette.
		 * 
		 * @return	All the colors used in the palette.
		 * 
		 * @see		#getHash
		 */
		function getList():Vector.<uint>;

		/**
		 * Returns the hash of the colors used in the palette.
		 * 
		 * @return	All the colors used in the palette.
		 * 
		 * @see		#getList
		 */
		function getHash():Object;
		
		/**
		 * Returns the index of the color inside the palette. 
		 * It is possible that the same index will be returned for different color values.
		 * 
		 * @param	color			The color you wish to index.
		 * 
		 * @return					The index of the color inside the palette.
		 * 
		 * @throws	ArgumentError	If the color was not found inside the palette.
		 */
		function getIndexByColor(color:uint):uint;

	}

}