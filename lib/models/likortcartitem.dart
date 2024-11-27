import 'package:flutter/material.dart';

import 'likortartproduct.dart';

class CartItem extends ChangeNotifier{
  final String id;
  final Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    this.quantity = 1,
  });

  final List<CartItem> items = [];

  void add(Product product) {
    final existingItemIndex = items.indexWhere((item) => item.product.id == product.id);

    if (existingItemIndex != -1) {
      // If product already in cart, increase quantity
      items[existingItemIndex].quantity++;
    } else {
      // If product not in cart, add it
      // items.add(CartItem(product: product));
    }}


  void incrementQuantity() {
    quantity++;
    notifyListeners();
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
    notifyListeners();
  }

  double getTotalPrice() {
    return product.price * quantity;
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      product: Product.fromJson(json['product']),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  @override
  String toString() {
    return 'CartItem(id: $id, product: ${product.name}, quantity: $quantity, total: ${getTotalPrice()})';
  }
}
