////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto {

	import flash.events.IEventDispatcher;
	import flash.utils.ByteArray;
	
	/**
	 * Dispatched when success.
	 * 
	 * <table>
	 * 	<tr><th>Property<th><th>Value</th></tr>
	 * 	<tr><td>bubbles</td><td><code>false</code></td></tr>
	 * 	<tr><td>cancelable</td><td><code>false</code>; there is no default behavior to cancel.</td></tr>
	 * 	<tr><td>currentTarget</td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	 * 	<tr><td>target</td><td>The object that reporting process result.</td></tr>
	 * 	<tr><td>data</td><td>Result.</td></tr>
	 * </table>
	 * 
	 * @eventType	by.blooddy.crypto.events.ProcessEvent.COMPLETE
	 */
	[Event( type="by.blooddy.crypto.events.ProcessEvent", name="complete" )]

	/**
	 * Dispatched when fault.
	 * 
	 * <table>
	 * 	<tr><th>Property<th><th>Value</th></tr>
	 * 	<tr><td>bubbles</td><td><code>false</code></td></tr>
	 * 	<tr><td>cancelable</td><td><code>false</code>; there is no default behavior to cancel.</td></tr>
	 * 	<tr><td>currentTarget</td><td>The object that is actively processing the Event object with an event listener.</td></tr>
	 * 	<tr><td>target</td><td>The object that reporting process error.</td></tr>
	 * 	<tr><td>data</td><td>Error.</td></tr>
	 * </table>
	 * 
	 * @eventType	by.blooddy.crypto.events.ProcessEvent.ERROR
	 */
	[Event( type="by.blooddy.crypto.events.ProcessEvent", name="error" )]
	
	/**
	 * The <code>IHashSum</code> interface defines methods for async calculating hash-sum.
	 * 
	 * @see		https://en.wikipedia.org/wiki/Hashsum
	 * @see		by.blooddy.crypto.IHashSum
	 * 
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					Apr 1, 2016 10:16:48 AM
	 */
	public interface IHashSumAsync extends IEventDispatcher {
		
		CRYPTO::worker {
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Asynchronously performs hash algorithm on a <code>String</code>.
		 * Dispatched result in <code>ProcessEvent</code>.
		 *
		 * @param	str		The <code>String</code> to hash.
		 * 
		 * @see				by.blooddy.crypto.IHashSum#hash()
		 */
		function hash(str:String):void;
		
		/**
		 * Asynchronously performs hash algorithm on a <code>ByteArray</code>.
		 * Dispatched result in <code>ProcessEvent</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 * 
		 * @see				by.blooddy.crypto.IHashSum#hashBytes()
		 */
		function hashBytes(bytes:ByteArray):void;
		
		/**
		 * Asynchronously performs hash algorithm on a <code>ByteArray</code>.
		 * Dispatched <code>ByteArray</code> result in <code>ProcessEvent</code>.
		 *
		 * @param	bytes	The <code>ByteArray</code> data to hash.
		 * 
		 * @see				by.blooddy.crypto.IHashSum#digest()
		 */
		function digest(bytes:ByteArray):void;
		
		}
		
	}
	
}