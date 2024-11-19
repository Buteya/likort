import 'package:flutter/material.dart';

class LikortSplashScreen extends StatefulWidget {
  const LikortSplashScreen({super.key});

  @override
  State<LikortSplashScreen> createState() => _LikortSplashScreenState();
}

class _LikortSplashScreenState extends State<LikortSplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacementNamed(context, '/likortlogin');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen content here
            Text(
              'Likort',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width*.14,
                child: LinearProgressIndicator(),
              ),
            ), // Optional loading indicator
          ],
        ),
      ),
    );
  }
}
