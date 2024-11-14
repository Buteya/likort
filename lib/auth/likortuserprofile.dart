import 'package:flutter/material.dart';

class LikortUserProfile extends StatefulWidget {
  const LikortUserProfile({super.key});

  @override
  State<LikortUserProfile> createState() => _LikortUserProfileState();
}

class _LikortUserProfileState extends State<LikortUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Drawer Header',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/');
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.store_mall_directory_rounded),
              title: const Text('create store'),
              onTap: () {
                Navigator.of(context).pushReplacementNamed('/lkortbuildcreatorstore');
              },
            ),
          ],
        ),
      ),
      body: Form(
          child: Column(
        children: [
          const Text('Profile'),
          TextFormField(),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Update'),
          ),
        ],
      )),
    );
  }
}
