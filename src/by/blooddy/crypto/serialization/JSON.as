////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.serialization {

	import flash.errors.IllegalOperationError;
	import flash.utils.getQualifiedClassName;

	/**
	 * @author					BlooDHounD
	 * @version					3.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					01.10.2010 15:53:38
	 * 
	 * @see						http://www.json.org
	 */
	public final class JSON {

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @param	value
		 * 
		 * @return
		 * 
		 * @throws	StackOverflowError	
		 */
		public static function encode(value:*):String {
			throw new IllegalOperationError();
		}
		
		/**
		 * @param	value
		 * 
		 * @return
		 * 
		 * @throws	TypeError			
		 * @throws	SyntaxError
		 */
		public static function decode(value:String):* {
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
		public function JSON() {
			Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
		}
		
	}

}