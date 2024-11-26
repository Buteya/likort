import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/likortartproduct.dart';

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
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    // Filter items to get only favorites
    final favoriteItems = product.favoriteIds
        .where((products) => product.favoriteIds.contains(product.id))
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
          : ListView.builder(
              itemCount: favoriteItems.length,
              itemBuilder: (context, index) {
                final item = favoriteItems[index];
                return const ListTile(
                  title: Text(''),
                  // ... other widgets to display item details ...
                );
              },
            ),
    );
  }
}
