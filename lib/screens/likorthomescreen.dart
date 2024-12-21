import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../models/likortartproduct.dart';
import '../models/likortstore.dart';
import '../widgets/customappbar.dart';

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
  String _selectedCategory = "All"; // Initial filter category
  final RangeValues _priceRange = const RangeValues(0, 100);
  late FocusNode _searchFocusNode;
  List<Product> filteredProducts = [];
  List<Product> _categorySearch = [];
  Set<String> get categories =>
      _categorySearch.map((product) => product.typeOfArt).toSet();

  @override
  void initState() {
    super.initState();
    _categorySearch = Provider.of<Product>(context, listen: false).products;
    filteredProducts = Provider.of<Product>(context, listen: false).products;
    _scrollController.addListener(_scrollListener);
    Provider.of<Product>(context, listen: false)
        .favoriteProducts; // Load favorites on initialization
  }

  void _filterProducts(String query) {
    final List<Product> filtered =
        Provider.of<Product>(context, listen: false).products.where((product) {
      final productNameLower = product.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return productNameLower.contains(queryLower);
    }).toList();
    setState(() {
      filteredProducts = filtered;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    setState(() {
      if (_selectedCategory == 'All') {
        filteredProducts =
            Provider.of<Product>(context, listen: false).products;
      } else {
        filteredProducts = Provider.of<Product>(context, listen: false)
            .products
            .where((item) {
          return item.typeOfArt == _selectedCategory;
        }).toList();
      }
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

  // Search function
  List<Product> searchProductsByType(
      List<Product> allProducts, String productType) {
    return allProducts
        .where((product) => product.typeOfArt == productType)
        .toList();
  }

  String getStoreName(String storeId) {
    // Find the store with the matching storeId
    final store = Provider.of<Store>(context, listen: false).stores.firstWhere(
          (store) => store.id == storeId,
          orElse: () => Store(
              userId: '',
              created: DateTime.now(),
              imageUrl: [],
              reviews: [],
              id: '',
              name: '',
              description: '',
              products: [],
              notifications: [],
              orders: []), // Handle case where store is not found
        );

    // Return the store name if found, otherwise return an empty string or a default value
    return store != null
        ? store.name
        : ''; // Or a default value like 'Unknown Store'
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;
    // Get the screen orientation
    var orientation = MediaQuery.of(context).orientation;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final product = Provider.of<Product>(context, listen: false);
    final String appTitle = widget.title;
    final ThemeMode appThemeMode = widget.themeMode;
    final Function() toggleThemeMode = widget.toggleThemeMode;
    final productProvider = Provider.of<Product>(context);
    final products = productProvider.products; // Get the list of products

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          appTitle: appTitle,
          appThemeMode: appThemeMode,
          toggleThemeMode: toggleThemeMode,
        ),
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
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).requestFocus(
                                        _searchFocusNode); // _searchFocusNode is a FocusNode
                                  },
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
                                        borderRadius:
                                            BorderRadius.circular(8.0),
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
                                      _filterProducts(query);
                                    },
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Filter by type of art'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              DropdownButton<String>(
                                                value: _selectedCategory,
                                                items: categories
                                                    .map(
                                                      (category) =>
                                                          DropdownMenuItem<
                                                              String>(
                                                        value: category,
                                                        child: Text(category),
                                                      ),
                                                    )
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
              child: Consumer<Product>(builder: (context, product, child) {
                return product.products.isEmpty
                    ? const Center(
                        child: Text('No Art to display'),
                      )
                    : GridView.builder(
                        controller: _scrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of items per row
                          crossAxisSpacing: 8.0, // Spacing between columns
                          mainAxisSpacing: 8.0, // Spacing between rows
                        ),
                        itemCount: filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = filteredProducts[index];
                          return InkWell(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed('/likortproductdetail');
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.network(
                                    color: Colors.black45,
                                    product.imageUrls[0],
                                    width: screenSize.width * .83,
                                    height: screenSize.height / 2.66,
                                    fit: BoxFit.contain,
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
                                      width: MediaQuery.of(context).size.width *
                                          .1,
                                    )
                                  ],
                                ),
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                Text(
                                  getStoreName(product.storeId),
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '\$${product.price}',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .1,
                                )
                              ],
                            ),
                          );
                        });
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
