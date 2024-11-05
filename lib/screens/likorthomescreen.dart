import 'package:flutter/material.dart';

class LikortHomeScreen extends StatefulWidget {
  const LikortHomeScreen({
    super.key,
    required this.title,
  });
  final String title;

  @override
  State<LikortHomeScreen> createState() => _LikortHomeScreenState();
}

class _LikortHomeScreenState extends State<LikortHomeScreen> {
  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;
    // Get the screen orientation
    var orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 6.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 100,
            itemBuilder: (context, index) {
              return  Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: screenSize.width,
                    height: screenSize.height * 0.4,
                  ),
                  const Text('Steve`s store'),
                  const Text('painting'),
                  const Text('brushes'),
                  const Text('\$1200'),
                ],
              );
            }),
      ),
    );
  }
}
