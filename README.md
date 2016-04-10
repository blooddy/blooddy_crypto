[BLODDY_CRYPTO](http://www.blooddy.by)
======================================
[![Wiki](https://img.shields.io/badge/wiki-GitHub-red.svg)](https://github.com/blooddy/blooddy_crypto/wiki)
[![Download](https://img.shields.io/badge/download-ZIP-yellow.svg)](https://github.com/blooddy/blooddy_crypto/releases/latest)
[![Last Release](https://img.shields.io/github/release/blooddy/blooddy_crypto.svg?label=version)](https://github.com/blooddy/blooddy_crypto/releases)
[![Licence](https://img.shields.io/github/license/blooddy/blooddy_crypto.svg)](LICENSE.md)

ActionScript library for processing binary data.


Description
-----------
This library contains [MD5](http://en.wikipedia.org/wiki/Md5), [SHA-1](http://en.wikipedia.org/wiki/SHA-1), [SHA-2](http://en.wikipedia.org/wiki/SHA-2) ( 224 и 256 ), [Base64](http://en.wikipedia.org/wiki/Base64), [CRC32](http://en.wikipedia.org/wiki/Crc32) algorithms, [JSON](http://en.wikipedia.org/wiki/JSON) encoder & decoder as well as [PNG](http://en.wikipedia.org/wiki/Portable_Network_Graphics) and [JPEG](http://en.wikipedia.org/wiki/JPEG) encoders.

Examples
--------

###### Sync
```actionscript
import by.blooddy.crypto.MD5;
var result:String = MD5.hash( 'text' );
```
###### Async
```actionscript
import by.blooddy.crypto.MD5;
import by.blooddy.crypto.events.ProcessEvent;

var md5:MD5 = new MD5();
md5.hash( 'text' );
md5.addEventListener( ProcessEvent.COMPLETE, function(event:ProcessEvent):void {
	var result:String = event.data;
	trace( result ); // async result
} );
md5.addEventListener( ProcessEvent.ERROR, function(event:ProcessEvent):void {
	var error:Error = event.data;
	trace( error ); // async error
} );
```
