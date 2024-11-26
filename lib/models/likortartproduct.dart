import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Product extends ChangeNotifier {
  final String id;
  final String name;
  final String shop;
  final String typeOfArt;
  final String description;
  final double price;
  final String storeId;
  final List<String> imageUrls;
  bool isFavorite;

  Product({
    required this.id,
    required this.storeId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.shop,
    required this.typeOfArt,
    this.isFavorite = false,
  });

  final List<Product> _products = [];

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  List<String> _favoriteIds = [];
  List<String> get favoriteIds => _favoriteIds;

  void toggleFavorite(String productId) {
    final productIndex =
        _products.indexWhere((product) => product.id == productId);
    if (productIndex != -1) {
      _products[productIndex].isFavorite = !_products[productIndex].isFavorite;
      if (_products[productIndex].isFavorite) {
        _favoriteIds.add(productId);
      } else {
        _favoriteIds.remove(productId);
      }
      notifyListeners(); // Notify listeners of state change
    }
  }

  Future<void> loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteIds = prefs.getStringList('favorite_ids') ??
        []; // Get favorite IDs from Shared Preferences
    _favoriteIds = favoriteIds; // Update the provider's favorite IDs
    // Update the isFavorite property of items based on loaded favorite IDs
    for (final itemId in favoriteIds) {
      final productIndex = _products.indexWhere((item) => item.id == itemId);
      if (productIndex != -1) {
        _products[productIndex].isFavorite = true;
      }
    }

    notifyListeners(); // Notify listeners of state change
  }

  // Save favorites to Shared Preferences
  Future<void> saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_ids',
        _favoriteIds); // Save favorite IDs to Shared Preferences
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrls: List<String>.from(json['imageUrls']),
      shop: json['shop'],
      typeOfArt: json['typeOfArt'],
      storeId: json['storeId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'shop': shop,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, imageUrls: $imageUrls,shop:$shop,)';
  }
}
