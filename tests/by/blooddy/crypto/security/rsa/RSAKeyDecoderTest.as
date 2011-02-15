////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2011 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.security.rsa {
	
	import flash.utils.ByteArray;
	
	import flexunit.framework.Assert;
	
	import org.flexunit.runners.Parameterized;

	[RunWith( "org.flexunit.runners.Parameterized" )]
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 10
	 * @langversion				3.0
	 */
	public class RSAKeyDecoderTest {

		//--------------------------------------------------------------------------
		//
		//  Class initialization
		//
		//--------------------------------------------------------------------------

		Parameterized;

		XML.ignoreComments = true;
		XML.ignoreProcessingInstructions = true;
		XML.ignoreWhitespace = true;
		XML.prettyPrinting = false;

		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------

		//----------------------------------
		//  decodeDER
		//----------------------------------

		public static var $decodeDER:Array = [
		];

		[Test( order="1", dataProvider="$decodeDER" )]
		public function decodeDER(der:ByteArray, result:String):void {
			Assert.assertEquals(
				RSAKeyDecoder.decodeDER( der ).toString(),
				result
			);
		}

		//----------------------------------
		//  decodeDER_error
		//----------------------------------
		
		public static var $decodeDER_error:Array = [
		];
		
		[Test( order="2", dataProvider="$decodeDER_error", expects="SyntaxError" )]
		public function decodeDER_error(der:ByteArray):void {
			RSAKeyDecoder.decodeDER( der );
		}

		//----------------------------------
		//  decodePEM
		//----------------------------------
		
		public static var $decodePEM:Array = [
			[

				'-----BEGIN RSA PRIVATE KEY-----' +
				'MGQCAQACEQDJG3bkuB9Ie7jOldQTVdzPAgMBAAECEQCOGqcPhP8t8mX8cb4cQEaR' +
				'AgkA5WTYuAGmH0cCCQDgbrto0i7qOQIINYr5btGrtccCCQCYy4qX4JDEMQIJAJll' +
				'OnLVtCWk' +
				'-----END RSA PRIVATE KEY-----',

				'[RSAKeyPair ([RSAPrivateKey n="c91b76e4b81f487bb8ce95d41355dccf" e="10001" d="8e1aa70f84ff2df265fc71be1c404691" P="e564d8b801a61f47" Q="e06ebb68d22eea39" dP="358af96ed1abb5c7" dQ="98cb8a97e090c431" iQ="99653a72d5b425a4"],[RSAPublicKey n="c91b76e4b81f487bb8ce95d41355dccf" e="10001"])]'

			],
			[

				'-----BEGIN PUBLIC KEY-----' +
				'MCwwDQYJKoZIhvcNAQEBBQADGwAwGAIRAMkbduS4H0h7uM6V1BNV3M8CAwEAAQ==' +
				'-----END PUBLIC KEY-----',

				'[RSAKeyPair (null,[RSAPublicKey n="c91b76e4b81f487bb8ce95d41355dccf" e="10001"])]'

			],
			[

				'-----BEGIN PUBLIC KEY-----' +
				'MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALHpyYTN96rMbkQB' +
				'gIoB9vH2AN47NN1YXoKxAaqpEkafQdPUw41p4gTrA0r04acE' +
				'm3GaWUA4YROCSKgJnvii0UsCAwEAAQ==' +
				'-----END PUBLIC KEY-----',

				'[RSAKeyPair (null,[RSAPublicKey n="b1e9c984cdf7aacc6e4401808a01f6f1f600de3b34dd585e82b101aaa912469f41d3d4c38d69e204eb034af4e1a7049b719a59403861138248a8099ef8a2d14b" e="10001"])]'

			],
			[

				'-----BEGIN CERTIFICATE-----'+
				'MIICNDCCAaECEAKtZn5ORf5eV288mBle3cAwDQYJKoZIhvcNAQECBQAwXzELMAkG'+
				'A1UEBhMCVVMxIDAeBgNVBAoTF1JTQSBEYXRhIFNlY3VyaXR5LCBJbmMuMS4wLAYD'+
				'VQQLEyVTZWN1cmUgU2VydmVyIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MB4XDTk0'+
				'MTEwOTAwMDAwMFoXDTEwMDEwNzIzNTk1OVowXzELMAkGA1UEBhMCVVMxIDAeBgNV'+
				'BAoTF1JTQSBEYXRhIFNlY3VyaXR5LCBJbmMuMS4wLAYDVQQLEyVTZWN1cmUgU2Vy'+
				'dmVyIENlcnRpZmljYXRpb24gQXV0aG9yaXR5MIGbMA0GCSqGSIb3DQEBAQUAA4GJ'+
				'ADCBhQJ+AJLOesGugz5aqomDV6wlAXYMra6OLDfO6zV4ZFQD5YRAUcm/jwjiioII'+
				'0haGN1XpsSECrXZogZoFokvJSyVmIlZsiAeP94FZbYQHZXATcXY+m3dM41CJVphI'+
				'uR2nKRoTLkoRWZweFdVJVCxzOmmCsZc5nG1wZ0jl3S3WyB57AgMBAAEwDQYJKoZI'+
				'hvcNAQECBQADfgBl3X7hsuyw4jrg7HFGmhkRuNPHoLQDQCYCPgmc4RKz0Vr2N6W3'+
				'YQO2WxZpO8ZECAyIUwxrl0nHPjXcbLm7qt9cuzovk2C2qUtN8iD3zV9/ZHuO3ABc'+
				'1/p3yjkWWW8O6tO1g39NTUJWdrTJXwT4OPjr0l91X817/OWOgHz8UA=='+
				'-----END CERTIFICATE-----',

				'[RSAKeyPair (null,[RSAPublicKey n="92ce7ac1ae833e5aaa898357ac2501760cadae8e2c37ceeb3578645403e5844051c9bf8f08e28a8208d216863755e9b12102ad7668819a05a24bc94b256622566c88078ff781596d840765701371763e9b774ce35089569848b91da7291a132e4a11599c1e15d549542c733a6982b197399c6d706748e5dd2dd6c81e7b" e="10001"])]'

			]
		];

		[Test( order="3", dataProvider="$decodePEM" )]
		public function decodePEM(pem:String, result:String):void {
			Assert.assertEquals(
				RSAKeyDecoder.decodePEM( pem ).toString(),
				result
			);
		}

		//----------------------------------
		//  decodePEM_error
		//----------------------------------
		
		public static var $decodePEM_error:Array = [
		];

		[Test( order="4", dataProvider="$decodePEM_error", expects="SyntaxError" )]
		public function decodePEM_error(pem:String):void {
			RSAKeyDecoder.decodePEM( pem );
		}

		//----------------------------------
		//  testDecodeXML
		//----------------------------------

		public static var $decodeXML:Array = [
			[
				'<RSAKeyPair xmlns="http://www.w3.org/2002/03/xkms#">' +
					'<Modulus>' +
						'0nIsmR+aVW2egl5MIfOKy4HuMKkk9AZ/IQuDLVPlhzOfgngjVQCjr8uvmnqtNu8HBupui8LgG' +
						'thO6U9D0CNT5mbmhIAErRADUMIAFsi7LzBarUvNWTqYNEJmcHsAUZdrdcDrkNnG7SzbuJx+GD' +
						'NiHKVDQggPBLc1XagW20RMvok=' +
					'</Modulus>' +
					'<Exponent>' +
						'AQAB' +
					'</Exponent>' +
					'<P>' +
						'7p05u5P4BO+aXdyD/6n31a4Dk9kC4Tv5fMbE15/ioPii9JwPU2J29qhO1QEqvgNwxv67w4jrC' +
						'025Yz5LXgjziw==' +
					'</P>' +
					'<Q>' +
						'4ceKAtGgSJg8ddRxwz8OESXVOd1tlSHFu7Gqona3VxbrOONLZEbsnYA4dv4nI+pxl8PmUe5CP' +
						'gggGElx30OIuw==' +
					'</Q>' +
					'<DP>' +
						've9rEDQVfaBYCRTKAY2DGJT+hgZ881qxGjCCaXz8gdPIqts6m85KEcchkQ3vvvawI8aLIXdwW' +
						'TwSMLxac8y+Rw==' +
					'</DP>' +
					'<DQ>' +
						'jW/x3ggx76gmn+3hAl3a0xUvORukjTrl4snOyg2ylsUNv8prrTrc+WGcfbaDEHXKiTc4bnTiX' +
						'He8m1pPEnz9Bw==' +
					'</DQ>' +
					'<InverseQ>' +
						'yxCo+k0v8n80Qeo2QAGKiwltLF+1ObyZ1TQg4chISWdfLD+j1nIKIs1miELdszjO/szLWMx5k' +
						'A3kOLi6jXsByw==' +
					'</InverseQ>' +
					'<D>' +
						'aeLWu8jh75/zRGdL6T1QFatvfH5uwHXQW4EeZJ00/P0lghEOvgNPWPGkjpaxNtW39GvaaWoJN' +
						'pilw9CFL2HHIVn1OVZyw5BDbotQty3lm66KL7qtrjqlqyPu5ARglGqTZIaRyP8LW6NAbkyxLP' +
						'npADVfHJuEePmooCmHbTValP0=' +
					'</D>' +
				'</RSAKeyPair>',
				'[RSAKeyPair ([RSAPrivateKey n="d2722c991f9a556d9e825e4c21f38acb81ee30a924f4067f210b832d53e587339f8278235500a3afcbaf9a7aad36ef0706ea6e8bc2e01ad84ee94f43d02353e666e6848004ad100350c20016c8bb2f305aad4bcd593a98344266707b0051976b75c0eb90d9c6ed2cdbb89c7e1833621ca54342080f04b7355da816db444cbe89" e="10001" d="69e2d6bbc8e1ef9ff344674be93d5015ab6f7c7e6ec075d05b811e649d34fcfd2582110ebe034f58f1a48e96b136d5b7f46bda696a093698a5c3d0852f61c72159f5395672c390436e8b50b72de59bae8a2fbaadae3aa5ab23eee40460946a93648691c8ff0b5ba3406e4cb12cf9e900355f1c9b8478f9a8a029876d355a94fd" P="ee9d39bb93f804ef9a5ddc83ffa9f7d5ae0393d902e13bf97cc6c4d79fe2a0f8a2f49c0f536276f6a84ed5012abe0370c6febbc388eb0b4db9633e4b5e08f38b" Q="e1c78a02d1a048983c75d471c33f0e1125d539dd6d9521c5bbb1aaa276b75716eb38e34b6446ec9d803876fe2723ea7197c3e651ee423e0820184971df4388bb" dP="bdef6b1034157da0580914ca018d831894fe86067cf35ab11a3082697cfc81d3c8aadb3a9bce4a11c721910defbef6b023c68b217770593c1230bc5a73ccbe47" dQ="8d6ff1de0831efa8269fede1025ddad3152f391ba48d3ae5e2c9ceca0db296c50dbfca6bad3adcf9619c7db6831075ca8937386e74e25c77bc9b5a4f127cfd07" iQ="cb10a8fa4d2ff27f3441ea3640018a8b096d2c5fb539bc99d53420e1c84849675f2c3fa3d6720a22cd668842ddb338cefecccb58cc79900de438b8ba8d7b01cb"],[RSAPublicKey n="d2722c991f9a556d9e825e4c21f38acb81ee30a924f4067f210b832d53e587339f8278235500a3afcbaf9a7aad36ef0706ea6e8bc2e01ad84ee94f43d02353e666e6848004ad100350c20016c8bb2f305aad4bcd593a98344266707b0051976b75c0eb90d9c6ed2cdbb89c7e1833621ca54342080f04b7355da816db444cbe89" e="10001"])]'
			],
			[
				'<RSAKeyValue>' +
					'<Modulus>' +
						'uCiukpgOaOmrq1fPUTH3CAXxuFmPjsmS4jnTKxrv0w1JKcXtJ2M3akaV1d/karvJ' +
						'lmeao20jNy9r+/vKwibjM77F+3bIkeMEGmAIUnFciJkR+ihO7b4cTuYnEi8xHtu4' +
						'iMn6GODBoEzqFQYdd8p4vrZBsvs44nTrS8qyyhba648=' +
					'</Modulus>' +
					'<Exponent>' +
						'AQAB' +
					'</Exponent>' +
				'</RSAKeyValue>',
				'[RSAKeyPair (null,[RSAPublicKey n="b828ae92980e68e9abab57cf5131f70805f1b8598f8ec992e239d32b1aefd30d4929c5ed2763376a4695d5dfe46abbc996679aa36d23372f6bfbfbcac226e333bec5fb76c891e3041a600852715c889911fa284eedbe1c4ee627122f311edbb888c9fa18e0c1a04cea15061d77ca78beb641b2fb38e274eb4bcab2ca16daeb8f" e="10001"])]'
			],
			[
				'<X509Certificate>' +
					'MIICeDCCAeGgAwIBAgIEOd3+iDANBgkqhkiG9w0BAQQFADBbMQswCQYDVQQGEwJJ' +
					'RTEPMA0GA1UECBMGRHVibGluMSUwIwYDVQQKExxCYWx0aW1vcmUgVGVjaG5vbG9n' +
					'aWVzLCBMdGQuMRQwEgYDVQQDEwtUZXN0IFJTQSBDQTAeFw0wMDEwMDYxNjMyMDda' +
					'Fw0wMTEwMDYxNjMyMDRaMF0xCzAJBgNVBAYTAklFMQ8wDQYDVQQIEwZEdWJsaW4x' +
					'JTAjBgNVBAoTHEJhbHRpbW9yZSBUZWNobm9sb2dpZXMsIEx0ZC4xFjAUBgNVBAMT' +
					'DU1lcmxpbiBIdWdoZXMwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALgorpKY' +
					'Dmjpq6tXz1Ex9wgF8bhZj47JkuI50ysa79MNSSnF7SdjN2pGldXf5Gq7yZZnmqNt' +
					'Izcva/v7ysIm4zO+xft2yJHjBBpgCFJxXIiZEfooTu2+HE7mJxIvMR7buIjJ+hjg' +
					'waBM6hUGHXfKeL62QbL7OOJ060vKssoW2uuPAgMBAAGjRzBFMB4GA1UdEQQXMBWB' +
					'E21lcmxpbkBiYWx0aW1vcmUuaWUwDgYDVR0PAQH/BAQDAgeAMBMGA1UdIwQMMAqA' +
					'CEngrZIVgu03MA0GCSqGSIb3DQEBBAUAA4GBAHJu4JVq/WnXK2oqqfLWqes5vHOt' +
					'fX/ZhCjFyDMhzslI8am62gZedwZ9IIZIwlNRMvEDQB2zds/eEBnIAQPl/yRLCLOf' +
					'ZnbA8PXrbFP5igs3qQWScBUjZVjik748HU2sUVZOa90c0mJl2vJs/RwyLW7/uCAf' +
					'C/I/k9xGr7fneoIW' +
				'</X509Certificate>',
				'[RSAKeyPair (null,[RSAPublicKey n="b828ae92980e68e9abab57cf5131f70805f1b8598f8ec992e239d32b1aefd30d4929c5ed2763376a4695d5dfe46abbc996679aa36d23372f6bfbfbcac226e333bec5fb76c891e3041a600852715c889911fa284eedbe1c4ee627122f311edbb888c9fa18e0c1a04cea15061d77ca78beb641b2fb38e274eb4bcab2ca16daeb8f" e="10001"])]'
			],
			[
				'<KeyValue>' +
					'<RSAKeyValue>' +
						'<Modulus>' +
							'uCiukpgOaOmrq1fPUTH3CAXxuFmPjsmS4jnTKxrv0w1JKcXtJ2M3akaV1d/karvJ' +
							'lmeao20jNy9r+/vKwibjM77F+3bIkeMEGmAIUnFciJkR+ihO7b4cTuYnEi8xHtu4' +
							'iMn6GODBoEzqFQYdd8p4vrZBsvs44nTrS8qyyhba648=' +
						'</Modulus>' +
						'<Exponent>' +
							'AQAB' +
						'</Exponent>' +
					'</RSAKeyValue>' +
				'</KeyValue>',
				'[RSAKeyPair (null,[RSAPublicKey n="b828ae92980e68e9abab57cf5131f70805f1b8598f8ec992e239d32b1aefd30d4929c5ed2763376a4695d5dfe46abbc996679aa36d23372f6bfbfbcac226e333bec5fb76c891e3041a600852715c889911fa284eedbe1c4ee627122f311edbb888c9fa18e0c1a04cea15061d77ca78beb641b2fb38e274eb4bcab2ca16daeb8f" e="10001"])]'
			],
			[
				'<X509Data>' +
					'<X509SubjectName>' +
						'CN=Merlin Hughes,O=Baltimore Technologies\, Ltd.,ST=Dublin,C=IE' +
					'</X509SubjectName>' +
					'<X509IssuerSerial>' +
						'<X509IssuerName>' +
							'CN=Test RSA CA,O=Baltimore Technologies\, Ltd.,ST=Dublin,C=IE' +
						'</X509IssuerName>' +
						'<X509SerialNumber>970849928</X509SerialNumber>' +
					'</X509IssuerSerial>' +
					'<X509Certificate>' +
						'MIICeDCCAeGgAwIBAgIEOd3+iDANBgkqhkiG9w0BAQQFADBbMQswCQYDVQQGEwJJ' +
						'RTEPMA0GA1UECBMGRHVibGluMSUwIwYDVQQKExxCYWx0aW1vcmUgVGVjaG5vbG9n' +
						'aWVzLCBMdGQuMRQwEgYDVQQDEwtUZXN0IFJTQSBDQTAeFw0wMDEwMDYxNjMyMDda' +
						'Fw0wMTEwMDYxNjMyMDRaMF0xCzAJBgNVBAYTAklFMQ8wDQYDVQQIEwZEdWJsaW4x' +
						'JTAjBgNVBAoTHEJhbHRpbW9yZSBUZWNobm9sb2dpZXMsIEx0ZC4xFjAUBgNVBAMT' +
						'DU1lcmxpbiBIdWdoZXMwgZ8wDQYJKoZIhvcNAQEBBQADgY0AMIGJAoGBALgorpKY' +
						'Dmjpq6tXz1Ex9wgF8bhZj47JkuI50ysa79MNSSnF7SdjN2pGldXf5Gq7yZZnmqNt' +
						'Izcva/v7ysIm4zO+xft2yJHjBBpgCFJxXIiZEfooTu2+HE7mJxIvMR7buIjJ+hjg' +
						'waBM6hUGHXfKeL62QbL7OOJ060vKssoW2uuPAgMBAAGjRzBFMB4GA1UdEQQXMBWB' +
						'E21lcmxpbkBiYWx0aW1vcmUuaWUwDgYDVR0PAQH/BAQDAgeAMBMGA1UdIwQMMAqA' +
						'CEngrZIVgu03MA0GCSqGSIb3DQEBBAUAA4GBAHJu4JVq/WnXK2oqqfLWqes5vHOt' +
						'fX/ZhCjFyDMhzslI8am62gZedwZ9IIZIwlNRMvEDQB2zds/eEBnIAQPl/yRLCLOf' +
						'ZnbA8PXrbFP5igs3qQWScBUjZVjik748HU2sUVZOa90c0mJl2vJs/RwyLW7/uCAf' +
						'C/I/k9xGr7fneoIW' +
					'</X509Certificate>' +
				'</X509Data>',
				'[RSAKeyPair (null,[RSAPublicKey n="b828ae92980e68e9abab57cf5131f70805f1b8598f8ec992e239d32b1aefd30d4929c5ed2763376a4695d5dfe46abbc996679aa36d23372f6bfbfbcac226e333bec5fb76c891e3041a600852715c889911fa284eedbe1c4ee627122f311edbb888c9fa18e0c1a04cea15061d77ca78beb641b2fb38e274eb4bcab2ca16daeb8f" e="10001"])]'
			],
			[
				'<Signature xmlns="http://www.w3.org/2000/09/xmldsig#">' +
					'<SignedInfo>' +
						'<CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />' +
						'<SignatureMethod Algorithm="http://www.w3.org/2000/09/xmldsig#rsa-sha1" />' +
						'<Reference URI="http://www.w3.org/TR/xml-stylesheet">' +
							'<DigestMethod Algorithm="http://www.w3.org/2000/09/xmldsig#sha1" />' +
							'<DigestValue>60NvZvtdTB+7UnlLp/H24p7h4bs=</DigestValue>' +
						'</Reference>' +
					'</SignedInfo>' +
					'<SignatureValue>' +
						'juS5RhJ884qoFR8flVXd/rbrSDVGn40CapgB7qeQiT+rr0NekEQ6BHhUA8dT3+BC' +
						'TBUQI0dBjlml9lwzENXvS83zRECjzXbMRTUtVZiPZG2pqKPnL2YU3A9645UCjTXU' +
						'+jgFumv7k78hieAGDzNci+PQ9KRmm//icT7JaYztgt4=' +
					'</SignatureValue>' +
					'<KeyInfo>' +
						'<X509Data>' +
							'<X509SubjectName>' +
								'CN=Merlin Hughes,O=Baltimore Technologies\, Ltd.,ST=Dublin,C=IE' +
							'</X509SubjectName>' +
							'<X509IssuerSerial>' +
								'<X509IssuerName>' +
									'CN=Test RSA CA,O=Baltimore Technologies\, Ltd.,ST=Dublin,C=IE' +
								'</X509IssuerName>' +
								'<X509SerialNumber>970849928</X509SerialNumber>' +
							'</X509IssuerSerial>' +
						'</X509Data>' +
						'<KeyValue>' +
							'<RSAKeyValue>' +
								'<Modulus>' +
									'uCiukpgOaOmrq1fPUTH3CAXxuFmPjsmS4jnTKxrv0w1JKcXtJ2M3akaV1d/karvJ' +
									'lmeao20jNy9r+/vKwibjM77F+3bIkeMEGmAIUnFciJkR+ihO7b4cTuYnEi8xHtu4' +
									'iMn6GODBoEzqFQYdd8p4vrZBsvs44nTrS8qyyhba648=' +
								'</Modulus>' +
								'<Exponent>' +
									'AQAB' +
								'</Exponent>' +
							'</RSAKeyValue>' +
						'</KeyValue>' +
					'</KeyInfo>' +
				'</Signature>',
				'[RSAKeyPair (null,[RSAPublicKey n="b828ae92980e68e9abab57cf5131f70805f1b8598f8ec992e239d32b1aefd30d4929c5ed2763376a4695d5dfe46abbc996679aa36d23372f6bfbfbcac226e333bec5fb76c891e3041a600852715c889911fa284eedbe1c4ee627122f311edbb888c9fa18e0c1a04cea15061d77ca78beb641b2fb38e274eb4bcab2ca16daeb8f" e="10001"])]'
			],
			[
				'<KeyInfo>' +
					'<X509Data>' +
						'<X509SubjectName>' +
							'CN=Merlin Hughes,O=Baltimore Technologies\, Ltd.,ST=Dublin,C=IE' +
						'</X509SubjectName>' +
						'<X509IssuerSerial>' +
							'<X509IssuerName>' +
								'CN=Test RSA CA,O=Baltimore Technologies\, Ltd.,ST=Dublin,C=IE' +
							'</X509IssuerName>' +
							'<X509SerialNumber>970849928</X509SerialNumber>' +
						'</X509IssuerSerial>' +
					'</X509Data>' +
					'<KeyValue>' +
						'<RSAKeyValue>' +
							'<Modulus>' +
								'uCiukpgOaOmrq1fPUTH3CAXxuFmPjsmS4jnTKxrv0w1JKcXtJ2M3akaV1d/karvJ' +
								'lmeao20jNy9r+/vKwibjM77F+3bIkeMEGmAIUnFciJkR+ihO7b4cTuYnEi8xHtu4' +
								'iMn6GODBoEzqFQYdd8p4vrZBsvs44nTrS8qyyhba648=' +
							'</Modulus>' +
							'<Exponent>' +
								'AQAB' +
							'</Exponent>' +
						'</RSAKeyValue>' +
					'</KeyValue>' +
				'</KeyInfo>',
				'[RSAKeyPair (null,[RSAPublicKey n="b828ae92980e68e9abab57cf5131f70805f1b8598f8ec992e239d32b1aefd30d4929c5ed2763376a4695d5dfe46abbc996679aa36d23372f6bfbfbcac226e333bec5fb76c891e3041a600852715c889911fa284eedbe1c4ee627122f311edbb888c9fa18e0c1a04cea15061d77ca78beb641b2fb38e274eb4bcab2ca16daeb8f" e="10001"])]'
			]
		];
		
		[Test( order="5", dataProvider="$decodeXML" )]
		public function decodeXML(xmlText:String, result:String):void {
			Assert.assertEquals(
				RSAKeyDecoder.decodeXML( new XML( xmlText ) ).toString(),
				result
			);
		}
		
		//----------------------------------
		//  decodeXML_error
		//----------------------------------
		
		public static var $decodeXML_error:Array = [
		];
		
		[Test( order="6", dataProvider="$decodeXML_error", expects="SyntaxError" )]
		public function decodeXML_error(xml:XML):void {
			RSAKeyDecoder.decodeXML( xml );
		}
		
	}
	
}