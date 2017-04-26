# croppie_dart

A Dart wrapper for the Javascript image cropper library Croppie [Croppie][croppie] 

### Documentation

For Croppie specific information, please take a look at there documentation. 

[Croppie][croppie]

## Usage

Include js and css within your index.html

```html
    <link rel="stylesheet" href="packages/croppie_dart/src/js/croppie.css" />
    <!--exif.js If you need-->
    <script defer src="packages/croppie_dart/src/js/exif.js"></script>
    <script src="packages/croppie_dart/src/js/croppie.min.js"></script>
```

Basic usage example (standard Croppie methods):

```dart
    import 'package:croppie_dart/croppie_dart.dart';
    import 'dart:html';
    
    Element croppieElement = querySelector("#croppie-element");
    Croppie croppie = new Croppie(croppieElement, new Options());
    croppie.bind(new BindConfiguration(url: "image_url"));
    
    // Some actions on croppie instance.
    
    Promise promise = croppie.result(String type, String size, String format, int quality, bool circle);
```    

### Convenience methods (Async / await):

This library provides a promise - async / await wrapper and several convenience methods to bind and get Croppie results in a typesafe manner.

```dart
    import 'package:croppie_dart/croppie_dart.dart';
    import 'dart:html';
    import 'dart:async';
    
    Element croppieElement = querySelector("#croppie-element");
    Croppie croppie = new Croppie(croppieElement, new Options());
    
    await croppie.bindAsync(new BindConfiguration(url: "image_url"));
    
    // Some actions on croppie instance. 
    
    // Async / await 
    Uint8List binary = await croppie.resultByteArray();
    Blob blob = await croppie.resultBlob();
    Element element = await croppie.resultHtml();
    String base64 = await croppie.resultBase64();
    CanvasElement canvas = await croppie.resultRawCanvas();
```    

### AngularDart

This library contains no component at the moment. Because it's very easy to integrate.

```html
    <!--Template reference on the target cropping div-->
    <div #cropping></div>
```

```dart
    @ViewChild("cropping")
    ElementRef croppingElementRef;
    
    Croppie croppie = new Croppie(croppingElementRef.nativeElement,new Options());
```

## Version

This version is corresponding with the original project

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/wem/croppie-dart/issues
[croppie]: https://foliotek.github.io/Croppie
