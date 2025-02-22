import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class LikortUserSettings extends StatefulWidget {
  const LikortUserSettings({super.key});

  @override
  State<LikortUserSettings> createState() => _LikortUserSettingsState();
}

class _LikortUserSettingsState extends State<LikortUserSettings> {
  Map<String, dynamic> data = {};
  String userId ='';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
     userId = FirebaseAuth.instance.currentUser!.uid;
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final userData = await getUserData(userId);
      if (userData != null) {
        setState(() {
          data = userData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading user data: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

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
    final List<String> items = ['Change Password', 'Change Delivery Location', 'Create Store','Manage Store', 'Delete Account',];

    return  FirebaseAuth.instance.currentUser == null
        ? Scaffold(
      body: TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed('/likortlogin'),
          child: const Text('Login')),
    )
        :Scaffold(
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
                        .pushNamed('/likortusersettings');
                  }
                  if (value == 0) {
                    Navigator.of(context)
                        .pushNamed('/likorthomescreen');
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
              child: data['imageUrl'].toString() == ""
                  ? const CircleAvatar(
                child: Icon(
                  Icons.person,
                ),
              )
                  : CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  data['imageUrl'].toString()
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
        body: _isLoading?const Center(child: CircularProgressIndicator(),):ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return ListTile(
              // leading: Icon(items[index]),
              title: Text(items[index]),
              onTap: () {
                // ...
                if(items[index] == 'Create Store'){
                  if(data['storeId'] == ""){
                    Navigator.of(context).pushNamed( '/lkortbuildcreatorstore');
                  }else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Store Exists'),
                          content: const Text('User has an existing store?'),
                          actions: [
                            // TextButton(
                            //   onPressed: () {
                            //     // Handle delete action
                            //     print('Deleting ${items[index]}');
                            //     Navigator.of(context).pop(); // Close the popup
                            //   },
                            //   child: const Text('Delete'),
                            // ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the popup
                              },
                              child: const Text('Ok'),
                            ),
                          ],
                        );
                      },
                    );
                  }

                }
                if(items[index] == 'Manage Store'){
                  Navigator.of(context).pushNamed( '/likortmanagestore');
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
