import 'dart:io';
import 'dart:ui';

import 'package:algo_test/pages/homepages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:document_file_save_plus/document_file_save_plus.dart';
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

    Future<void> savepng() async {
      try {
        RenderRepaintBoundary boundary = previewContainer.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);
        ByteData? byteData =
            await image.toByteData(format: ImageByteFormat.png);
        final pngBytes = byteData!.buffer.asUint8List();

        await DocumentFileSavePlus.saveFile(
            pngBytes, "images.png", "image/png");

        var snackBar = const SnackBar(
          content: Text(
            'Berhasil disimpan',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (e) {
        print(e);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Mim Generator'),
        leading: IconButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePages()),
                  (route) => false);
            },
            icon: Icon(Icons.arrow_back_ios)),
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
                    savepng();
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
