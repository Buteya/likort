import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:likort/models/likortartproduct.dart';
import 'package:likort/models/likortnotifications.dart';
import 'package:likort/models/likortorders.dart';
import 'package:likort/models/likortreview.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/likortstore.dart';
import '../models/likortusers.dart';

class LikortBuildCreatorStore extends StatefulWidget {
  const LikortBuildCreatorStore({super.key});

  @override
  State<LikortBuildCreatorStore> createState() =>
      _LikortBuildCreatorStoreState();
}

class _LikortBuildCreatorStoreState extends State<LikortBuildCreatorStore> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  late TextEditingController _storeNameController;
  late TextEditingController _storeDescriptionController;
  List<String> _uploadedImages = []; // To store uploaded image paths

  @override
  void initState() {
    super.initState();
    _storeNameController = TextEditingController();
    _storeDescriptionController = TextEditingController();
  }

  @override
  void dispose() {
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    super.dispose();
  }

  // Function to handle image upload (replace with your actual implementation)
  Future<void> _uploadImage() async {
    // Simulate image upload
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _uploadedImages.add('path/to/uploaded/image');
    });
  }

  // Function to handle form submission
  void _submitForm() {
    var uuid = const Uuid();
    final id = uuid.v4();
    if (_formKey.currentState!.validate()) {
      // Process the form data
      print('Store Name: ${_storeNameController.text}');
      print('Store Description: ${_storeDescriptionController.text}');
      print('Uploaded Images: $_uploadedImages');
      // ... (your logic to handle form submission)
      final store = Provider.of<Store>(context, listen: false);
      try{
        store.addStore(
          Store(
            userId: Provider.of<User>(context, listen: false).users.last.id,
            created: DateTime.now(),
            imageUrl: _uploadedImages,
            reviews: [],
            id: id,
            name: _storeNameController.text,
            description: _storeDescriptionController.text,
            products: [],
            notifications: [],
            orders: [],
          ),
        );
        for (final store in store.stores){
          print(store.id);
          print(store.created);
          print(store.reviews);
          print(store.userId);
          print(store.products);
          print(store.description);
          print(store.name);
          print(store.orders);
          print(store.notifications);
          print(store.imageUrl);
        }
        if(store.stores.isNotEmpty){
          Navigator.of(context).pushReplacementNamed('/likortmanagestore');
        }
      }catch (e){
        print(e);
      }


    }
  }

  // Function to move to the next step
  void _nextStep() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _currentStep++;
      });
    }
  }

  // Function to move to the previous step
  void _previousStep() {
    setState(() {
      _currentStep--;
    });
  }

  // Function to get step color basedon current step
  Color _getStepColor(int step) {
    switch (step) {
      case 0:
        return Colors.deepOrangeAccent;
      case 1:
        return Colors.orangeAccent;
      case 2:
        return Colors.orange;
      default:
        return Colors.deepOrange;
    }
  }

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedImages.add(pickedFile.path);
      });
    }
  }

  Future<void> _rePickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _uploadedImages[index] = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const totalSteps = 3; // Total number of steps

    return Scaffold(
      appBar: AppBar(
        title: const Text('create likort store'),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: LinearProgressIndicator(
                value: (_currentStep + 1) / totalSteps,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  _getStepColor(_currentStep),
                ),
              ),
            ),
            Expanded(
              child: IndexedStack(
                // Use IndexedStack to display only one step at a time
                index: _currentStep,
                children: [
                  // Step 1: Store Name
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Visibility(
                        visible: _currentStep == 0,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            controller: _storeNameController,
                            decoration: const InputDecoration(
                              labelText: 'Enter Store Name',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a store name';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Step 2: Store Description
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Visibility(
                        visible: _currentStep == 1,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TextFormField(
                            maxLines: 3,
                            controller: _storeDescriptionController,
                            decoration: const InputDecoration(
                              labelText: 'Enter Store Description',
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a store description';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Step 3: Upload Images
                  Visibility(
                    visible: _currentStep == 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed:
                                _pickImage, // Call _pickImage toselect an image
                            child: const Text('Add Image'),
                          ),
                          const SizedBox(height: 10),
                          // Display picked images in a row
                          if (_uploadedImages.isNotEmpty)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * .6,
                              width: double.infinity, // Adjust height as needed
                              child: ListView.builder(
                                itemCount: _uploadedImages.length,
                                itemBuilder: (context, index) {
                                  final imageFile = _uploadedImages[index];
                                  return GestureDetector(
                                    onTap: () => _rePickImage(
                                        index), // Call _rePickImage to re-select
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: imageFile != null
                                          ? ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(15.0),
                                              child: Image.network(
                                                imageFile,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .3,
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    .6,
                                                fit: BoxFit.contain,
                                              ),
                                            )
                                          : const Placeholder(
                                              fallbackWidth: 100,
                                              fallbackHeight: 100,
                                            ),
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            const Center(child: Text('No images selected')),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_currentStep > 0)
                    ElevatedButton(
                      onPressed: _previousStep,
                      child: const Text('Previous'),
                    ),
                  ElevatedButton(
                    onPressed:
                        _currentStep < totalSteps - 1 ? _nextStep : _submitForm,
                    child:
                        Text(_currentStep < totalSteps - 1 ? 'Next' : 'Submit'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
