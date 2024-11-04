import 'package:flutter/material.dart';

class LikortCheckoutScreen extends StatefulWidget {
  const LikortCheckoutScreen({super.key});

  @override
  State<LikortCheckoutScreen> createState() => _LikortCheckoutScreenState();
}

class _LikortCheckoutScreenState extends State<LikortCheckoutScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('checkout'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('delivery'),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('pickup'),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                'https://cdn.pixabay.com/photo/2017/04/03/14/42/smartphone-2198559_960_720.jpg',
                width: double.infinity,
                height: 100,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: 5,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item ${index + 1}'),
                    );
                  },
                ),
              ),
            ),
            const Text('pay total'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/likorttrackorder');
                  },
                  child: const Text('mpesa'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/likorttrackorder');
                  },
                  child: const Text('cash'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
