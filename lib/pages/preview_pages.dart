import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:path_provider/path_provider.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class PreviewPage extends StatefulWidget {
  final Image image;

  const PreviewPage({super.key, required this.image});

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  @override
  Widget build(BuildContext context) {
    print(widget.image.toString());
    GlobalKey previewContainer = GlobalKey();

    int originalSize = 800;

    Future<void> _sharePng() async {
      try {
        RenderRepaintBoundary boundary = previewContainer.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();
        if (pngBytes != null) {
          final directory = await getApplicationDocumentsDirectory();
          final imagePath = await File('${directory.path}/image.png').create();
          await imagePath.writeAsBytes(pngBytes);
          ShareFilesAndScreenshotWidgets()
              .shareFile("images", "images.png", pngBytes, "image/png");
        }
      } catch (e) {
        print(e);
      }
    }

    Future<void> _savepng() async {
      try {
        RenderRepaintBoundary boundary = previewContainer.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();
        if (pngBytes != null) {
          final directory = await getApplicationDocumentsDirectory();
          File imagePath = await File('${directory.path}/image.png').create();

          String img64 = base64Encode(pngBytes);
          final decodedBytes = base64Decode(img64);
          var file = File('${directory.path}/image.png');
          file.writeAsBytesSync(decodedBytes);
          // print(img64.substring(0, 100));
          // final imageEncode = base64Encode(pngBytes);
          // String base64String = base64Encode(pngBytes);
          // String header = "data:image/png;base64,";
          // String image64 = header + base64String;

          // print(image64);
          // final File newImage = await imagePath.writeAsBytes(pngBytes);
          // final data = await File(imagePath.toString()).open();

          // await imagePath.writeAsBytes(pngBytes);
        }
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Mim Generator'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
                child: RepaintBoundary(
                    key: previewContainer, child: widget.image)),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    _savepng();
                  },
                  child: const Text('Simpan'),
                ),
                ElevatedButton(
                    onPressed: () async {
                      _sharePng();
                    },
                    child: const Text('Share'))
              ],
            )
          ],
        ),
      ),
    );
  }
}
