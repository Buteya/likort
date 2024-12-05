import 'package:flutter/material.dart';

class LikortManageStoreScreen extends StatefulWidget {
  const LikortManageStoreScreen({super.key});

  @override
  State<LikortManageStoreScreen> createState() => _LikortManageStoreScreenState();
}

class _LikortManageStoreScreenState extends State<LikortManageStoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(),drawer:  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text(
              'Drawer Header',style: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.message),
            title: Text('Messages'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.account_circle),
            title: Text('Profile'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            onTap: () {
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(context);
            },
          ),
        ],
      ),
    ),
        );
  }
}
