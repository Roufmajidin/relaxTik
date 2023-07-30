import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../format/converter.dart';
import '../../view_model/login_controller.dart';
import '../../view_model/tiket-controller.dart';
import '../login.dart';

// ignore: must_be_immutable
class DetailPesanan extends StatefulWidget {
  var emailUser;

  DetailPesanan({super.key, required this.emailUser});

  @override
  State<DetailPesanan> createState() => _DetailPesananState();

  //  List<DataPesanan> _employees;
  //   _employees = [];
}

int no = 1;

class _DetailPesananState extends State<DetailPesanan> {
  @override
  void initState() {
    print('is user detail : ${widget.emailUser}');
    super.initState();
    Future.microtask(
      () => Provider.of<TiketController>(context, listen: false)
          .fetchRiwayatUser(widget.emailUser),
    );
    // Future.microtask(
    //   () =>
    //       Provider.of<TiketController>(context, listen: false).fetchRiwayaAll(),
    // );
  }

  @override
  Widget build(BuildContext context) {
    // log(pesanan.length);
    final con = Provider.of<TiketController>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const Center(child: Text('Detail Pesanan')),
        actions: [
          InkWell(
            onTap: () async {
              print("logouted");
              await Provider.of<LoginController>(context, listen: false)
                  .logout();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Login()),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/logo.png'),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Container(
                child: Consumer<TiketController>(
                  builder: (context, cont, _) {
                    final i = cont.pesananUserById;
                    if (cont.requestState == RequestState.loading) {
                      return const SizedBox(
                          // height: mediaquery.height,
                          child: Center(child: CircularProgressIndicator()));
                    }

                    if (cont.requestState == RequestState.loaded) {
                      if (i != null) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(8),
                            itemCount: cont.pesananUserById.length,
                            itemBuilder: (BuildContext context, int index) {
                              final item = cont.pesananUserById[index];
                              return Container(
                                margin: const EdgeInsets.only(bottom: 20),
                                padding: const EdgeInsets.all(20.0),
                                height: 150,
                                color: const Color.fromRGBO(84, 87, 84, 0.12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.pemesan,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          DateFormatter
                                              .formatToDDMMYYYYWithMonthName(
                                                  item.createdAt),
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500),
                                        ),
                                        SizedBox(
                                          height: 60,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              for (var item in item.pesanan)
                                                Row(
                                                  children: [
                                                    SizedBox(
                                                      width: 200,
                                                      child: Text(item.nama),
                                                    ),
                                                    SizedBox(
                                                      // width: 100,
                                                      child: Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              '( x ${item.counter.toString()})',
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w800),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          10.0),
                                                              child: Text(
                                                                  'Rp. ${item.hargaTiket.toInt()}'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                            FormatRupiah.format(double.parse(
                                                item.totalAmount.toString())),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                        Text(
                                          item.status,
                                          style: item.status == 'pending'
                                              ? const TextStyle(
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.red)
                                              : const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.green),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              );
                            });
                      } else if (i.isEmpty) {
                        return const Center(child: Text("Belum ada transaksi"));
                      } else {
                        return const CircularProgressIndicator();
                      }
                    } else if (cont.requestState == RequestState.error) {
                      return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: const Text("Error cant get Data"));
                    }
                    return const Text("");
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
