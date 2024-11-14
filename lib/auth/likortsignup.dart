import 'package:flutter/material.dart';

import '../models/likortusers.dart';
import '../widgets/phonenumberinput.dart';

class LikortSignup extends StatefulWidget {
  const LikortSignup({super.key});

  @override
  State<LikortSignup> createState() => _LikortSignupState();
}

class _LikortSignupState extends State<LikortSignup> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phoneNumber = '';

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
