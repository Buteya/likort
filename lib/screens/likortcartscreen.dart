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
  String getStoreName(String storeId) {
    // Find the store with the matching storeId
    final store = Provider.of<Store>(context, listen: false).stores.firstWhere(
          (store) => store.id == storeId,
          orElse: () => Store(
              userId: '',
              created: DateTime.now(),
              imageUrl: [],
              reviews: [],
              id: '',
              name: '',
              description: '',
              products: [],
              notifications: [],
              orders: []), // Handle case where store is not found
        );

    // Return the store name if found, otherwise return an empty string or a default value
    return store != null
        ? store.name
        : ''; // Or a default value like 'Unknown Store'
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: Provider.of<CartItem>(context).cartItems.isEmpty
          ? const Center(
              child: Text(
                'Start shopping',
              ),
            )
          : Column(
              children: [
                Flexible(
                  child: ListView.builder(
                      itemCount:
                          Provider.of<CartItem>(context).cartItems.length,
                      itemBuilder: (context, index) {
                        var cartitems =
                            Provider.of<CartItem>(context).cartItems;
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
                                          cartitems[index].product.storeId,
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
                                    cartitems[index].product.imageUrls[0],
                                    width: 75,
                                    height: 75,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Flexible(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(cartitems[index].product.name),
                                      Text(
                                        getStoreName(
                                          cartitems[index].product.storeId,
                                        ),
                                      ),
                                      Text(
                                          '\$${cartitems[index].product.price}'),
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
                                            cartitems[index].incrementQuantity(
                                                cartitems[index]);
                                          });
                                        },
                                        child: const Card(
                                          child: Icon(
                                            Icons.add,
                                          ),
                                        ),
                                      ),
                                      Text(
                                          cartitems[index].quantity.toString()),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            if (cartitems[index].quantity > 1) {
                                              cartitems[index]
                                                  .decrementQuantity(
                                                      cartitems[index]);
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
                            Provider.of<CartItem>(context).allCartItemsPrice().toString(),
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
                                child: Center(child: Text(Provider.of<CartItem>(context).allCartItemsQuantity().toString(),)),
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
