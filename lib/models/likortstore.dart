import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:likort/models/likortorders.dart';
import 'package:likort/models/likortreview.dart';

import 'likortartproduct.dart';


class Store extends ChangeNotifier {
  final String id;
  final String name;
  final String description;
  final List<Product> products;
  final String userId;
  final DateTime created;
  final List<String> imageUrl;
  final List<Review> reviews;
  final List<String> notifications;
  final List<Order> orders;

  Store({
    required this.userId,
    required this.created,
    required this.imageUrl,
    required this.reviews,
    required this.id,
    required this.name,
    required this.description,
    required this.products,
    required this.notifications,
    required this.orders,
  });

  final List<Store> _stores = [];

  UnmodifiableListView<Store> get stores => UnmodifiableListView(_stores);

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      products: (json['products'] as List)
          .map((item) => Product.fromJson(item))
          .toList(),
      userId: json['userId'],
      created: json['created'],
      imageUrl: json['imageUrl'],
      reviews: json['reviews'],
      notifications: json['notifications'],
      orders: json['orderIds'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'products': products.map((item) => item.toJson()).toList(),
      'userId':userId,
      'created' : created,
      'reviews' : reviews,
      'notifications' : notifications,
      'orderIds':orders,
    };
  }
  void addStore(Store store) {
    _stores.add(store);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeStore(int index) {
    _stores.removeAt(index);
    notifyListeners();
  }

  void updateStore(Store updatedStore) {
    _stores[_stores.length - 1] = updatedStore;
    notifyListeners();
  }

  void updateSingleStore(Store updatedStore, int index) {
    _stores[index] = updatedStore;
    notifyListeners();
  }

  void removeAll() {
    _stores.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
  @override
  String toString() {
    return 'Store(id: $id, name: $name, description: $description, products: $products)';
  }
}
