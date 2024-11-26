import 'package:flutter/material.dart';

class LikortProductDetailScreen extends StatefulWidget {
  const LikortProductDetailScreen({super.key});

  @override
  State<LikortProductDetailScreen> createState() =>
      _LikortProductDetailScreenState();
}

class _LikortProductDetailScreenState extends State<LikortProductDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_circle_left_outlined),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0,right: 8.0,bottom: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
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
                SizedBox(width: MediaQuery.of(context).size.width*.1,),
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                  width: 90,
                  height: 70,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width*.02,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 90,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*.02,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 90,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*.02,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 90,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*.02,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 90,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: MediaQuery.of(context).size.width*.02,),
            ],),
          ),
          SizedBox(height: MediaQuery.of(context).size.height*.01,),
          Row(mainAxisAlignment:MainAxisAlignment.end,children: [const Icon(Icons.favorite_rounded),SizedBox(width: MediaQuery.of(context).size.width*.1,)],),
          const Text('paint brushes'),
          const Text('ann\'s store'),
          const Text('The brushes are likely made of natural materials, possibly wood and animal hair.The container might be a repurposed jar or pot, adding to the rustic charm.'),
          const Text('Supplies'),
          const Text('\$99'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(onPressed: (){}, child: const Row(children: [Icon(Icons.remove),Text('1'),Icon(Icons.add)],)),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/likortcart');
                },
                child: const Flexible(
                  child: Row(
                    children: [
                      Icon(Icons.shopping_cart_rounded),
                      Text('add to cart'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
