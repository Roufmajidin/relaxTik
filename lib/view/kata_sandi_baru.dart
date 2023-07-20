import 'dart:developer';

import 'package:flutter/material.dart';

class KataSandiBaru extends StatefulWidget {
  const KataSandiBaru({super.key});

  @override
  State<KataSandiBaru> createState() => _KataSandiBaruState();
}

class _KataSandiBaruState extends State<KataSandiBaru> {
  @override
  bool ispressed = false;

  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  bool isLihat = false;
  bool hidePw = false;

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
            child: TextFormField(
              style: const TextStyle(
                  color: Color.fromARGB(
                      255, 0, 0, 0)), // Set the text color to white
              autovalidateMode: AutovalidateMode.onUserInteraction,

              obscureText: hidePw ? false : true,
              validator: (value) {
                // if (value == null ||
                //     value.isEmpty ||
                //     !value.contains('@') ||
                //     !value.contains('.')) {
                //   return 'Invalid Email (harus ada @)';
                // }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                ),

                filled: true,
                fillColor: Colors
                    .white, // This should be the background color of the input field
                labelText: 'Password',
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
                labelStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),

          // konfirm passw
          Padding(
            padding: const EdgeInsets.only(left: 30.0, right: 30, top: 20),
            child: TextFormField(
              style: const TextStyle(
                  color: Color.fromARGB(
                      255, 0, 0, 0)), // Set the text color to white
              autovalidateMode: AutovalidateMode.onUserInteraction,

              obscureText: hidePw ? false : true,
              validator: (value) {
                // if (value == null ||
                //     value.isEmpty ||
                //     !value.contains('@') ||
                //     !value.contains('.')) {
                //   return 'Invalid Email (harus ada @)';
                // }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                      10.0), // Adjust the radius as needed
                ),

                filled: true,
                fillColor: Colors
                    .white, // This should be the background color of the input field
                labelText: 'Konfirmasi Password',
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
                labelStyle: const TextStyle(color: Colors.black),
              ),
            ),
          ),
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
