import 'dart:collection';

import 'package:flutter/material.dart';

class Review with ChangeNotifier {
  final String reviewId;
  final String userId;
  final String review;
  final String productId;
  final DateTime createdAt;

  Review({
    required this.reviewId,
    required this.productId,
    required this.createdAt,
    required this.review,
    required this.userId,
  });

  final List<Review> _reviews = [];

  UnmodifiableListView<Review> get reviews => UnmodifiableListView(_reviews);

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewId: json['reviewId'],
      productId: json['productId'],
      createdAt: json['createdAt'],
      userId: json['userId'],
      review: json['review'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reviewId': reviewId,
      'productId': productId,
      'userId': userId,
      'createdAt': createdAt,
      'review': review,
    };
  }

  void addReview(Review review) {
    _reviews.add(review);
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  void removeReview(int index) {
    _reviews.removeAt(index);
    notifyListeners();
  }

  void updateReview(Review updatedReview) {
    _reviews[_reviews.length - 1] = updatedReview;
    notifyListeners();
  }

  void updateSingleReview(Review updatedReview, int index) {
    _reviews[index] = updatedReview;
    notifyListeners();
  }

  void removeAll() {
    _reviews.clear();
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }

  @override
  String toString() {
    return 'Review(reviewId: $reviewId, userId: $userId,productId: $productId, review: $review, createdAt: $createdAt,)';
  }
}
