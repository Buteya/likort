import 'package:flutter/material.dart';

import 'likortcartitem.dart';


class Order extends ChangeNotifier{
  final String orderId;
  final List<CartItem> items;
  final DateTime orderDate;
  final double totalAmount;
  final String userId;

  Order({
    required this.orderId,
    required this.items,
    required this.orderDate,
    required this.userId,
  }) : totalAmount = items.fold(0, (sum, item) => sum + item.getTotalPrice());

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      orderDate: DateTime.parse(json['orderDate']), userId: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'items': items.map((item) => item.toJson()).toList(),
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
      'user':userId,
    };
  }

  @override
  String toString() {
    return 'Order(id: $orderId, items: $items, orderDate: $orderDate, totalAmount: $totalAmount)';
  }
}
