import 'package:flutter/material.dart';

class LikortUserProfile extends StatefulWidget {
  const LikortUserProfile({super.key});

  @override
  State<LikortUserProfile> createState() => _LikortUserProfileState();
}

class _LikortUserProfileState extends State<LikortUserProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('profile'),
      ),
      body: Form(
          child: Column(
        children: [
          const Text('Profile'),
          TextFormField(),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Update'),
          ),
        ],
      )),
    );
  }
}
