import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

// import '../models/likortartproduct.dart';
import '../models/likortfavorites.dart';
import '../models/likortstore.dart';
import '../models/likortusers.dart';

class LikortFavoriteScreen extends StatefulWidget {
  const LikortFavoriteScreen({super.key});

  @override
  State<LikortFavoriteScreen> createState() => _LikortFavoriteScreenState();
}

class _LikortFavoriteScreenState extends State<LikortFavoriteScreen> {
  List<Map<String,dynamic>> stores = [];
  List<Map<String,dynamic>> favorites = [];
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    loadStoreData();
    loadFavoriteData();
    super.initState();
  }

  Future<List<Map<String, dynamic>>> fetchFavoriteData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('favorites').get();
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

  Future<void> loadFavoriteData() async{
    try {
      final userData =  await fetchFavoriteData();
      if (userData != null) {
        setState(() {
          favorites = userData;
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

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return _isLoading?Scaffold(body:Center(child:CircularProgressIndicator())): Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed('/likorthomescreen');
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: favorites.isEmpty
          ? const Center(
              child: Text('No favorites yet.'),
            )
          : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.builder(
                // controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of items per row
                  crossAxisSpacing: 8.0, // Spacing between columns
                  mainAxisSpacing: 8.0, // Spacing between rows
                ),
                itemCount: favorites
                    .length,
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
                            favorites[index]['favoriteProducts'][index]['imageUrls'][0],
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
                                    if (!favorites.any((item)=>item.values == favorites[index]['favoriteProducts'])) {

                                    } else if (favorites.any((item)=>item.values == favorites[index]['favoriteProducts'])) {

                                    }

                                },
                                child: favorites.any((item)=>item['favoriteProducts'] == favorites[index]['favoriteProducts'])
                                    ? Icon(
                                        Icons.favorite_rounded,
                                        color:favorites.any((item)=>item['favoriteProducts'] == favorites[index]['favoriteProducts'])
                                            ? Colors.red
                                            : Colors.grey,
                                      )
                                    : Icon(
                                        Icons.favorite_border_rounded,
                                        color: favorites.any((item)=>item['favoriteProducts'] == favorites[index]['favoriteProducts'])
                                            ? Colors.red
                                            : Colors.grey,
                                      ),
                              ),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * .1,
                            )
                          ],
                        ),
                        Text(
                          favorites[index]['favoriteProducts'][index]['name'],
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          getStoreName( favorites[index]['favoriteProducts'][index]['storeId']),
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '\$${ favorites[index]['favoriteProducts'][index]['price']}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * .1,
                        )
                      ],
                    ),
                  );
                }),
          ),
    );
  }
}
