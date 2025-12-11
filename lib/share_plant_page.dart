import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

class SharePlantPage extends StatefulWidget {
  const SharePlantPage({Key? key}) : super(key: key);

  @override
  _SharePlantPageState createState() => _SharePlantPageState();
}

class _SharePlantPageState extends State<SharePlantPage> {
  File? _image;
  final TextEditingController _captionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery
  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Take photo using camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Share image
  Future<void> _shareImage() async {
    if (_image != null) {
      await Share.shareXFiles(
        [XFile(_image!.path)],
        text: _captionController.text.isEmpty
            ? "Check out my plant! 🌱"
            : _captionController.text,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick or capture an image")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Share Plant")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _image != null
                ? Image.file(_image!, height: 250)
                : Container(
              height: 250,
              color: Colors.grey[200],
              child: const Center(child: Text("No image selected")),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: _captionController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Caption',
              ),
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImageFromGallery,
                    icon: const Icon(Icons.photo),
                    label: const Text("Gallery"),
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImageFromCamera,
                    icon: const Icon(Icons.camera_alt),
                    label: const Text("Camera"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _shareImage,
              icon: const Icon(Icons.share),
              label: const Text("Share"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
