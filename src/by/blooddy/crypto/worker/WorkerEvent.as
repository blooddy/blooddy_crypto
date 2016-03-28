////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.worker {

	import flash.events.Event;
	
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 11.4
	 * @langversion				3.0
	 * @created					25.03.2016 1:17:56
	 */
	public class WorkerEvent extends Event {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		public static const SUCCESS:String =	'success';

		public static const FAULT:String =		'fault';
	
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
		public function WorkerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false, data:*=null) {
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
			return new WorkerEvent( super.type, super.bubbles, super.cancelable, this.data );
		}
		
	}

}