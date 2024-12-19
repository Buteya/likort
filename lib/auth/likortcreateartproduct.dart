import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class LikortCreateArtProduct extends StatefulWidget {
  const LikortCreateArtProduct({super.key});

  @override
  State<LikortCreateArtProduct> createState() => _LikortCreateArtProductState();
}

class _LikortCreateArtProductState extends State<LikortCreateArtProduct> {
  final ImagePicker _picker = ImagePicker();
  final List<String> _images = [];
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create art product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('create art'),
            ),
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Capture Image'),
            ),
            const SizedBox(height: 16),
            _images.isEmpty
                ? const Center(
                    child: Icon(Icons.image_rounded),
                  )
                : Image.network(
                    _images[0],
                    height: 400,
                  ),
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: GridView.builder(
                itemCount: _images.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemBuilder: (context, index) {
                  return Image.network(_images[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
