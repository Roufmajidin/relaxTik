import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/view/staging.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';

class DetailTransaksi extends StatefulWidget {
  var statusPage;

  var userEmail;

  DetailTransaksi(
      {super.key, required this.statusPage, required this.userEmail});

  @override
  State<DetailTransaksi> createState() => _DetailTransaksiState();
}

class _DetailTransaksiState extends State<DetailTransaksi> {
  @override
  Widget build(BuildContext context) {
    final conti = Provider.of<TiketController>(context, listen: false);
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
                      Consumer<TiketController>(
                        builder: (context, cont, _) {
                          final items = widget.statusPage == 'pending_bayar'
                              ? cont.cartItemsPending
                              : cont.cartItems;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              final item = items[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      item.nama,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "${item.counter} * ${item.hargaTiket}",
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      const Divider(thickness: 2, color: Colors.black),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Total",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              widget.statusPage == 'pending_bayar'
                                  ? conti.tot.toString()
                                  : conti.totalHarga.toString(),
                              style: const TextStyle(
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
        onPressed: () async {
          // final con = Provider.of<TiketController>(context, listen: false);
          List<Map<String, dynamic>> jsonList =
              conti.cartItems.map((item) => item.toJson()).toList();
          Map<String, dynamic> jsonObject = {
            'pesanan': jsonList,
          };
          print(jsonObject);

          showAlertDialog(
              context, conti, conti.dataLink, widget.userEmail, jsonList);
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

  showAlertDialog(BuildContext context, con, dataLink, userEmail, jsonList) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Consumer<TiketController>(
          builder: (context, value, child) => AlertDialog(
            title: const Text('Pemberitahuan'),
            content: const Text('Lanjut Ke pembayaran ?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  log("masuk");
                  await value.bayar(jsonList);
                  var data = await value.dataLink;
                  await Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return WebViewExample(
                        url: data,
                        title: "Pembayaran",
                        userEmail: userEmail,
                      );
                    },
                  ));
                  // con.itemCart = [];
                },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue, // Button background color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(10.0), // Button border radius
                  ),
                ),
                child: value.requestState == RequestState.loading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : Text('Ya'),
              ),
            ],
          ),
        );
      },
    );
  }
}
