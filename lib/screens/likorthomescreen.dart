import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/likortartproduct.dart';

import '../models/likortfavorites.dart';
import '../models/likortstore.dart';
import '../models/likortusers.dart' as userLikort;
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
  bool _isLoading = false;
  RangeValues currentRangeValues =  const RangeValues(0, 100);
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _searchBarVisible = true;
  String? _selectedCategory; // Initial filter category
  late FocusNode _searchFocusNode;
  List<Map<String, dynamic>> filteredProducts = [];
  // List<Map<String, dynamic>> _categorySearch = [];
  Set<dynamic> get categories =>
      filteredProducts.map((product) => product['typeOfArt']).toSet();
  final CollectionReference _itemsCollection = FirebaseFirestore.instance
      .collection('products'); //Change myCollection to your collection name
  String storeName = '';
  List<Map<String,dynamic>> stores = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    loadStoreData();
    _scrollController.addListener(_scrollListener);
    Provider.of<Product>(context, listen: false)
        .favoriteProducts; // Load favorites on initialization
  }

  void _filterProducts(String query) {
    final List<Map<String, dynamic>> filtered =
        filteredProducts.where((product) {
      final productNameLower = product['name'].toLowerCase();
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
        filteredProducts = filteredProducts;
      } else {
        filteredProducts = filteredProducts.where((item) {
          return item['typeOfArt'] == _selectedCategory;
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
  List<Map<String, dynamic>> searchProductsByType(
      List<Map<String, dynamic>> allProducts, String productType) {
    return allProducts
        .where((product) => product['typeOfArt'] == productType)
        .toList();
  }

  Future<void> loadStoreData() async{
    try {
      final userData =  await fetchStoreData();
      if (userData != null) {
        setState(() {
          stores = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getStoreName(String storeId)  {
    final store = stores.firstWhere(
      (store) => store['id'] == storeId,
      orElse: () => {}, // Handle case where store is not found
    );
    // Return the store name if found, otherwise return an empty string or a default value
    return store != null
        ? store['name']
        : ''; // Or a default value like 'Unknown Store'
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await fetchData();
      if (userData != null) {
        setState(() {
          filteredProducts = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchStoreData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('stores').get();
      List<Map<String, dynamic>> items = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        items.add(doc.data() as Map<String, dynamic>);
      }
      print(items);
      return items;
    } catch (e) {
      print("Error fetching data: $e");
      return []; //Return an empty list in case of error
    }
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      QuerySnapshot querySnapshot = await _itemsCollection.get();
      List<Map<String, dynamic>> items = [];
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        items.add(doc.data() as Map<String, dynamic>);
      }
      print(items);
      return items;
    } catch (e) {
      print("Error fetching data: $e");
      return []; //Return an empty list in case of error
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    var screenSize = MediaQuery.of(context).size;
    // Get the screen orientation
    // var orientation = MediaQuery.of(context).orientation;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    // final product = Provider.of<Product>(context, listen: false);
    final String appTitle = widget.title;
    final ThemeMode appThemeMode = widget.themeMode;
    final Function() toggleThemeMode = widget.toggleThemeMode;
    final productList = filteredProducts;

    final favorites = Provider.of<Favorites>(
      context,
      listen: false,
    );
    _selectedCategory = categories.first;

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
                                          title: const Text('Filter art by'),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text('Type of art',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                                              const Divider(),
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: DropdownButton<String>(
                                                    isExpanded: true,
                                                    value: _selectedCategory,
                                                    items: categories
                                                        .map(
                                                          (category) =>
                                                              DropdownMenuItem<
                                                                  String>(
                                                            value: category,
                                                            child: Text(category,)
                                                          ),
                                                        )
                                                        .toList(),
                                                    onChanged: (value) {
                                                      setState(() {
                                                        _selectedCategory = value!;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                // _applyFilters(); // Apply filters when dialog is closed
                                                Navigator.of(context).pop();
                                              },
                                              child: const Text('Cancel'),
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
            padding: const EdgeInsets.only(left: 29.0, bottom: 10.0),
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
              child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: fetchData(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                    return snapshot.connectionState == ConnectionState.waiting
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : snapshot.hasError
                            ? Center(child: Text('Error: ${snapshot.error}'))
                            : snapshot.hasData
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: GridView.builder(
                                        controller: _scrollController,
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount:
                                              2, // Number of items per row
                                          crossAxisSpacing:
                                              8.0, // Spacing between columns
                                          mainAxisSpacing:
                                              8.0, // Spacing between rows
                                        ),
                                        itemCount: filteredProducts.length,
                                        itemBuilder: (context, index) {
                                          return InkWell(
                                            onTap: () {
                                              Navigator.of(context).pushNamed(
                                                  '/likortproductdetail',
                                                  arguments: index);
                                            },
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          15.0),
                                                  child: Image.network(
                                                    filteredProducts[index]
                                                        ['imageUrls'][0],
                                                    width:
                                                        screenSize.width * .83,
                                                    height: screenSize.height /
                                                        2.66,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                // Row(
                                                //   mainAxisAlignment:
                                                //       MainAxisAlignment.end,
                                                //   children: [
                                                //     Padding(
                                                //       padding:
                                                //           const EdgeInsets
                                                //               .only(top: 8.0),
                                                //       child: InkWell(
                                                //         onTap: () {
                                                //           // product
                                                //           //     // .toggleFavorite(product.products[0].id);
                                                //           setState(() {
                                                //             final favoriteProducts =
                                                //                 Provider.of<
                                                //                         Favorites>(
                                                //               context,
                                                //               listen: false,
                                                //             )
                                                //                     .favorites
                                                //                     .expand((fav) =>
                                                //                         fav.favoriteProducts)
                                                //                     .toList();
                                                //             final productIndex =
                                                //                 favoriteProducts
                                                //                     .indexWhere((prod) =>
                                                //                         prod.id ==
                                                //                         product
                                                //                             .id);
                                                //             if (!favoriteProducts
                                                //                 .contains(
                                                //                     product)) {
                                                //               favoriteProducts
                                                //                   .add(
                                                //                       product);
                                                //               favorites.add(
                                                //                   Favorites(
                                                //                 id: const Uuid()
                                                //                     .v4(),
                                                //                 userId: Provider.of<
                                                //                             userLikort
                                                //                             .User>(
                                                //                         context,
                                                //                         listen:
                                                //                             false)
                                                //                     .users
                                                //                     .last
                                                //                     .id,
                                                //                 favoriteProducts:
                                                //                     favoriteProducts,
                                                //               ));
                                                //             } else if (favoriteProducts
                                                //                 .contains(
                                                //                     product)) {
                                                //               setState(() {
                                                //                 Provider.of<
                                                //                         Favorites>(
                                                //                   context,
                                                //                   listen:
                                                //                       false,
                                                //                 )
                                                //                     .favorites
                                                //                     .expand((fav) => fav
                                                //                         .favoriteProducts)
                                                //                     .toList()
                                                //                     .removeAt(
                                                //                         productIndex);
                                                //                 favorites
                                                //                     .removeFavorite(
                                                //                         productIndex);
                                                //               });
                                                //             }
                                                //           });
                                                //         },
                                                //         child: favorites
                                                //                 .favorites
                                                //                 .any((fav) => fav
                                                //                     .favoriteProducts
                                                //                     .contains(
                                                //                         product))
                                                //             ? Icon(
                                                //                 Icons
                                                //                     .favorite_rounded,
                                                //                 color: favorites.favorites.any((fav) => fav
                                                //                         .favoriteProducts
                                                //                         .contains(
                                                //                             product))
                                                //                     ? Colors
                                                //                         .red
                                                //                     : Colors
                                                //                         .grey,
                                                //               )
                                                //             : Icon(
                                                //                 Icons
                                                //                     .favorite_border_rounded,
                                                //                 color: favorites.favorites.any((fav) => fav
                                                //                         .favoriteProducts
                                                //                         .contains(
                                                //                             product))
                                                //                     ? Colors
                                                //                         .red
                                                //                     : Colors
                                                //                         .grey,
                                                //               ),
                                                //       ),
                                                //     ),
                                                //     SizedBox(
                                                //       width: MediaQuery.of(
                                                //                   context)
                                                //               .size
                                                //               .width *
                                                //           .1,
                                                //     )
                                                //   ],
                                                // ),
                                                Text(
                                                  filteredProducts[index]
                                                      ['name'],
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                Text(
                                                  getStoreName(filteredProducts[index]['storeId']),
                                                  style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(
                                                  '\$${filteredProducts[index]['price']}',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .1,
                                                )
                                              ],
                                            ),
                                          );
                                        }),
                                  )
                                : Center(
                                    child: Text('No art to display'),
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
