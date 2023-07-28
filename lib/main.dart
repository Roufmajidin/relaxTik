// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/admin/admin_a.dart';
import 'package:relax_tik/view/atur_ulang.dart';
import 'package:relax_tik/view/login.dart';
import 'package:relax_tik/view_model/controller_provider.dart';
import 'package:relax_tik/view_model/login_controller.dart';
import 'dart:convert';
import 'dart:io';
import 'package:relax_tik/view/beli_tiket.dart';
import 'package:relax_tik/view/dashboard.dart';
import 'package:relax_tik/view/landing_page.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';

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
  runApp(MyApp());
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
    final FirebaseAuth _auth = FirebaseAuth.instance;

    // Cek apakah pengguna sudah login atau belum
    User? user = _auth.currentUser;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ControllerProvider()),
        ChangeNotifierProvider(create: (_) => LoginController()),
        ChangeNotifierProvider(create: (_) => TiketController()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: user != null ? Dashboard() : Login(),
      ),
    );
  }
}
