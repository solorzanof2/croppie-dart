@TestOn("browser")
import 'package:croppie_dart/croppie_dart.dart';
import 'dart:async';
import 'dart:typed_data';
import "package:test/test.dart";
import 'dart:html';

/// Simple tests for integration
main() {
  test("Simple bind test", () async {
    DivElement el = testElement;

    Croppie croppie = new Croppie(el, new Options());
    await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));

    Blob b = await croppie.resultBlob(size: "viewport");
    expect(b.size, greaterThan(0));
  });

  group("Result tests", () {
    test("Compare blob and byte length", () async {
      DivElement el = testElement;

      Croppie croppie = new Croppie(el, new Options());
      await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));

      Blob b = await croppie.resultBlob(size: "viewport");
      expect(b.size, greaterThan(0));

      Uint8List byteArr = await croppie.resultByteArray(size: "viewport");

      expect(byteArr.length, equals(b.size));
    });

    test("Negative byte array result", () async {
      DivElement el = testElement;

      Croppie croppie = new Croppie(el, new Options());

      try
      {
        await croppie.resultByteArray(size: "viewport");
        fail("should fail to get result when not bind");
      }
      catch ( e )
      {
      }
    });

    test("Test base64 result", () async {
      DivElement el = testElement;

      Croppie croppie = new Croppie(el, new Options());
      await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));

      Blob b = await croppie.resultBlob(size: "viewport");
      expect(b.size, greaterThan(0));

      String result = await croppie.resultBase64(size: "viewport");

      expect(result, startsWith("data:image/png;base64"));
    });

    test("Test war canvas result", () async {
      DivElement el = testElement;

      Croppie croppie = new Croppie(el, new Options());
      await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));

      Blob b = await croppie.resultBlob(size: "viewport");
      expect(b.size, greaterThan(0));

      CanvasElement result = await croppie.resultRawCanvas(size: "viewport");

      expect(result, isNotNull);
    });



    test("Test html result", () async {
      DivElement el = testElement;

      Croppie croppie = new Croppie(el, new Options());
      await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));

      Blob b = await croppie.resultBlob(size: "viewport");
      expect(b.size, greaterThan(0));

      Element result = await croppie.resultHtml(size: "viewport");

      expect(result.className, equals("croppie-result"));
    });
  });

  test("Zoom points compare", () async {
    DivElement el = testElement;

    Croppie croppie = new Croppie(el, new Options());
    await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));
    Data dataDefaultZoom = croppie.get();

    croppie.destroy();

    croppie = new Croppie(el, new Options());

    await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));
    croppie.setZoom(1.5);
    Data dataZoomIn = croppie.get();

    expect(double.parse(dataDefaultZoom.points[0]), lessThan(double.parse(dataZoomIn.points[0])));
    expect(double.parse(dataDefaultZoom.points[1]), lessThan(double.parse(dataZoomIn.points[1])));
    expect(double.parse(dataDefaultZoom.points[2]), greaterThan(double.parse(dataZoomIn.points[2])));
    expect(double.parse(dataDefaultZoom.points[3]), greaterThan(double.parse(dataZoomIn.points[3])));
  });

  test("Orientation compare after 90 degrees", () async {
    DivElement el = testElement;

    Croppie croppie = new Croppie(el, new Options());
    await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));
    Data dataDefaultZoom = croppie.get();

    croppie.destroy();

    croppie = new Croppie(el, new Options(enableOrientation: true));

    await croppie.bindAsync(new BindConfiguration(url: "demo.jpg", orientation: 5));
    Data dataAfterOrientation = croppie.get();

    expect(double.parse(dataDefaultZoom.points[0]), lessThanOrEqualTo(double.parse(dataAfterOrientation.points[0])));
    expect(double.parse(dataDefaultZoom.points[1]), lessThanOrEqualTo(double.parse(dataAfterOrientation.points[1])));
    expect(double.parse(dataDefaultZoom.points[2]), lessThanOrEqualTo(double.parse(dataAfterOrientation.points[2])));
    expect(double.parse(dataDefaultZoom.points[3]), lessThanOrEqualTo(double.parse(dataAfterOrientation.points[3])));
  });

  test("Rotate compare after 90 degrees", () async {
    DivElement el = testElement;

    Croppie croppie = new Croppie(el, new Options(enableOrientation: true));
    await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));
    Data dataDefaultZoom = croppie.get();

    croppie.rotate(90);

    Data dataAfterRotation = croppie.get();

    expect(double.parse(dataDefaultZoom.points[0]), greaterThanOrEqualTo(double.parse(dataAfterRotation.points[0])));
    expect(double.parse(dataDefaultZoom.points[1]), equals(double.parse(dataAfterRotation.points[1])));
    expect(double.parse(dataDefaultZoom.points[2]), greaterThanOrEqualTo(double.parse(dataAfterRotation.points[2])));
    expect(double.parse(dataDefaultZoom.points[3]), equals(double.parse(dataAfterRotation.points[3])));
  });

  test("Destroy bind test", () async {
    DivElement el = testElement;

    Croppie croppie = new Croppie(el, new Options());
    await croppie.bindAsync(new BindConfiguration(url: "demo.jpg"));

    Node boundaryNode =
        el.childNodes.firstWhere((Node node) => node is Element && node.classes.contains("cr-boundary"), orElse: () => null);
    expect(boundaryNode, isNotNull);

    final Completer completer = new Completer();

    int removedElements = 0;
    bool boundaryRemoved = false;

    // Wait until boundary element get removed from dom
    window.document.addEventListener("DOMNodeRemoved", (Event e) {
      boundaryRemoved = boundaryRemoved || e.target is Element && (e.target as Element).className == "cr-boundary";
      ++removedElements;
      if (removedElements == 2) {
        completer.complete(null);
      }
    });

    croppie.destroy();
    await completer.future;

    expect(boundaryRemoved, equals(true));
  });
}

DivElement get testElement => querySelector("#croppie-test");
