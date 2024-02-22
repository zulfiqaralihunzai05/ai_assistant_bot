import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../apis/apis.dart';
import '../../helper/my_dialog.dart';
import '../../widget/custom_btn.dart';

class BackgroundRemove extends StatefulWidget {
  const BackgroundRemove({super.key});

  @override
  State<BackgroundRemove> createState() => _BackgroundRemoveState();
}

class _BackgroundRemoveState extends State<BackgroundRemove> {
  Uint8List? imageFile;

  String? imagePath;

  ScreenshotController controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remove Bg'),
        actions: [

          IconButton(
              onPressed: () {
                getImage(ImageSource.camera);
              },
              icon: const Icon(Icons.camera_alt)),

          // IconButton(
          //     onPressed: () async {
          //       saveImage();
          //     },
          //     icon: const Icon(Icons.save))
        ],
      ),

      floatingActionButton: Padding(
        padding: const EdgeInsets.only(right: 6, bottom: 6),
        child: FloatingActionButton(
          onPressed: () async {
            saveImage();
          },
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          child: const Icon(Icons.save_alt_rounded, size: 26),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.blue,
                    width: 2.0,
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    getImage(ImageSource.gallery);
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      (imageFile != null)
                          ? Screenshot(
                        controller: controller,
                        child: Image.memory(
                          imageFile!,
                        ),
                      )
                          : Container(
                        width: 300,
                        height: 300,
                        color: Colors.grey[300]!,
                        child: const Icon(
                          Icons.image,
                          size: 100,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(
              height: 10,
            ),
            CustomBtn(
              onTap: () async {
                imageFile = await APIs().removeBgApi(imagePath!);
                setState(() {});
              },
              text: 'Remove Background',
            ),
            const SizedBox(
              height: 80,
            ),
            //ElevatedButton(onPressed: (){}, child: const Text(''))
          ],
        ),
      ),
    );
  }

  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        imagePath = pickedImage.path;
        imageFile = await pickedImage.readAsBytes();
        setState(() {});
      }
    } catch (e) {
      imageFile = null;
      setState(() {});
    }
  }

  void saveImage() async {
    try {
      MyDialog.showLoadingDialog();
      bool isGranted = await Permission.storage.status.isGranted;
      if (!isGranted) {
        isGranted = await Permission.storage
            .request()
            .isGranted;
      }

      if (isGranted) {
        String directory = (await getExternalStorageDirectory())!.path;
        String fileName =
            DateTime
                .now()
                .microsecondsSinceEpoch
                .toString() + ".png";
        //"${DateTime.now().microsecondsSinceEpoch}.png";
        controller.captureAndSave(directory, fileName: fileName);
        Get.back();
        MyDialog.success('Image Downloaded to Gallery!');
      }
    } catch (e) {
      Get.back();
      MyDialog.error('Something Went Wrong (Try again in sometime)!');
      //log('downloadImageE: $e');
    }
  }
}
