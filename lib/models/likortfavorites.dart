import 'dart:collection';

import 'package:flutter/material.dart';

import 'likortartproduct.dart';

class Favorites with ChangeNotifier {
  final String id;
  final String userId;
  final List<Product> favoriteProducts;

  Favorites({
    required this.id,
    required this.userId,
    required this.favoriteProducts,
  });

  final List<Favorites> _favorites = [];

  UnmodifiableListView<Favorites> get favorites =>
      UnmodifiableListView(_favorites);
  factory Favorites.fromJson(Map<String, dynamic> json) {
    return Favorites(
      id: json['id'],
      userId: json[''],
      favoriteProducts: json['favoriteProducts'],
    );
  }

  void add(Favorites favorites) {
    _favorites.add(favorites);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void updateFavoritesById(String id, Favorites updatedFavorites) {
    final index = _favorites.indexWhere((favorites) => favorites.id == id);
    if (index != -1) {
      _favorites[index] = updatedFavorites;
      notifyListeners();
    } else {
      // Handle the case when the user is not found
      print('User not found.');
    }
  }

  void removeFavorite(int index) {
    _favorites.removeAt(index);
    notifyListeners();
  }

  void updateSingleFavorite(Favorites updatedFavorite, int index) {
    _favorites[index] = updatedFavorite;
    notifyListeners();
  }

  void removeAll() {
    _favorites.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  @override
  String toString() {
    return 'Favorites(id: $id, userId: $userId,favoriteProducts: $favoriteProducts,)';
  }
}
