import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LikortSplashScreen extends StatefulWidget {
  const LikortSplashScreen({super.key});

  @override
  State<LikortSplashScreen> createState() => _LikortSplashScreenState();
}

class _LikortSplashScreenState extends State<LikortSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _shakeAnimation;
  late Animation<double> _sizeAnimation;
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
    );
    _sizeAnimation = Tween<double>(begin: 1.0, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });
    _startAnimation();
    super.initState();
  }

  _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 4), () {});
    Navigator.pushReplacementNamed(context, '/likortlogin');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Add your splash screen content here
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_shakeAnimation.value, 0),
                  child: Transform.scale(
                    scale: _sizeAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Transform.rotate(
                angle: -6 * 3.1415926535897932 / 180,
                child: Transform.scale(
                  scaleX: 1.36,
                  scaleY: 1.0,
                  child: Text(
                    'Likort',
                    style: GoogleFonts.dancingScript(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .14,
                child: const LinearProgressIndicator(),
              ),
            ), // Optional loading indicator
          ],
        ),
      ),
    );
  }
}
