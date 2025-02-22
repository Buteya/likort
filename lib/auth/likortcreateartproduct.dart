import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/likortartproduct.dart';
import '../models/likortstore.dart';
import '../models/likortusers.dart' as userLikort;

class LikortCreateArtProduct extends StatefulWidget {
  const LikortCreateArtProduct({super.key});

  @override
  State<LikortCreateArtProduct> createState() => _LikortCreateArtProductState();
}

class _LikortCreateArtProductState extends State<LikortCreateArtProduct> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _typeOfArtController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();
  bool _isLoading = false;
  String? downloadUrl = '';
  var uuid = const Uuid();
  final ImagePicker _picker = ImagePicker();
  final List<String> _images = [];
  final List<XFile> _imagesImages = [];
  String? fetchedFieldValue;

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _images.add(pickedFile.path);
        _imagesImages.add(pickedFile);
      });
    }
  }


  Future<void> buildProduct(String productName,String description,String price,String typeOfArt,String quantity,List<XFile> images) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final id = uuid.v4();
      await prefs.setString('id', id);
      List<String> downloadUrls = [];
      List<Map<String,dynamic>> products = [];


   Map<String,dynamic>? data;
      try {
        // Replace with your actual collection and document ID
        const collectionName = 'stores';
        final documentID = userId;
        const fieldName = 'id'; //the name of the field you want

        final docRef = FirebaseFirestore.instance
            .collection(collectionName)
            .doc(documentID);
        final docSnap = await docRef.get();

        if (docSnap.exists) {
          // Access the field.  Handle potential null values.
          final data = docSnap.data();
          final fieldValue = data?[fieldName]; //safe access using ?
          setState(() {
            fetchedFieldValue = fieldValue.toString(); //convert to string for display
          });
          print(fetchedFieldValue);
        } else {
          setState(() {
            fetchedFieldValue = 'Document does not exist.';
          });
          print(fetchedFieldValue);
        }
      } catch (e) {
        setState(() {
          fetchedFieldValue = 'Error fetching data: $e';
        });
        print(fetchedFieldValue);
      } finally {
        setState(() {
          // isLoading = false; //hide the loading indicator
        });
        print(fetchedFieldValue);
      }
      Map<String, dynamic> productData = {
        'id': id,
        'name': productName,
        'description': description,
        'price': double.parse(price),
        'imageUrls': downloadUrls,
        'storeId': fetchedFieldValue,
        'typeOfArt': typeOfArt,
        'quantity': int.parse(quantity),
        'lastUpdated': FieldValue.serverTimestamp(), // Update with server timestamp
      };
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('products');
      await usersCollection.doc(userId).set(productData).then((_) {
        if (kDebugMode) {
          print('Product data saved successfully!');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('Error saving user data: $error');
        }
        throw Exception('Failed to save product data: $error');
      });
      DocumentReference storeDocRef=
      FirebaseFirestore.instance.collection('stores').doc(userId);
      final storageRef = FirebaseStorage.instance.ref();
      final metadata = SettableMetadata(
        contentType: 'image/jpeg', // Default content type
      );
      // if (images.isEmpty) {
      //   return downloadUrls; // Return empty list if no images
      // }
      for(final imageFile in images){
        final imageRef = storageRef.child('product_images/$userId/${imageFile.name}');
        if (kIsWeb) {
          // For web, use putData with Uint8List
          final bytes = await imageFile.readAsBytes();
          await imageRef.putData(bytes, metadata);
        } else {
          // For mobile/desktop, use putFile with File
          await imageRef.putFile(File(imageFile.path), metadata);
        }
        final downloadUrl = await imageRef.getDownloadURL();
        downloadUrls.add(downloadUrl);
      }

      Map<String, dynamic> productToUpdate = {
        'id': id,
        'name': productName,
        'description': description,
        'price': double.parse(price),
        'imageUrls': downloadUrls,
        'storeId': fetchedFieldValue,
        'typeOfArt': typeOfArt,
        'quantity': int.parse(quantity),
      };

      Map<String, dynamic> dataToUpdate = {};

      // Only add imageUrl if it's not null
      if (id != "") {
        // List<String> ids = [];
        // ids.add(id);
        products.add(productToUpdate);
        dataToUpdate['products'] = products;
      }

      // Update the document
      await storeDocRef.update(dataToUpdate);

      DocumentReference productDocRef=
      FirebaseFirestore.instance.collection('products').doc(userId);

      if(downloadUrls.isNotEmpty){
        productData['imageUrls'] = downloadUrls;
      }

      await productDocRef.update(productData);

      Navigator.of(context).pushReplacementNamed('/likortmanagestore');

      if (kDebugMode) {
        print('Store document updated successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating store document: $e');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }
  //
  // // Function to handle image upload (replace with your actual implementation)
  // Future<void> _uploadImage() async {
  //   // Simulate image upload
  //   await Future.delayed(const Duration(seconds: 1));
  //   setState(() {
  //     _uploadedImages.add('path/to/uploaded/image');
  //   });
  // }

  // Function to handle form submission
  void _submitForm() {
    var uuid = const Uuid();
    final id = uuid.v4();
    if (_formKey.currentState!.validate()) {
      // Process the form data
      print('Art Name: ${_nameController.text}');
      print('Art Description: ${_descriptionController.text}');
      print('Uploaded Images: $_images');
      // ... (your logic to handle form submission)
      final store = Provider.of<Store>(context, listen: false);
      try {
        Provider.of<Product>(context, listen: false).add(
              Product(
                id: id,
                name: _nameController.text,
                description: _descriptionController.text,
                price: double.parse(_priceController.text),
                imageUrls: _images,
                storeId: store.stores.last.id,
                typeOfArt: _typeOfArtController.text,
                quantity: int.parse(_quantityController.text),
              ),
            );
      } catch (e) {
        print(e);
      }

      List<Product> product = [];
      for (final product in product){
        print(product.id);
        print(product.storeId);
        print(product.description);
        print(product.name);
        print(product.quantity);
        print(product.price);
        print(product.typeOfArt);
        print(product.imageUrls);
      }
      if (Provider.of<Product>(context, listen: false).products.last.storeId ==
          store.stores.last.id) {
        product = Provider.of<Product>(context, listen: false).products;
      }
      try {
        store.addStore(
          Store(
            userId: Provider.of<userLikort.User>(context, listen: false).users.last.id,
            created: store.stores.last.created,
            imageUrl: store.stores.last.imageUrl,
            reviews: [],
            id: id,
            name: store.stores.last.name,
            description: store.stores.last.description,
            products: product,
            notifications: [],
            orders: [],
          ),
        );
        for (final store in store.stores) {
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
        if (store.stores.isNotEmpty) {
          Navigator.of(context).pushReplacementNamed('/likortmanagestore');
        }
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _nameController.dispose();
    _typeOfArtController.dispose();
    _descriptionController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Scaffold(
      body: TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed('/likortlogin'),
          child: const Text('Login')),
    )
        : Scaffold(
      appBar: AppBar(
        title: const Text('create art product'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter art name';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _typeOfArtController,
                  decoration: const InputDecoration(
                    labelText: 'Type of Art',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter type of art';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter product description';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _quantityController,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid integer';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid integer';
                    }
                    return null;
                  },
                ),
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
                height: MediaQuery.sizeOf(context).height *.6,
                child: GridView.builder(
                  itemCount: _images.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 4,
                    mainAxisSpacing: 4,
                  ),
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        _images[index],
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0,bottom: 20),
                child: ElevatedButton(
                  onPressed: () {
                    // _submitForm();
                    buildProduct(_nameController.text, _descriptionController.text,_priceController.text, _typeOfArtController.text, _quantityController.text, _imagesImages);
                  },
                  child: const Text('create art'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
