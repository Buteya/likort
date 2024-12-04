import 'dart:collection';

import 'package:flutter/material.dart';

class Product extends ChangeNotifier {
  final String id;
  final String name;
  final String storeId;
  final String typeOfArt;
  final String description;
  final double price;
  final List<String> imageUrls;
  int quantity;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrls,
    required this.storeId,
    required this.typeOfArt,
    this.quantity = 1,
    this.isFavorite = false,
  });

  final List<Product> _products = [];

  UnmodifiableListView<Product> get products => UnmodifiableListView(_products);

  void toggleFavoriteStatus(int index) {
    _products[index].isFavorite = !_products[index].isFavorite;
    notifyListeners();
  }

  List<Product> get favoriteProducts => _products.where((product) => product.isFavorite).toList();

  void increaseQuantity(String productId) {
    final productIndex =
        _products.indexWhere((product) => product.id == productId);
    _products[productIndex].quantity++;
    notifyListeners();
  }

  void decreaseQuantity(String productId) {
    final productIndex =
        _products.indexWhere((product) => product.id == productId);
    _products[productIndex].quantity--;
    notifyListeners();
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'],
      imageUrls: List<String>.from(json['imageUrls']),
      storeId: json['shop'],
      typeOfArt: json['typeOfArt'],
      isFavorite: json['isFavorite'],
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrls': imageUrls,
      'shop': storeId,
      'isFavorite' : isFavorite,
    };
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, description: $description, price: $price, imageUrls: $imageUrls,shop:$storeId,)';
  }
}
