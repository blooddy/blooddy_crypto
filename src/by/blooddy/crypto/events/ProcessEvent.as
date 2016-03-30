////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.events {

	import flash.events.ErrorEvent;
	import flash.events.Event;
	
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					25.03.2016 1:17:56
	 */
	public class ProcessEvent extends Event {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		public static const COMPLETE:String =	Event.COMPLETE;

		public static const ERROR:String =		ErrorEvent.ERROR;
	
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @param	type
		 * @param	bubbles
		 * @param	cancelable
		 * @param	data
		 */
		public function ProcessEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null) {
			super( type, bubbles, cancelable );
			this.data = data;
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		public var data:*;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		public override function clone():Event {
			return new ProcessEvent( super.type, super.bubbles, super.cancelable, this.data );
		}
		
	}

}