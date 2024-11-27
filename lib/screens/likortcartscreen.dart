import 'package:flutter/material.dart';

class LikortCartScreen extends StatefulWidget {
  const LikortCartScreen({super.key});

  @override
  State<LikortCartScreen> createState() => _LikortCartScreenState();
}

class _LikortCartScreenState extends State<LikortCartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacementNamed('/likorthomescreen');
          },
          child: const Icon(Icons.arrow_circle_left_outlined),
        ),
        title: const Center(child: Text('cart')),
        actions: const [
          Card(
            child: Icon(Icons.delete),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      const Icon(
                        Icons.shopping_basket_rounded,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Text('ann\'s shop'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('view shop'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('painting'),
                      Text('ann\'s shop'),
                      Text('\$99')
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(child: Icon(Icons.add)),
                      Text('1'),
                      Card(child: Icon(Icons.remove)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      const Icon(
                        Icons.shopping_basket_rounded,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Text('ann\'s shop'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('view shop'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('painting'),
                      Text('ann\'s shop'),
                      Text('\$99')
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(child: Icon(Icons.add)),
                      Text('1'),
                      Card(child: Icon(Icons.remove)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      const Icon(
                        Icons.shopping_basket_rounded,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Text('ann\'s shop'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('view shop'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('painting'),
                      Text('ann\'s shop'),
                      Text('\$99')
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(child: Icon(Icons.add)),
                      Text('1'),
                      Card(child: Icon(Icons.remove)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      const Icon(
                        Icons.shopping_basket_rounded,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Text('ann\'s shop'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('view shop'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('painting'),
                      Text('ann\'s shop'),
                      Text('\$99')
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(child: Icon(Icons.add)),
                      Text('1'),
                      Card(child: Icon(Icons.remove)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      const Icon(
                        Icons.shopping_basket_rounded,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Text('ann\'s shop'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('view shop'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('painting'),
                      Text('ann\'s shop'),
                      Text('\$99')
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(child: Icon(Icons.add)),
                      Text('1'),
                      Card(child: Icon(Icons.remove)),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .05,
                      ),
                      const Icon(
                        Icons.shopping_basket_rounded,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * .02,
                      ),
                      const Text('ann\'s shop'),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('view shop'),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .03,
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16.0, right: 16.0),
              child: Divider(),
            ),
            Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .05,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('painting'),
                      Text('ann\'s shop'),
                      Text('\$99')
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .1,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * .2,
                ),
                const Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Card(child: Icon(Icons.add)),
                      Text('1'),
                      Card(child: Icon(Icons.remove)),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .07,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: Column(
                    children: [
                      const Text('amount price'),
                      Text('\$99',style: Theme.of(context).textTheme.headlineLarge,),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: ElevatedButton(
                      onPressed: () {},
                      child: const Row(
                        children: [
                          Text('checkout'),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Card(
                              child: Center(child: Text('6')),
                            ),
                          )
                        ],
                      ),),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * .05,
            ),
          ],
        ),
      ),
    );
  }
}
