import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/likortusers.dart' as userLikort;

class LikortLogin extends StatefulWidget {
  const LikortLogin({super.key});

  @override
  State<LikortLogin> createState() => _LikortLoginState();
}

class _LikortLoginState extends State<LikortLogin> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late bool _isLoading = false;

  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    setState(() {
      _isLoading =true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if(email == userCredential.user!.email){
        //messages shown if user already exists
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Show the first SnackBar
        scaffoldMessenger
            .showSnackBar(
          const SnackBar(
            content: Text('Login successful.'),
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
        Navigator.pushNamed(context, '/likorthomescreen');
      }
      setState(() {
        _isLoading = false;
      });
      return userCredential;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        //messages shown if user already exists
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Show the first SnackBar
        scaffoldMessenger
            .showSnackBar(
          const SnackBar(
            content: Text('No user found for that email.'),
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
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        //messages shown if user already exists
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Show the first SnackBar
        scaffoldMessenger
            .showSnackBar(
          const SnackBar(
            content: Text('Wrong password provided for that user.'),
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
        print('Wrong password provided for that user.');
      }
      setState(() {
        _isLoading = false;
      });
      return null; // or handle the error appropriately
    }
  }

  Future<void> _login(String email, String password) async {
    userLikort.User? users = Provider.of<userLikort.User>(context, listen: false);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? encodedPassword;
    String? prefEmail;
    String? decodedPassword;
    var currentUser = users.users.firstWhere((user)=>user.id == prefs.getString('id'));
    try {
      prefEmail = prefs.getString('email');
      encodedPassword = prefs.getString('password');
      decodedPassword =
          decodedPassword = utf8.decode(base64.decode(encodedPassword!));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
      print('Error: $e');
    }

    try {
      if ((prefEmail == email &&
              users.users.any((user) => user.email == email)) &&
          decodedPassword == password) {
        users.updateUser(
          userLikort.User(
            id: currentUser.id,
            firstname: currentUser.firstname,
            lastname: currentUser.lastname,
            email: email,
            password: password,
            phone: currentUser.phone,
            latitude: currentUser.latitude,
            longitude: currentUser.longitude,
            imageUrl: currentUser.imageUrl,
            storeId: currentUser.storeId,
            reviews: currentUser.reviews,
            favorites: currentUser.favorites,
            notifications: currentUser.notifications,
            created: currentUser.created,
            isOnline: currentUser.isOnline = true,
          ),
        );
        Navigator.pushNamed(context, '/likorthomescreen');
      } else {
        //messages shown if user already exists
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        // Show the first SnackBar
        scaffoldMessenger
            .showSnackBar(
              const SnackBar(
                content: Text('Login Error'),
                duration: Duration(seconds: 2),
              ),
            )
            .closed
            .then((_) {
          // Show the second SnackBar after the first one is closed
          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('user does not exist!!!'),
              duration: Duration(seconds: 2),
            ),
          );
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$e'),
        ),
      );
      print('Error: $e');
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading?const Center(child: CircularProgressIndicator(),):Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                'Login',
                style: Theme.of(context).textTheme.displayLarge,
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
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
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
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                      signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                    _emailController.clear();
                    _passwordController.clear();
                  }
                },
                child: const Text('login'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushReplacementNamed('/likortforgotpassword');
                },
                child: const Text('Forgot password?'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/likortsignup');
                },
                child: const Text('Can\'t login? Signup'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
