import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../models/likortusers.dart' as likortUser;

class LikortUserProfile extends StatefulWidget {
  const LikortUserProfile({super.key});

  @override
  State<LikortUserProfile> createState() => _LikortUserProfileState();
}

class _LikortUserProfileState extends State<LikortUserProfile> {
  likortUser.User? currentUser;
  String? imageAvailable = '';
  final bool _imagePicked = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser!.uid;
  String? _imageUrl; // Store the Firebase Storage URL here
  XFile? _pickedImage; // Store the picked image here
  String? downloadUrl = ''; // Initialize downloadUrl to null

  @override
  void initState() {
    try {
      currentUser =
          Provider.of<likortUser.User>(context, listen: false).users.last;
      print(Provider.of<likortUser.User>(context, listen: false).users.length);
    } catch (e) {
      print(e.toString());
    }
    super.initState();
  }

  void _update(
    String firstname,
    String lastname,
    String mobileNumber,
  ) {
    final user = Provider.of<likortUser.User>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    print(user.users.length);

    if (currentUser != null) {
      user.updateUser(
        likortUser.User(
            id: currentUser!.id,
            email: currentUser!.email,
            password: currentUser!.password,
            firstname: firstname,
            lastname: lastname,
            imageUrl: imageAvailable!,
            phone: mobileNumber,
            latitude: 0,
            longitude: 0,
            storeId: '',
            reviews: [],
            favorites: [],
            notifications: [],
            created: currentUser!.created),
      );
    } else {
      print('failed to update');
    }
    final newUser = Provider.of<likortUser.User>(context, listen: false);
    for (final user in newUser.users) {
      print(user.id);
      print(user.firstname);
      print(user.lastname);
      print(user.imageUrl);
      print(user.phone);
    }
    if (user.users.last.id == newUser.users.last.id) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'updated successfully!!!',
              style: GoogleFonts.roboto(
                fontSize: 17,
              ),
            ),
          ),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'unable to update!!!',
              style: GoogleFonts.roboto(
                fontSize: 17,
              ),
            ),
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
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
  Future<void> _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, preferredCameraDevice: CameraDevice.front);
    if (pickedImage != null) {
      setState(() {
        _pickedImage = pickedImage;
      });
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    setState(() {
      _isLoading = true;
    });try {
      final storageRef = FirebaseStorage.instance.ref();
      final imageRef = storageRef.child('user_images/$userId/${image.name}');
      await imageRef.putFile(File(image.path));
      final downloadUrl = await imageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> updateUserDocument(
      String userId,
      String phone,
      String firstname,
      String lastname,
      XFile? imageUrl, // Make imageUrl nullable
      ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      // Get a reference to the document
      DocumentReference userDocRef=
      FirebaseFirestore.instance.collection('users').doc(userId);
        final storageRef = FirebaseStorage.instance.ref();
        final imageRef = storageRef.child('user_images/$userId/${imageUrl?.name}');

      final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        // You can add other metadata here if needed
        //customMetadata: {
        //   'key': 'value',
        // },
      );

      if (kIsWeb) {
          // For web, use putData with Uint8List
          final bytes = await imageUrl?.readAsBytes();
          await imageRef.putData(bytes!,metadata);
        } else {
          // For mobile/desktop, use putFile with File
          await imageRef.putFile(File(imageUrl!.path),metadata);
        }

        downloadUrl = await imageRef.getDownloadURL();
      // Data to update
      Map<String, dynamic> dataToUpdate = {
        'firstname': firstname,
        'lastname': lastname,
        'phone': phone,
        'lastUpdated': FieldValue.serverTimestamp(), // Update with server timestamp
      };

      
      // Only add imageUrl if it's not null
      if (downloadUrl != "") {
        dataToUpdate['imageUrl'] = downloadUrl;
      }

      // Update the document
      await userDocRef.update(dataToUpdate);

      if (kDebugMode) {
        print('User document updated successfully.');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error updating user document: $e');
      }
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
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
                  //     children: [
                  //       Icon(Icons.store_rounded),
                  //       Text('Manage Store')
                  //     ],
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
        title: const Text('profile'),
        centerTitle: true,
      ),
      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     children: <Widget>[
      //       const DrawerHeader(
      //         decoration: BoxDecoration(
      //           color: Colors.blue,
      //         ),
      //         child: Text(
      //           'Drawer Header',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.home),
      //         title: const Text('Home'),
      //         onTap: () {
      //           Navigator.of(context).pushReplacementNamed('/');
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.settings),
      //         title: const Text('Settings'),
      //         onTap: () {
      //           Navigator.pop(context);
      //         },
      //       ),
      //       ListTile(
      //         leading: const Icon(Icons.store_mall_directory_rounded),
      //         title: const Text('create store'),
      //         onTap: () {
      //           Navigator.of(context)
      //               .pushReplacementNamed('/lkortbuildcreatorstore');
      //         },
      //       ),
      //     ],
      //   ),
      // ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(userId),
        builder: (BuildContext context,
            AsyncSnapshot<Map<String, dynamic>?> snapshot) {
          PhoneNumber phoneNumber = PhoneNumber(
            isoCode: 'KE',
            phoneNumber: snapshot.data?['phone'].toString(),
          );
          final phoneController = TextEditingController(
              text: phoneNumber.phoneNumber?.replaceAll('+254', ''));
          if (snapshot.connectionState == ConnectionState.waiting) {
            // While the Future is still running
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return SingleChildScrollView(
              child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: _pickedImage != null
                            ? Image.network(
                          _pickedImage!.path,
                                width: screenSize.width * .83,
                                height: screenSize.height / 2.2,
                                fit: BoxFit.contain,
                              )
                            :
                                    snapshot.data!['imageUrl'] != ""
                                ?
                                    Image.network(
                                    snapshot.data!['imageUrl'],
                                    width: screenSize.width * .83,
                                    height: screenSize.height / 2.3,
                                    fit: BoxFit.contain,
                                      loadingBuilder: (BuildContext context,Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress.expectedTotalBytes != null
                                                ? loadingProgress.cumulativeBytesLoaded /
                                                loadingProgress.expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                      errorBuilder: (BuildContext context, Object error,
                                          StackTrace? stackTrace) {
                                        // Handle the error here
                                        print('Error loading image: $error');
                                        return const Center(
                                          child: Text('Failed to load image'),
                                        );
                                      },
                                  )
                                : const Icon(
                                    Icons.person,
                                    size: 60,
                                  ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      ElevatedButton(
                        onPressed: ()  {
                          _pickImage();
                        },
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.image_rounded),
                            Text('change image'),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          initialValue: snapshot.data!['firstname'],
                          onChanged: (value) =>  _firstnameController.text= value,
                          decoration: const InputDecoration(
                            labelText: 'Firstname',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your firstname';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          initialValue: snapshot.data!['lastname'],
                          onChanged: (value) => _lastnameController.text = value,
                          decoration: const InputDecoration(
                            labelText: 'Lastname',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your lastname';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          readOnly: true,
                          initialValue: snapshot.data!['email'],
                          // onChanged: (value) => currentUserEmail = value,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: InternationalPhoneNumberInput(
                          textFieldController: phoneController,
                          initialValue: phoneNumber,
                          onInputChanged: (PhoneNumber number) {
                            phoneNumber = number;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                          selectorTextStyle: TextStyle(
                            color: isDark ? Colors.white54 : Colors.black54,
                          ), // Change hint color based on theme
                          selectorConfig: const SelectorConfig(
                            selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                          ),
                          ignoreBlank: false,
                          autoValidateMode: AutovalidateMode.disabled,
                          inputDecoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Phone Number',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width:
                              double.infinity, // Make button occupy full width
                          child: ElevatedButton(
                            onPressed: () {
                              // Validate will return true if the form is valid, or false if
                              // the form is invalid.
                              if (_formKey.currentState!.validate()) {
                                // Process data.
                                // _update(
                                //   currentUserFirstname!,
                                //   currentUserLastname!,
                                //   phoneController.text,
                                // );
                                updateUserDocument(userId, phoneController.text.isEmpty?snapshot.data!['phone']:phoneController.text,_firstnameController.text.isEmpty?snapshot.data!['firstname']:_firstnameController.text,_lastnameController.text.isEmpty?snapshot.data!['lastname']:_lastnameController.text,_pickedImage.toString().isEmpty?snapshot.data!['imageUrl']:_pickedImage);
                              }
                            },
                            child: const Text('Update'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      )
                    ],
                  )),
            );
          } else {
            return const Text('No data');
          }
        },
      ),
    );
  }
}
