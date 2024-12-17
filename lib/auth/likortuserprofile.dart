import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../models/likortusers.dart';

class LikortUserProfile extends StatefulWidget {
  const LikortUserProfile({super.key});

  @override
  State<LikortUserProfile> createState() => _LikortUserProfileState();
}

class _LikortUserProfileState extends State<LikortUserProfile> {
  User? currentUser;
  String? imageAvailable = '';
  bool _imagePicked = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    try {
      currentUser = Provider.of<User>(context, listen: false).users.last;
      print(Provider.of<User>(context, listen: false).users.length);
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
    final user = Provider.of<User>(context, listen: false);

    setState(() {
      _isLoading = true;
    });
    print(user.users.length);

    if (currentUser != null) {
      user.updateUser(
        User(
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
    final newUser = Provider.of<User>(context, listen: false);
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Consumer<User>(builder: (context, user, child) {
            var currentUserFirstname = user.users.last.firstname;
            var currentUserLastname = user.users.last.lastname;
            var currentUserEmail = user.users.last.email;
            var currentUserPhone = user.users.last.phone;
            PhoneNumber phoneNumber = PhoneNumber(
              isoCode: 'KE',
              phoneNumber: user.users.last.phone,
            );
            final phoneController = TextEditingController(
                text: currentUserPhone.replaceAll('+254', ''));

            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: imageAvailable!.isNotEmpty
                      ? Image.network(
                          imageAvailable!,
                          width: screenSize.width * .83,
                          height: screenSize.height / 2.2,
                          fit: BoxFit.contain,
                        )
                      : currentUser!.imageUrl.isNotEmpty
                          ? Image.network(
                              currentUser!.imageUrl,
                              width: screenSize.width * .83,
                              height: screenSize.height / 2.3,
                              fit: BoxFit.contain,
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
                  onPressed: () async {
                    final pickedImage = await ImagePicker().pickImage(
                        source: ImageSource.gallery,
                        preferredCameraDevice: CameraDevice.front);
                    if (pickedImage != null) {
                      setState(() {
                        print(pickedImage.name);
                        print(pickedImage.path);
                        imageAvailable = pickedImage.path;
                        print(imageAvailable);
                      });
                      for (final user in currentUser!.users) {
                        print('image ${user.imageUrl}');
                      }
                    } else {
                      // Handle the case where the user canceled image selection
                      // (e.g., show a message or revert to a default image)
                    }
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
                    initialValue: currentUserFirstname,
                    onChanged: (value) => currentUserFirstname = value,
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
                    initialValue: currentUserLastname,
                    onChanged: (value) => currentUserLastname = value,
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
                    initialValue: currentUserEmail,
                    onChanged: (value) => currentUserEmail = value,
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
                    width: double.infinity, // Make button occupy full width
                    child: ElevatedButton(
                      onPressed: () {
                        // Validate will return true if the form is valid, or false if
                        // the form is invalid.
                        ;
                        if (_formKey.currentState!.validate()) {
                          // Process data.
                          _update(
                            currentUserFirstname,
                            currentUserLastname,
                            phoneController.text,
                          );
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
            );
          }),
        ),
      ),
    );
  }
}
