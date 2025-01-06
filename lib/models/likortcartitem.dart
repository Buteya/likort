import 'dart:collection';

import 'package:flutter/material.dart';

import 'likortartproduct.dart';

class CartItem extends ChangeNotifier{
  final String id;
  final String userId;
  final Product product;
  int quantity;


  CartItem({
    required this.id,
    required this.userId,
    required this.product,
    this.quantity = 1,
  });

  final List<CartItem> _cartItems = [];

  UnmodifiableListView<CartItem> get cartItems =>
      UnmodifiableListView(_cartItems);

  void add(CartItem cartItem) {
    _cartItems.add(cartItem);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  // void add(Product product) {
  //   final existingItemIndex = items.indexWhere((item) => item.product.id == product.id);
  //
  //   if (existingItemIndex != -1) {
  //     // If product already in cart, increase quantity
  //     items[existingItemIndex].quantity++;
  //   } else {
  //     // If product not in cart, add it
  //     // items.add(CartItem(product: product));
  //   }}


  void incrementQuantity(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  void decrementQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    }
    notifyListeners();
  }

  double getTotalPrice() {
    return product.price * quantity;
  }

  double allCartItemsPrice(){
    return _cartItems.fold(0, (sum,item)=>sum +item.getTotalPrice());
  }

  double allCartItemsQuantity(){
    return _cartItems.fold(0,(sum,item)=>sum + item.quantity);
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'],
      userId: json['userId'],
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
