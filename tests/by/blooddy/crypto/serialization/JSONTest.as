////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.serialization {

	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.xml.XMLDocument;
	
	import by.blooddy.crypto.serialization.JSON;
	
	import org.flexunit.Assert;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 */
	public class JSONTest {

		//--------------------------------------------------------------------------
		//
		//  Private class variables
		//
		//--------------------------------------------------------------------------
		
		private static const blooddyJSON:Object = by.blooddy.crypto.serialization.JSON;
		
		private static const nativeJSON:Object = ApplicationDomain.currentDomain.getDefinition( 'JSON' );
		
		//--------------------------------------------------------------------------
		//
		//  Private class methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 */
		private static function equalsObjects(o1:Object, o2:Object):Boolean {
			
			if ( o1 == o2 ) return true;
			
			if ( !o1 || !o2 ) return false;
			if ( o1.constructor !== o2.constructor ) return false;
			
			if ( o1 is Array ) {
				if ( o1.length != o2.length ) return false;
			}
			
			var i:Object;
			for ( i in o1 ) {
				if ( !( i in o2 ) ) return false;
				else if ( o1[ i ] != o2[ i ] ) {
					switch ( typeof o1[ i ] ) {
						case 'object':
							if ( !equalsObjects( o1[ i ], o2[ i ] ) ) {
								return false;
							}
							break;
						case 'number':
							if ( isFinite( o1[ i ] ) || isFinite( o2[ i ] ) ) {
								return false;
							}
							break;
					}
				}
			}
			
			for ( i in o2 ) {
				if ( !( i in o2 ) ) return false;
			}
			
			return true;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		[Test]
		public function encode_null():void {
			Assert.assertEquals(
				blooddyJSON.encode( null ),
				nativeJSON.stringify( null )
			);
		}
		
		[Test]
		public function encode_undefined():void {
			Assert.assertEquals(
				blooddyJSON.encode( undefined ),
				nativeJSON.stringify( undefined )
			);
		}
		
		[Test]
		public function encode_notFinite():void {
			Assert.assertEquals(
				blooddyJSON.encode( NaN ),
				nativeJSON.stringify( NaN )
			);
			Assert.assertEquals(
				blooddyJSON.encode( Number.NEGATIVE_INFINITY ),
				nativeJSON.stringify( Number.NEGATIVE_INFINITY )
			);
			Assert.assertEquals(
				blooddyJSON.encode( Number.POSITIVE_INFINITY ),
				nativeJSON.stringify( Number.POSITIVE_INFINITY )
			);
		}
		
		[Test]
		public function encode_number_positive():void {
			Assert.assertEquals(
				blooddyJSON.encode( 5 ),
				nativeJSON.stringify( 5 )
			);
		}
		
		[Test]
		public function encode_number_negative():void {
			Assert.assertEquals(
				blooddyJSON.encode( -5 ),
				nativeJSON.stringify( -5 )
			);
		}
		
		[Test]
		public function encode_false():void {
			Assert.assertEquals(
				blooddyJSON.encode( false ),
				nativeJSON.stringify( false )
			);
		}
		
		[Test]
		public function encode_true():void {
			Assert.assertEquals(
				blooddyJSON.encode( true ),
				nativeJSON.stringify( true )
			);
		}
		
		[Test]
		public function encode_string():void {
			Assert.assertEquals(
				blooddyJSON.encode( 'asd' ),
				nativeJSON.stringify( 'asd' )
			);
		}
		
		[Test]
		public function encode_string_enpty():void {
			Assert.assertEquals(
				blooddyJSON.encode( '' ),
				nativeJSON.stringify( '' )
			);
		}
		
		[Test]
		public function encode_string_escape():void {
			Assert.assertEquals(
				blooddyJSON.encode( '\x33\u0044\t\n\b\r\t\v\f\\"' ),
				'"\x33\u0044\\t\\n\\b\\r\\t\\v\\f\\\\\\""'
			);
		}
		
		[Test]
		public function encode_string_nonescape():void {
			Assert.assertEquals(
				blooddyJSON.encode( '\x3\u044\5' ),
				nativeJSON.stringify( '\x3\u044\5' )
				//'"\x3\u044\5"'
			);
		}
		
		[Test]
		public function encode_xml():void {
			Assert.assertEquals(
				blooddyJSON.encode( <xml field="098"><node field="123" /></xml> ),
				nativeJSON.stringify( <xml field="098"><node field="123" /></xml> )
				//'"<xml field=\\"098\\"><node field=\\"123\\"\\/><\\/xml>"'
			);
		}
		
		[Test]
		public function encode_xmlDocument():void {
			Assert.assertEquals(
				blooddyJSON.encode( new XMLDocument( '<xml field="098">\n         <node            field = "123" />\n\r\t</xml>' ) ),
				'"XML"'
//				'"<xml field=\\"098\\"><node field=\\"123\\"\\/><\\/xml>"'
			);
		}
		
		[Test]
		public function encode_xml_empty():void {
			Assert.assertEquals(
				blooddyJSON.encode( new XML() ),
				nativeJSON.stringify( new XML() )
				//'""'
			);
		}
		
		[Test]
		public function encode_xmlDocument_empty():void {
			Assert.assertEquals(
				blooddyJSON.encode( new XMLDocument() ),
				'"XML"'
			);
		}
		
		[Test]
		public function encode_array_empty():void {
			Assert.assertEquals(
				blooddyJSON.encode( [] ),
				nativeJSON.stringify( [] )
				//'[]'
			);
		}
		
		[Test]
		public function encode_array_trailComma():void {
			Assert.assertEquals(
				blooddyJSON.encode( [5,,,] ),
				nativeJSON.stringify( [5,,,] )
				//'[5]'
			);
			Assert.assertEquals(
				blooddyJSON.encode( new Array( 100 ) ),
				nativeJSON.stringify( new Array( 100 ) )
				//'[]'
			);
		}
		
		[Test]
		public function encode_array_leadComma():void {
			Assert.assertEquals(
				blooddyJSON.encode( [,,5] ),
				nativeJSON.stringify( [,,5] )
				//'[null,null,5]'
			);
		}
		
		[Test]
		public function encode_vector_empty():void {
			Assert.assertEquals(
				blooddyJSON.encode( new <*>[] ),
				nativeJSON.stringify( new <*>[] )
				//'[]'
			);
			Assert.assertEquals(
				blooddyJSON.encode( new <SimpleClass>[] ),
				nativeJSON.stringify( new <SimpleClass>[] )
				//'[]'
			);
			Assert.assertEquals(
				blooddyJSON.encode( new <uint>[] ),
				nativeJSON.stringify( new <uint>[] )
				//'[]'
			);
			Assert.assertEquals(
				blooddyJSON.encode( new <int>[] ),
				nativeJSON.stringify( new <int>[] )
				//'[]'
			);
			Assert.assertEquals(
				blooddyJSON.encode( new <Number>[] ),
				nativeJSON.stringify( new <Number>[] )
				//'[]'
			);
		}
		
		[Test]
		public function encode_vector_int():void {
			Assert.assertEquals(
				blooddyJSON.encode( new <uint>[1,5,6] ),
				nativeJSON.stringify( new <uint>[1,5,6] )
				//'[1,5,6]'
			);
			Assert.assertEquals(
				blooddyJSON.encode( new <int>[1,-5,6] ),
				nativeJSON.stringify( new <int>[1,-5,6] )
				//'[1,-5,6]'
			);
		}
		
		[Test]
		public function encode_vector_number():void {
			Assert.assertEquals(
				blooddyJSON.encode( new <Number>[1.555,0.5e-1,6,NaN] ),
				nativeJSON.stringify( new <Number>[1.555,0.5e-1,6,NaN] )
				//'[1.555,0.05,6]'
			);
		}
		
		[Test]
		public function encode_vector_object():void {
			Assert.assertEquals(
				blooddyJSON.encode( new <*>[{},5,null] ),
				nativeJSON.stringify( new <*>[{},5,null] )
				//'[{},5]'
			);
		}
		
		[Test]
		public function encode_object_empty():void {
			Assert.assertEquals(
				blooddyJSON.encode( {} ),
				nativeJSON.stringify( {} )
				//'{}'
			);
		}
		
		[Test]
		public function encode_object_key_string():void {
			Assert.assertEquals(
				blooddyJSON.encode( { "string key": "value" } ),
				nativeJSON.stringify( { "string key": "value" } )
				//'{"string key":"value"}'
			);
		}
		
		[Test]
		public function encode_object_key_nonstring():void {
			Assert.assertEquals(
				blooddyJSON.encode( { key: "value", 5:true } ),
				nativeJSON.stringify( { key: "value", 5:true } )
				//'{"key":"value","5":true}'
			);
		}
		
		[Test]
		public function encode_object_key_undefined_NaN():void {
			Assert.assertEquals(
				blooddyJSON.encode( {undefined:1,NaN:2} ),
				nativeJSON.stringify( {undefined:1,NaN:2} )
				//'{"undefined":1,"NaN":2}'
			);
		}
		
		[Test( order=1 )]
		public function encode_object_class():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.encode( new SimpleClass() ),
					nativeJSON.stringify( new SimpleClass() )
					//blooddyJSON.decode( '{"accessor":4,"variable":1,"constant":2,"getter":3,"dynamicProperty":0}' )
				)
			);
		}
		
		[Test]
		public function encode_object_toJSON():void {
			var obj:Object = { toJSON: function(k:String):* { return {a:5} } };
			Assert.assertEquals(
				blooddyJSON.encode( obj ),
				nativeJSON.stringify( obj )
				//'{}'
			);
		}
		
		[Test]
		public function encode_object_toJSON_recursion():void {
			var obj:Object = { toJSON: function(k:String):* { return obj } };
			Assert.assertEquals(
				blooddyJSON.encode( obj ),
				nativeJSON.stringify( obj )
				//'{}'
			);
		}
		
		[Test]
		public function encode_dic():void {
			var dic:Dictionary = new Dictionary();
			Assert.assertEquals(
				blooddyJSON.encode( dic ),
				nativeJSON.stringify( dic )
			);
		}
		
		[Test]
		public function encode_dic_toJSON_recursion():void {
			var dic:Dictionary = new Dictionary();
			dic[ this ] = true;
			dic[ 'test' ] = true;
			dic.toJSON = function(k:String):* {
				return dic;
			};
			Assert.assertEquals(
				blooddyJSON.encode( dic ),
				nativeJSON.stringify( dic )
			);
		}
		
		[Test]
		public function encode_regexp():void {
			var exp:RegExp = /asd/g;
			Assert.assertEquals(
				blooddyJSON.encode( exp ),
				nativeJSON.stringify( exp )
			);
		}

		[Test]
		public function encode_date():void {
			var d:Date = new Date();
			Assert.assertEquals(
				blooddyJSON.encode( d ),
				nativeJSON.stringify( d )
			);
		}

		[Test]
		public function encode_date_recursion():void {
			var d:Date = new Date();
			d.toJSON = function(k:String):* {
				return d;
			}
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.encode( d ),
					nativeJSON.stringify( d )
				)
			);
		}
		
		[Test]
		public function encode_bytearray():void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeBoolean( true );
			bytes.writeUTFBytes( 'asd' );
			Assert.assertEquals(
				blooddyJSON.encode( bytes ),
				nativeJSON.stringify( bytes )
			);
		}
		
		[Test]
		public function encode_bytearray_recursion():void {
			var bytes:SimpleByteArray = new SimpleByteArray();
			bytes.writeBoolean( true );
			bytes.writeUTFBytes( 'asd' );
			Assert.assertEquals(
				blooddyJSON.encode( bytes ),
				nativeJSON.stringify( bytes )
			);
		}
		
		[Test( expects="flash.errors.StackOverflowError" )]
		public function encode_object_recursion():void {
			var o:SimpleClass = new SimpleClass();
			o.arr = [ o ];
			blooddyJSON.encode( o );
		}
		
		[Test]
		public function decode_value_empty():void {
			Assert.assertTrue(
				blooddyJSON.decode( '' ) === undefined
			);
		}
		
		[Test]
		public function decode_undefined():void {
			// assertStrictlyEquals not work with undefined
			Assert.assertTrue(
				blooddyJSON.decode( 'undefined' ) === undefined
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_identifier():void {
			blooddyJSON.decode( 'identifier' );
		}
		
		[Test]
		public function decode_true():void {
			Assert.assertTrue(
				blooddyJSON.decode( 'true' )
			);
		}
		
		[Test]
		public function decode_false():void {
			Assert.assertFalse(
				blooddyJSON.decode( 'false' )
			);
		}
		
		[Test]
		public function decode_null():void {
			Assert.assertNull(
				blooddyJSON.decode( 'null' )
			);
		}
		
		[Test]
		public function decode_string():void {
			Assert.assertEquals(
				blooddyJSON.decode( '"string"' ),
				'string'
			);
			Assert.assertEquals(
				blooddyJSON.decode( "'string'" ),
				'string'
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_string_noclose():void {
			blooddyJSON.decode( '"string' );
		}
		
		[Test]
		public function decode_string_escape():void {
			Assert.assertEquals(
				blooddyJSON.decode( '"\\x33\\u0044\\t\\n\\b\\r\\t\\v\\f\\\\\\""' ),
				'\x33\u0044\t\n\b\r\t\v\f\\\"'
			);
		}
		
		[Test]
		public function decode_string_nonescape():void {
			Assert.assertEquals(
				blooddyJSON.decode( '"\\x3\\u044\\5"' ),
				'\x3\u044\5'
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_sring_newline():void {
			blooddyJSON.decode( '"firs\nsecond"' );
		}
		
		[Test]
		public function decode_number_zero():void {
			Assert.assertEquals(
				blooddyJSON.decode( '0' ),
				0
			);
		}
		
		[Test]
		public function decode_number_leadZero():void {
			Assert.assertEquals(
				blooddyJSON.decode( '01' ),
				01
			);
			Assert.assertEquals(
				blooddyJSON.decode( '002' ),
				002
			);
		}
		
		[Test]
		public function decode_number_positive():void {
			Assert.assertEquals(
				blooddyJSON.decode( '123' ),
				123
			);
		}
		
		[Test]
		public function decode_number_float():void {
			Assert.assertEquals(
				blooddyJSON.decode( '1.123' ),
				1.123
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonfloat():void {
			blooddyJSON.decode( '1.' );
		}
		
		[Test]
		public function decode_number_float_witoutLeadDot():void {
			Assert.assertEquals(
				blooddyJSON.decode( '.123' ),
				.123
			);
		}
		
		[Test]
		public function decode_number_float_witoutLeadZero():void {
			Assert.assertEquals(
				blooddyJSON.decode( '0.123' ),
				.123
			);
		}
		
		[Test]
		public function decode_number_exp():void {
			Assert.assertEquals(
				blooddyJSON.decode( '1E3' ),
				1e3
			);
			Assert.assertEquals(
				blooddyJSON.decode( '1e-3' ),
				1e-3
			);
			Assert.assertEquals(
				blooddyJSON.decode( '1e+3' ),
				1e+3
			);
		}
		
		[Test]
		public function decode_number_exp_leadZeo():void {
			Assert.assertEquals(
				blooddyJSON.decode( '02E3' ),
				2e3
			);
			Assert.assertEquals(
				blooddyJSON.decode( '01e-3' ),
				1e-3
			);
			Assert.assertEquals(
				blooddyJSON.decode( '0e+3' ),
				0e+3
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonexp():void {
			blooddyJSON.decode( '1E' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_floatexp():void {
			blooddyJSON.decode( '1E1.2' );
		}
		
		[Test]
		public function decode_number_hex():void {
			Assert.assertEquals(
				blooddyJSON.decode( '0xFF' ),
				0xFF
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonhex():void {
			blooddyJSON.decode( '0x' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonhex2():void {
			blooddyJSON.decode( '0xZ' );
		}
		
		[Test]
		public function decode_number_NaN():void {
			Assert.assertTrue(
				isNaN( blooddyJSON.decode( 'NaN' ) )
			);
		}
		
		[Test]
		public function decode_dash_number():void {
			Assert.assertEquals(
				blooddyJSON.decode( '-  \n 5' ),
				-5
			);
		}
		
		[Test]
		public function decode_dash_undefined():void {
			Assert.assertTrue(
				isNaN( blooddyJSON.decode( '-undefined' ) )
			);
		}
		
		[Test]
		public function decode_dash_null():void {
			Assert.assertEquals(
				blooddyJSON.decode( '-null' ),
				-null
			);
		}
		
		[Test]
		public function decode_dash_NaN():void {
			Assert.assertTrue(
				isNaN( blooddyJSON.decode( '-NaN' ) )
			);
		}
		
		[Test]
		public function decode_dash_false():void {
			Assert.assertEquals(
				blooddyJSON.decode( '-false' ),
				0
			);
		}
		
		[Test]
		public function decode_dash_true():void {
			Assert.assertEquals(
				blooddyJSON.decode( '-true' ),
				-1
			);
		}
		
		[Test]
		public function decode_object_empty():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '{}' ),
					{}
				)
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_leadComma():void {
			blooddyJSON.decode( '{,}' );
		}
		
		[Test]
		public function decode_object_key_string():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '{"key":"value"}' ),
					{"key":"value"}
				)
			);
		}
		
		[Test]
		public function decode_object_key_nonstring():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '{key1:"value1",5:"value2"}' ),
					{key1:"value1",5:"value2"}
				)
			);
		}
		
		[Test]
		public function decode_object_key_undefined_NaN():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '{undefined:1,NaN:2}' ),
					{undefined:1,NaN:2}
				)
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_key_null():void {
			blooddyJSON.decode( '{null:1}' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_key_false():void {
			blooddyJSON.decode( '{false:1}' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_key_true():void {
			blooddyJSON.decode( '{true:1}' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_noclose():void {
			blooddyJSON.decode( '{key1:"value1"' );
		}
		
		[Test]
		public function decode_array_empty():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '[]' ),
					[]
				)
			);
		}
		
		[Test]
		public function decode_array_trailComma():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '[,,,]' ),
					[,,,]
				)
			);
		}
		
		[Test]
		public function decode_array_number():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '[,,,5]' ),
					[,,,5]
				)
			);
		}
		
		[Test]
		public function decode_array_text():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '[,,"asdasdas",]' ),
					[,,"asdasdas",]
				)
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_array_withIdentifier():void {
			blooddyJSON.decode( '[identifier]' );
		}
		
		[Test]
		public function decode_comment_line():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '5// comment' ),
					5// comment
				)
			);
		}
		
		[Test]
		public function decode_comment_multiline():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '[1/* line1\nline2*/,2]' ),
					[1/* line1\nline2*/,2]
				)
			);
		}
		
		[Test]
		public function decode_comment_only():void {
			Assert.assertTrue(
				blooddyJSON.decode( '// comment' ) === undefined
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_multilineComments_noclose():void {
			blooddyJSON.decode( '1/* comment' );
		}
		
		[Test]
		public function decode_object_all():void {
			Assert.assertTrue(
				equalsObjects(
					blooddyJSON.decode( '{key1: {"key2" /*comment\r222\n*/: null},// comment\n   3 : [undefined,true,false,\n-   .5e3,"string",				NaN]}' ),
					{ key1: { "key2" : null }, 3 : [ undefined, true, false, -.5e3, "string", NaN ] }
				)
			);
		}
		
	}

}