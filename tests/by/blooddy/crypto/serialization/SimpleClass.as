////////////////////////////////////////////////////////////////////////////////
//
//  © 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.serialization {

	import flash.utils.flash_proxy;

	use namespace flash_proxy;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					07.10.2010 18:13:34
	 */
	public dynamic class SimpleClass {
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * Constructor.
		 */
		public function SimpleClass() {
			super();
			this.dynamicProperty = 0;
		}

		//--------------------------------------------------------------------------
		//
		//  Include
		//
		//--------------------------------------------------------------------------

		public var variable:int = 1;

		public const constant:int = 2;
		
		public function get getter():int {
			return 3;
		}
		
		public function get accessor():int {
			return 4;
		}

		public function set accessor(value:int):void {
		}
		
		//--------------------------------------------------------------------------
		//
		//  Exclude
		//
		//--------------------------------------------------------------------------
		
//		public function get getterError():int {
//			throw new Error();
//		}
		
		public function set setter(value:int):void {
		}
		
		private var _variable:int = 7;

		protected const _constant:int = 8;
		
		flash_proxy function get _getter():int {
			return 9;
		}

		[Transient]
		public function get _accessor():int {
			return 10;
		}
		
		public function set _accessor(value:int):void {
		}
		
		public function method():void {
		}

	}
	
}