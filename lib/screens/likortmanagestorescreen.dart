import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/likortstore.dart';

class LikortManageStoreScreen extends StatefulWidget {
  const LikortManageStoreScreen({super.key});

  @override
  State<LikortManageStoreScreen> createState() =>
      _LikortManageStoreScreenState();
}

class _LikortManageStoreScreenState extends State<LikortManageStoreScreen> {
  List<double> data = [1, 5, 6, 7, 8, 9, 1, 2, 34, 5, 5, 6, 7];

  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> getProductData(String userId) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('products');
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(userId).get();

      if (documentSnapshot.exists) {
        // Document exists, get the data
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        if (kDebugMode) {
          print('User data retrieved successfully: $userData');
        }
        return userData;
      } else {
        // Document does not exist
        if (kDebugMode) {
          print('User document does not exist for userId: $userId');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }

  Future<Map<String, dynamic>?> getStoreData(String userId) async {
    try {
      CollectionReference usersCollection =
          FirebaseFirestore.instance.collection('stores');
      DocumentSnapshot documentSnapshot =
          await usersCollection.doc(userId).get();

      if (documentSnapshot.exists) {
        // Document exists, get the data
        Map<String, dynamic> userData =
            documentSnapshot.data() as Map<String, dynamic>;
        if (kDebugMode) {
          print('User data retrieved successfully: $userData');
        }
        return userData;
      } else {
        // Document does not exist
        if (kDebugMode) {
          print('User document does not exist for userId: $userId');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }

  String getStoreName(String storeId) {
    // Find the store with the matching storeId
    final store = Provider.of<Store>(context).stores.firstWhere(
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
    return FutureBuilder<Map<String, dynamic>?>(
        future: getStoreData(userId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>?> snapshot) {
          return snapshot.connectionState == ConnectionState.waiting
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              :  FirebaseAuth.instance.currentUser == null
              ? Scaffold(
            body: TextButton(
                onPressed: () => Navigator.of(context)
                    .pushReplacementNamed('/likortlogin'),
                child: const Text('Login')),
          )
              :Scaffold(
                  appBar: AppBar(),
                  drawer: Drawer(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        DrawerHeader(
                          decoration: const BoxDecoration(
                            color: Colors.black38,
                          ),
                          child: Stack(
                            // Use Stack to position text over image
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(15.0)),
                                child: Image.network(
                                  snapshot.data!['imageUrls'][0],
                                  fit: BoxFit.cover, // Cover the entire header
                                  width:
                                      double.infinity, // Stretch to full width
                                  height:
                                      double.infinity, // Stretch to full height
                                ),
                              ),
                              Positioned(
                                // Position text at the bottom
                                bottom: 0,
                                child: IntrinsicWidth(
                                  child: Card(
                                    color: Colors.black26,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0, vertical: 8.0),
                                      child: Text(
                                        snapshot.data!['name'],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 24,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // ... (other drawer items) ...
                        ListTile(
                          leading: const Icon(
                              Icons.home_rounded), // Create Product icon
                          title: const Text('Home'),
                          onTap: () {
                            // Handle create product action
                            Navigator.pop(context); // Close the drawer first
                            Navigator.of(context).pushNamed(
                                '/likorthomescreen'); // Then navigate to create product screen
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.message), // Messages icon
                          title: const Text('Messages'),
                          onTap: () {
                            // Handle messages action
                            Navigator.pop(context);
                            // Navigate to messages screen
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons
                              .production_quantity_limits), // Create Product icon
                          title: const Text('Create Product'),
                          onTap: () {
                            // Handle create product action
                            Navigator.pop(context); // Close the drawer first
                            Navigator.of(context).pushNamed(
                                '/likortcreateartproduct'); // Then navigate to create product screen
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.settings), // Settings icon
                          title: const Text('Settings'),
                          onTap: () {
                            // Handle settings action
                            Navigator.pop(context);
                            // Navigate to settings screen
                          },
                        ),
                      ],
                    ),
                  ),
                  body: snapshot.connectionState == ConnectionState.waiting
                      ?
                      // While the Future is still running
                      const Center(child: CircularProgressIndicator())
                      : snapshot.hasError
                          ? Text('Error: ${snapshot.error}')
                          : snapshot.hasData
                              ? SingleChildScrollView(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        1.8,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      child: DefaultTabController(
                                        length: 2,
                                        child: Column(
                                          children: [
                                            Stack(
                                              children: [
                                                Image.network(
                                                  fit: BoxFit.cover,
                                                  snapshot.data!['imageUrls']
                                                      [0],
                                                  width: double.infinity,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.4,
                                                ),
                                                Positioned(
                                                  bottom: 0,
                                                  // Remove left and right properties
                                                  child: IntrinsicWidth(
                                                    child: Card(
                                                      color: Colors.black26,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    16.0,
                                                                vertical: 8.0),
                                                        child: Text(
                                                          snapshot
                                                              .data!['name'],
                                                          style:
                                                              const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 25,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height:
                                                  100, // Adjust height as needed
                                              child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: snapshot
                                                    .data!['imageUrls'].length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.0),
                                                      child: Image.network(
                                                        snapshot.data![
                                                            'imageUrls'][index],
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.4, // Adjust width
                                                        height: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.35, // Adjust height
                                                        fit: BoxFit.contain,
                                                        errorBuilder: (context,
                                                            error, stackTrace) {
                                                          return const Icon(Icons
                                                              .error); // Errorwidget
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                            Text(
                                              'Description',
                                              style: GoogleFonts.roboto(
                                                fontSize: 23,
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                            ),
                                            const Divider(),
                                            Text(
                                              snapshot.data!['description'],
                                              style: GoogleFonts.roboto(
                                                fontSize: 21,
                                                fontWeight: FontWeight.normal,
                                                color: Theme.of(context)
                                                            .brightness ==
                                                        Brightness.light
                                                    ? Colors.black
                                                    : Colors.white,
                                              ),
                                              // textAlign:
                                              //     TextAlign.justify, // Justify text for neat alignment
                                              maxLines:
                                                  5, // Limit lines to 5 (optional)
                                              overflow: TextOverflow
                                                  .ellipsis, // Show ellipsis if text overflows
                                            ),
                                            const TabBar(
                                              tabs: [
                                                Tab(
                                                    icon: Icon(
                                                      Icons.inventory_2,
                                                    ),
                                                    text: 'Products'),
                                                Tab(
                                                    icon: Icon(
                                                      Icons.bar_chart,
                                                    ),
                                                    text: 'Analytics'),
                                              ],
                                            ),
                                            Expanded(
                                              // Use Expanded to fill available space
                                              child: TabBarView(
                                                children: [
                                                  Consumer<Store>(builder:
                                                      (context, store, child) {
                                                    return snapshot.data![
                                                                'products'] ==
                                                            null
                                                        ? const Center(
                                                            child: Text(
                                                                'No products'),
                                                          )
                                                        : FutureBuilder<
                                                                Map<String,
                                                                    dynamic>?>(
                                                            future:
                                                                getProductData(
                                                                    userId),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        Map<String,
                                                                            dynamic>?>
                                                                    snapshotProduct) {
                                                              return ListView
                                                                  .builder(
                                                                      itemCount: snapshot
                                                                          .data![
                                                                              'products']
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.only(
                                                                                top: 20.0,
                                                                                left: 30,
                                                                                right: 30,
                                                                              ),
                                                                              child: ClipRRect(
                                                                                borderRadius: const BorderRadius.only(
                                                                                  topRight: Radius.circular(15),
                                                                                  topLeft: Radius.circular(15),
                                                                                ),
                                                                                child: Image.network(width: MediaQuery.sizeOf(context).width, height: MediaQuery.sizeOf(context).height * .6, fit: BoxFit.cover, snapshot.data!['products'][index]['imageUrls'][0]),
                                                                              ),
                                                                            ),
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(16.0),
                                                                              child: Column(
                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                children: [
                                                                                  Text(snapshot.data!['products'][index]['name'],
                                                                                      style: GoogleFonts.roboto(
                                                                                        fontSize: 22,
                                                                                        fontWeight: FontWeight.bold,
                                                                                      )),
                                                                                  Text('Price: \$${snapshot.data!['products'][index]['price']}',
                                                                                      style: GoogleFonts.roboto(
                                                                                        fontSize: 18,
                                                                                      )),
                                                                                  Text(snapshot.data!['name'],
                                                                                      style: GoogleFonts.roboto(
                                                                                        fontSize: 20,
                                                                                      )),
                                                                                  // Ratings or In Stock
                                                                                  // if (widget.product.ratings != null)
                                                                                  //   const Text('Ratings: ${widget.product.ratings}',
                                                                                  //       style: GoogleFonts.roboto()),
                                                                                  // if (widget.product.inStock != null)
                                                                                  //   const Text('In Stock: ${widget.product.inStock}',style: GoogleFonts.roboto()),
                                                                                  // Comments Section
                                                                                  // GestureDetector(
                                                                                  //   onTap: () {
                                                                                  //     setState(() {
                                                                                  //       _showComments = !_showComments;
                                                                                  //     });
                                                                                  //   },
                                                                                  //   child: Padding(
                                                                                  //     padding: const EdgeInsets.only(top: 8.0),
                                                                                  //     child: Row(
                                                                                  //       children: [
                                                                                  //         const Icon(Icons.comment),
                                                                                  //         Text(
                                                                                  //           _showComments
                                                                                  //               ? 'Hide Comments'
                                                                                  //               : 'View Comments (${comments.length})',
                                                                                  //           style: GoogleFonts.roboto(),
                                                                                  //         ),
                                                                                  //       ],
                                                                                  //     ),
                                                                                  //   ),
                                                                                  // ),
                                                                                  // if (_showComments)
                                                                                  //   Column(
                                                                                  //     children: [
                                                                                  //       // Display Comments
                                                                                  //       ListView.builder(
                                                                                  //         shrinkWrap: true,
                                                                                  //         physics: const NeverScrollableScrollPhysics(),
                                                                                  //         itemCount: comments.length,
                                                                                  //         itemBuilder: (context, index) {
                                                                                  //           final comment = comments[index];
                                                                                  //           return ListTile(
                                                                                  //             title: Text(comment.user,
                                                                                  //                 style: GoogleFonts.roboto()),
                                                                                  //             subtitle: Text(comment.text,
                                                                                  //                 style: GoogleFonts.roboto()),
                                                                                  //           );
                                                                                  //         },
                                                                                  //       ),
                                                                                  //       // Add Comment Form
                                                                                  //       Padding(
                                                                                  //         padding: const EdgeInsets.all(16.0),
                                                                                  //         child: Row(
                                                                                  //           children: [
                                                                                  //             const Expanded(
                                                                                  //               child: TextField(
                                                                                  //                 controller: _commentController,
                                                                                  //                 decoration: const InputDecoration(
                                                                                  //                     hintText: 'Add a comment...'),
                                                                                  //               ),
                                                                                  //             ),
                                                                                  //             IconButton(
                                                                                  //               icon: const Icon(Icons.send),
                                                                                  //               onPressed: () {
                                                                                  //                 // Add comment logic using provider
                                                                                  //                 Provider.of<CommentProvider>(context,
                                                                                  //                     listen: false)
                                                                                  //                     .addComment(
                                                                                  //                     _commentController.text,
                                                                                  //                     widget.product.id);
                                                                                  //                 _commentController.clear();
                                                                                  //               },
                                                                                  //             ),
                                                                                  //           ],
                                                                                  //         ),
                                                                                  //       ),
                                                                                  //     ],
                                                                                  //   ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        );
                                                                      });
                                                            });
                                                  }),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            30.0),
                                                    child: SizedBox(
                                                      height: MediaQuery.sizeOf(
                                                                  context)
                                                              .height *
                                                          .5,
                                                      child: SfCartesianChart(
                                                        primaryXAxis:
                                                            const CategoryAxis(),
                                                        primaryYAxis:
                                                            const NumericAxis(),
                                                        series: [
                                                          LineSeries<double,
                                                              int>(
                                                            dataSource: data,
                                                            xValueMapper: (datum,
                                                                    index) =>
                                                                index +
                                                                1, // X-axis: index + 1
                                                            yValueMapper: (datum,
                                                                    _) =>
                                                                datum, // Y-axis: data value
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : const Center(child: Text('No data')),
                );
        });
  }
}
