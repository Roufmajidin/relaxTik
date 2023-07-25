import 'dart:developer';

import 'package:external_app_launcher/external_app_launcher.dart';
import 'package:flutter/material.dart';
import 'package:open_mail_app/open_mail_app.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/kata_sandi_baru.dart';
import 'package:relax_tik/view/login.dart';
import 'package:relax_tik/view_model/controller_provider.dart';
import 'package:relax_tik/view_model/login_controller.dart';

class AturUlangKataSandi extends StatefulWidget {
  const AturUlangKataSandi({super.key});

  @override
  State<AturUlangKataSandi> createState() => _AturUlangKataSandiState();
}

bool ispressed = false;
final pinController = TextEditingController();
final _formKey = GlobalKey<FormState>();
bool isOTPFilled = false;
final focusNode = FocusNode();
final defaultPinTheme = PinTheme(
  // textStyle: ,
  height: 68,
  width: 68,
  decoration: BoxDecoration(
      color: const Color(0xffE6E6E6), borderRadius: BorderRadius.circular(8)),
);
const focusedBorderColor = Color(0xffFF7F00);

class _AturUlangKataSandiState extends State<AturUlangKataSandi> {
  @override
  Future<void> openGmailApp() async {
    LaunchApp.openApp(
        androidPackageName: 'com.google.android.gm', openStore: true);
  }

  Future<void> _loadOTPFromSharedPreferences() async {
    final forgotProvider = Provider.of<LoginController>(context, listen: false);
    String? otp = await forgotProvider.getOTPFromSharedPreferences();
    if (otp != null) {
      pinController.text = otp;
    }
  }

  String _email = '';

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Alamat email harus diisi';
    }
    // Regular expression untuk memvalidasi alamat email
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Format alamat email tidak valid';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7DFF0),
      appBar: AppBar(
        title: const Text(
          'Atur ulang kata sandi',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        // leading: const Padding(
        //   padding:
        //       EdgeInsets.only(left: 16), // Add padding around the leading icon
        //   child: Icon(Icons.arrow_back),
        // ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.only(
                right: 16), // Add padding around the actions element
            child: Center(
              child: InkWell(
                onTap: () async {
                  print("logouted");
                  await Provider.of<LoginController>(context, listen: false)
                      .logout();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  );
                },
                child: SizedBox(
                  height: 40,
                  child: Image(
                    image: AssetImage(
                      'assets/ikon/logo_semen.png',
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50),
              child: SizedBox(
                height: 200,
                child: ispressed == false
                    ? Image.asset('assets/ikon/animasi_2.png')
                    : Image.asset('assets/ikon/email.png'),
              ),
            ),
          ),
          SizedBox(
            width: 350,
            child: Align(
                alignment: Alignment.center,
                child: ispressed == false
                    ? Text(
                        'Masukkan email yang terkait dengan akun anda dan kami akan mengirimkan email dengan intruksi untuk mengatur ulang kata sandi anda',
                        style: TextStyle(),
                      )
                    : Text(
                        'Kami telah mengirimkan intruksi pemulihan kata sandi ke email anda')),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
              padding: EdgeInsets.all(24),
              child: ispressed == false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email'),
                        Form(
                          key: _formKey,
                          child: TextFormField(
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: validateEmail,
                            onChanged: (value) {
                              _email = value;
                            },
                            showCursor: false,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              hintText: 'Masukkan Alamat Email',
                              hintStyle: TextStyle(
                                  color: Colors.grey.shade600, fontSize: 12),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  style: BorderStyle.solid,
                                  color: Colors.white,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 164, 164, 164),
                                    width: 2.0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              fillColor: Colors.white,
                              filled: true,
                              contentPadding: const EdgeInsets.all(19),
                            ),
                            style: TextStyle(color: Colors.black, fontSize: 17),
                          ),
                        ),
                      ],
                    )
                  : SizedBox()),
          ispressed == false
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff73A8CF),

                        onPrimary: Colors.white, //
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        log('Button pressed!');

                        setState(() {
                          ispressed = true;
                        });
                      },
                      child: Text(
                        'Kirim Intruksi',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SizedBox(
                    width: 400,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xff73A8CF),

                        onPrimary: Colors.white, //
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      onPressed: () async {
                        log('open Gmail!');

                        setState(() {
                          openGmailApp();
                        });
                      },
                      child: Text(
                        'Buka Gmail',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
                      ),
                    ),
                  ),
                ),
          ispressed == true
              ? Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          log("lewati");
                          setState(() {
                            ispressed = false;
                          });
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) {
                          //       return KataSandiBaru();
                          //     },
                          //   ),
                          // );
                        },
                        child: Text(
                          'resend email',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        ' jika tidak ada inbox masuk',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    ],
                  ),
                )
              : SizedBox()
        ]),
      ),
    );
  }

  Widget formOTP(PinTheme defaultPinTheme, Color focusedBorderColor) {
    return Form(
      key: _formKey,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Directionality(
            textDirection: TextDirection.ltr,
            child: Pinput(
              controller: pinController,
              focusNode: focusNode,
              defaultPinTheme: defaultPinTheme,
              hapticFeedbackType: HapticFeedbackType.lightImpact,
              onCompleted: (pin) {
                setState(() {
                  isOTPFilled = pinController.text.isNotEmpty;
                });
              },
              cursor: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 9),
                    width: 22,
                    height: 1,
                    color: focusedBorderColor,
                  ),
                ],
              ),
              focusedPinTheme: defaultPinTheme.copyWith(
                decoration: defaultPinTheme.decoration!.copyWith(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: focusedBorderColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
