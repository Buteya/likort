import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/likortfavorites.dart';
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
  var uuid = const Uuid();
  bool _isLoading = false;
  RangeValues currentRangeValues = const RangeValues(0, 100);
  final _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _searchBarVisible = true;
  String? _selectedCategory; // Initial filter category
  late FocusNode _searchFocusNode;
  List<Map<String, dynamic>> filteredProducts = [];
  List<Map<String, dynamic>> favoriteProducts = [];
  Set<dynamic> get categories {
    if (filteredProducts.isNotEmpty) {
      return filteredProducts.map((product) => product['typeOfArt']).toSet();
    } else {
      return <dynamic>{};
    }
  }

  final CollectionReference _itemsCollection = FirebaseFirestore.instance
      .collection('products'); //Change myCollection to your collection name
  String storeName = '';
  List<Map<String, dynamic>> stores = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    loadStoreData();
    _scrollController.addListener(_scrollListener);
    _loadFavoriteData();
  }

  void _filterProducts(String query) {
    try {
      final List<Map<String, dynamic>> filtered = filteredProducts.isNotEmpty
          ? filteredProducts.where((product) {
              final productNameLower = product['name'].toLowerCase();
              final queryLower = query.toLowerCase();
              return productNameLower.contains(queryLower);
            }).toList()
          : [];

      if (filtered.isNotEmpty) {
        setState(() {
          filteredProducts = filtered;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> deleteDocumentByFieldValue(String collectionName,
      String fieldName, dynamic fieldValue, String userId) async {
    try {
      // 1. Get a reference to the Firestore collection.
      CollectionReference collection =
          FirebaseFirestore.instance.collection(collectionName);

      // 2. Create a query to find the document with thespecific field value.
      Query query = collection.where(fieldName, isEqualTo: fieldValue);

      // 3. Get the documents that match the query.
      QuerySnapshot querySnapshot = await query.get();

      // 4. Check if any documents were found.
      if (querySnapshot.docs.isNotEmpty) {
        // 5. Find the document with the matching userId.
        DocumentSnapshot? documentToDelete;
        for (DocumentSnapshot doc in querySnapshot.docs) {
          if (doc.id == userId) {
            documentToDelete = doc;
            break; // Exit the loop once the document is found.
          }
        }

        // 6. Check if a document with the matching userId was found.
        if (documentToDelete != null) {
          // 7. Delete the document.
          await documentToDelete.reference.delete();
          print(
              'Document with $fieldName: $fieldValue and ID: $userId deleted successfully.');
        } else {
          print(
              'No document found with $fieldName: $fieldValue and ID: $userId.');
        }
      } else {
        print('No document found with $fieldName: $fieldValue.');
      }
    } catch (e) {
      print('Error deleting document: $e');
      // Handle the error appropriately (e.g., show an error message to the user).
    }
  }

  Future<void> createFavorite(Map products) async {
    final id = uuid.v4();
    final listProducts = [];
    try {
      // 1. Create the user with email and password
      var userId = FirebaseAuth.instance.currentUser?.uid;

      // 2. Check if the user is created
      if (userId == null) {
        if (kDebugMode) {
          print('user not found');
        }
        return;
      }

      listProducts.add(products);

      // 3. Get the user ID
      print(userId);
      // 4. Create the user data map
      Map<String, dynamic> favoriteData = {
        'id': id,
        'userId': userId,
        'favoriteProducts': listProducts,
        'created': FieldValue.serverTimestamp(), // Use server timestamp
      };

      for (final favorite in favoriteData.values) {
        print(favorite);
      }
      // 5. Save the user data to Firestore
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('favorites');
      await usersCollection.doc(userId).set(favoriteData).then((_) {
        if (kDebugMode) {
          print('User data saved successfully!');
        }
      }).catchError((error) {
        if (kDebugMode) {
          print('Error saving user data: $error');
        }
        throw Exception('Failed to save user data: $error');
      });
    } catch (e) {
      if (kDebugMode) {
        print('Unexpected Error: $e');
      }
    }
  }

  String _findNewestCategory(List<Map<String, dynamic>> products) {
    if (products.isEmpty) {
      return ''; // Return empty string if no products
    }

    Map<String, dynamic> categoryLatestDate = {};
    for (var product in products) {
      String category = product['typeOfArt'];
      dynamic dateAdded = product['lastUpdated'];
      if (!categoryLatestDate.containsKey(category) ||
          dateAdded.isAfter(categoryLatestDate[category]!)) {
        categoryLatestDate[category] = dateAdded;
      }
    }

    String newestCategory = '';
    dynamic latestDate = DateTime(0); // Start with a very old date
    categoryLatestDate.forEach((category, date) {
      if (date.isAfter(latestDate)) {
        latestDate = date;
        newestCategory = category;
      }
    });

    return newestCategory;
  }

  String _findMostFrequentCategory(List<Map<String, dynamic>> products) {
    if (products.isEmpty) {
      return ''; // Return empty string if noproducts
    }

    Map<String, int> categoryCounts = {};
    for (var product in products) {
      String category = product['typeOfArt'];
      categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
    }

    String mostFrequentCategory = '';
    int maxCount = 0;
    categoryCounts.forEach((category, count) {
      if (count > maxCount) {
        maxCount = count;
        mostFrequentCategory = category;
      }
    });

    return mostFrequentCategory;
  }

  void _applyFilters(String category) {
    setState(() {
      if (_selectedCategory == 'All') {
        filteredProducts = filteredProducts;
      } else if (category == 'Paintings' &&
          filteredProducts.any((item) => item['typeOfArt'] == category)) {
        filteredProducts = filteredProducts.where((item) {
          return item['typeOfArt'] == category;
        }).toList();
      } else if (category == 'Decor' &&
          filteredProducts.any((item) => item['typeOfArt'] == category)) {
        filteredProducts = filteredProducts.where((item) {
          return item['typeOfArt'] == category;
        }).toList();
      } else if (category == 'Popular') {
        filteredProducts = filteredProducts.where((item) {
          return item['typeOfArt'] ==
              _findMostFrequentCategory(filteredProducts);
        }).toList();
      } else if (category == 'New') {
        filteredProducts = filteredProducts.where((item) {
          return item['typeOfArt'] == _findNewestCategory(filteredProducts);
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

  Future<void> loadStoreData() async {
    try {
      final userData = await fetchStoreData();
      setState(() {
        stores = userData;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getStoreName(String storeId) {
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
      setState(() {
        filteredProducts = userData;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadFavoriteData() async {
    try {
      final userData = await fetchData();
      setState(() {
        favoriteProducts = userData;
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> fetchFavoriteData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('favorites').get();
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

  Future<List<Map<String, dynamic>>> fetchStoreData() async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('stores').get();
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
    final platformBrightness = Theme.of(context).brightness;
    final bool isDark = platformBrightness == Brightness.dark;
    // final product = Provider.of<Product>(context, listen: false);
    final String appTitle = widget.title;
    final ThemeMode appThemeMode = widget.themeMode;
    final Function() toggleThemeMode = widget.toggleThemeMode;
    final productList = filteredProducts;
    final favorites = Provider.of<Favorites>(
      context,
      listen: false,
    );
    // _selectedCategory = categories.first;

    return _isLoading
        ? const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : FirebaseAuth.instance.currentUser == null
            ? Scaffold(
                body: TextButton(
                    onPressed: () => Navigator.of(context)
                        .pushReplacementNamed('/likortlogin'),
                    child: const Text('Login')),
              )
            : Scaffold(
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
                            ? (MediaQuery.sizeOf(context).height < 670)?MediaQuery.of(context).size.height * .29 :(MediaQuery.sizeOf(context).height >900)?MediaQuery.of(context).size.height * .2:MediaQuery.of(context).size.height * .28
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
                                    padding: const EdgeInsets.only(
                                        left: 29.0, right: 29),
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
                                                      BorderRadius.circular(
                                                          8.0),
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
                                                        'Filter art by'),
                                                    content: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const Text(
                                                          'Type of art',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15),
                                                        ),
                                                        const Divider(),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(16.0),
                                                          child: SizedBox(
                                                            width:
                                                                double.infinity,
                                                            child:
                                                                DropdownButton<
                                                                    String>(
                                                              isExpanded: true,
                                                              value:
                                                                  _selectedCategory =
                                                                      categories
                                                                          .first,
                                                              items: categories
                                                                  .map(
                                                                    (category) => DropdownMenuItem<
                                                                            String>(
                                                                        value:
                                                                            category,
                                                                        child:
                                                                            Text(
                                                                          category,
                                                                        )),
                                                                  )
                                                                  .toList(),
                                                              onChanged:
                                                                  (value) {
                                                                setState(() {
                                                                  _selectedCategory =
                                                                      value!;
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                            'Cancel'),
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
                              onPressed: () {
                                _applyFilters('New');
                              },
                              child: const Text('New'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _applyFilters('Popular');
                              },
                              child: const Text('Popular'),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _applyFilters('Paintings');
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
                              onPressed: () {
                                _applyFilters('Decor');
                              },
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
                                AsyncSnapshot<List<Map<String, dynamic>>>
                                    snapshot) {
                              return snapshot.connectionState ==
                                      ConnectionState.waiting
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : snapshot.hasError
                                      ? Center(
                                          child:
                                              Text('Error: ${snapshot.error}'))
                                      : snapshot.hasData
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 16.0),
                                              child: GridView.builder(
                                                  controller: _scrollController,
                                                  gridDelegate:
                                                       SliverGridDelegateWithFixedCrossAxisCount(
                                                         mainAxisExtent: MediaQuery.sizeOf(context).height * 0.55,
                                                    childAspectRatio:  0.26,
                                                    crossAxisCount:
                                                        2, // Number of items per row
                                                    crossAxisSpacing:
                                                        8.0, // Spacing between columns
                                                    mainAxisSpacing:
                                                        2.0, // Spacing between rows
                                                  ),
                                                  itemCount:
                                                      filteredProducts.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pushNamed(
                                                                '/likortproductdetail',
                                                                arguments:
                                                                    index);
                                                      },
                                                      child: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15.0),
                                                            child: FadeInImage(
                                                              placeholder:
                                                                  const AssetImage(
                                                                      'assets/placeholder.png'), // Replace with your placeholder image asset
                                                              image: NetworkImage(
                                                                  filteredProducts[
                                                                          index]
                                                                      [
                                                                      'imageUrls'][0]),
                                                              width: screenSize
                                                                      .width *
                                                                  .83,
                                                              height: screenSize
                                                                      .height /
                                                                  2.66,
                                                              fit: BoxFit.cover,
                                                              imageErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Center(
                                                                  child: Icon(
                                                                    Icons
                                                                        .error_outline,
                                                                    size: screenSize
                                                                            .width *
                                                                        0.2, // Adjust size as needed
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                );
                                                              },
                                                              placeholderErrorBuilder:
                                                                  (context,
                                                                      error,
                                                                      stackTrace) {
                                                                return Center(
                                                                  child: Icon(
                                                                    Icons.image,
                                                                    size: screenSize
                                                                            .width *
                                                                        0.2, // Adjust size as needed
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .end,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            8.0),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (!favoriteProducts
                                                                          .any(
                                                                              (item) {
                                                                        return item['id'] ==
                                                                            snapshot.data![index]['id'];
                                                                      })) {
                                                                        //add favorites
                                                                        createFavorite(
                                                                            snapshot.data![index]);
                                                                      } else if (favoriteProducts
                                                                          .any(
                                                                              (item) {
                                                                        return item['id'] ==
                                                                            snapshot.data![index]['id'];
                                                                      })) {
                                                                        //remove favorite
                                                                        favoriteProducts
                                                                            .remove(snapshot.data![index]);
                                                                        deleteDocumentByFieldValue(
                                                                            'favorites',
                                                                            'id',
                                                                            snapshot.data![index]['id'],
                                                                            FirebaseAuth.instance.currentUser!.uid);
                                                                      }
                                                                    });
                                                                  },
                                                                  child: favoriteProducts
                                                                          .any(
                                                                              (item) {
                                                                    return item[
                                                                            'id'] ==
                                                                        snapshot.data![index]
                                                                            [
                                                                            'id'];
                                                                  })
                                                                      ? Icon(
                                                                          Icons
                                                                              .favorite_rounded,
                                                                          color: favoriteProducts.any((item) {
                                                                            return item['id'] ==
                                                                                snapshot.data![index]['id'];
                                                                          })
                                                                              ? Colors.red
                                                                              : Colors.grey,
                                                                        )
                                                                      : Icon(
                                                                          Icons
                                                                              .favorite_border_rounded,
                                                                          color: favoriteProducts.any((item) {
                                                                            return item['id'] ==
                                                                                snapshot.data![index]['id'];
                                                                          })
                                                                              ? Colors.red
                                                                              : Colors.grey,
                                                                        ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width *
                                                                    .1,
                                                              )
                                                            ],
                                                          ),
                                                          Text(
                                                            filteredProducts[
                                                                index]['name'],
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                          Text(
                                                            getStoreName(
                                                                filteredProducts[
                                                                        index][
                                                                    'storeId']),
                                                            style: const TextStyle(
                                                                fontSize: 18,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                          Text(
                                                            '\$${filteredProducts[index]['price']}',
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyLarge,
                                                          ),
                                                          // SizedBox(
                                                          //   height: MediaQuery.of(
                                                          //               context)
                                                          //           .size
                                                          //           .height *
                                                          //       .1,
                                                          // )
                                                        ],
                                                      ),
                                                    );
                                                  }),
                                            )
                                          : const Center(
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
