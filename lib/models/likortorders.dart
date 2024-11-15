import 'package:flutter/material.dart';

import 'likortcartitem.dart';

class Order extends ChangeNotifier{
  final String id;
  final List<CartItem> items;
  final DateTime orderDate;
  final double totalAmount;

  Order({
    required this.id,
    required this.items,
    required this.orderDate,
  }) : totalAmount = items.fold(0, (sum, item) => sum + item.getTotalPrice());

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List).map((item) => CartItem.fromJson(item)).toList(),
      orderDate: DateTime.parse(json['orderDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'orderDate': orderDate.toIso8601String(),
      'totalAmount': totalAmount,
    };
  }

  @override
  String toString() {
    return 'Order(id: $id, items: $items, orderDate: $orderDate, totalAmount: $totalAmount)';
  }
}
