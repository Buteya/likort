import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'cartbadge.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({
    super.key,
    required this.appTitle,
    required this.appThemeMode,
    required this.toggleThemeMode,
  });

  final String appTitle;
  final ThemeMode appThemeMode;
  final Function() toggleThemeMode;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<Map<String, dynamic>?> getUserData(String userId) async {
    try {
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      DocumentSnapshot documentSnapshot =
      await usersCollection.doc(userId).get();

      if (documentSnapshot.exists) {
        // Document exists, get the data
        Map<String, dynamic> userData =
        documentSnapshot.data() as Map<String, dynamic>;
        if (kDebugMode) {
          print('User data retrieved successfully: $userData');
        }
        return userData;
      } else {
        // Document does not exist
        if (kDebugMode) {
          print('User document does not exist for userId: $userId');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting user data: $e');
      }
      return null;
    }
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String,dynamic>?>(
      future: getUserData(userId),
      builder: (BuildContext context, AsyncSnapshot<Map<String,dynamic>?> snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          // While the Future is still running
          return const LinearProgressIndicator();
        } else if(snapshot.hasError){
          return Text('Error: ${snapshot.error}');
        }else if(snapshot.hasData){return AppBar(
          toolbarHeight: 74,
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
                        children: [
                          Icon(Icons.notifications),
                          Text('Notifications')
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [Icon(Icons.favorite_rounded), Text('Favorites')],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.chat_bubble_rounded),
                          Text('Chat Shop')
                        ],
                      ),
                    ),
                    const PopupMenuItem<int>(
                      value: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(Icons.admin_panel_settings_rounded),
                          Text('Admin Panel')
                        ],
                      ),
                    ),
                  ],
                  elevation: 8.0,
                ).then((value) {
                  if (value != null) {
                    // Handle menu selection here
                    if (value == 1) {
                      Navigator.of(context)
                          .pushReplacementNamed('/likortfavoritesscreen');
                    }
                    if (value == 3) {
                      Navigator.of(context)
                          .pushReplacementNamed('/likortadminhome');
                    }

                    print("Selected: $value");
                  }
                });
              },
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/likorthomescreen');
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Transform.rotate(
                  angle: -6 * 3.1415926535897932 / 180,
                  child: Transform.scale(
                    scaleX: 1.36,
                    scaleY: 1.0,
                    child: Text(
                      widget.appTitle,
                      style: GoogleFonts.dancingScript(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(widget.appThemeMode == ThemeMode.light
                  ? Icons.wb_sunny
                  : (widget.appThemeMode == ThemeMode.dark
                      ? Icons.nights_stay
                      : Icons.brightness_auto)),
              onPressed: widget.toggleThemeMode,
            ),
            IconButton(
              onPressed: () {},
              icon: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacementNamed(
                    '/likortcart',
                    arguments: [
                      widget.appThemeMode,
                      widget.toggleThemeMode,
                    ],
                  );
                },
                child: const CartBadge(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pushNamed('/likortuserprofile');
                },
                child:snapshot.data!['imageUrl'] == ""
                    ? const CircleAvatar(
                        child: Icon(
                          Icons.person,
                        ),
                      )
                    : CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage: NetworkImage(snapshot.data!['imageUrl'],
                        ),
                      ),
              ),
            ),
          ],
        );}else{
          return const Text('No data');
        }
      }
    );
  }
}
