import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final _searchController = TextEditingController();

  List<String> _items = List<String>.generate(100, (index) => 'Item $index');
  late List<String> _filteredItems;
  @override
  void initState() {
    super.initState();
    _filteredItems = _items;
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;
    // Get the screen orientation
    var orientation = MediaQuery.of(context).orientation;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 74,
        leading: const Icon(
          Icons.dehaze_rounded,
          size: 40,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Transform.rotate(
              angle: -6 * 3.1415926535897932 / 180,
              child: Transform.scale(
                scaleX: 1.36,
                scaleY: 1.0,
                child: Text(
                  widget.title,
                  style: GoogleFonts.dancingScript(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.notifications)),
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PreferredSize(
                preferredSize: const Size.fromHeight(48.0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: isDark ? Colors.white54 : Colors.black54,
                      ),
                      hintText: 'Search...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: isDark ? Colors.grey[800] : Colors.grey[200],
                      prefixIcon: Icon(
                        Icons.search,
                      ),
                    ),
                    onChanged: (query) {
                      _filterItems(query);
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).pushNamed('/likortproductdetail');
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.network(
                                'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                                width: screenSize.width * .83,
                                height: screenSize.height / 2.66,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 7.0),
                          const Text('title',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          const Text('\$price',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.green)),
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
          ],
        ),
      ),
    );
  }
}
