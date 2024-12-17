import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/likortusers.dart';

class LikortUserSettings extends StatefulWidget {
  const LikortUserSettings({super.key});

  @override
  State<LikortUserSettings> createState() => _LikortUserSettingsState();
}

class _LikortUserSettingsState extends State<LikortUserSettings> {
  @override
  Widget build(BuildContext context) {
    final List<String> items = ['Change Password', 'Change Delivery Location', 'Create Store','Manage Store', 'Delete Account',];

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.dehaze_rounded,
              size: 40,
            ),
            onPressed: () {
              showMenu(
                context: context,
                position: const RelativeRect.fromLTRB(0, kToolbarHeight, 0, 0),
                items: [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.home), Text('Home')],
                    ),
                  ),
                  // const PopupMenuItem<int>(
                  //   value: 1,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //     children: [Icon(Icons.store_rounded), Text('Manage Store')],
                  //   ),
                  // ),
                  const PopupMenuItem<int>(
                    value: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.settings), Text('Settings')],
                    ),
                  ),
                  const PopupMenuItem<int>(
                    value: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [Icon(Icons.logout_rounded), Text('Logout')],
                    ),
                  ),
                ],
                elevation: 8.0,
              ).then((value) {
                if (value != null) {
                  // Handle menu selection here
                  if (value == 2) {
                    Navigator.of(context)
                        .pushReplacementNamed('/likortusersettings');
                  }
                  if (value == 0) {
                    Navigator.of(context)
                        .pushReplacementNamed('/likorthomescreen');
                  }
                  // if (value == 1) {
                  //   Navigator.of(context)
                  //       .pushReplacementNamed('/likortmanagestore');
                  // }
                  print("Selected: $value");
                }
              });
            },
          ),
        ),
        title: const Text('settings'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed('/likortuserprofile');
              },
              child: Provider.of<User>(
                context,
                listen: false,
              ).users.last.imageUrl.isEmpty
                  ? const CircleAvatar(
                child: Icon(
                  Icons.person,
                ),
              )
                  : CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  Provider.of<User>(
                    context,
                    listen: false,
                  ).users.last.imageUrl,
                ),
              ),
            ),
          ),
        ],
      ),
      // body: Column(
      //   children: [
      //     Center(child: Text('change password')),
      //     Center(child: Text('change delivery location')),
      //     Center(child: Text('create store')),
      //     Center(child: Text('delete account')),
      //   ],
      // ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              // leading: Icon(items[index]),
              title: Text(items[index]),
              onTap: () {
                // ...
                if(items[index] == 'Create Store'){
                  Navigator.of(context).pushReplacementNamed( '/lkortbuildcreatorstore');
                }
                if(items[index] == items.last){
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Delete Confirmation'),
                        content: const Text('Are you sure you want to delete this item?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              // Handle delete action
                              print('Deleting ${items[index]}');
                              Navigator.of(context).pop(); // Close the popup
                            },
                            child: const Text('Delete'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the popup
                            },
                            child: const Text('Cancel'),
                          ),
                        ],
                      );
                    },
                  );
                }

                print('Tapped on ${items[index]}');
              },
            );
          },
        ),
    );
  }
}
