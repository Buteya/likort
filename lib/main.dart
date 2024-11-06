
import 'package:flutter/material.dart';
import 'package:likort/auth/likortcreateartproduct.dart';
import 'package:likort/auth/likortcreatorprofilestore.dart';
import 'package:likort/auth/likortbuildcreatorstore.dart';
import 'package:likort/auth/likortlogin.dart';
import 'package:likort/auth/likortsignup.dart';
import 'package:likort/auth/likortuserprofile.dart';
import 'package:likort/screens/likortcartscreen.dart';
import 'package:likort/screens/likortcheckoutscreen.dart';
import 'package:likort/screens/likortcompletedorder.dart';
import 'package:likort/screens/likorthomescreen.dart';
import 'package:likort/screens/likortpaycash.dart';
import 'package:likort/screens/likortproductdetailscreen.dart';
import 'package:likort/screens/likorttrackorder.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Likort',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      initialRoute: '/likortlogin',
      routes:  {
        '/': (context) => const LikortHomeScreen(title: 'Likort'),
        '/likortproductdetail': (context) => const LikortProductDetailScreen(),
        '/likortcart': (context) => const LikortCartScreen(),
        '/likortcheckout': (context) => const LikortCheckoutScreen(),
        '/likorttrackorder': (context) => const LikortTrackOrder(),
        '/likortpaycash' : (context) => const LikortPayCash(),
        '/likortcompletedorder' : (context) => const LikortCompletedOrder(),
        '/likortsignup' : (context) => const LikortSignup(),
        '/likortlogin' : (context) => const LikortLogin(),
        '/likortuserprofile' : (context) => const LikortUserProfile(),
        '/lkortbuildcreatorstore' : (context) => const LikortBuildCreatorStore(),
        '/likortcreatorprofilestore' : (context) => const LikortCreatorProfileStore(),
        '/likortcreateartproduct' : (context) => const LikortCreateArtProduct(),
      },
    );
  }
}

