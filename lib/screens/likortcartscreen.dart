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
        title: const Text('Cart'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/likortcheckout');
                },
                child: const Text('checkout')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text('Item ${index + 1}'),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
