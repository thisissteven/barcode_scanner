import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerWidget extends StatefulWidget {
  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? _pickedImage;
  Uint8List? webImage;

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      }
    } else if (kIsWeb) {
      final ImagePicker picker = ImagePicker();
      XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('image');
        });
      }
    }
  }

  Future<void> uploadImage() async {
    Dio dio = Dio();
    String url = "http://localhost:8080/predict_image";

    try {
      FormData formData = FormData();

      final mimeType = MediaType.parse('image/jpeg');
      final fileData = MultipartFile.fromBytes(
        webImage!,
        filename: 'image.jpg',
        contentType: mimeType,
      );

      formData.files.add(MapEntry("uploaded_file", fileData));

      Response response = await dio.post(
        url,
        data: formData,
      );
      print(response.data); // Handle the response data accordingly
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Picker Example'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (webImage != null) Image.memory(webImage!, height: 100),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                await _pickImage();
              },
              child: Text('Pick an image'),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () async {
                await uploadImage();
              },
              child: Text('Upload'),
            ),
          ],
        ),
      ),
    );
  }
}
