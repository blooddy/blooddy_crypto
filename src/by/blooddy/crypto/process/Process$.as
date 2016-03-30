////////////////////////////////////////////////////////////////////////////////
//
//  © 2016 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.process {

	[ExcludeClass]
	/**
	 * @private
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10.1
	 * @langversion				3.0
	 * @created					25.03.2016 17:11:05
	 */
	internal interface Process$ {

		function process(WorkerClass:Class, defenitionName:String, methodName:String, arguments:Array, success:Function, fault:Function):void;
		
	}

}