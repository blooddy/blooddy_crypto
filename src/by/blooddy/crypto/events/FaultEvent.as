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
	 * @created					25.03.2016 1:32:46
	 */
	public class FaultEvent extends Event {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		public static const FAULT:String = 'fault';
		
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
		public function FaultEvent(error:*, type='error', bubbles:Boolean=false, cancelable:Boolean=false) {
			super( type, bubbles, cancelable );
			this.error = error;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var error:*;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public override function clone():Event {
			return new FaultEvent( this.error, super.type, super.bubbles, super.cancelable );
		}
		
	}

}