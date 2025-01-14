import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:likort/models/likortreview.dart';

import 'likortartproduct.dart';


class User extends ChangeNotifier {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String phone;
  String usertype;
  final double latitude;
  final double longitude;
  final String storeId;
  final List<Review> reviews;
  final List<Product> favorites;
  final String imageUrl;
  final List<String> notifications;
  final DateTime created;
  bool isOnline;

  late List<User> _users = [];

  UnmodifiableListView<User> get users => UnmodifiableListView(_users);

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    required this.phone,
    this.usertype = 'basic user',
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.storeId,
    required this.reviews,
    required this.favorites,
    required this.notifications,
    required this.created,
    this.isOnline = false,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
      phone: json['phone'],
      usertype: json['usertype'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      imageUrl: json['imageUrl'],
      storeId: json['orderIds'],
      reviews: json['reviews'],
      favorites: json['favorites'],
      notifications: json['notifications'],
      created: json['created'],
      isOnline: json['isOnline'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password': password,
      'phone': phone,
      'usertype': usertype,
      'latitude': latitude,
      'longitude': longitude,
      'notification':notifications,
      'favorites' : favorites,
      'reviews' : reviews,
      'orderIds' : storeId,
      'imageUrl' :imageUrl,
      'created' : created,
      'isOnline':isOnline,
    };
  }

  void add(User? user) {
    // Add a new user to the list
    if (user != null) {
      _users = [..._users, user];
      // This call tells the widgets that are listening to this model to rebuild.
      notifyListeners();
    } else {
      print('Cannot add a null user.');
    }
  }

  void removeUser(int index) {
    if (index >= 0 && index < _users.length) {
      _users.removeAt(index);
      notifyListeners();
    } else {
      print('Invalid index: $index');
    }
  }

  void updateUser(User updatedUser) {
    final index = _users.indexWhere((user) => user.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
      notifyListeners();
    } else {
      print('User with ID ${updatedUser.id} not found.');
    }
  }
  void updateSingleUser(User updatedUser, int index) {
    if (index >= 0 && index < _users.length) {
      _users[index] = updatedUser;
      notifyListeners();
    } else {
      print('Invalid index: $index');
    }
  }

  void removeAll() {
    _users.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  @override
  String toString() {
    return 'User(id: $id, firstname: $firstname,lastname: $lastname, email: $email, password: $password,phone: $phone,usertype: $usertype,latitude: $latitude,longitude: $longitude,)';
  }
}
