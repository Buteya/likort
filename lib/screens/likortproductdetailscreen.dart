import 'package:flutter/material.dart';

class LikortProductDetailScreen extends StatefulWidget {
  const LikortProductDetailScreen({super.key});

  @override
  State<LikortProductDetailScreen> createState() =>
      _LikortProductDetailScreenState();
}

class _LikortProductDetailScreenState extends State<LikortProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('title'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.network(
            'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
            width: double.infinity,
            height: 200,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
            Image.network(
              'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
              width: 100,
              height: 100,
            ),
            Image.network(
              'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
              width: 100,
              height: 100,
            ),
            Image.network(
              'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
              width: 100,
              height: 100,
            ),
          ],),
          const Text('description'),
          const Text('Steve`s store'),
          const Text('painting'),
          const Text('brushes'),
          const Text('\$1200'),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/likortcart');
            },
            child: const Text('add to cart'),
          ),
        ],
      ),
    );
  }
}
