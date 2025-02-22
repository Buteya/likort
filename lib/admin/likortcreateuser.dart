import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../models/likortusers.dart' as userLikort;

class LikortCreateUser extends StatefulWidget {
  const LikortCreateUser({super.key});

  @override
  State<LikortCreateUser> createState() => _LikortCreateUserState();
}

class _LikortCreateUserState extends State<LikortCreateUser> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'KE');
  bool _isLoading = false;
  var uuid = const Uuid();

  Future<void> _submitForm() async {
    //setting is loading is true while the function completes
    setState(() {
      _isLoading = true;
    });

    //function submit variables
    userLikort.User? users;
    users = Provider.of<userLikort.User>(context, listen: false);
    final encodedPassword =
        base64.encode(utf8.encode(_passwordController.text));

    final id = uuid.v4();

    //validating input then saving and finally if the user exists
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (users.users.isNotEmpty &&
          (users.users.last.email != _emailController.text)) {
        try {
          users.add(userLikort.User(
            id: id,
            firstname: _firstnameController.text,
            lastname: _lastnameController.text,
            email: _emailController.text,
            password: encodedPassword,
            phone: _phoneNumber.phoneNumber.toString(),
            latitude: 0,
            longitude: 0,
            imageUrl: '',
            storeId: '',
            reviews: [],
            favorites: [],
            notifications: [],
            created: DateTime.now(),
          ));
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$e'),
            ),
          );
          print('Error: $e');
        }
        //once added navigating user to login
        Navigator.of(context).pushNamed('/likortviewallusers');
      } else if (users.users.isEmpty) {
        try {
          users.add(userLikort.User(
            id: id,
            firstname: _firstnameController.text,
            lastname: _lastnameController.text,
            email: _emailController.text,
            password: encodedPassword,
            phone: _phoneNumber.phoneNumber.toString(),
            latitude: 0,
            longitude: 0,
            imageUrl: '',
            storeId: '',
            reviews: [],
            favorites: [],
            notifications: [],
            created: DateTime.now(),
          ));
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(
              content: Text('user $id created'),
              duration: const Duration(seconds: 1), // Set duration to 1 second
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('$e'),
            ),
          );
          print('Error: $e');
        }

        //once added navigating user to login
        Navigator.of(context).pushNamed('/likortviewallusers');
      } else {
        //messages shown if user already exists
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Show the first SnackBar
        scaffoldMessenger
            .showSnackBar(
              SnackBar(
                content: Text('user $id already exists'),
                duration: const Duration(seconds: 2),
              ),
            )
            .closed
            .then((_) {
          // Show the second SnackBar after the first one is closed
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('change email!!!'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }

      //printing all users currently in state
      print(users.users.length);
      for (final user in users.users) {
        print("id: ${user.id}");
        print("firstname: ${user.firstname}");
        print("lastname: ${user.lastname}");
        print("email: ${user.email}");
        print("password: ${user.password}");
        print("phone: ${user.phone}");
        print("usertype: ${user.usertype}");
        print("latitude: ${user.latitude}");
        print("longitude: ${user.longitude}");
      }

      //clearing the submit form
      _clearForm();
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _firstnameController.clear();
    _lastnameController.clear();
    _emailController.clear();
    _passwordController.clear();
    _phoneController.clear();
    _phoneNumber = PhoneNumber();
    // setState(() {
    //   _selectedMarker = null;
    // });
  }

  //disposing off the text editing controllers
  @override
  void dispose() {
    // Dispose of the controllers when the widget is disposed.
    _firstnameController.dispose();
    _lastnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : FirebaseAuth.instance.currentUser == null
        ? Scaffold(
      body: TextButton(
          onPressed: () => Navigator.of(context)
              .pushReplacementNamed('/likortlogin'),
          child: const Text('Login')),
    )
        : Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        controller: _firstnameController,
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
                        controller: _lastnameController,
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
                        controller: _emailController,
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
                      child: TextFormField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 6) {
                              return 'Password must be at least 6 characters long';
                            }
                            return null;
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: InternationalPhoneNumberInput(
                        textFieldController: _phoneController,
                        onInputChanged: (PhoneNumber number) {
                          _phoneNumber = number;
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
                        initialValue: _phoneNumber,
                        inputDecoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Phone Number',
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: ElevatedButton(
                        onPressed: () {   // Process data
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Processing Data'),
                              duration: Duration(seconds: 1), // Set duration to 1 second
                            ),
                          );
                          if (_formKey.currentState!.validate()) {

                            _submitForm();
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
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
                  const Text('user'),
                  const Divider(
                    color: Colors.grey, // Set the color of the line
                    thickness: 1.0, // Set the thickness of the line
                    height:
                        10.0, // Set the height of the line (including spacing)
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
                  const Text('store'),
                  const Divider(
                    color: Colors.grey, // Set the color of the line
                    thickness: 1.0, // Set the thickness of the line
                    height:
                        10.0, // Set the height of the line (including spacing)
                    indent: 20.0, // Set the indent from the leading edge
                    endIndent: 20.0, // Set the indent from the trailing edge
                  ),
                  ListTile(
                    leading: const Icon(Icons.store_outlined),
                    title: const Text('create store'),
                    onTap: () {
                      // Update the state of the app
                      Navigator.of(context)
                          .pushReplacementNamed('/likortcreateproduct')
                          .then((_) {
                        // Then close the drawer
                        Navigator.pop(context);
                      });
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
                  const Text('order'),
                  const Divider(
                    color: Colors.grey, // Set the color of the line
                    thickness: 1.0, // Set the thickness of the line
                    height:
                        10.0, // Set the height of the line (including spacing)
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
                  const Text('payments'),
                  const Divider(
                    color: Colors.grey, // Set the color of the line
                    thickness: 1.0, // Set the thickness of the line
                    height:
                        10.0, // Set the height of the line (including spacing)
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
                  const Text('role'),
                  const Divider(
                    color: Colors.grey, // Set the color of the line
                    thickness: 1.0, // Set the thickness of the line
                    height:
                        10.0, // Set the height of the line (including spacing)
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
                  const Text('permission'),
                  const Divider(
                    color: Colors.grey, // Set the color of the line
                    thickness: 1.0, // Set the thickness of the line
                    height:
                        10.0, // Set the height of the line (including spacing)
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
