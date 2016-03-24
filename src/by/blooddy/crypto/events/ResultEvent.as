////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.events {

	import flash.events.Event;
	
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					25.03.2016 1:17:56
	 */
	public class ResultEvent extends Event {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		public static const RESULT:String = 'result';
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @param	result
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 */
		public function ResultEvent(result:*, type='result', bubbles:Boolean=false, cancelable:Boolean=false) {
			super( type, bubbles, cancelable );
			this.result = result;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var result:*;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public override function clone():Event {
			return new ResultEvent( this.result, super.type, super.bubbles, super.cancelable );
		}
		
	}

}