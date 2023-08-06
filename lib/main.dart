// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/admin/admin_a.dart';
import 'package:relax_tik/view/dashboard.dart';
import 'package:relax_tik/view/landing_page.dart';
import 'package:relax_tik/view/login.dart';
import 'package:relax_tik/view_model/controller_provider.dart';
import 'package:relax_tik/view_model/login_controller.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:xendit/xendit.dart';

import 'firebase_options.dart';
// import "package:galaxeus_lib/galaxeus_lib.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  String apiKey =
      'xnd_development_c87nmgt97GWLv3QwUdY1rtymgenS71BM6kuSt1sZFll6bPaDiKagvYIVndjgQ';

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  Xendit xendit = Xendit(apiKey: apiKey);
  // var res = await xendit.invoke(
  //     endpoint: "POST https://api.xendit.co/v2/invoices",
  //     headers: {
  //       "for-user-id": "",
  //     },
  //     parameters: {
  //       "external_id": "asoaskoaks",
  //       "amount": 10000,
  //     },
  //     queryParameters: {"id": "saksoak"},
  //     apiKey: apiKey);

  // print(res);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Inisialisasi Midtrans SDK dengan kunci API
    // var _clentKey = 'SB-Mid-client-uKlPRIds6oO-mQhw';
    // var serverKey = 'SB-Mid-server-D_icXc3QC80CNAJq-JZjokYg';

    // MidtransSDK.init(
    //     config: MidtransConfig(
    //   merchantBaseUrl: 'https://api.sandbox.midtrans.com/v2',
    //   clientKey: _clentKey,
    // ));
    final FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControllerProvider()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => TiketController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus(context);
  }

  Future<void> _checkLoginStatus(context) async {
    LoginController loginProvider =
        Provider.of<LoginController>(context, listen: false);
    bool isLoggedIn = await loginProvider.checkLoginStatus(context);

    if (isLoggedIn == true) {
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (_, __, ___) {
            if (loginProvider.emailUser == 'admin@gmail.com') {
              return AdminDashboard();
            }
            return LandingPage();
          },
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 1000),
          pageBuilder: (_, __, ___) => const Login(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            var begin = const Offset(1.0, 0.0);
            var end = Offset.zero;
            var curve = Curves.ease;
            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
        (route) => false,
      );
    }
  }
}
