import 'package:flutter/material.dart';

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
        title: const Text('Track order'),
      ),
      body: Column(
        children: [
          const Text('notification'),
          Image.network(
            'https://cdn.pixabay.com/photo/2023/07/06/01/51/motorcycle-8109453_1280.jpg',
            width: double.infinity,
            height: 400,
          ),
          ElevatedButton(onPressed: (){
            Navigator.of(context).pushNamed('/likortpaycash');
          }, child: const Text('pay cash'))
        ],
      ),
    );
  }
}
