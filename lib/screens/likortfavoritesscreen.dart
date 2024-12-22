import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/likortartproduct.dart';
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
    return store != null
        ? store.name
        : ''; // Or a default value like 'Unknown Store'
  }
  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final product = Provider.of<Product>(context);
    // Filter items to get only favorites
    final favoriteItems = product.favoriteProducts
        .where((products) => product.favoriteProducts.contains(product.id))
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton.outlined(onPressed: (){
          Navigator.of(context).pushReplacementNamed('/likorthomescreen');
        }, icon: const Icon(Icons.arrow_circle_left_outlined)),
      ),
      body: favoriteItems.isEmpty
          ? const Center(
              child: Text('No favorites yet.'),
            )
          : GridView.builder(
          // controller: _scrollController,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Number of items per row
            crossAxisSpacing: 8.0, // Spacing between columns
            mainAxisSpacing: 8.0, // Spacing between rows
          ),
          itemCount: Provider.of<User>(context).users.last.favorites.length,
          itemBuilder: (context, index) {
            final product = Provider.of<User>(context).users.last.favorites[index];
            return InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushNamed('/likortproductdetail');
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
                              List<Product> favorites = [];
                              final prod = Provider.of<User>(context).users.last.favorites
                                  .firstWhere((prod) =>
                              prod.id == product.id);
                              if (prod.isFavorite) {
                                prod.isFavorite = false;
                                favorites.remove(prod);
                              } else {
                                prod.isFavorite = true;
                                favorites.add(prod);
                                final user =
                                Provider.of<User>(context,listen: false);
                                user.updateUser(User(
                                  id: user.users.last.id,
                                  firstname:
                                  user.users.last.firstname,
                                  lastname:
                                  user.users.last.lastname,
                                  email: user.users.last.email,
                                  password:
                                  user.users.last.password,
                                  phone: user.users.last.phone,
                                  latitude:
                                  user.users.last.latitude,
                                  longitude:
                                  user.users.last.longitude,
                                  imageUrl:
                                  user.users.last.imageUrl,
                                  storeId:
                                  user.users.last.storeId,
                                  reviews:
                                  user.users.last.reviews,
                                  favorites: favorites,
                                  notifications: user
                                      .users.last.notifications,
                                  created:
                                  user.users.last.created,
                                ));
                              }
                            });
                          },
                          child: product.isFavorite
                              ? Icon(
                            Icons.favorite_rounded,
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.grey,
                          )
                              : Icon(
                            Icons.favorite_border_rounded,
                            color: product.isFavorite
                                ? Colors.red
                                : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width *
                            .1,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '\$${product.price}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height:
                    MediaQuery.of(context).size.height * .1,
                  )
                ],
              ),
            );
          }),
    );
  }
}
