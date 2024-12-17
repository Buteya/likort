import 'package:flutter/material.dart';

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
    if (_formKey.currentState!.validate()) {
      // Process the form data
      print('Store Name: ${_storeNameController.text}');
      print('Store Description: ${_storeDescriptionController.text}');
      print('Uploaded Images: $_uploadedImages');
      // ... (your logic to handle form submission)
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
              child:  IndexedStack( // Use IndexedStack to display only one step at a time
                index: _currentStep,
                children: [
                  // Step 1: Store Name
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child:  Visibility(
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
                            onPressed: _uploadImage,
                            child: const Text('Upload Image'),
                          ),
                          const SizedBox(height: 10),
                          // Display uploaded images (replace with your desired UI)
                          ..._uploadedImages.map((imagePath) => Text(imagePath)).toList(),
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
                    onPressed: _currentStep < totalSteps - 1 ? _nextStep : _submitForm,
                    child: Text(_currentStep < totalSteps - 1 ? 'Next' : 'Submit'),
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
