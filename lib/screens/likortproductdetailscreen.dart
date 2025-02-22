import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/likortartproduct.dart';
import '../models/likortcartitem.dart';
import '../models/likortfavorites.dart';
import '../models/likortstore.dart';
import '../models/likortusers.dart';

class LikortProductDetailScreen extends StatefulWidget {
  const LikortProductDetailScreen({super.key});

  @override
  State<LikortProductDetailScreen> createState() =>
      _LikortProductDetailScreenState();
}

class _LikortProductDetailScreenState extends State<LikortProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;
  List<Map<String,dynamic>> stores = [];
  List<Map<String,dynamic>> products = [];
  List<Map<String,dynamic>> favorites = [];
  bool _isLoading = false;
  var uuid = const Uuid();

  @override
  void initState() {
    // TODO: implement initState
    loadStoreData();
    loadProductData();
    loadFavoriteData();
    super.initState();
  }

  Future<void> createCartItem(
      Map product) async {
    final id = uuid.v4();
    final listProducts = [];
    List<Map<String,dynamic>> cartItemsList = [];
    try {
      // 1. Create the user with email and password
      var userId = FirebaseAuth.instance.currentUser?.uid;
      // 2. Check if the user is created
      if (userId == null) {
        if (kDebugMode) {
          print('user not found');
        }
        return;
      }
      listProducts.add(product);
      // 3. Get the user ID
      print(userId);
      // 4. Create the user data map
      Map<String, dynamic> cartItemData = {
        'id': id,
        'userId': userId,
        'product':product,
        'quantity':_quantity,
        'created': DateTime.now(),  // Use server timestamp
      };
      print(cartItemData);
      //
      // for(final cartItem in cartItemData.values){
      //   print(cartItem);
      // }
      // 5. Save the user data to Firestore
       cartItemsList.add(cartItemData);
       Map<String,dynamic> listCartItems = {
         'cartItemsList':cartItemsList,
       };
          CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('cartItems');
      await usersCollection.doc(userId).set(cartItemData).then((_) {
          if (kDebugMode) {
            print('CartItems data saved successfully!');
          }
        }).catchError((error) {
          if (kDebugMode) {
            print('Error saving cartitems data: $error');
          }
          throw Exception('Failed to save cartitems data: $error');
        });

    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
    }
  }

  Future<List<Map<String, dynamic>>> fetchFavoriteData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('favorites').get();
      List<Map<String, dynamic>> items = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        items.add(doc.data() as Map<String, dynamic>);
      }
      print(items);
      return items;
    } catch (e) {
      print("Error fetching data: $e");
      return []; //Return an empty list in case of error
    }
  }

  Future<void> loadFavoriteData() async{
    try {
      final userData =  await fetchFavoriteData();
      if (userData != null) {
        setState(() {
          favorites = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchProductData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('products').get();
      List<Map<String, dynamic>> items = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        items.add(doc.data() as Map<String, dynamic>);
      }
      print(items);
      return items;
    } catch (e) {
      print("Error fetching data: $e");
      return []; //Return an empty list in case of error
    }
  }


  Future<List<Map<String, dynamic>>> fetchStoreData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('stores').get();
      List<Map<String, dynamic>> items = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        items.add(doc.data() as Map<String, dynamic>);
      }
      print(items);
      return items;
    } catch (e) {
      print("Error fetching data: $e");
      return []; //Return an empty list in case of error
    }
  }

  Future<void> loadProductData() async{
    try {
      final userData =  await fetchProductData();
      if (userData != null) {
        setState(() {
          products = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> loadStoreData() async{
    try {
      final userData =  await fetchStoreData();
      if (userData != null) {
        setState(() {
          stores = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }


  String getStoreName(String storeId)  {
    final store = stores.firstWhere(
          (store) => store['id'] == storeId,
      orElse: () => {}, // Handle case where store is not found
    );
    // Return the store name if found, otherwise return an empty string or a default value
    return store != null
        ? store['name']
        : ''; // Or a default value like 'Unknown Store'
  }

  @override
  Widget build(BuildContext context) {
    final index = ModalRoute.of(context)!.settings.arguments as int;

    return _isLoading ?Scaffold(body: Center(child: CircularProgressIndicator(),),):Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/likorthomescreen');
            },
            child: const Icon(Icons.arrow_back,),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  products[index]['imageUrls'][_selectedImageIndex],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.4,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) {
                      // Image has finished loading
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      });
                      return child;
                    } else {
                      // Image is still loading
                      return const SizedBox.shrink(); // Return an empty widget while loading
                    }
                  },
                  errorBuilder: (BuildContext context, Object error,
                      StackTrace? stackTrace) {
                    // Handle image loading errors here
                    return const Icon(Icons.error); // Show an error icon
                  },
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: products[index]['imageUrls'].length,
                      itemBuilder: (context, imageIndex) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedImageIndex = imageIndex; // Update _selectedImageIndex
                            });
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  products[index]['imageUrls'][imageIndex],
                                  width: MediaQuery.of(context).size.width * .2,
                                  height:  MediaQuery.of(context).size.height * .15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .02,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      if (!favorites
                          .contains(products[index])) {
                      }else if(favorites.contains(products[index])){
                        setState(() {
                        });
                      }
                    });
                  },
                  child: favorites.any(
                          (fav) =>
                          favorites
                          .contains(products[index]))
                      ? Icon(
                    Icons.favorite_rounded,
                    color:  favorites.any(
                            (fav) =>
                            favorites
                            .contains(products[index]))
                        ? Colors.red
                        : Colors.grey,
                  )
                      : Icon(
                    Icons
                        .favorite_border_rounded,
                    color:  favorites.any(
                            (fav) =>
                            favorites
                            .contains(products[index]))
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                )
              ],
            ),
             Text(products[index]['name']),
             Text(products[index]['typeOfArt']),
            Text(
              getStoreName(products[index]['storeId']),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
             Center(
              child: SizedBox(
                width: 200,
                child: Text(
                  products[index]['description'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Text(
              '\$${products[index]['price']}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:() {
                      // Handle remove quantity
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
                    ),
                    child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                if (_quantity > 1) {
                                  _quantity--;
                                }});
                            },child: const Icon(Icons.remove,),),
                        const SizedBox(width: 8.0), // Add spacing
                        Text(_quantity.toString()),
                        const SizedBox(width: 8.0), // Add spacing
                        InkWell(
                            onTap: () {
                              setState(() {
                                  _quantity++;
                                });
                            },
                            child: const Icon(Icons.add,),),
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: () {

                    Navigator.of(context).pushReplacementNamed('/likorthomescreen');
                  },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
                    ),
                    child: InkWell(
                      onTap: (){
                        var cartItems = Provider.of<CartItem>(context,listen:false);
                        var id = const Uuid().v4();
                        if(_quantity >= 1){
                          createCartItem(products[index]);
                          Navigator.of(context).pushNamed('/likortcart');
                          // cartItems.add(CartItem(id: id,userId: Provider.of<User>(context,listen:false).users.last.id, product: products[index],quantity: _quantity,),);
                        }
                       for(var item in cartItems.cartItems){
                         print(item.id);
                         print(item.userId);
                         print(item.product.id);
                         print(item.quantity);
                       }

                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_rounded),
                          SizedBox(width: 8.0), // Add spacing
                          Text('Add to Cart'), // Capitalize text
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            )
          ],
        ),
      ),
    );
  }
}
