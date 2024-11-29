import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class LikortTrackOrder extends StatefulWidget {
  const LikortTrackOrder({super.key});

  @override
  State<LikortTrackOrder> createState() => _LikortTrackOrderState();
}

class _LikortTrackOrderState extends State<LikortTrackOrder> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Order details card
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text('Order #${widget.order.id}',
                   Text('Order #',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  // Display order items, quantities, and total price
                  // ...
                ],
              ),
            ),
          ),

          // Tracking card
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tracking',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Progress indicator
                  LinearProgressIndicator(
                    // value: _getProgressValue(widget.order.status),
                    backgroundColor: Colors.grey[300],
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),),
                  const SizedBox(height: 8),
                  // Text(_getStatusText(widget.order.status)),
                  const Text('status'),
                ],
              ),
            ),
          ),

          // Review card (visible only if _isDelivered is true)
          // if (_isDelivered)
            const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Submit a Review',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  // Rating bar
                  RatingBar.builder(
                    initialRating: 3,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    onRatingUpdate: (rating) {
                      // Handle rating update
                    },
                  ),
                  const SizedBox(height: 16),
                  // Review text field
                  const TextField(
                    decoration: InputDecoration(
                      hintText: 'Write your review',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Handle review submission
                    },
                    child: const Text('Submit Review'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

  }
}
