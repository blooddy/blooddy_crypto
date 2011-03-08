////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2010 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.utils {

	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					18.01.2011 4:49:57
	 * 
	 * @see						http://en.wikipedia.org/wiki/ASN1
	 */
	public final class ASN1Key {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static var _privateCall:Boolean = false;

		/**
		 * @private
		 */
		private static const _OID_RSA_ENCRYPTION:String =	'1.2.840.113549.1.1.1';

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function readMemory(pos:uint, length:uint, type:String=null):ASN1Key {

			var t:DER = DER.readMemory( pos, length );
			if ( !t ) throw null;

			if ( !type || type == PEM.CERTIFICATE ) {
				if ( isCertificate( t ) ) {
					t = t.seq[ 0 ].seq[ 5 ];
					type = PEM.PUBLIC_KEY;
				} else if ( type ) {
					throw null;
				}
			}

			var result:ASN1Key;

			if ( !type || type == PEM.PUBLIC_KEY ) {
				if ( isSubjectPublicKeyInfo( t ) ) {

					switch ( t.seq[ 0 ].seq[ 0 ].oid ) {
						case _OID_RSA_ENCRYPTION:	type = PEM.RSA_PUBLIC_KEY;	break;
						default:	throw null;
					}
					t = t.seq[ 1 ];
					t = DER.readMemory( t.block.pos, t.block.pos + t.block.len );

				} else if ( type ) {
					throw null;
				}
			}

			if ( !type || type == PEM.PRIVATE_KEY ) {
				if ( isPrivateKeyInfo( t ) ) {

					switch ( t.seq[ 1 ].seq[ 0 ].oid ) {
						case _OID_RSA_ENCRYPTION:	type = PEM.RSA_PRIVATE_KEY;	break;
						default:	throw null;
					}
					t = t.seq[ 2 ];
					t = DER.readMemory( t.block.pos, t.block.pos + t.block.len );

				} else if ( type ) {
					throw null;
				}
			}

			if ( !type || type == PEM.RSA_PUBLIC_KEY ) {
				if ( isRSAPublicKey( t ) ) {
					return createKey( t, PEM.RSA_PUBLIC_KEY );
				} else if ( type ) {
					throw null;
				}
			}

			if ( !type || type == PEM.RSA_PRIVATE_KEY ) {
				if ( isRSAPrivateKey( t ) ) {
					return createKey( t, PEM.RSA_PRIVATE_KEY );
				} else if ( type ) {
					throw null;
				}
			}

			throw null;

		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function createKey(t:DER, type:String):ASN1Key {
			_privateCall = true;
			var result:ASN1Key = new ASN1Key();
			result.type = type;
			result.der = t;
			return result;
		}

		/**
		 * @private
		 * 
		 * 	Certificate ::= SEQUENCE {
		 * 		tbsCertificate			TBSCertificate,
		 * 		signatureAlgorithm		AlgorithmIdentifier,
		 * 		signatureValue			BIT_STRING
		 * 	}
		 */
		private static function isCertificate(t:DER):Boolean {
			return	t.type == DER.SEQUENCE				&&
					t.seq.length == 3					&&
					t.seq[ 2 ].type == DER.BIT_STRING	&&	// signatureValue
					isAlgorithmIdentifier( t.seq[ 1 ] )	&&	// signatureAlgorithm
					isTBSCertificate( t.seq[ 0 ] )		;	// tbsCertificate
		}

		/**
		 * @private
		 * 
		 * 	AlgorithmIdentifier  ::=  SEQUENCE  {
		 * 		algorithm				OBJECT_IDENTIFIER,
		 * 		parameters				ANY DEFINED BY algorithm OPTIONAL
		 * 	}
		 */
		private static function isAlgorithmIdentifier(t:DER):Boolean {
			return	t.type == DER.SEQUENCE						&&
					t.seq.length == 2							&&
					t.seq[ 0 ].type == DER.OBJECT_IDENTIFIER	;	// algorithm
		}

		/**
		 * @private
		 * 
		 * 	TBSCertificate ::= SEQUENCE {
		 * 		version				[0]	EXPLICIT Version DEFAULT v1,
		 * 		serialNumber			INTEGER,
		 * 		signature				AlgorithmIdentifier,
		 * 		issuer					Name,
		 * 		validity				Validity,
		 * 		subject					Name,
		 * 		subjectPublicKeyInfo	SubjectPublicKeyInfo,
		 * 		issuerUniqueID		[1]	IMPLICIT UniqueIdentifier OPTIONAL,	-- If present, version MUST be v2 or v3
		 * 		subjectUniqueID		[2]	IMPLICIT UniqueIdentifier OPTIONAL,	-- If present, version MUST be v2 or v3
		 * 		extensions			[3]	EXPLICIT Extensions OPTIONAL		-- If present, version MUST be v3
		 * 	}
		 */
		private static function isTBSCertificate(t:DER):Boolean {
			return	t.type == DER.SEQUENCE					&&
					t.seq.length >= 6						&&
					t.seq[ 0 ].type == DER.INTEGER			&&	// serialNumber
					isAlgorithmIdentifier( t.seq[ 1 ] ) 	&&	// signature
					t.seq[ 2 ].type == DER.SEQUENCE			&&	// issuer
					isValidity( t.seq[ 3 ] )				&&	// validity
					t.seq[ 4 ].type == DER.SEQUENCE			&&	// subject
					isSubjectPublicKeyInfo( t.seq[ 5 ] )	;	// subjectPublicKeyInfo
					// TODO: issuerUniqueID, subjectUniqueID, extensions
		}

		/**
		 * @private
		 * 
		 * 	Validity ::= SEQUENCE {
		 * 		notBefore				Time,
		 * 		notAfter				Time
		 * 	}
		 */
		private static function isValidity(t:DER):Boolean {
			return	t.type == DER.SEQUENCE	&&
					t.seq.length == 2		&&
					isTime( t.seq[ 0 ] )	&&	// notBefore
					isTime( t.seq[ 1 ] )	;	// notAfter
		}

		/**
		 * @private
		 * 
		 * 	Time ::= CHOICE { UTCTime, GeneralizedTime }
		 */
		private static function isTime(t:DER):Boolean {
			return	t.type == DER.UTC_TIME			||
					t.type == DER.GENERALIZED_TIME	;
		}

		/**
		 * @private
		 * 
		 * 	SubjectPublicKeyInfo ::= SEQUENCE {
		 * 		algorithm				AlgorithmIdentifier,
		 * 		subjectPublicKey		BIT_STRING
		 * 	}
		 */
		private static function isSubjectPublicKeyInfo(t:DER):Boolean {
			return	t.type == DER.SEQUENCE				&&
					t.seq.length == 2					&&
					t.seq[ 1 ].type == DER.BIT_STRING	&&	// subjectPublicKey
					isAlgorithmIdentifier( t.seq[ 0 ] )	;	// algorithm
		}

		/**
		 * @private
		 * 
		 * 	PrivateKeyInfo ::= SEQUENCE {
		 * 		version					INTEGER,
		 * 		privateKeyAlgorithm		AlgorithmIdentifier,
		 * 		privateKey				OCTET_STRING
		 * 		attributes			[0]	IMPLICIT Attributes OPTIONAL
		 * 	}
		 */
		private static function isPrivateKeyInfo(t:DER):Boolean {
			return	t.type == DER.SEQUENCE				&&
					t.seq.length >= 3					&&
					t.seq[ 0 ].type == DER.INTEGER		&&	// version
					t.seq[ 2 ].type == DER.OCTET_STRING	&&	// privateKey
					isAlgorithmIdentifier( t.seq[ 1 ] )	;	// privateKeyAlgorithm
					// TODO: attributes
		}

		/**
		 * 	RSAPublicKey ::= SEQUENCE {
		 * 		modulus					INTEGER,	-- n
		 * 		publicExponent			INTEGER		-- e
		 * 	}
		 */
		private static function isRSAPublicKey(t:DER):Boolean {
			return	t.type == DER.SEQUENCE			&&
					t.seq.length == 2				&&
					t.seq[ 0 ].type == DER.INTEGER	&&	// n
					t.seq[ 1 ].type == DER.INTEGER	;	// e
		}

		/**
		 * 	RSAPrivateKey ::= SEQUENCE {
		 * 		version				INTEGER,
		 * 		modulus				INTEGER,	-- n
		 * 		publicExponent		INTEGER,	-- e
		 * 		privateExponent		INTEGER,	-- d
		 * 		prime1				INTEGER,	-- p
		 * 		prime2				INTEGER,	-- q
		 * 		exponent1			INTEGER,	-- d mod (p-1)
		 * 		exponent2			INTEGER,	-- d mod (q-1)
		 * 		coefficient			INTEGER,	-- (inverse of q) mod p
		 * 		otherPrimeInfos	[0]	OtherPrimeInfos OPTIONAL
		 * 	}
		 */
		private static function isRSAPrivateKey(t:DER):Boolean {
			return	t.type == DER.SEQUENCE			&&
					t.seq.length >= 9				&&
					t.seq[ 0 ].type == DER.INTEGER	&&	// version
					t.seq[ 1 ].type == DER.INTEGER	&&	// modulus
					t.seq[ 2 ].type == DER.INTEGER	&&	// publicExponent
					t.seq[ 3 ].type == DER.INTEGER	&&	// privateExponent
					t.seq[ 4 ].type == DER.INTEGER	&&	// prime1
					t.seq[ 5 ].type == DER.INTEGER	&&	// prime2
					t.seq[ 6 ].type == DER.INTEGER	&&	// exponent1
					t.seq[ 7 ].type == DER.INTEGER	&&	// exponent2
					t.seq[ 8 ].type == DER.INTEGER	;	// coefficient
					// TODO: otherPrimeInfos
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
		public function ASN1Key() {
			super();
			if ( !_privateCall ) Error.throwError( ArgumentError, 2012, getQualifiedClassName( this ) );
			_privateCall = false;
		}

		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------

		public var type:String;

		public var der:DER;

	}

}