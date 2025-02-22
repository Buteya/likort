import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikortCompletedOrder extends StatefulWidget {
  const LikortCompletedOrder({super.key});

  @override
  State<LikortCompletedOrder> createState() => _LikortCompletedOrderState();
}

class _LikortCompletedOrderState extends State<LikortCompletedOrder> {
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
      appBar: AppBar(
        title: const Text('Order Completed'),
      ),
      body: Column(
        children: [
          const Text('Thank you for placing your order with us'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/', (Route<dynamic> route) => false);
            },
            child: const Text('place new order'),
          ),
        ],
      ),
    );
  }
}
