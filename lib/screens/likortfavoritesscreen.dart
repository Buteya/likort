import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// import '../models/likortartproduct.dart';
import '../models/likortfavorites.dart';
import '../models/likortstore.dart';
import '../models/likortusers.dart';

class LikortFavoriteScreen extends StatefulWidget {
  const LikortFavoriteScreen({super.key});

  @override
  State<LikortFavoriteScreen> createState() => _LikortFavoriteScreenState();
}

class _LikortFavoriteScreenState extends State<LikortFavoriteScreen> {
  // final product = Provider.of<Product>(context);
  //
  // // Filter items to get only favorites
  // final favoriteProducts = product.products
  //     .where((product) => product.products.favoriteIds.contains(product.id))
  //     .toList();

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
    return store.name ?? ''; // Or a default value like 'Unknown Store'
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    // final product = Provider.of<Product>(context);
    // Filter items to get only favorites
    // final favoriteItems = product.favoriteProducts
    //     .where((products) => product.favoriteProducts.contains(product.id))
    //     .toList();
    for (final prod in Provider.of<User>(context).users.last.favorites) {
      print(prod.isFavorite);
      print(prod.id);
      print(prod.typeOfArt);
    }
    final favorites = Provider.of<Favorites>(
      context,
      listen: false,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/likorthomescreen');
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Provider.of<Favorites>(context).favorites.isEmpty
          ? const Center(
              child: Text('No favorites yet.'),
            )
          : GridView.builder(
              // controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of items per row
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
              ),
              itemCount: Provider.of<Favorites>(context, listen: false)
                  .favorites
                  .expand((fav) => fav.favoriteProducts)
                  .length,
              itemBuilder: (context, index) {
                final product = Provider.of<Favorites>(context, listen: false)
                    .favorites
                    .expand((fav) => fav.favoriteProducts)
                    .toList()[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed('/likortproductdetail');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.network(
                          product.imageUrls[0],
                          width: screenSize.width * .83,
                          height: screenSize.height / 2.66,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: InkWell(
                              onTap: () {
                                // product
                                //     // .toggleFavorite(product.products[0].id);
                                setState(() {
                                  final favoriteProducts =
                                      Provider.of<Favorites>(
                                    context,
                                    listen: false,
                                  )
                                          .favorites
                                          .expand((fav) => fav.favoriteProducts)
                                          .toList();
                                  final productIndex =
                                      favoriteProducts.indexWhere(
                                          (prod) => prod.id == product.id);
                                  if (!favoriteProducts.contains(product)) {
                                    favoriteProducts.add(product);
                                    favorites.add(Favorites(
                                      id: const Uuid().v4(),
                                      userId: Provider.of<User>(context,
                                              listen: false)
                                          .users
                                          .last
                                          .id,
                                      favoriteProducts: favoriteProducts,
                                    ));
                                  } else if (favoriteProducts
                                      .contains(product)) {
                                    setState(() {
                                      Provider.of<Favorites>(
                                        context,
                                        listen: false,
                                      )
                                          .favorites
                                          .expand((fav) => fav.favoriteProducts)
                                          .toList()
                                          .removeAt(productIndex);
                                      favorites.removeFavorite(productIndex);
                                    });
                                  }
                                });
                              },
                              child: favorites.favorites.any((fav) =>
                                      fav.favoriteProducts.contains(product))
                                  ? Icon(
                                      Icons.favorite_rounded,
                                      color: favorites.favorites.any((fav) =>
                                              fav.favoriteProducts
                                                  .contains(product))
                                          ? Colors.red
                                          : Colors.grey,
                                    )
                                  : Icon(
                                      Icons.favorite_border_rounded,
                                      color: favorites.favorites.any((fav) =>
                                              fav.favoriteProducts
                                                  .contains(product))
                                          ? Colors.red
                                          : Colors.grey,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .1,
                          )
                        ],
                      ),
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        getStoreName(product.storeId),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${product.price}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .1,
                      )
                    ],
                  ),
                );
              }),
    );
  }
}
