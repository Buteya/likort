import 'package:flutter/material.dart';

class LikortSignup extends StatefulWidget {
  const LikortSignup({super.key});

  @override
  State<LikortSignup> createState() => _LikortSignupState();
}

class _LikortSignupState extends State<LikortSignup> {
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
