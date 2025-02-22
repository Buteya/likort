import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikortPaymentSuccessScreen extends StatefulWidget {
  const LikortPaymentSuccessScreen({super.key});

  @override
  State<LikortPaymentSuccessScreen> createState() =>
      _LikortPaymentSuccessScreenState();
}

class _LikortPaymentSuccessScreenState
    extends State<LikortPaymentSuccessScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  FirebaseAuth.instance.currentUser == null
        ? Scaffold(
      body: TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed('/likortlogin'),
          child: const Text('Login')),
    )
        :Scaffold(
      body: Column(
        children: [
          SizedBox(height: MediaQuery.of(context).size.height*.3,),
          ScaleTransition(
            scale: _animation,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green[400],
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 60,
                color: Colors.white,
              ),
            ),
          ),
          const Text(
            'Payment Successful!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const Text('Successfully paid \$99'),
          const Padding(
            padding: EdgeInsets.only(left: 16.0,right: 16.0,top: 12.0,bottom: 10.0,),
            child: Text(
              'Thank you for your purchase. Your transaction was completed successfully.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle "Back to Home" button action
              Navigator.pop(context);
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.home_rounded),
                Text('Back to Home'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,),
            child: ElevatedButton(
              onPressed: () {
                // Handle "View Order" button action
                // Navigate to the order details screen
                Navigator.of(context).pushReplacementNamed('/likorttrackorder');
              },

              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.receipt_long_rounded),
                  Text('View Order'),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle "Share" button action
              // Implement share functionality
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.share_rounded),
                Text('Share'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
