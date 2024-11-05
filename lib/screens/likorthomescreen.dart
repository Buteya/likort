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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: 100,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: (){
                Navigator.of(context).pushNamed('/likortproductdetail');
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.network(
                        'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/2,
                      ),
                   const Column(
                      mainAxisSize: MainAxisSize.min,
                     mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Steve`s store'),
                        Text('painting'),
                        Text('brushes'),
                        Text('\$1200'),
                      ],
                    ),
                ],
              ),
            );
          }),
    );
  }
}
