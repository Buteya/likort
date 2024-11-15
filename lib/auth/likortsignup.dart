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
  final _formKey = GlobalKey<FormState>();
  final String _name = '';
  String _phoneNumber = '';
  Position? _currentPosition;
  GoogleMapController? _mapController;
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
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
    }
    return await Geolocator.getCurrentPosition();
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
      appBar: AppBar(
        title: const Text('Likort Signup'),
      ),
      body: Form(
          child: Column(
        children: [
          const Text('Signup'),
          ElevatedButton(
            onPressed: () async {
              Position position = await _determinePosition();
              setState(() {
                _currentPosition = position;
              });
              _mapController?.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(position.latitude, position.longitude),
                ),
              );
            },
            child: const Text('Get Current Location'),
          ),
          Expanded(
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
                    markers: {
                      Marker(
                        markerId: const MarkerId('current_location'),
                        position: LatLng(
                          _currentPosition!.latitude,
                          _currentPosition!.longitude,
                        ),
                      ),
                    },
                  )
                : const Center(
                    child: Text('No location selected'),
                  ),
          ),
          TextFormField(),
          TextFormField(),
          TextFormField(),
          PhoneNumberInput(onPhoneNumberChanged: _onPhoneNumberChanged),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Signup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/likortlogin');
            },
            child: const Text('already signed up? login!!!'),
          ),
        ],
      )),
    );
  }
}
