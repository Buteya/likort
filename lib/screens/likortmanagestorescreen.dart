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
    final store = Provider.of<Store>(context);
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.deepOrange,
              ),
              child: Stack(
                // Use Stack to position text over image
                children: [
                  Image.network(
                    store.stores.last.imageUrl[0],
                    fit: BoxFit.contain, // Cover the entire header
                    width: double.infinity, // Stretch to full width
                    height: double.infinity, // Stretch to full height
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
                            store.stores.last.name,
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
              leading: const Icon(
                  Icons.production_quantity_limits), // Create Product icon
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
      body: Consumer<Store>(
        builder: (context, store, child) {
          return SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height*1.8,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Image.network(
                            store.stores.last.imageUrl[0],
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.4,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            bottom: 0,
                            // Remove left and right properties
                            child: IntrinsicWidth(
                              child: Card(
                                color: Colors.black26,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Text(
                                    store.stores.last.name,
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
                      SizedBox(
                        height: 100, // Adjust height as needed
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: store.stores.last.imageUrl.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  store.stores.last.imageUrl[index],
                                  width: MediaQuery.of(context).size.width *
                                      0.25, // Adjust width
                                  height: MediaQuery.of(context).size.width *
                                      0.25, // Adjust height
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error); // Errorwidget
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
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                      ),
                      const Divider(),
                      Text(
                        store.stores.last.description,
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).brightness == Brightness.light
                              ? Colors.black
                              : Colors.white,
                        ),
                        // textAlign:
                        //     TextAlign.justify, // Justify text for neat alignment
                        maxLines: 5, // Limit lines to 5 (optional)
                        overflow: TextOverflow
                            .ellipsis, // Show ellipsis if text overflows
                      ),
                      const TabBar(
                        tabs: [
                          Tab(icon: Icon(Icons.inventory_2), text: 'Products'),
                          Tab(icon: Icon(Icons.bar_chart), text: 'Analytics'),
                        ],
                      ),
                      Expanded(
                        // Use Expanded to fill available space
                        child: TabBarView(
                          children: [
                            Card(
                              child:
                                  Consumer<Store>(builder: (context, store, child) {
                                return store.stores.last.products.isEmpty
                                    ? const Center(
                                        child: Text('No products'),
                                      )
                                    : ListView.builder(
                                        itemCount: store.stores.last.products.length,
                                        itemBuilder: (context, index) {
                                          return Column(
                                            children: [
                                              Image.network(store.stores.last
                                                  .products[index].imageUrls[0]),
                                              Padding(
                                                padding: const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        store.stores.last
                                                            .products[index].name,
                                                        style: GoogleFonts.roboto(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        )),
                                                    Text(
                                                        'Price: \$${store.stores.last.products[index].price}',
                                                        style:
                                                            GoogleFonts.roboto()),
                                                    Text(
                                                        'Shop: ${getStoreName(store.stores.last.products[index].storeId)}',
                                                        style:
                                                            GoogleFonts.roboto()),
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
                              }),
                            ),
                            SfCartesianChart(
                              primaryXAxis: const CategoryAxis(),
                              primaryYAxis: const NumericAxis(),
                              series: [
                                LineSeries<double, int>(
                                  dataSource: data,
                                  xValueMapper: (datum, index) =>
                                      index + 1, // X-axis: index + 1
                                  yValueMapper: (datum, _) =>
                                      datum, // Y-axis: data value
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
