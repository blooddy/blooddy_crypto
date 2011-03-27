////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {

	import by.blooddy.crypto.security.utils.ARC4Random;
	import by.blooddy.math.utils.BigUint;
	
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.utils.Endian;
	import flash.display.Shape;
	import flash.utils.getTimer;
	import by.blooddy.math.utils.BigUintTest;
	import by.blooddy.system.Memory;
	import flash.system.ApplicationDomain;

	[Event(name="complete", type="flash.events.Event")]

	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					18.01.2011 3:56:37
	 */
	public class RSAKeyGenerator extends EventDispatcher {

		//--------------------------------------------------------------------------
		//
		//  Namespace
		//
		//--------------------------------------------------------------------------

		use namespace $internal;

		//--------------------------------------------------------------------------
		//
		//  Class properties
		//
		//--------------------------------------------------------------------------

		public static var frameTimeLimit:uint = 1e3 / 31; // 31 frame per second

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _domain:ApplicationDomain = ApplicationDomain.currentDomain;

		/**
		 * @private
		 */
		private static const enterFrameBroadcaster:Shape = new Shape();

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function random(bits:uint, pos:uint):BigUint {
			var len:uint = ( bits + 7 ) >>> 3;
			var end:uint = pos + len - 1;
			var fix:uint = len & 3;
			if ( fix ) fix = 4 - fix;
			var shift:uint = bits & 7;
			if ( shift ) shift = 8 - shift;
			var c:uint;
			var bu:BigUint;
			// Generate random bytes and mask out any excess bits
			// read pool
			ARC4Random.readPool( pos, len );
			// fix to the correct bitLength
			Memory.setI8( end, ( Memory.getUI8( end ) | 0x80 ) >>> shift );
			// fix to odd
			c = Memory.getUI8( pos );
			if ( c & 1 == 0 ) Memory.setI8( pos, c | 1 );
			// fix biguint
			if ( fix ) Memory.setI32( 0, end + 1 );
			return new BigUint( pos, len + fix );
		}

		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------

		/**
		 * Constructor
		 */
		public function RSAKeyGenerator() {
			super();
		}

		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _busy:Boolean = false;

		/**
		 * @private
		 */
		private var _keySize:uint;
		
		/**
		 * @private
		 */
		private var _lp:uint;

		/**
		 * @private
		 */
		private var _lq:uint;
		
		/**
		 * @private
		 */
		private var _pos:uint;
		
		/**
		 * @private
		 */
		private var _key:RSAPrivateKey;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private var _pair:RSAKeyPair;

		public function get pair():RSAKeyPair {
			return this._pair;
		}

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		public function generate(keySize:uint, e:uint):void {
			
			if ( this._busy ) throw new ArgumentError();
			this._busy = true;
			
			this._lp = ( keySize + 1 ) >>> 1;
			this._lq = keySize - this._lp;

			RSAPublicKey.internalCall = true;
			this._key = new RSAPrivateKey();
			this._key.bytes = new ByteArray();
			this._key.bytes.endian = Endian.LITTLE_ENDIAN;
			this._key.bytes.length = 65e4; // TODO: fix length
			this._key.bytes.writeInt( e );
			this._key.e = new BigUint( 0, 4 );

			this._pos = 4;

			// запускаем генерацию
			enterFrameBroadcaster.addEventListener( Event.ENTER_FRAME, this.handler_enterFrame );

		}

		//--------------------------------------------------------------------------
		//
		//  Event handlers
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private function handler_enterFrame(event:Event):void {

			var tmp:ByteArray = _domain.domainMemory;

			_domain.domainMemory = this._key.bytes;
			
			var t:uint = getTimer();

			var pos:uint = this._pos;

			var p:BigUint = this._key.p;
			var q:BigUint = this._key.q;
			var n:BigUint = this._key.n;

			var p1:BigUint;
			var q1:BigUint;
			var phi:BigUint;

			var bu:BigUint;

			do {

				// generate two random primes of size lp/lq
				if ( !p ) {

					do { // probablePrime
						p = random( this._lp, pos );
						if ( BigUint.isProbablePrime( p, 100 ) ) break;
						if ( getTimer() - t >= frameTimeLimit ) { // timelimit
							this._pos = pos;
							this._key.p = null;
							this._key.q = null;
							this._key.n = null;
							_domain.domainMemory = tmp;
							return;
						}
					} while ( true );
					pos = p.pos + p.len;

				}

				if ( !q || !n ) {

					do {

						do { // probablePrime
							q = random( this._lq, pos );
							if ( BigUint.isProbablePrime( q, 100 ) ) break;
							if ( getTimer() - t >= frameTimeLimit ) { // timelimit
								this._pos = pos;
								this._key.p = p;
								this._key.q = null;
								this._key.n = null;
								_domain.domainMemory = tmp;
								return;
							}
						} while ( true );

						// modulus n = p * q
						n = BigUint.mul( p, q, q.pos + q.len );
						// even with correctly sized p and q, there is a chance that
						// n will be one bit short. re-generate the smaller prime if so
					} while ( BigUint.getBitLength( n ) < this._keySize );
					pos = n.pos + n.len;

					if ( getTimer() - t >= frameTimeLimit ) { // timelimit
						this._pos = pos;
						this._key.p = p;
						this._key.q = q;
						this._key.n = n;
						_domain.domainMemory = tmp;
						return;
					}
					
				}

				// convention is for p > q
				if ( BigUint.compare( p, q ) < 0 ) {
					bu = p;
					p = q;
					q = bu;
				}
				
				// phi = (p - 1) * (q - 1) must be relative prime to e
				// otherwise RSA just won't work ;-)
				p1 = BigUint.dec( p, pos + 30e4 ); // TODO: fix pos
				q1 = BigUint.dec( q, p1.pos + p1.len );
				phi = BigUint.mul( p1, q1, q1.pos + q1.len );

				// generate new p and q until they work. typically
				// the first try will succeed when using F4
				bu = BigUint.gcd( this._key.e, phi, phi.pos + phi.len );
				if ( bu.len == 4 && Memory.getI32( bu.pos ) == 1 ) {
					break;
				} else {
					pos = 4;
					p = null;
					q = null;
					n = null;
				}

			} while ( true );

			this._key.n = n;
			this._key.d = bu = BigUint.modInverse( this._key.e, phi, pos );
			this._key.p = p;
			this._key.q = q;
			this._key.dp = bu = BigUint.mod( this._key.d, p1, bu.pos + bu.len );
			this._key.dq = bu = BigUint.mod( this._key.d, q1, bu.pos + bu.len );
			this._key.invq = bu = BigUint.modInverse( q, p, bu.pos + bu.len );

			_domain.domainMemory = tmp;

			// cut key
			var bytes:ByteArray = new ByteArray();
			bytes.writeBytes( this._key.bytes, 0, bu.pos + bu.len );
			this._key.bytes = bytes;

			// result
			this._pair = new RSAKeyPair( null, this._key );
			this._key = null;

			this._busy = false;
			enterFrameBroadcaster.removeEventListener( Event.ENTER_FRAME, this.handler_enterFrame );
			super.dispatchEvent( new Event( Event.COMPLETE ) );
			
		}

	}

}