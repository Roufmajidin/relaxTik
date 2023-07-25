import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../view_model/login_controller.dart';

class KataSandiBaru extends StatefulWidget {
  const KataSandiBaru({super.key});

  @override
  State<KataSandiBaru> createState() => _KataSandiBaruState();
}

bool ispressed = false;

final passwordController = TextEditingController();
final newPasswordController = TextEditingController();
final usernameController = TextEditingController();
bool isLihat = true;
bool isLihat2 = true;
bool hidePw = true;
String pass = '';

//
class _KataSandiBaruState extends State<KataSandiBaru> {
  @override
  var _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7DFF0),
      appBar: AppBar(
        title: const Text(
          'Buat Kata Sandi Baru',
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        leading: const Padding(
          padding:
              EdgeInsets.only(left: 16), // Add padding around the leading icon
          child: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(
                right: 16), // Add padding around the actions element
            child: Center(
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
        ],
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0),
            child: Center(
              child: SizedBox(
                width: 350,
                child: Text(
                    'Kata sandi baru anda harus berbeda dari kata sandi yang digunakan previsus'),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Password'),
                  Form(
                    key: _formKey,
                    child: TextFormField(
                      controller: passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      obscureText: isLihat,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Password harus diisi';
                        }
                        return null;
                      },
                      showCursor: false,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: InputDecoration(
                        hintText: 'Password Anda',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade600, fontSize: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Color.fromARGB(255, 164, 164, 164),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            style: BorderStyle.solid,
                            color: Colors.white,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: const EdgeInsets.all(19),
                        suffixStyle: const TextStyle(color: Colors.white),
                        suffixIcon: IconButton(
                            icon: Icon(
                              isLihat ? Icons.visibility : Icons.visibility_off,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              setState(() {
                                isLihat = !isLihat;
                              });
                            }),
                      ),
                      style: TextStyle(color: Colors.black, fontSize: 17),
                    ),
                  ),
                ],
              )),

          // konfirm passw
          Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Konfirmasi Password'),
                  TextFormField(
                    controller: newPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: isLihat2,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Konfirmasi Password harus diisi';
                      }
                      if (value != pass) {
                        return 'Konfirmasi Password tidak sesuai';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      pass = value;
                      print(value);
                    },
                    showCursor: false,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: 'Konfirmasi Password Anda',
                      hintStyle:
                          TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
                      suffixStyle: const TextStyle(color: Colors.white),
                      suffixIcon: IconButton(
                          icon: Icon(
                            isLihat2 ? Icons.visibility : Icons.visibility_off,
                            color: Colors.black,
                          ),
                          onPressed: () {
                            setState(() {
                              isLihat2 = !isLihat2;
                            });
                          }),
                    ),
                    style: TextStyle(color: Colors.black, fontSize: 17),
                  ),
                ],
              )),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 40),
            child: SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff73A8CF),
                  onPrimary: Colors.white, //
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  log('Atur Ulang');
                  final forgotProvider =
                      Provider.of<LoginController>(context, listen: false);
                  forgotProvider.logout();
                  forgotProvider.changePassword(
                      newPassword: passwordController.text);

                  setState(() {});
                },
                child: Text(
                  'Atur ulang kata sandi',
                  style: const TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
