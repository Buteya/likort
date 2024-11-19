import 'package:flutter/material.dart';

class LikortHomeScreen extends StatefulWidget {
  const LikortHomeScreen({
    super.key,
    required this.title,
    required this.themeMode,
    required this.toggleThemeMode,
  });
  final String title;
  final ThemeMode themeMode;
  final Function() toggleThemeMode;

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
        actions: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed('/likortuserprofile');
            },
            child: const CircleAvatar(),
          ),
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.light
                ? Icons.wb_sunny
                : (widget.themeMode == ThemeMode.dark
                    ? Icons.nights_stay
                    : Icons.brightness_auto)),
            onPressed: widget.toggleThemeMode,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: 100,
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/likortproductdetail');
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(
                      'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                      width: screenSize.width,
                      height: orientation == Orientation.portrait
                          ? screenSize.height * 0.1
                          : screenSize.height * 0.36,
                    ),
                    const SizedBox(height: 7.0),
                    const Text('title',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const Text('\$price',
                        style: TextStyle(fontSize: 16, color: Colors.green)),
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 20),
                        Text('rating (reviewCount reviews)'),
                      ],
                    ),
                    const SizedBox(height: 5.0),
                    const Text('description')
                  ],
                ),
              );
            }),
      ),
    );
  }
}
