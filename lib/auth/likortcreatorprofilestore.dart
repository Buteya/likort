import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikortCreatorProfileStore extends StatefulWidget {
  const LikortCreatorProfileStore({super.key});

  @override
  State<LikortCreatorProfileStore> createState() => _LikortCreatorProfileStoreState();
}

class _LikortCreatorProfileStoreState extends State<LikortCreatorProfileStore> {
  @override
  Widget build(BuildContext context) {
    return FirebaseAuth.instance.currentUser == null
        ? Scaffold(
      body: TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed('/likortlogin'),
          child: const Text('Login')),
    )
        : Scaffold(
      appBar: AppBar(
        title: const Text('Store Profiel'),
      ),
      body: Column(
        children: [
          Image.network(
            'https://cdn.pixabay.com/photo/2016/09/20/18/49/brushes-1683134_1280.jpg',
            width: 400,
            height: 400,
          ),
          const Text('all store products'),
          ElevatedButton(onPressed: (){
Navigator.of(context).pushNamed('/likortcreateartproduct');
          }, child: const Text('create product')),
        ],
      ),
    );
  }
}
