import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/likortartproduct.dart';

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
  final ScrollController _scrollController = ScrollController();
  bool _searchBarVisible = true;
  final List<String> _items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5'
  ]; // Your data
  List<String> _filteredItems = [];
  String _selectedCategory = 'All'; // Initial filter category
  final RangeValues _priceRange = const RangeValues(0, 100);

  @override
  void initState() {
    super.initState();
    _filteredItems = _items;
    _scrollController.addListener(_scrollListener);
    Provider.of<Product>(context, listen: false)
        .loadFavorites(); // Load favorites on initialization
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      _filteredItems = _items.where((item) {
        // Category filter
        if (_selectedCategory != 'All' && item != _selectedCategory) {
          return false;
        }
        // Price range filter (example - assuming items have prices)
        // Replace with your actual price filtering logic
        // final itemPrice = getItemPrice(item); // Get price of the item
        // if (itemPrice < _priceRange.start || itemPrice > _priceRange.end) {
        //   return false;
        // }

        return true;
      }).toList();
    });
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
            ScrollDirection.reverse &&
        _searchBarVisible) {
      setState(() {
        _searchBarVisible = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
            ScrollDirection.forward &&
        !_searchBarVisible &&
        _scrollController.offset <= 0) {
      setState(() {
        _searchBarVisible = true;
      });
    }
  }

  void _filterItems(String query) {
    setState(() {
      _filteredItems = _items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Search function
  List<Product> searchProductsByType(
      List<Product> allProducts, String productType) {
    return allProducts
        .where((product) => product.typeOfArt == productType)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;
    // Get the screen orientation
    var orientation = MediaQuery.of(context).orientation;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final product = Provider.of<Product>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 74,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.dehaze_rounded,
              size: 40,
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
                items: [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.notifications),
                        Text('Notifications')
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.favorite_rounded),
                        Text('Favorites')
                      ],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.chat_bubble_rounded),
                        Text('Chat Artist')
                      ],
                    ),
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if (value != null) {
                  // Handle menu selection here
                  if (value == 1) {
                    Navigator.of(context)
                        .pushReplacementNamed('/likortfavoritesscreen');
                  }
                  print("Selected: $value");
                }
              });
            },
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/likorthomescreen');
          },
          child: Center(
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
        ),
        actions: [
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.light
                ? Icons.wb_sunny
                : (widget.themeMode == ThemeMode.dark
                    ? Icons.nights_stay
                    : Icons.brightness_auto)),
            onPressed: widget.toggleThemeMode,
          ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_rounded,
              )),
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/likortuserprofile');
              },
              child: const CircleAvatar(
                child: Icon(
                  Icons.person,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedOpacity(
            opacity: _searchBarVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: SizedBox(
              height: _searchBarVisible
                  ? MediaQuery.of(context).size.height * .28
                  : MediaQuery.of(context).size.height * .01,
              child: _searchBarVisible
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 29.0,
                            right: 29.0,
                          ),
                          child: Text(
                            'Discover the world\'s finest art',
                            style: GoogleFonts.openSans(
                              fontSize: 25,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 29.0, right: 29),
                          child: Text(
                            'Explore works from the most talented artists showcasing their most finest works',
                            style: GoogleFonts.openSans(
                              fontSize: 15,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 29.0, right: 29.0, top: 10.0),
                          child: Row(
                            children: [
                              Flexible(
                                child: TextField(
                                  controller: _searchController,
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      color: isDark
                                          ? Colors.white54
                                          : Colors.black54,
                                    ),
                                    hintText: 'Search...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    filled: true,
                                    fillColor: isDark
                                        ? Colors.grey[800]
                                        : Colors.grey[200],
                                    prefixIcon: const Icon(
                                      Icons.search,
                                    ),
                                  ),
                                  onChanged: (query) {
                                    _filterItems(query);
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text('Filter Options'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButton<String>(
                                                value: _selectedCategory,
                                                items: [
                                                  'All',
                                                  'Fruits',
                                                  'Vegetables'
                                                ]
                                                    .map((category) =>
                                                        DropdownMenuItem(
                                                          value: category,
                                                          child: Text(category),
                                                        ))
                                                    .toList(),
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedCategory = value!;
                                                  });
                                                },
                                              ),
                                              // Price range slider (example)
                                              // RangeSlider(
                                              //   values: _priceRange,
                                              //   min: 0,
                                              //   max: 100,
                                              //   onChanged: (values) {
                                              //     setState(() {
                                              //       _priceRange = values;
                                              //     });
                                              //   },
                                              // ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                _applyFilters(); // Apply filters when dialog is closed
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Apply'),
                                            ),
                                          ],
                                        );
                                      });
                                },
                                child: const Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(
                                      Icons.tune_rounded,
                                      size: 30,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 29.0, bottom: 20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('new'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Popular'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        // _filteredItems = searchProductsByType(allProducts, text).cast<String>();
                      });
                    },
                    child: const Text('Painting'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Decor'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: _searchBarVisible
                  ? MediaQuery.of(context)
                      .size
                      .height // Adjust height when search bar is visible
                  : MediaQuery.of(context).size.height,
              child: ListView.builder(
                  controller: _scrollController,
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15.0),
                            child: Image.network(
                              'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                              width: screenSize.width * .83,
                              height: screenSize.height / 2.66,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: InkWell(
                                  onTap: () {
                                    // product
                                    //     // .toggleFavorite(product.products[0].id);
                                  },
                                  child: const Icon(Icons.favorite_rounded
                                      // product.products[0].isFavorite
                                      //     ? Icons.favorite
                                      //     : Icons.favorite_border,
                                      // color: product.products[0].isFavorite
                                      //     ? Colors.red
                                      //     : Colors.grey,
                                      ),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .1,
                              )
                            ],
                          ),
                          const Text(
                            'paint brushes',
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                          const Text(
                            'anne\'s shop',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Text(
                            '\$99',
                            style: TextStyle(fontSize: 16, color: Colors.green),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .1,
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
      floatingActionButton: _searchBarVisible
          ? null
          : FloatingActionButton.small(
              onPressed: () {
                setState(() {
                  _searchBarVisible = !_searchBarVisible;
                });
              },
              child: const Center(
                child: Icon(
                  Icons.search,
                ),
              ),
            ),
    );
  }
}
