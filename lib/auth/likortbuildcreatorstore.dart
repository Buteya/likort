import 'package:flutter/material.dart';

class LikortBuildCreatorStore extends StatefulWidget {
  const LikortBuildCreatorStore({super.key});

  @override
  State<LikortBuildCreatorStore> createState() =>
      _LikortBuildCreatorStoreState();
}

class _LikortBuildCreatorStoreState extends State<LikortBuildCreatorStore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('create store'),
      ),
      body: Column(children: [
        const Text('store name'),
        const Text('store details'),
        const Text('location'),
        ElevatedButton(onPressed: (){
          Navigator.of(context).pushNamed('/likortcreatorprofilestore');
        }, child: const Text('create store'),),
      ],),
    );
  }
}
