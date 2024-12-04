import 'dart:collection';

import 'package:flutter/material.dart';

import 'likortstore.dart';
import 'likortusers.dart';

class LikortNotification with ChangeNotifier {
  final String notificationId;
  final DateTime createdAt;
  final List<User> users;
  final List<Store> stores;

  LikortNotification({
    required this.notificationId,
    required this.createdAt,
    required this.users,
    required this.stores,
  });

  final List<LikortNotification> _notifications = [];

  UnmodifiableListView<LikortNotification> get notifications =>
      UnmodifiableListView(_notifications);

  factory LikortNotification.fromJson(Map<String, dynamic> json) {
    return LikortNotification(
      notificationId: json['notificationId'],
      createdAt: json['createdAt'],
      users: List<User>.from(json['users'] as List),
      stores: List<Store>.from(json['stores'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'createdAt': createdAt,
      'users': users,
      'stores': stores,
    };
  }

  void addNotification(LikortNotification notification) {
    _notifications.add(notification);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeNotification(int index) {
    _notifications.removeAt(index);
    notifyListeners();
  }

  void updateNotification(LikortNotification updatedNotification) {
    _notifications[_notifications.length - 1] = updatedNotification;
    notifyListeners();
  }

  void updateSingleNotification(LikortNotification updatedNotification, int index) {
    _notifications[index] = updatedNotification;
    notifyListeners();
  }

  void removeAll() {
    _notifications.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  @override
  String toString() {
    return 'Notification(notificationId: $notificationId, createdAt: $createdAt, users: $users, stores: $stores,)';
  }
}
