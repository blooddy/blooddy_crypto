package by.blooddy.crypto.serialization {

	import flash.utils.ByteArray;
	
	public class SimpleByteArray extends ByteArray {

		public function SimpleByteArray() {
			super();
		}

		public function toJSON(k:String):* {
			return this;
		}
		
	}

}