import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/atur_ulang.dart';
import 'package:relax_tik/view/dashboard.dart';
import 'package:relax_tik/view/kata_sandi_baru.dart';
import 'package:relax_tik/view/register.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../view_model/login_controller.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final passwordController = TextEditingController();
final emailController = TextEditingController();
bool isLihat = true;
bool visible = false;
var _formKey = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffC7DFF0),
          title: const Text(
            'Login',
            style: TextStyle(
                fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black),
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
        backgroundColor: Color(0xffC7DFF0),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 100),
              width: double.infinity,
              // constraints:
              //     BoxConstraints(minHeight: MediaQuery.of(context).size.height),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text.rich(TextSpan(
                          text: "Selamat Datang ,\n",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 24,
                              fontWeight: FontWeight.w700),
                          children: [
                            TextSpan(
                              text: "di Wisata Air Panas Gempol",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500),
                            )
                          ])),
                      const SizedBox(height: 70),
                      Text('Email'),
                      TextFormField(
                        onChanged: (value) {},
                        showCursor: false,
                        textCapitalization: TextCapitalization.sentences,
                        controller: emailController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              !value.contains('@') ||
                              !value.contains('.')) {
                            return 'Invalid Email (harus ada @)';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: 'Masukkan Alamat Email',
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 12),
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
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                      Text('Password'),
                      TextFormField(
                        obscureText: isLihat,
                        validator: (value) {
                          // if (value == null ||
                          //     value.isEmpty ||
                          //     !value.contains('@') ||
                          //     !value.contains('.')) {
                          //   return 'Invalid Email (harus ada @)';
                          // }
                          return null;
                        },
                        controller: passwordController,
                        onChanged: (value) {
                          // passwordController = value;
                        },
                        showCursor: false,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                          hintText: 'Password Anda',
                          hintStyle:
                              TextStyle(color: Colors.black, fontSize: 12),
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
                                isLihat
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                setState(() {
                                  isLihat = !isLihat;
                                });
                              }),
                        ),
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.topRight,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  // Replace `SecondScreen` with the screen you want to navigate to
                                  return AturUlangKataSandi();
                                },
                              ),
                            );
                          },
                          child: Text(
                            'Lupa Kata Sandi',
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xff73A8CF),
                              onPrimary: Colors.white, //
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            onPressed: () async {
                              log('Button pressed!');

                              String email = emailController.text.trim();
                              String password = passwordController.text.trim();
                              final login = Provider.of<LoginController>(
                                  context,
                                  listen: false);
                              if (email.isNotEmpty && password.isNotEmpty) {
                                await login.loginWithEmail(email, password);

                                // Navigasi ke halaman beranda setelah proses login berhasil
                                if (login.loginState !=
                                        RequestStateLogin.loading &&
                                    login.loginState !=
                                        RequestStateLogin.error) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            Dashboard()), // Ganti dengan halaman beranda yang sesuai
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Login',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.white),
                            ),
                          )),
                      const SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Anda tidak mempunyai akun?',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    // Replace `SecondScreen` with the screen you want to navigate to
                                    return Register();
                                  },
                                ),
                              );
                            },
                            child: Text(
                              ' Daftar',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
