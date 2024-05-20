import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MainPage());
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  File? image;

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      //final imageTemporary = File(image.path);
      //setState(() => this.image = imageTemporary);
      final imagePremanent = await saveImagePermanently(image.path);
      setState(() => this.image = imagePremanent);
    } on PlatformException catch (e) {
      print('Error: $e');
    }
  }

  Future<File> saveImagePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');

    return File(imagePath).copy(image.path);
  }

  uploadImage() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const SizedBox(
                height: 250,
              ),
              image != null
                  ? Image.file(
                image!,
                width: 160,
                height: 160,
              )
                  : const FlutterLogo(
                size: 160,
              ),
              const SizedBox(
                height: 100,
              ),
              buildButton(
                  title: 'Выбрать из галереи',
                  icon: Icons.image_outlined,
                  onClicked: () => pickImage(ImageSource.gallery)),
              const SizedBox(height: 24),
              buildButton(
                  title: 'Камера',
                  icon: Icons.camera_alt_outlined,
                  onClicked: () => pickImage(ImageSource.camera)),
              const SizedBox(height: 24),
              buildButton(
                  title: 'Загрузить изображение',
                  icon: Icons.upload_file,
                  onClicked: () => uploadImage()),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildButton(
    {required String title,
      required IconData icon,
      required VoidCallback onClicked}) =>
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(56),
            primary: Colors.white,
            onPrimary: Colors.black,
            textStyle: const TextStyle(fontSize: 20)),
        onPressed: onClicked,
        child: Row(
          children: [
            Icon(
              icon,
              size: 28,
            ),
            const SizedBox(
              width: 16,
            ),
            Text(title)
          ],
        ),
      ),
    );
