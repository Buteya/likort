import 'package:flutter/material.dart';

class LikortLogin extends StatefulWidget {
  const LikortLogin({super.key});

  @override
  State<LikortLogin> createState() => _LikortLoginState();
}

class _LikortLoginState extends State<LikortLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
          child: Column(
        children: [
          const Text('Likort Login'),
          TextFormField(),
          TextFormField(),
          ElevatedButton(onPressed: (){
            Navigator.of(context).pushReplacementNamed('/');
          }, child: const Text('login'),),
          TextButton(onPressed: (){
            Navigator.of(context).pushReplacementNamed('/likortsignup');
          }, child: const Text('cant login? signup!!!'),),
        ],
      )),
    );
  }
}
