import 'dart:io';

import 'package:algo_test/model/mim_model.dart';
import 'package:algo_test/pages/preview_pages.dart';
import 'package:algo_test/pages/widgets/overlay_widgets.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_files_and_screenshot_widgets/share_files_and_screenshot_widgets.dart';

class DetailMimPage extends StatefulWidget {
  final Meme data;
  const DetailMimPage({super.key, required this.data});

  @override
  State<DetailMimPage> createState() => _DetailMimPageState();
}

class _DetailMimPageState extends State<DetailMimPage> {
  Offset offset = Offset(0, 0);
  List<Widget> addWidgets = [];
  List<Widget> dummyWidgets = [];
  TextEditingController inputController = TextEditingController();
  GlobalKey previewContainer = GlobalKey();
  int originalSize = 800;
  Image? _image;

  File? _file;
  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      _file = File(pickedFile!.path);

      if (_file != null) {
        dummyWidgets.add(Image.file(
          _file!,
          fit: BoxFit.cover,
        ));
      }
      addWidgets.add(
          OverlayWidgets(child: dummyWidgets.elementAt(addWidgets.length)));
    });
  }

  void modalBottomSheet() {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SizedBox(
            height: 150,
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        height: 100,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: inputController,
                            decoration: const InputDecoration(
                              hintText: 'Input Text',
                            ),
                          ),
                        )),
                    ElevatedButton(
                      onPressed: () {
                        dummyWidgets.add(Text(
                          inputController.text,
                          style: const TextStyle(
                              color: Colors.red,
                              fontSize: 36,
                              fontWeight: FontWeight.bold),
                        ));
                      },
                      child: const Text('OK'),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (addWidgets.length < dummyWidgets.length) {
                      setState(() {
                        addWidgets.add(OverlayWidgets(
                            child: dummyWidgets.elementAt(addWidgets.length)));
                      });
                    }
                    inputController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text('Tampilkan'),
                ),
              ],
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    dummyWidgets.clear();
  }

  void screenshot() async {
    ShareFilesAndScreenshotWidgets()
        .takeScreenshot(previewContainer, originalSize)
        .then((Image? value) {
      setState(() {
        _image = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(dummyWidgets);
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIM Generator'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            RepaintBoundary(
              key: previewContainer,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.65,
                      child: Image.network(
                        widget.data.url,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  for (int i = 0; i < addWidgets.length; i++) addWidgets[i]
                ],
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    pickImage();
                  },
                  child: Column(
                    children: const [
                      Text('Add Logo'),
                      Icon(
                        Icons.image_outlined,
                        size: 46,
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    modalBottomSheet();
                  },
                  child: Column(
                    children: const [
                      Text('Add Text'),
                      Icon(
                        Icons.text_fields_outlined,
                        size: 46,
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SizedBox(
                height: 55,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    screenshot();
                    if (_image != null) {
                      await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PreviewPage(image: _image!)));
                    }
                  },
                  child: const Text('Preview'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
