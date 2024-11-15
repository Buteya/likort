import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/likortusers.dart';
import '../widgets/phonenumberinput.dart';

class LikortSignup extends StatefulWidget {
  const LikortSignup({super.key});

  @override
  State<LikortSignup> createState() => _LikortSignupState();
}

class _LikortSignupState extends State<LikortSignup> {
  //signup variables
  final _formKey = GlobalKey<FormState>();
  final String _name = '';
  String _phoneNumber = '';
  Position? _currentPosition;
  GoogleMapController? _mapController;
  Marker? _selectedMarker;

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

  void _onPhoneNumberChanged(String phoneNumber) {
    setState(() {
      _phoneNumber = phoneNumber;
    });
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      User user = User(
        id: '',
        firstname: '',
        lastname: '',
        email: '',
        password: '',
        phone: '',
        latitude: 0,
        longitude: 0,
      );
      print(user);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'Signup',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Firstname',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Lastname',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: TextFormField(
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
                      child: PhoneNumberInput(
                          onPhoneNumberChanged: _onPhoneNumberChanged),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _getUserLocation,
                        child: const Text('Location'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: SizedBox(
                        height: _selectedMarker == null ? 0 : MediaQuery.of(context).size.height * .4,
                        child: Expanded(
                          child: _currentPosition != null
                              ? GoogleMap(
                                  onMapCreated: (controller) {
                                    _mapController = controller;
                                  },
                                  initialCameraPosition: CameraPosition(
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
                                        markerId:
                                            const MarkerId('selected_location'),
                                        position: latLng,
                                      );
                                    });
                                  },
                                )
                              : const Center(
                                  child: Text('No location selected'),
                                ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: _selectedMarker != null
                            ? () {
                                // Send selected location for delivery
                                print(
                                    'Selected location: ${_selectedMarker!.position}');
                              }
                            : null,
                        child: const Icon(Icons.check),
                      ),
                    ),
                    Text(_selectedMarker?.position.latitude as String),
                    Text(_selectedMarker?.position.longitude as String),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {},
                        child: const Text('Signup'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 48.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacementNamed('/likortlogin');
                        },
                        child:
                            const Text('are you already signed up? login!!!'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
