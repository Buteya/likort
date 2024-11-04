
import 'package:flutter/material.dart';
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
      title: 'Likort',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
      },
    );
  }
}

