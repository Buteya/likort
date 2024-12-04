import 'dart:collection';

import 'package:flutter/material.dart';

class Payment with ChangeNotifier {
  final String paymentId;
  final int amount;
  final DateTime createdAt;
  final String status;
  final String orderId;

  Payment({
    required this.paymentId,
    required this.orderId,
    required this.amount,
    required this.status,
    required this.createdAt,
  });

  final List<Payment> _payments = [];

  UnmodifiableListView<Payment> get payments => UnmodifiableListView(_payments);

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      paymentId: json['paymentId'],
      orderId: json['orderId'],
      amount: json['amount'],
      status: json['status'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'orderId': orderId,
      'createdAt': createdAt,
      'status': status,
      'amount': amount,
    };
  }

  void addPayment(Payment payment) {
    _payments.add(payment);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removePayment(int index) {
    _payments.removeAt(index);
    notifyListeners();
  }

  void updatePayment(Payment updatedPayment) {
    _payments[_payments.length - 1] = updatedPayment;
    notifyListeners();
  }

  void updateSinglePayment(Payment updatedPayment, int index) {
    _payments[index] = updatedPayment;
    notifyListeners();
  }

  void removeAll() {
    _payments.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  @override
  String toString() {
    return 'Payment(paymentId: $paymentId,  orderId: $orderId, amount: $amount, status: $status, createdAt: $createdAt,)';
  }
}
