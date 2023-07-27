import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/staging.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';

class DetailTransaksi extends StatefulWidget {
  const DetailTransaksi({super.key});

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  @override
  void initState() {
    super.initState();
    final con = Provider.of<TiketController>(context, listen: false);
    List<Map<String, dynamic>> jsonList =
        con.cartItems.map((item) => item.toJson()).toList();
    Map<String, dynamic> jsonObject = {
      'pesanan': jsonList,
    };
    print(jsonObject);

    log("masuk");
    Future.microtask(
      () =>
          Provider.of<TiketController>(context, listen: false).bayar(jsonList),
    );
  }

  Widget build(BuildContext context) {
    final con = Provider.of<TiketController>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Center(child: Text('Ringkasan Order')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset('assets/images/logo.png'),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.only(bottom: 50),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
                  // color: Colors.amber,
                  child: Image.asset(
                    'assets/icons/iconoir_profile-circle.png',
                    height: 40,
                  ),
                ),
                const SizedBox(height: 50),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Riwayat Transaksi',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  // constraints: BoxConstraints(minHeight: 200),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: con.cartItems.length,
                        itemBuilder: (context, index) {
                          final item = con.cartItems[index];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  item.nama,
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  "${item.counter} * ${item.hargaTiket}",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 10),
                      const Divider(thickness: 2, color: Colors.black),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              con.totalHarga.toString(),
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        )),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color.fromRGBO(114, 136, 214, 1),
        onPressed: () {
          final con = Provider.of<TiketController>(context, listen: false);

          Navigator.push(context, MaterialPageRoute(
            builder: (context) {
              return WebViewExample(url: con.dataLink);
            },
          ));
        },
        label: const Padding(
          padding: EdgeInsets.all(25),
          child: Text(
            'Bayar Sekarang',
            style: TextStyle(color: Colors.white),
          ),
        ),
        // backgroundColor: Colors.pink,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
