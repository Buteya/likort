import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/likortusers.dart' as userLikort;

class LikortSignup extends StatefulWidget {
  const LikortSignup({super.key});

  @override
  State<LikortSignup> createState() => _LikortSignupState();
}

class _LikortSignupState extends State<LikortSignup> {
  //signup variables
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  Position? _currentPosition;
  GoogleMapController? _mapController;
  Marker? _selectedMarker;
  var uuid = const Uuid();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'KE');
  bool _isLoading = false;
  bool _showHint = true;
  bool _selected = true;

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

  //function to determine the user position
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    } // Permissions are granted, get the position.
    return await Geolocator.getCurrentPosition();
  }

  //function to get user location
  Future<void> _getUserLocation() async {
    Position position = await _determinePosition();
    setState(() {
      _currentPosition = position;
      _selectedMarker = Marker(
        markerId: const MarkerId('current_location'),
        position: LatLng(position.latitude, position.longitude),
      );
    });
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude),
      ),
    );
  }

  Future<UserCredential?> signUpWithEmailAndPassword(
      String email, String password) async {
    setState(() {
      _isLoading =true;
    });
    try {
      // 1. Create the user with email and password
      UserCredential userCredential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // 2. Check if the user is created
      if (userCredential.user == null) {
        if (kDebugMode) {
          print('User creation failed.');
        }
        return null;
      }
      // 3. Get the user ID
      String userId = userCredential.user!.uid;
      print(userId);
      // 4. Create the user data map
      Map<String, dynamic> userData = {
        'id': userId,
        'firstname': _firstnameController.text,
        'lastname': _lastnameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'phone': _phoneNumber.phoneNumber.toString(), // Use .text instead of .phoneNumber.toString()
        'latitude': _selectedMarker!.position.latitude, // Handle null case
        'longitude': _selectedMarker!.position.longitude, // Handle null case
        'imageUrl': '',
        'storeId': '',
        'reviews': [],
        'favorites': [],
        'notifications': [],
        'created': FieldValue.serverTimestamp(), // Use server timestamp
      };
     for(final user in userData.values){
       print(user);
     }
      // 5. Save the user data to Firestore
      CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');
      await usersCollection.doc(userId).set(userData).then((_) {
        if (kDebugMode) {
          //messages shown if user already exists
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          // Show the first SnackBar
          scaffoldMessenger
              .showSnackBar(
            const SnackBar(
              content: Text('sign up successful'),
              duration: Duration(seconds: 2),
            ),
          )
              .closed
              .then((_) {
            // Show the second SnackBar after the first one is closed
            // scaffoldMessenger.showSnackBar(
            //   const SnackBar(
            //     content: Text('Login instead!!!'),
            //     duration: Duration(seconds: 2),
            //   ),
            // );
          });
          if (context.mounted) {
            Navigator.of(context).pushNamed('/likortlogin');
          }
          print('User data saved successfully!');
          _clearForm();
          setState(() {
            _isLoading = false;
          });
        }
      }).catchError((error) {
        if (kDebugMode) {
          //messages shown if user already exists
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          // Show the first SnackBar
          scaffoldMessenger
              .showSnackBar(
            SnackBar(
              content: Text('Error signing up $error'),
              duration: const Duration(seconds: 2),
            ),
          )
              .closed
              .then((_) {
            // Show the second SnackBar after the first one is closed
            // scaffoldMessenger.showSnackBar(
            //   const SnackBar(
            //     content: Text('Login instead!!!'),
            //     duration: Duration(seconds: 2),
            //   ),
            // );
          });
          print('Error saving user data: $error');
          setState(() {
            _isLoading = false;
          });
        }
        setState(() {
          _isLoading = false;
        });
        throw Exception('Failed to save user data: $error');
      });
      // 6. Return the user credential

      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          setState(() {
            _isLoading = false;
          });
          //messages shown if user already exists
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          // Show the first SnackBar
          scaffoldMessenger
              .showSnackBar(
            const SnackBar(
              content: Text('The password provided is too weak.'),
              duration: Duration(seconds: 2),
            ),
          )
              .closed
              .then((_) {
            // Show the second SnackBar after the first one is closed
            // scaffoldMessenger.showSnackBar(
            //   const SnackBar(
            //     content: Text('Login instead!!!'),
            //     duration: Duration(seconds: 2),
            //   ),
            // );
          });
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          setState(() {
            _isLoading = false;
          });
          //messages shown if user already exists
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          // Show the first SnackBar
          scaffoldMessenger
              .showSnackBar(
            const SnackBar(
              content: Text('The account already exists for that email'),
              duration: Duration(seconds: 2),
            ),
          )
              .closed
              .then((_) {
            // Show the second SnackBar after the first one is closed
            // scaffoldMessenger.showSnackBar(
            //   const SnackBar(
            //     content: Text('Login instead!!!'),
            //     duration: Duration(seconds: 2),
            //   ),
            // );
          });
          print('The account already exists for that email.');
        }
      } else {
        if (kDebugMode) {
          setState(() {
            _isLoading = false;
          });
          //messages shown if user already exists
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          // Show the first SnackBar
          scaffoldMessenger
              .showSnackBar(
            SnackBar(
              content: Text('Error  $e'),
              duration: const Duration(seconds: 2),
            ),
          )
              .closed
              .then((_) {
            // Show the second SnackBar after the first one is closed
            // scaffoldMessenger.showSnackBar(
            //   const SnackBar(
            //     content: Text('Login instead!!!'),
            //     duration: Duration(seconds: 2),
            //   ),
            // );
          });
          print('FirebaseAuthException: $e');
        }
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        setState(() {
          _isLoading = false;
        });
        //messages shown if user already exists
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Show the first SnackBar
        scaffoldMessenger
            .showSnackBar(
          SnackBar(
            content: Text('Unexpected Error $e'),
            duration: const Duration(seconds: 2),
          ),
        )
            .closed
            .then((_) {
          // Show the second SnackBar after the first one is closed
          // scaffoldMessenger.showSnackBar(
          //   const SnackBar(
          //     content: Text('Login instead!!!'),
          //     duration: Duration(seconds: 2),
          //   ),
          // );
        });

        print('Unexpected Error: $e');
      }
      setState(() {
        _isLoading = false;
      });
      return null;
    }

  }

  //function to submit signup form
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final id = uuid.v4();

    //storing user in shared preferences
    try {
      do {
        await prefs.setString('id', id);
        await prefs.setString('firstname', _firstnameController.text);
        await prefs.setString('lastname', _lastnameController.text);
        await prefs.setString('email', _emailController.text);
        await prefs.setString('password', encodedPassword);
        await prefs.setString('phone', '$_phoneNumber');
        await prefs.setString('usertype', users.usertype);
        await prefs.setString(
            'latitude', '${_selectedMarker!.position.latitude}');
        await prefs.setString(
            'longitude', '${_selectedMarker!.position.longitude}');
        await prefs.setString(
            'current location time', '${_currentPosition!.timestamp}');
        await prefs.setString(
            'current location latitude', '${_currentPosition!.latitude}');
        await prefs.setString(
            'current location longitude', '${_currentPosition!.longitude}');
      } while (prefs.getString('id')!.isEmpty);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
      print('Error: $e');
    }

    //validating input then saving and finally if the user exists
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      if (users.users.isNotEmpty &&
          (users.users.last.email != _emailController.text &&
              users.users.last.password != _passwordController.text)) {
        if (_selectedMarker != null) {
          try {
            users.add(userLikort.User(
              id: id,
              firstname: _firstnameController.text,
              lastname: _lastnameController.text,
              email: _emailController.text,
              password: encodedPassword,
              phone: _phoneNumber.phoneNumber.toString(),
              latitude: _selectedMarker!.position.latitude,
              longitude: _selectedMarker!.position.longitude,
              imageUrl: '',
              storeId: '',
              reviews: [],
              favorites: [],
              notifications: [],
              created: DateTime.now(),
            ));
          } catch (e) {
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$e'),
                ),
              );
            }

            print('Error: $e');
          }
          setState(() {
            _selected = true;
          });
          //once added navigating user to login
          if (context.mounted) {
            Navigator.of(context).pushNamed('/likortlogin');
          }
        } else {
          setState(() {
            _selected = false;
          });
        }
      } else if (users.users.isEmpty) {
        if (_selectedMarker != null) {
          try {
            users.add(userLikort.User(
              id: id,
              firstname: _firstnameController.text,
              lastname: _lastnameController.text,
              email: _emailController.text,
              password: encodedPassword,
              phone: _phoneNumber.phoneNumber.toString(),
              latitude: _selectedMarker!.position.latitude,
              longitude: _selectedMarker!.position.longitude,
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

          setState(() {
            _selected = true;
          });
          //once added navigating user to login
          Navigator.of(context).pushNamed('/likortlogin');
        } else {
          setState(() {
            _selected = false;
          });
        }
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
              content: Text('Login instead!!!'),
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
      // _clearForm();
      setState(() {
        _isLoading = false;
      });

      //printing the current user in shared preferences
      print('SharedPreferences id:${prefs.getString('id')}');
      print('SharedPreferences firstname:${prefs.getString('firstname')}');
      print('SharedPreferences lastname:${prefs.getString('lastname')}');
      print('SharedPreferences email:${prefs.getString('email')}');
      print('SharedPreferences phone:${prefs.getString('phone')}');
      print('SharedPreferences usertype:${prefs.getString('usertype')}');
      print('SharedPreferences latitude:${prefs.getString('latitude')}');
      print('SharedPreferences longitude:${prefs.getString('longitude')}');
      print('SharedPreferences password:${prefs.getString('password')}');
      print(
          'SharedPreferences current location time:${prefs.getString('current location time')}');
      print(
          'SharedPreferences current location latitude:${prefs.getString('current location latitude')}');
      print(
          'SharedPreferences current location longitude:${prefs.getString('current location longitude')}');
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
    setState(() {
      _selectedMarker = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return _isLoading
        ? const Scaffold(body: Center(
            child: CircularProgressIndicator(),
          ))
        : Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 32.0),
                              child: Text(
                                'Signup',
                                style: Theme.of(context).textTheme.displayLarge,
                              ),
                            ),
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
                                  color:
                                      isDark ? Colors.white54 : Colors.black54,
                                ), // Change hint color based on theme
                                selectorConfig: const SelectorConfig(
                                  selectorType:
                                      PhoneInputSelectorType.BOTTOM_SHEET,
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
                              padding: const EdgeInsets.all(16.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  _getUserLocation();
                                  // Set a timer to hide the hint text after a few seconds
                                  Timer(const Duration(seconds: 15), () {
                                    setState(() {
                                      _showHint = false;
                                    });
                                  });
                                },
                                child: const Text('Get Current Location'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: SizedBox(
                                height: _selectedMarker == null
                                    ? 0
                                    : _showHint
                                        ? MediaQuery.sizeOf(context).height *
                                            .61
                                        : MediaQuery.sizeOf(context).height *
                                            .44,
                                child: _currentPosition != null
                                    ? Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (_showHint)
                                            Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              color: Colors.black12,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  'The marker on the map show\'s the current location.',
                                                  style: TextStyle(
                                                    color: MediaQuery
                                                                .platformBrightnessOf(
                                                                    context) ==
                                                            Brightness.dark
                                                        ? Colors.white60
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (_showHint)
                                            Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              color: Colors.black12,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  'If the current location is your delivery location.',
                                                  style: TextStyle(
                                                    color: MediaQuery
                                                                .platformBrightnessOf(
                                                                    context) ==
                                                            Brightness.dark
                                                        ? Colors.white60
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          if (_showHint)
                                            Card(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4.0),
                                              color: Colors.black12,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  'Press the button below to set it as your delivery location.',
                                                  style: TextStyle(
                                                    color: MediaQuery
                                                                .platformBrightnessOf(
                                                                    context) ==
                                                            Brightness.dark
                                                        ? Colors.white60
                                                        : Colors.black,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.01,
                                          ),
                                          SizedBox(
                                            height: MediaQuery.sizeOf(context)
                                                    .height *
                                                0.4,
                                            child: GoogleMap(
                                              onMapCreated: (controller) {
                                                _mapController = controller;
                                              },
                                              initialCameraPosition:
                                                  CameraPosition(
                                                target: LatLng(
                                                  _currentPosition!.latitude,
                                                  _currentPosition!.longitude,
                                                ),
                                                zoom: 14,
                                              ),
                                              markers: _selectedMarker != null
                                                  ? {_selectedMarker!}
                                                  : {},
                                              onTap: (latLng) {
                                                setState(() {
                                                  _selectedMarker = Marker(
                                                    markerId: const MarkerId(
                                                        'selected_location'),
                                                    position: latLng,
                                                  );
                                                });
                                              },
                                            ),
                                          ),
                                        ],
                                      )
                                    : const Center(
                                        child: Text('No location selected'),
                                      ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: _selectedMarker != null
                                  ? () {
                                      setState(() {
                                        _selected = true;
                                      });
                                      // Send selected location for delivery
                                      print(
                                          'Selected location: ${_selectedMarker!.position}');
                                      final scaffoldMessenger =
                                          ScaffoldMessenger.of(context);
                                      // Show the first SnackBar
                                      scaffoldMessenger.showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'delivery location has been set!!!'),
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  : null,
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text('Set Delivery Location'),
                                  Icon(Icons.check),
                                ],
                              ),
                            ),

                            _selected == false
                                ? Text(
                                    'Delivery location not selected',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.red.shade100,
                                    ),
                                  )
                                : const Text(''),
                            // Text(_selectedMarker != null
                            //     ? _selectedMarker!.position.latitude.toString()
                            //     : ''),
                            // Text(_selectedMarker != null
                            //     ? _selectedMarker!.position.longitude.toString()
                            //     : ''),
                            Padding(
                              padding: const EdgeInsets.all(32.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    // _submitForm();
                                    signUpWithEmailAndPassword(_emailController.text, _passwordController.text);

                                    setState(() {
                                      _selected = true;
                                    });
                                  } else {
                                    setState(() {
                                      _selected = false;
                                    });
                                  }
                                },
                                child: const Text('Signup'),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed('/likortlogin');
                                },
                                child: const Text(
                                    'Already signed up? Login'),
                              ),
                            ),
                            const SizedBox(
                              height: 130,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
  }
}
