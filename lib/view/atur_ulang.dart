import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/kata_sandi_baru.dart';
import 'package:relax_tik/view_model/controller_provider.dart';

class AturUlangKataSandi extends StatefulWidget {
  const AturUlangKataSandi({super.key});

  @override
  State<AturUlangKataSandi> createState() => _AturUlangKataSandiState();
}

class _AturUlangKataSandiState extends State<AturUlangKataSandi> {
  @override
  bool ispressed = false;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffC7DFF0),
      appBar: AppBar(
        title: const Text(
          'Atur ulang kata sandi',
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
          Padding(
              padding: EdgeInsets.all(24),
              child: ispressed == false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Email'),
                        TextFormField(
                          onChanged: (value) {},
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
                          style:
                              TextStyle(color: Colors.grey[50], fontSize: 17),
                        ),
                      ],
                    )
                  : SizedBox()),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: 400,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xff73A8CF),
                  onPrimary: Colors.white, //
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  log('Button pressed!');
                  final prov =
                      Provider.of<ControllerProvider>(context, listen: false);
                  prov.postPaymentToXendit();
                  // ispressed == false
                  //     ? ispressed = true
                  //     :
                  //     // beda lagi
                  //     ispressed = false;
                  // setState(() {});
                },
                child: Text(
                  ispressed == false ? 'Kirim Intruksi' : "Buka Aplikasi Email",
                  style: const TextStyle(fontSize: 12, color: Colors.white),
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                // Replace `SecondScreen` with the screen you want to navigate to
                                return KataSandiBaru();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Lewati,',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                      Text(
                        ' saya akan konfirmasi nanti,',
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
}
