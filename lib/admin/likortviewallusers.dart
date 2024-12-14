import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/likortusers.dart';

class LikortViewAllUsers extends StatefulWidget {
  const LikortViewAllUsers({super.key});

  @override
  State<LikortViewAllUsers> createState() => _LikortViewAllUsersState();
}

class _LikortViewAllUsersState extends State<LikortViewAllUsers> {
  final List<bool> _isExpanded = []; // Track expansion state for each tile

  @override
  void initState() {
    super.initState();
    // Initialize expansion state to false for all tiles
    _isExpanded.addAll(List.generate(context.read<User>().users.length, (index) => false));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer<User>(
        builder: (context, users, child) {
          // Create a modifiable copy of the users list
          final sortedUsers = List<User>.from(users.users);

          // Sort the modifiable copy
          sortedUsers.sort((a, b) => b.created.compareTo(a.created));
          return ListView.builder(
            itemCount: sortedUsers.length, // Use the sorted copy
            itemBuilder: (context, index) {
              final user = sortedUsers[index];
              return ExpansionTile(
                initiallyExpanded: _isExpanded[index], // Set initial expansion state
                onExpansionChanged: (expanded) {
                  setState(() {
                    _isExpanded[index] = expanded; // Update expansion state
                  });
                },
                leading: CircleAvatar(
                  backgroundImage: user.imageUrl != ''
                      ? NetworkImage(user.imageUrl)
                      : null,
                  child: user.imageUrl == '' ? const Icon(Icons.person) : null,
                ),
                title: Text(user.firstname),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email: ${user.id}'),
                        Text('Phone: ${user.firstname}'),
                        Text('Email: ${user.lastname}'),
                        Text('Phone: ${user.email}'),
                        Text('Email: ${user.phone}'),
                        Text('Phone: ${user.latitude}'),
                        Text('Email: ${user.longitude}'),
                        Text('Phone: ${user.password}'),
                        Text('Email: ${user.usertype}'),
                        Text('Phone: ${user.storeId}'),
                        Text('Email: ${user.reviews}'),
                        Text('Phone: ${user.notifications}'),
                        Text('Email: ${user.favorites}'),
                        Text('Phone: ${user.imageUrl}'),
                        Text('Email: ${user.created}'),
                        Text('Phone: ${user.isOnline}'),

                        // Add moreuser details here
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                // Handle update action
                              },
                              child: const Text('Update'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Handle close action
                                setState(() {
                                  _isExpanded[index] = false; // Retract the tile
                                });
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
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