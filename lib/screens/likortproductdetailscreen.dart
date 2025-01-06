import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/likortartproduct.dart';
import '../models/likortcartitem.dart';
import '../models/likortfavorites.dart';
import '../models/likortstore.dart';
import '../models/likortusers.dart';

class LikortProductDetailScreen extends StatefulWidget {
  const LikortProductDetailScreen({super.key});

  @override
  State<LikortProductDetailScreen> createState() =>
      _LikortProductDetailScreenState();
}

class _LikortProductDetailScreenState extends State<LikortProductDetailScreen> {
  int _selectedImageIndex = 0;
  int _quantity = 1;
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
    final index = ModalRoute.of(context)!.settings.arguments as int;
    final products = Provider.of<Product>(context,listen:false).products;
    final favorites = Provider.of<Favorites>(
      context,
      listen: false,
    );


    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/likorthomescreen');
            },
            child: const Icon(Icons.arrow_back,),),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  products[index].imageUrls[_selectedImageIndex],
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.4,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .1,
                  ),
                  SizedBox(
                    height: 100,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: products[index].imageUrls.length,
                      itemBuilder: (context, imageIndex) {
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedImageIndex = imageIndex; // Update _selectedImageIndex
                            });
                          },
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15.0),
                                child: Image.network(
                                  products[index].imageUrls[imageIndex],
                                  width: MediaQuery.of(context).size.width * .2,
                                  height:  MediaQuery.of(context).size.height * .15,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * .02,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .01,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                InkWell(
                  onTap: () {
                    // product
                    //     // .toggleFavorite(product.products[0].id);
                    setState(() {
                      final favoriteProducts =
                      Provider.of<Favorites>(
                        context,listen: false,)
                          .favorites
                          .expand((fav) => fav
                          .favoriteProducts)
                          .toList();
                      final productIndex =
                      favoriteProducts.indexWhere(
                              (prod) =>
                          prod.id ==
                              products[index].id);
                      if (!favoriteProducts
                          .contains(products[index])) {
                        favoriteProducts.add(products[index]);
                        favorites.add(Favorites(
                          id: const Uuid().v4(),
                          userId: Provider.of<User>(
                              context,
                              listen: false)
                              .users
                              .last
                              .id,
                          favoriteProducts:
                          favoriteProducts,
                        ));
                      }else if(favoriteProducts.contains(products[index])){
                        setState(() {
                          Provider.of<Favorites>(
                            context,listen: false,)
                              .favorites
                              .expand((fav) => fav
                              .favoriteProducts)
                              .toList().removeAt(productIndex);
                          favorites.removeFavorite(productIndex);

                        });
                      }
                    });
                  },
                  child: favorites.favorites.any(
                          (fav) => fav
                          .favoriteProducts
                          .contains(products[index]))
                      ? Icon(
                    Icons.favorite_rounded,
                    color:  favorites.favorites.any(
                            (fav) => fav
                            .favoriteProducts
                            .contains(products[index]))
                        ? Colors.red
                        : Colors.grey,
                  )
                      : Icon(
                    Icons
                        .favorite_border_rounded,
                    color:  favorites.favorites.any(
                            (fav) => fav
                            .favoriteProducts
                            .contains(products[index]))
                        ? Colors.red
                        : Colors.grey,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                )
              ],
            ),
             Text(products[index].name),
             Text(products[index].typeOfArt),
            Text(
              getStoreName(products[index].storeId),
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
             Center(
              child: SizedBox(
                width: 200,
                child: Text(
                  products[index].description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w400),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Text(
              '\$${products[index].price}',
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .03,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Add padding
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed:() {
                      // Handle remove quantity
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
                    ),
                    child:  Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        InkWell(
                            onTap: () {
                              setState(() {
                                if (_quantity > 1) {
                                  _quantity--;
                                }});
                            },child: const Icon(Icons.remove,),),
                        const SizedBox(width: 8.0), // Add spacing
                        Text(_quantity.toString()),
                        const SizedBox(width: 8.0), // Add spacing
                        InkWell(
                            onTap: () {
                              setState(() {
                                  _quantity++;
                                });
                            },
                            child: const Icon(Icons.add,),),
                      ],
                    ),
                  ),
                  ElevatedButton(onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/likorthomescreen');
                  },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0), // Adjust padding
                    ),
                    child: InkWell(
                      onTap: (){
                        var cartItems = Provider.of<CartItem>(context,listen:false);
                        var id = const Uuid().v4();
                        if(_quantity >= 1){
                          cartItems.add(CartItem(id: id,userId: Provider.of<User>(context,listen:false).users.last.id, product: products[index],quantity: _quantity,),);
                        }
                       for(var item in cartItems.cartItems){
                         print(item.id);
                         print(item.userId);
                         print(item.product.id);
                         print(item.quantity);
                       }
                       Navigator.of(context).pushReplacementNamed('/likortcart');
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.shopping_cart_rounded),
                          SizedBox(width: 8.0), // Add spacing
                          Text('Add to Cart'), // Capitalize text
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .04,
            )
          ],
        ),
      ),
    );
  }
}
