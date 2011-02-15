package by.blooddy.crypto.security.utils {

	import flash.utils.getQualifiedClassName;

	[ExcludeClass]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 * @created					19.01.2011 15:58:29
	 *
	 * @see						http://www.w3.org/TR/xmldsig-core/#sec-RSAKeyValue
	 * @see						http://www.w3.org/TR/xkms2/#ElementRSAKeyPair
	 */
	public final class XMLKey {

		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static const _NS_RSA_KEY_PAIR:Namespace = new Namespace( 'http://www.w3.org/2002/03/xkms#' );

		/**
		 * @private
		 */
		private static const _NS_SIGNATURE:Namespace = new Namespace( 'http://www.w3.org/2000/09/xmldsig#' );

		/**
		 * @private
		 */
		private static const _NS_EMPTY:Namespace = new Namespace();

		/**
		 * @private
		 */
		private static var _privateCall:Boolean = false;

		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------

		public static function decode(xml:XML):Vector.<XMLKey> {

			var result:Vector.<XMLKey> = new Vector.<XMLKey>();

			var ns:Namespace = xml.namespace();
			if ( ns == _NS_RSA_KEY_PAIR || ( ns == _NS_EMPTY && xml.localName() == 'RSAKeyPair' ) ) {

				if ( isRSAKeyPair( xml, ns ) ) {
					result.push( createKey( xml, PEM.RSA_PRIVATE_KEY ) );
				}

			} else if ( ns == _NS_SIGNATURE || ns == _NS_EMPTY ) {

				var x:XML;

				if ( isRSAKeyValue( xml, ns ) ) {

					result.push( createKey( xml, PEM.RSA_PUBLIC_KEY ) );

				} else if ( isX509Certificate( xml, ns ) ) {

					result.push( createKey( xml, PEM.CERTIFICATE ) );

				} else if ( isKeyValue( xml, ns ) ) {

					xml = xml.ns::*[ 0 ];
					if ( isRSAKeyValue( xml, ns ) ) {
						result.push( createKey( xml, PEM.RSA_PUBLIC_KEY ) );
					} else {
						throw null;
					}

				} else if ( isX509Data( xml, ns ) ) {

					for each ( xml in xml.ns::X509Certificate ) {
						if ( isX509CertificateContent( xml, ns ) ) {
							result.push( createKey( xml, PEM.CERTIFICATE ) );
						}
					}

				} else if ( isSignature( xml, ns ) ) {

					var list:XMLList = xml.ns::*;
					if (
						list.length() >= 3 &&
						isNode( list[ 2 ], ns, 'KeyInfo' )	/// <KeyInfo (Id)?>
					) {
						xml = list[ 2 ];
					} else {
						throw null;
					}

				}

				if ( isNode( xml, ns, 'KeyInfo' ) ) {

					for each ( x in xml.ns::KeyValue ) {
						if ( isKeyValueContent( x, ns ) ) {
							x = x.ns::*[ 0 ];
							if ( isRSAKeyValue( x, ns ) ) {
								result.push( createKey( x, PEM.RSA_PUBLIC_KEY ) );
							}
						}
					}
					for each ( x in xml.ns::X509Data ) {
						if ( isX509DataContent( x, ns ) ) {
							for each ( x in x.ns::X509Certificate ) {
								if ( isX509CertificateContent( x, ns ) ) {
									result.push( createKey( x, PEM.CERTIFICATE ) );
								}
							}
						}
					}

				}

			}

			if ( result.length <= 0 ) {
				throw null;
			}

			return result;

		}

		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------

		/**
		 * @private
		 */
		private static function createKey(xml:XML, type:String):XMLKey {
			_privateCall = true;
			var result:XMLKey = new XMLKey();
			result.type = type;
			result.xml = xml;
			return result;
		}

		/**
		 * @private
		 * 
		 * 	<Node />
		 */
		private static function isNode(xml:XML, ns:Namespace, name:String):Boolean {
			return	xml.namespace() == ns	&&
					xml.localName() == name	;
		}

		/**
		 * @private
		 * 
		 * 	<Signature (Id)?>
     	 * 		<SignedInfo />
		 * 		<SignatureValue />
		 * 		( <KeyInfo /> )?
		 * 		( <Object /> )*
		 * 	</Signature>
		 */
		private static function isSignature(xml:XML, ns:Namespace):Boolean {
			if ( isNode( xml, ns, 'Signature' ) ) {
				var list:XMLList = xml.ns::*;
				if (
					list.length() >= 2					&&
					isSignedInfo( list[ 0 ], ns )		&&
					isValue( list[ 1 ], ns, 'SignatureValue' )
				) {
					return true;
				}
			}
			return false;
		}

		/**
		 * @private
		 * 
		 * 	<SignedInfo (Id)?>
		 * 		<CanonicalizationMethod /> := Method
		 * 		<SignatureMethod /> := Method
		 * 		( <Reference /> )+
		 * 	</SignedInfo>
		 */
		private static function isSignedInfo(xml:XML, ns:Namespace):Boolean {
			if ( isNode( xml, ns, 'SignedInfo' ) ) {
				var list:XMLList = xml.ns::*;
				var l:uint = list.length();
				if (
					l >= 3												&&
					isMethod( list[ 0 ], ns, 'CanonicalizationMethod' )	&&
					isMethod( list[ 1 ], ns, 'SignatureMethod' )
				) {
					for ( var i:uint = 2; i<l; ++i ) {
						if ( !isReference( list[ i ], ns ) ) {
							return false;
						}
					}
					return true;
				}
			}
			return false;
		}

		/**
		 * @private
		 * 
		 * 	<Method Algorithm>
		 * 		( < /> )*
		 * 	</Method>
		 */
		private static function isMethod(xml:XML, ns:Namespace, name:String):Boolean {
			return	isNode( xml, ns, name )	&&
					'@Algorithm' in xml		;
		}

		/**
		 * @private
		 * 
		 * 	<Reference (Id)? (URI)? (Type)?>
		 * 		( <Transforms /> )?
		 * 		<DigestMethod /> := Method
		 * 		<DigestValue />
		 * 	</Reference>
		 */
		private static function isReference(xml:XML, ns:Namespace):Boolean {
			if ( isNode( xml, ns, 'Reference' ) ) {
				var list:XMLList = xml.ns::*;
				var l:uint = list.length();
				if (
					l >= 2 &&
					isValue( list[ l - 1 ], ns, 'DigestValue' ) &&
					isMethod( list[ l - 2 ], ns, 'DigestMethod' )
				) {
					return true;
				}
			}
			return false;
		}

		/**
		 * @private
		 * 
		 * 	<Value (Id)?>
		 * 		data
		 * 	</Value>
		 */
		private static function isValue(xml:XML, ns:Namespace, name:String):Boolean {
			return	isNode( xml, ns, name )	&&
					xml.hasSimpleContent()	;
		}

		/**
		 * @private
		 * 	<?>
		 * 		<? />
		 * 	</?>
		 */
		private static function isKeyValueContent(xml:XML, ns:Namespace):Boolean {
			return	xml.hasComplexContent()	&&
					xml.ns::*.length() == 1	;
		}

		/**
		 * @private
		 * 
		 * 	<KeyValue>
		 * 		<? />
		 * 	</KeyValue>
		 */
		private static function isKeyValue(xml:XML, ns:Namespace):Boolean {
			return	isNode( xml, ns, 'KeyValue' ) 	&&
					isKeyValueContent( xml, ns )	;
		}

		/**
		 * @private
		 * 	<?>
		 * 		( <? /> )+
		 * 	</?>
		 */
		private static function isX509DataContent(xml:XML, ns:Namespace):Boolean {
			return	xml.hasComplexContent()	&&
					xml.ns::*.length() >= 1	;
		}

		/**
		 * @private
		 * 
		 * 	<X509Data>
		 * 		<? />
		 * 	</X509Data>
		 */
		private static function isX509Data(xml:XML, ns:Namespace):Boolean {
			return	isNode( xml, ns, 'X509Data' ) 	&&
					isX509DataContent( xml, ns )	;
		}

		/**
		 * @private
		 * 
		 * 	data
		 */
		private static function isX509CertificateContent(xml:XML, ns:Namespace):Boolean {
			return xml.hasSimpleContent();
		}

		/**
		 * @private
		 * 
		 * 	<X509Certificate>
		 * 		data
		 * 	</X509Certificate> 
		 */
		private static function isX509Certificate(xml:XML, ns:Namespace):Boolean {
			return isValue( xml, ns, 'X509Certificate' );
		}

		/**
		 * @private
		 */
		private static function isRSAKeyValue(xml:XML, ns:Namespace):Boolean {
			if ( isNode( xml, ns, 'RSAKeyValue' ) ) {
				var list:XMLList = xml.ns::*;
				if (
					list.length() == 2						&&
					isValue( list[ 0 ], ns, 'Modulus' )		&&
					isValue( list[ 1 ], ns, 'Exponent' )
				) {
					return true;
				}
			}
			return false;
		}

		/**
		 * @private
		 */
		private static function isRSAKeyPair(xml:XML, ns:Namespace):Boolean {
			if ( isNode( xml, ns, 'RSAKeyPair' ) ) {
				var list:XMLList = xml.ns::*;
				if (
					list.length() == 8						&&
					isValue( list[ 0 ], ns, 'Modulus' )		&&
					isValue( list[ 1 ], ns, 'Exponent' )	&&
					isValue( list[ 2 ], ns, 'P' )			&&
					isValue( list[ 3 ], ns, 'Q' )			&&
					isValue( list[ 4 ], ns, 'DP' )			&&
					isValue( list[ 5 ], ns, 'DQ' )			&&
					isValue( list[ 6 ], ns, 'InverseQ' )	&&
					isValue( list[ 7 ], ns, 'D' )
				) {
					return true;
				}
			}
			return false;
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
		public function XMLKey() {
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

		public var xml:XML;

	}

}