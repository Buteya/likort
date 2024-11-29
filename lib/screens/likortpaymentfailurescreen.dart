import 'package:flutter/material.dart';

class LikortPaymentFailureScreen extends StatefulWidget {
  const LikortPaymentFailureScreen({super.key});

  @override
  State<LikortPaymentFailureScreen> createState() => _LikortPaymentFailureScreenState();
}

class _LikortPaymentFailureScreenState extends State<LikortPaymentFailureScreen> with SingleTickerProviderStateMixin
{
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = CurvedAnimation(
        parent: _controller, curve: Curves.elasticOut); // Shake effect
    _controller.forward(); // Start the animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height*.3,),
            RotationTransition(
              turns: Tween(begin: -0.05, end: 0.05).animate(_animation),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red[400],
                ),
                child: const Icon(
                  Icons.close, // Or Icons.warning
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const Text(
              'Payment Failed!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
            ),
            const Text(
              'Unfortunately, your transaction could not be completed. Please try again.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.0),
            ),
            SizedBox(height: MediaQuery.of(context).size.height*.01,),
            ElevatedButton(
              onPressed: () {
                // Handle "Retry Payment" button action
                // Implement retry payment functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(Icons.refresh_rounded),
                  Text('Retry Payment'),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0,),
              child: ElevatedButton(
                onPressed: () {
                  // Handle "Contact Support" button action
                  // Implement contact support functionality
                  Navigator.of(context).pushReplacementNamed('/likortcontactsupport');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.support_agent),
                    Text('Contact Support'),
                  ],
                ),
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
          ],
        ),

    );

  }
}
