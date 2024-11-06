import 'package:flutter/material.dart';

class LikortCreateArtProduct extends StatefulWidget {
  const LikortCreateArtProduct({super.key});

  @override
  State<LikortCreateArtProduct> createState() => _LikortCreateArtProductState();
}

class _LikortCreateArtProductState extends State<LikortCreateArtProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create art product'),
      ),
      body: Column(
        children: [
          Form(
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {

                  },
                  child: const Text('create art'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
