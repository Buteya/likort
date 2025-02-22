import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/likortcartitem.dart';
import '../models/likortstore.dart';

class LikortCartScreen extends StatefulWidget {
  const LikortCartScreen({super.key});

  @override
  State<LikortCartScreen> createState() => _LikortCartScreenState();
}

class _LikortCartScreenState extends State<LikortCartScreen> {
  List<Map<String, dynamic>> cartItems = [];
  List<Map<String, dynamic>> stores = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    loadCartItemData();
    loadStoreData();
    super.initState();
  }


  Future<List<Map<String, dynamic>>> fetchCartItemData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('cartitems').get();
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

  Future<void> loadCartItemData() async {
    try {
      final userData = await fetchCartItemData();
      if (userData != null) {
        setState(() {
          cartItems = userData;
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

  Future<List<Map<String, dynamic>>> fetchStoreData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();
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

  Future<void> loadStoreData() async {
    try {
      final userData = await fetchStoreData();
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

  String getStoreName(String storeId) {
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
    return _isLoading?Scaffold(body: Center(child: CircularProgressIndicator(),),):Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/likorthomescreen');
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Center(child: Text('cart')),
        actions: const [
          Card(
            child: Icon(Icons.delete),
          ),
        ],
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Text(
                'Start shopping',
              ),
            )
          : Column(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .05,
                                      ),
                                      const Icon(
                                        Icons.shopping_basket_rounded,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .02,
                                      ),
                                      Text(
                                        getStoreName(
                                          cartItems[index]['product']
                                              ['storeId'],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('view shop'),
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * .03,
                                ),
                              ],
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, right: 16.0),
                              child: Divider(),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    cartItems[index]['product']['imageUrls'][0],
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(cartItems[index]['product']['name']),
                                      Text(
                                        getStoreName(
                                          cartItems[index]['product']
                                              ['storeId'],
                                        ),
                                      ),
                                      Text(
                                          '\$${cartItems[index]['product']['price']}'),
                                    ],
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            cartItems[index]['quantity']++;
                                          });
                                        },
                                        child: const Card(
                                          child: Icon(
                                            Icons.add,
                                          ),
                                        ),
                                      ),
                                      Text(cartItems[index]['quantity']
                                          .toString()),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (cartItems[index]['quantity'] >
                                                1) {
                                              cartItems[index]['quantity']--;
                                            }
                                          });
                                        },
                                        child: const Card(
                                          child: Icon(
                                            Icons.remove,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      }),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .07,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          const Text('amount price'),
                          Text(
                            cartItems.fold(
                              0.0,
                              (double cartSum, Map<String, dynamic> item) {
                                // Safely get the price and quantity.
                                double price = double.tryParse(
                                        item['product']['price']?.toString() ??
                                            '0') ??
                                    0.0;
                                //double quantity = double.tryParse(item.product['quantity']?.toString() ?? '0') ?? 0.0;
                                int quantity = item['quantity'];

                                // Calculate the item total.
                                double itemTotal = price * quantity;

                                // Add the item total to the running sum.
                                return cartSum + itemTotal;
                              },
                            ).toStringAsFixed(2),
                            style: Theme.of(context).textTheme.headlineLarge,
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/likortcheckout');
                        },
                        child: Row(
                          children: [
                            const Text('checkout'),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Center(
                                    child: Text(
                                      cartItems.fold(
                                        0.0,
                                            (double cartSum, Map<String, dynamic> item) {
                                          // Safely get the price and quantity.
                                          double price = double.tryParse(
                                              item['product']['price']?.toString() ??
                                                  '0') ??
                                              0.0;
                                          //double quantity = double.tryParse(item.product['quantity']?.toString() ?? '0') ?? 0.0;
                                          int quantity = item['quantity'];

                                          // Calculate the item total.
                                          double itemTotal = price * quantity;

                                          // Add the item total to the running sum.
                                          return cartSum + quantity;
                                        },
                                      ).toStringAsFixed(0),
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .05,
                ),
              ],
            ),
    );
  }
}
