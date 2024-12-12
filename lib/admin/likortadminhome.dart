import 'package:flutter/material.dart';

class LikortAdminHome extends StatefulWidget {
  const LikortAdminHome({super.key});

  @override
  State<LikortAdminHome> createState() => _LikortAdminHomeState();
}

class _LikortAdminHomeState extends State<LikortAdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Hello, John',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Text('user'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_rounded),
              title: const Text('create user'),
              onTap: () {
                // Update the state of the app
                Navigator.of(context)
                    .pushReplacementNamed('/likortcreateuser')
                    .then((_) {
                  // Then close the drawer
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('view all users'),
              onTap: () {
                // Update the state of the app
                Navigator.of(context)
                    .pushReplacementNamed('/likortviewallusers')
                    .then((_) {
                  // Then close the drawer
                  Navigator.pop(context);
                });
              },
            ),
            Text('store'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.store_outlined),
              title: const Text('create store'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.store_rounded),
              title: const Text('view all store'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Text('order'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('create order'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_rounded),
              title: const Text('view all orders'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Text('payments'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.payment_rounded),
              title: const Text('view all payments'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Text('role'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services_outlined),
              title: const Text('create role'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services_rounded),
              title: const Text('view all roles'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Text('permission'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility_outlined),
              title: const Text('create permission'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility_sharp),
              title: const Text('view all permissions'),
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
