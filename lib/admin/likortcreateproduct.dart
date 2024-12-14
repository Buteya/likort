import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Likortcreateproduct extends StatefulWidget {
  const Likortcreateproduct({super.key});

  @override
  State<Likortcreateproduct> createState() => _LikortcreateproductState();
}

class _LikortcreateproductState extends State<Likortcreateproduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<XFile>? _imageFiles;

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage();
    if (pickedFiles != null) {
      setState(() {
        _imageFiles = pickedFiles;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            // Wrap with SingleChildScrollView
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(labelText: 'Type of Art'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the typeof art';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3, // Allow multiple lines for description
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                ElevatedButton(
                  onPressed: _pickImages,
                  child: const Text('Upload Images'),
                ),
                if (_imageFiles != null)
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _imageFiles!.length,
                      itemBuilder: (context, index) {
                        final imageFile = _imageFiles![index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.file(File(imageFile.path)),
                        );
                      },
                    ),
                  ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                      // Access form data using controllers:
                      // _nameController.text, _typeController.text, etc.
                      // Access image files using _imageFiles
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
