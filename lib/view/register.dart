import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/kata_sandi_baru.dart';
import 'package:relax_tik/view/login.dart';
import 'package:relax_tik/view_model/controller_provider.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool isLihat = true;
  bool visible = false;
  var _formKey = GlobalKey<FormState>();
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7DFF0),
      appBar: AppBar(
        backgroundColor: Color(0xffC7DFF0),
        title: const Text(
          'Daftar',
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black),
        ),
        // leading: const Padding(
        //   padding:
        //       EdgeInsets.only(left: 16), // Add padding around the leading icon
        //   child: Icon(
        //     Icons.arrow_back,
        //     color: Colors.black,
        //   ),
        // ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(
                right: 16), // Add padding around the actions element
            child: Center(
              child: SizedBox(
                height: 30,
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
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 50),
              child: SizedBox(
                  height: 200, child: Image.asset('assets/ikon/animasi_2.png')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  onChanged: (value) {},
                  showCursor: false,
                  textCapitalization: TextCapitalization.sentences,
                  controller: usernameController,
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
                  ),
                  style: TextStyle(color: Colors.grey[50], fontSize: 17),
                ),
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  onChanged: (value) {},
                  showCursor: false,
                  textCapitalization: TextCapitalization.sentences,
                  controller: usernameController,
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
                  ),
                  style: TextStyle(color: Colors.grey[50], fontSize: 17),
                ),
                SizedBox(
                  height: 12,
                ),
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
                  onChanged: (value) {},
                  showCursor: false,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                    hintText: 'Password Anda',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade600, fontSize: 12),
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
                SizedBox(
                  height: 12,
                ),
                TextFormField(
                  obscureText: isLihat2,
                  validator: (value) {
                    // if (value == null ||
                    //     value.isEmpty ||
                    //     !value.contains('@') ||
                    //     !value.contains('.')) {
                    //   return 'Invalid Email (harus ada @)';
                    // }
                    return null;
                  },
                  onChanged: (value) {},
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
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 50,
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
                      onPressed: () {
                        log('Button pressed!');

                        // ispressed == false
                        //     ? ispressed = true
                        //     :
                        //     // beda lagi
                        //     ispressed = false;
                        // setState(() {});
                      },
                      child: Text(
                        'Register',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.white),
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
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        ' Login',
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
          )
        ]),
      ),
    );
  }
}
