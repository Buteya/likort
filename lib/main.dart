import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:likort/admin/likortadminhome.dart';
import 'package:likort/admin/likortcreateproduct.dart';
import 'package:likort/admin/likortcreateuser.dart';
import 'package:likort/admin/likortviewallusers.dart';
import 'package:likort/auth/likortcreateartproduct.dart';
import 'package:likort/auth/likortcreatorprofilestore.dart';
import 'package:likort/auth/likortbuildcreatorstore.dart';
import 'package:likort/auth/likortlogin.dart';
import 'package:likort/auth/likortsignup.dart';
import 'package:likort/auth/likortuserprofile.dart';
import 'package:likort/models/likortartproduct.dart';
import 'package:likort/models/likortcartitem.dart';
import 'package:likort/models/likortfavorites.dart';
import 'package:likort/models/likortnotifications.dart';
import 'package:likort/models/likortorders.dart';
import 'package:likort/models/likortpayment.dart';
import 'package:likort/models/likortreview.dart';
import 'package:likort/models/likortstore.dart';
import 'package:likort/models/likortusers.dart';
import 'package:likort/screens/likortcartscreen.dart';
import 'package:likort/screens/likortcheckoutscreen.dart';
import 'package:likort/screens/likortcompletedorder.dart';
import 'package:likort/screens/likortcontactsupportscreen.dart';
import 'package:likort/screens/likortfavoritesscreen.dart';
import 'package:likort/screens/likortforgotpasswordscreen.dart';
import 'package:likort/screens/likorthomescreen.dart';
import 'package:likort/screens/likortmanagestorescreen.dart';
import 'package:likort/screens/likortpaycash.dart';
import 'package:likort/screens/likortpaymentfailurescreen.dart';
import 'package:likort/screens/likortpaymentsuccessscreen.dart';
import 'package:likort/screens/likortproductdetailscreen.dart';
import 'package:likort/screens/likortsplashscreen.dart';
import 'package:likort/screens/likorttrackorder.dart';
import 'package:likort/screens/likortusersettings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => User(
              id: '',
              firstname: '',
              lastname: '',
              email: '',
              password: '',
              phone: '',
              latitude: 0,
              longitude: 0,
              imageUrl: '',
              storeId: '',
              reviews: [],
              favorites: [],
              notifications: [],
              created: DateTime.now(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => Store(
              id: '',
              name: '',
              description: '',
              products: [],
              userId: '',
              created: DateTime.now(),
              imageUrl: [],
              reviews: [],
              notifications: [],
              orders: [],
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => Order(
              orderId: '',
              items: [],
              orderDate: DateTime(DateTime.now().year),
              userId: '',
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => CartItem(
              id: '',
              userId: '',
              product: Product(
                id: '',
                name: '',
                description: '',
                price: 0,
                imageUrls: [],
                storeId: '',
                typeOfArt: '',
              ),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => Product(
              id: '',
              name: '',
              description: '',
              price: 0,
              imageUrls: [],
              storeId: '',
              typeOfArt: '',
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => Review(
                reviewId: '',
                productId: '',
                createdAt: DateTime.now(),
                review: '',
                userId: ''),
          ),
          ChangeNotifierProvider(
            create: (context) => Payment(
              paymentId: '',
              orderId: '',
              amount: 0,
              status: '',
              createdAt: DateTime.now(),
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => LikortNotification(
              notificationId: '',
              createdAt: DateTime.now(),
              users: [],
              stores: [],
            ),
          ),
          ChangeNotifierProvider(
            create: (context) => Favorites(
              id: '',
              userId: '',
              favoriteProducts: [],
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;
  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeMode = prefs.getString('theme_mode') ?? 'system';
    setState(() {
      _themeMode = _getThemeModeFromString(themeMode);
    });
  }

  ThemeMode _getThemeModeFromString(String themeMode) {
    switch (themeMode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  void _saveThemeMode(String themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('theme_mode', themeMode);
  }

  void _toggleThemeMode() {
    setState(() {
      switch (_themeMode) {
        case ThemeMode.light:
          _themeMode = ThemeMode.dark;
          _saveThemeMode('dark');
          break;
        case ThemeMode.dark:
          _themeMode = ThemeMode.system;
          _saveThemeMode('system');
          break;
        case ThemeMode.system:
        _themeMode = ThemeMode.light;
          _saveThemeMode('light');
          break;
      }
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false,
      title: 'Likort',
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.amber,
        scaffoldBackgroundColor: Colors.grey[100],
        textTheme: TextTheme(
          displayLarge: GoogleFonts.lobster(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
          headlineLarge: GoogleFonts.lobster(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: GoogleFonts.openSans(
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: GoogleFonts.openSans(
            fontSize: 16,
          ),
          bodySmall: GoogleFonts.openSans(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Colors.blue,
          textTheme: ButtonTextTheme.primary,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      initialRoute: '/likortsplashscreen',
      routes: {
        '/likorthomescreen': (context) => LikortHomeScreen(
              title: 'Likort',
              themeMode: _themeMode,
              toggleThemeMode: _toggleThemeMode,
            ),
        '/likortproductdetail': (context) => const LikortProductDetailScreen(),
        '/likortcart': (context) => const LikortCartScreen(),
        '/likortcheckout': (context) => const LikortCheckoutScreen(),
        '/likorttrackorder': (context) => const LikortTrackOrder(),
        '/likortpaycash': (context) => const LikortPayCash(),
        '/likortcompletedorder': (context) => const LikortCompletedOrder(),
        '/likortsignup': (context) => const LikortSignup(),
        '/likortlogin': (context) => const LikortLogin(),
        '/likortuserprofile': (context) => const LikortUserProfile(),
        '/lkortbuildcreatorstore': (context) => const LikortBuildCreatorStore(),
        '/likortcreatorprofilestore': (context) =>
            const LikortCreatorProfileStore(),
        '/likortcreateartproduct': (context) => const LikortCreateArtProduct(),
        '/likortforgotpassword': (context) => const ForgotPasswordScreen(),
        '/likortsplashscreen': (context) => const LikortSplashScreen(),
        '/likortfavoritesscreen': (context) => const LikortFavoriteScreen(),
        '/likortpaymentfailure': (context) =>
            const LikortPaymentFailureScreen(),
        '/likortpaymentsuccess': (context) =>
            const LikortPaymentSuccessScreen(),
        '/likortcontactsupport': (context) =>
            const LikortContactSupportScreen(),
        '/likortusersettings': (context) => const LikortUserSettings(),
        '/likortadminhome': (context) => const LikortAdminHome(),
        '/likortmanagestore': (context) => const LikortManageStoreScreen(),
        '/likortviewallusers': (context) => const LikortViewAllUsers(),
        '/likortcreateuser': (context) => const LikortCreateUser(),
        '/likortcreateproduct': (context) => const Likortcreateproduct(),
      },
    );
  }
}
