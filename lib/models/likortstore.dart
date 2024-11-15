import 'package:flutter/material.dart';

import 'likortartproduct.dart';

class Store extends ChangeNotifier{
  final String id;
  final String name;
  final String description;
  List<Product> products;

  Store({
    required this.id,
    required this.name,
    required this.description,
    required this.products,
  });

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      products: (json['products'] as List).map((item) => Product.fromJson(item)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'products': products.map((item) => item.toJson()).toList(),
    };
  }

  void addProduct(Product product) {
    products.add(product);
    notifyListeners();
  }

  void removeProduct(String productId) {
    products.removeWhere((product) => product.id == productId);
    notifyListeners();
  }

  @override
  String toString() {
    return 'Store(id: $id, name: $name, description: $description, products: $products)';
  }
}
