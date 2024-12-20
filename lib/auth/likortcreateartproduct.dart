import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/likortartproduct.dart';
import '../models/likortstore.dart';
import '../models/likortusers.dart';

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
            userId: Provider.of<User>(context, listen: false).users.last.id,
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
    return Scaffold(
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
                height: MediaQuery.of(context).size.height,
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
              ElevatedButton(
                onPressed: () {
                  _submitForm();
                },
                child: const Text('create art'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
