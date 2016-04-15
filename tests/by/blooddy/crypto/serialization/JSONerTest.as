////////////////////////////////////////////////////////////////////////////////
//
//  (C) 2009 BlooDHounD
//
////////////////////////////////////////////////////////////////////////////////

package by.blooddy.crypto.serialization {
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.xml.XMLDocument;
	
	import by.blooddy.crypto.events.ProcessEvent;
	
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	
	/**
	 * @author					BlooDHounD
	 * @version					1.0
	 * @playerversion			Flash 9
	 * @langversion				3.0
	 */
	public class JSONerTest {
		
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
				JSONer.encode( null ),
//				JSON.stringify( null )
				'null'
			);
		}
		
		[Test]
		public function encode_undefined():void {
			Assert.assertEquals(
				JSONer.encode( undefined ),
//				JSON.stringify( undefined )
				'null'
			);
		}
		
		[Test]
		public function encode_notFinite():void {
			Assert.assertEquals(
				JSONer.encode( NaN ),
//				JSON.stringify( NaN )
				'null'
			);
			Assert.assertEquals(
				JSONer.encode( Number.NEGATIVE_INFINITY ),
//				JSON.stringify( Number.NEGATIVE_INFINITY )
				'null'
			);
			Assert.assertEquals(
				JSONer.encode( Number.POSITIVE_INFINITY ),
//				JSON.stringify( Number.POSITIVE_INFINITY )
				'null'
			);
		}
		
		[Test]
		public function encode_number_positive():void {
			Assert.assertEquals(
				JSONer.encode( 5 ),
//				JSON.stringify( 5 )
				'5'
			);
		}
		
		[Test]
		public function encode_number_negative():void {
			Assert.assertEquals(
				JSONer.encode( -5 ),
//				JSON.stringify( -5 )
				'-5'
			);
		}
		
		[Test]
		public function encode_false():void {
			Assert.assertEquals(
				JSONer.encode( false ),
//				JSON.stringify( false )
				'false'
			);
		}
		
		[Test]
		public function encode_true():void {
			Assert.assertEquals(
				JSONer.encode( true ),
//				JSON.stringify( true )
				'true'
			);
		}
		
		[Test]
		public function encode_string():void {
			Assert.assertEquals(
				JSONer.encode( 'asd' ),
//				JSON.stringify( 'asd' )
				'"asd"'
			);
		}
		
		[Test]
		public function encode_string_enpty():void {
			Assert.assertEquals(
				JSONer.encode( '' ),
//				JSON.stringify( '' )
				'""'
			);
		}
		
		[Test]
		public function encode_string_escape():void {
			Assert.assertEquals(
				JSONer.encode( '\x33\u0044\t\n\b\r\t\v\f\\"' ),
				'"\x33\u0044\\t\\n\\b\\r\\t\\v\\f\\\\\\""'
			);
		}
		
		[Test]
		public function encode_string_nonescape():void {
			Assert.assertEquals(
				JSONer.encode( '\x3\u044\5' ),
//				JSON.stringify( '\x3\u044\5' )
				'"\x3\u044\5"'
			);
		}
		
		[Test]
		public function encode_xml():void {
			Assert.assertEquals(
				JSONer.encode( <xml field="098"><node field="123" /></xml> ),
//				JSON.stringify( <xml field="098"><node field="123" /></xml> )
//				'"<xml field=\\"098\\"><node field=\\"123\\"\\/><\\/xml>"'
				'"XML"'
			);
		}
		
		[Test]
		public function encode_xmlDocument():void {
			Assert.assertEquals(
				JSONer.encode( new XMLDocument( '<xml field="098">\n         <node            field = "123" />\n\r\t</xml>' ) ),
//				'"<xml field=\\"098\\"><node field=\\"123\\"\\/><\\/xml>"'
				'"XML"'
			);
		}
		
		[Test]
		public function encode_xml_empty():void {
			Assert.assertEquals(
				JSONer.encode( new XML() ),
//				JSON.stringify( new XML() )
//				'""'
				'"XML"'
			);
		}
		
		[Test]
		public function encode_xmlDocument_empty():void {
			Assert.assertEquals(
				JSONer.encode( new XMLDocument() ),
				'"XML"'
			);
		}
		
		[Test]
		public function encode_array_empty():void {
			Assert.assertEquals(
				JSONer.encode( [] ),
//				JSON.stringify( [] )
				'[]'
			);
		}
		
		[Test]
		public function encode_array_trailComma():void {
			Assert.assertEquals(
				JSONer.encode( [5,,,] ),
//				JSON.stringify( [5,,,] )
				'[5,null,null]'
			);
			Assert.assertEquals(
				JSONer.encode( new Array( 3 ) ),
//				JSON.stringify( new Array( 3 ) )
				'[null,null,null]'
			);
		}
		
		[Test]
		public function encode_array_leadComma():void {
			Assert.assertEquals(
				JSONer.encode( [,,5] ),
//				JSON.stringify( [,,5] )
				'[null,null,5]'
			);
		}
		
		[Test]
		public function encode_vector_empty():void {
			Assert.assertEquals(
				JSONer.encode( new <*>[] ),
//				JSON.stringify( new <*>[] )
				'[]'
			);
			Assert.assertEquals(
				JSONer.encode( new <SimpleClass>[] ),
//				JSON.stringify( new <SimpleClass>[] )
				'[]'
			);
			Assert.assertEquals(
				JSONer.encode( new <uint>[] ),
//				JSON.stringify( new <uint>[] )
				'[]'
			);
			Assert.assertEquals(
				JSONer.encode( new <int>[] ),
//				JSON.stringify( new <int>[] )
				'[]'
			);
			Assert.assertEquals(
				JSONer.encode( new <Number>[] ),
//				JSON.stringify( new <Number>[] )
				'[]'
			);
		}
		
		[Test]
		public function encode_vector_int():void {
			Assert.assertEquals(
				JSONer.encode( new <uint>[1,5,6] ),
//				JSON.stringify( new <uint>[1,5,6] )
				'[1,5,6]'
			);
			Assert.assertEquals(
				JSONer.encode( new <int>[1,-5,6] ),
//				JSON.stringify( new <int>[1,-5,6] )
				'[1,-5,6]'
			);
		}
		
		[Test]
		public function encode_vector_number():void {
			Assert.assertEquals(
				JSONer.encode( new <Number>[1.555,0.5e-1,6,NaN] ),
//				JSON.stringify( new <Number>[1.555,0.5e-1,6,NaN] )
				'[1.555,0.05,6,null]'
			);
		}
		
		[Test]
		public function encode_vector_object():void {
			Assert.assertEquals(
				JSONer.encode( new <*>[{},5,null] ),
//				JSON.stringify( new <*>[{},5,null] )
				'[{},5,null]'
			);
		}
		
		[Test]
		public function encode_object_empty():void {
			Assert.assertEquals(
				JSONer.encode( {} ),
//				JSON.stringify( {} )
				'{}'
			);
		}
		
		[Test]
		public function encode_object_key_string():void {
			Assert.assertEquals(
				JSONer.encode( { "string key": "value" } ),
//				JSON.stringify( { "string key": "value" } )
				'{"string key":"value"}'
			);
		}
		
		[Test]
		public function encode_object_key_nonstring():void {
			Assert.assertEquals(
				JSONer.encode( { key: "value", 5:true } ),
//				JSON.stringify( { key: "value", 5:true } )
				'{"5":true,"key":"value"}'
			);
		}
		
		[Test]
		public function encode_object_key_undefined_NaN():void {
			var result:String = JSONer.encode( {undefined:1,NaN:2} );
//			JSON.stringify( {undefined:1,NaN:2} )
			Assert.assertTrue(
				result == '{"NaN":2,"undefined":1}' ||
				result == '{"undefined":1,"NaN":2}'
			);
		}

		[Test( order=1 )]
		public function encode_object_class():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.encode( new SimpleClass() ),
//					JSON.stringify( new SimpleClass() )
					'{"accessor":4,"variable":1,"constant":2,"getter":3,"dynamicProperty":0}'
				)
			);
		}
		
		[Test]
		public function encode_object_toJSON():void {
			var obj:Object = { toJSON: function(k:String):* { return {a:5} } };
			Assert.assertEquals(
				JSONer.encode( obj ),
//				JSON.stringify( obj )
				'{"a":5}'
			);
		}
		
		[Test]
		public function encode_object_toJSON_recursion():void {
			var obj:Object = { toJSON: function(k:String):* { return obj } };
			Assert.assertEquals(
				JSONer.encode( obj ),
//				JSON.stringify( obj )
				'{}'
			);
		}
		
		[Test]
		public function encode_dic():void {
			var dic:Dictionary = new Dictionary();
			var result:String = JSONer.encode( dic );
//			JSON.stringify( dic )
			Assert.assertTrue(
				result == '{}' ||
				result == '"Dictionary"'
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
				JSONer.encode( dic ),
//				JSON.stringify( dic )
				'{"test":true}'
			);
		}
		
		[Test]
		public function encode_regexp():void {
			var exp:RegExp = /asd/g;
			var result:String = JSONer.encode( exp );
//			JSON.stringify( exp )
			Assert.assertTrue(
				result == '{"lastIndex":0,"ignoreCase":false,"global":true,"source":"asd","multiline":false,"dotall":false,"extended":false}' ||
				result == '{"ignoreCase":false,"multiline":false,"dotall":false,"extended":false,"source":"asd","lastIndex":0,"global":true}'
			);
		}

		[Test]
		public function encode_date():void {
			var d:Date = new Date( 555555555 );
			var result:String = JSONer.encode( d );
//			JSON.stringify( d )
			Assert.assertTrue(
				result == '"Wed Jan 7 13:19:15 GMT+0300 1970"' ||
				result == '{"date":7,"hours":13,"minutes":19,"seconds":15,"milliseconds":555,"fullYearUTC":1970,"monthUTC":0,"dateUTC":7,"hoursUTC":10,"minutesUTC":19,"secondsUTC":15,"millisecondsUTC":555,"time":555555555,"timezoneOffset":-180,"day":3,"dayUTC":3,"fullYear":1970,"month":0}'
			);
		}

		[Test]
		public function encode_date_recursion():void {
			var d:Date = new Date( 555555555 );
			d.toJSON = function(k:String):* {
				return d;
			}
			var result:String = JSONer.encode( d );
//			JSON.stringify( d )
			Assert.assertTrue(
				result == '{"date":7,"hours":13,"minutes":19,"seconds":15,"milliseconds":555,"fullYearUTC":1970,"monthUTC":0,"dateUTC":7,"hoursUTC":10,"minutesUTC":19,"secondsUTC":15,"millisecondsUTC":555,"time":555555555,"timezoneOffset":-180,"day":3,"dayUTC":3,"fullYear":1970,"month":0}' ||
				result == '{"fullYear":1970,"month":0,"date":7,"seconds":15,"fullYearUTC":1970,"monthUTC":0,"hoursUTC":10,"minutesUTC":19,"secondsUTC":15,"minutes":19,"time":555555555,"milliseconds":555,"day":3,"dayUTC":3,"timezoneOffset":-180,"hours":13,"dateUTC":7,"millisecondsUTC":555}'
			);
		}

		[Test]
		public function encode_bytearray():void {
			var bytes:ByteArray = new ByteArray();
			bytes.writeBoolean( true );
			bytes.writeUTFBytes( 'asd' );
			var result:String = JSONer.encode( bytes );
//			JSON.stringify( bytes )
			Assert.assertTrue(
				result == 'null' ||
				result == '"ByteArray"'
			);
		}
		
		[Test]
		public function encode_bytearray_recursion():void {
			var bytes:SimpleByteArray = new SimpleByteArray();
			bytes.writeBoolean( true );
			bytes.writeUTFBytes( 'asd' );
			var result:String = JSONer.encode( bytes );
//			JSON.stringify( bytes )
			Assert.assertTrue(
				result == '{"bytesAvailable":0,"length":4,"endian":"bigEndian","objectEncoding":3,"position":4}' ||
				result == '{"objectEncoding":3,"bytesAvailable":0,"endian":"bigEndian","length":4,"position":4}'
			);
		}

		[Test]
		public function encode_issue_15():void {
			var o:Object = {a:"\u"};
			Assert.assertEquals(
				JSONer.encode( o ),
//				JSON.stringify( o )
				'{"a":"u"}'
			);
		}
		
		[Test( expects="flash.errors.StackOverflowError" )]
		public function encode_object_recursion():void {
			var o:SimpleClass = new SimpleClass();
			o.arr = [ o ];
			JSONer.encode( o );
		}
		
		[Test]
		public function decode_value_empty():void {
			Assert.assertTrue(
				JSONer.decode( '' ) === undefined
			);
		}
		
		[Test]
		public function decode_undefined():void {
//			assertStrictlyEquals not work with undefined
			Assert.assertTrue(
				JSONer.decode( 'undefined' ) === undefined
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_identifier():void {
			JSONer.decode( 'identifier' );
		}
		
		[Test]
		public function decode_true():void {
			Assert.assertTrue(
				JSONer.decode( 'true' )
			);
		}
		
		[Test]
		public function decode_false():void {
			Assert.assertFalse(
				JSONer.decode( 'false' )
			);
		}
		
		[Test]
		public function decode_null():void {
			Assert.assertNull(
				JSONer.decode( 'null' )
			);
		}
		
		[Test]
		public function decode_string():void {
			Assert.assertEquals(
				JSONer.decode( '"string"' ),
				'string'
			);
			Assert.assertEquals(
				JSONer.decode( "'string'" ),
				'string'
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_string_noclose():void {
			JSONer.decode( '"string' );
		}
		
		[Test]
		public function decode_string_escape():void {
			Assert.assertEquals(
				JSONer.decode( '"\\x33\\u0044\\t\\n\\b\\r\\t\\v\\f\\\\\\""' ),
				'\x33\u0044\t\n\b\r\t\v\f\\\"'
			);
		}
		
		[Test]
		public function decode_string_nonescape():void {
			Assert.assertEquals(
				JSONer.decode( '"\\x3\\u044\\5"' ),
				'\x3\u044\5'
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_sring_newline():void {
			JSONer.decode( '"firs\nsecond"' );
		}
		
		[Test]
		public function decode_number_zero():void {
			Assert.assertEquals(
				JSONer.decode( '0' ),
				0
			);
		}
		
		[Test]
		public function decode_number_leadZero():void {
			Assert.assertEquals(
				JSONer.decode( '01' ),
				01
			);
			Assert.assertEquals(
				JSONer.decode( '002' ),
				002
			);
		}
		
		[Test]
		public function decode_number_positive():void {
			Assert.assertEquals(
				JSONer.decode( '123' ),
				123
			);
		}
		
		[Test]
		public function decode_number_float():void {
			Assert.assertEquals(
				JSONer.decode( '1.123' ),
				1.123
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonfloat():void {
			JSONer.decode( '1.' );
		}
		
		[Test]
		public function decode_number_float_witoutLeadDot():void {
			Assert.assertEquals(
				JSONer.decode( '.123' ),
				.123
			);
		}
		
		[Test]
		public function decode_number_float_witoutLeadZero():void {
			Assert.assertEquals(
				JSONer.decode( '0.123' ),
				.123
			);
		}
		
		[Test]
		public function decode_number_exp():void {
			Assert.assertEquals(
				JSONer.decode( '1E3' ),
				1e3
			);
			Assert.assertEquals(
				JSONer.decode( '1e-3' ),
				1e-3
			);
			Assert.assertEquals(
				JSONer.decode( '1e+3' ),
				1e+3
			);
		}
		
		[Test]
		public function decode_number_exp_leadZeo():void {
			Assert.assertEquals(
				JSONer.decode( '02E3' ),
				2e3
			);
			Assert.assertEquals(
				JSONer.decode( '01e-3' ),
				1e-3
			);
			Assert.assertEquals(
				JSONer.decode( '0e+3' ),
				0e+3
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonexp():void {
			JSONer.decode( '1E' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_floatexp():void {
			JSONer.decode( '1E1.2' );
		}
		
		[Test]
		public function decode_number_hex():void {
			Assert.assertEquals(
				JSONer.decode( '0xFF' ),
				0xFF
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonhex():void {
			JSONer.decode( '0x' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_number_nonhex2():void {
			JSONer.decode( '0xZ' );
		}
		
		[Test]
		public function decode_number_NaN():void {
			Assert.assertTrue(
				isNaN( JSONer.decode( 'NaN' ) )
			);
		}
		
		[Test]
		public function decode_dash_number():void {
			Assert.assertEquals(
				JSONer.decode( '-  \n 5' ),
				-5
			);
		}
		
		[Test]
		public function decode_dash_undefined():void {
			Assert.assertTrue(
				isNaN( JSONer.decode( '-undefined' ) )
			);
		}
		
		[Test]
		public function decode_dash_null():void {
			Assert.assertEquals(
				JSONer.decode( '-null' ),
				-null
			);
		}
		
		[Test]
		public function decode_dash_NaN():void {
			Assert.assertTrue(
				isNaN( JSONer.decode( '-NaN' ) )
			);
		}
		
		[Test]
		public function decode_dash_false():void {
			Assert.assertEquals(
				JSONer.decode( '-false' ),
				0
			);
		}
		
		[Test]
		public function decode_dash_true():void {
			Assert.assertEquals(
				JSONer.decode( '-true' ),
				-1
			);
		}
		
		[Test]
		public function decode_object_empty():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '{}' ),
					{}
				)
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_leadComma():void {
			JSONer.decode( '{,}' );
		}
		
		[Test]
		public function decode_object_key_string():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '{"key":"value"}' ),
					{"key":"value"}
				)
			);
		}
		
		[Test]
		public function decode_object_key_nonstring():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '{key1:"value1",5:"value2"}' ),
					{key1:"value1",5:"value2"}
				)
			);
		}
		
		[Test]
		public function decode_object_key_undefined_NaN():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '{undefined:1,NaN:2}' ),
					{undefined:1,NaN:2}
				)
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_key_null():void {
			JSONer.decode( '{null:1}' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_key_false():void {
			JSONer.decode( '{false:1}' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_key_true():void {
			JSONer.decode( '{true:1}' );
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_object_noclose():void {
			JSONer.decode( '{key1:"value1"' );
		}
		
		[Test]
		public function decode_array_empty():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '[]' ),
					[]
				)
			);
		}
		
		[Test]
		public function decode_array_trailComma():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '[,,,]' ),
					[,,,]
				)
			);
		}
		
		[Test]
		public function decode_array_number():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '[,,,5]' ),
					[,,,5]
				)
			);
		}
		
		[Test]
		public function decode_array_text():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '[,,"asdasdas",]' ),
					[,,"asdasdas",]
				)
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_array_withIdentifier():void {
			JSONer.decode( '[identifier]' );
		}
		
		[Test]
		public function decode_comment_line():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '5// comment' ),
					5// comment
				)
			);
		}
		
		[Test]
		public function decode_comment_multiline():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '[1/* line1\nline2*/,2]' ),
					[1/* line1\nline2*/,2]
				)
			);
		}
		
		[Test]
		public function decode_comment_only():void {
			Assert.assertTrue(
				JSONer.decode( '// comment' ) === undefined
			);
		}
		
		[Test( expects="SyntaxError" )]
		public function decode_multilineComments_noclose():void {
			JSONer.decode( '1/* comment' );
		}
		
		[Test]
		public function decode_object_all():void {
			Assert.assertTrue(
				equalsObjects(
					JSONer.decode( '{key1: {"key2" /*comment\r222\n*/: null},// comment\n   3 : [undefined,true,false,\n-   .5e3,"string",				NaN]}' ),
					{ key1: { "key2" : null }, 3 : [ undefined, true, false, -.5e3, "string", NaN ] }
				)
			);
		}
		
		[Test( async )]
		public function async_decode_object_all():void {
			
			var json:JSONer = new JSONer();
			json.parse( '{"key1":[{"key2":5},67,"test",null],"key3":[true,false]}' );
			json.addEventListener( ProcessEvent.COMPLETE, Async.asyncHandler( this, function(event:ProcessEvent, data:*):void {
				Assert.assertTrue( equalsObjects(
					event.data,
					{"key1":[{"key2":5},67,"test",null],"key3":[true,false]}
				) );
			}, 1e3 ) );
			Async.registerFailureEvent( this, json, ProcessEvent.ERROR );
			
		}
		
	}
	
}