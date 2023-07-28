import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/model/Pesanan.dart';

import '../../view_model/tiket-controller.dart';

class AdminA extends StatefulWidget {
  AdminA({super.key});

  @override
  State<AdminA> createState() => _AdminAState();

  //  List<DataPesanan> _employees;
  //   _employees = [];
}

class _AdminAState extends State<AdminA> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<TiketController>(context, listen: false).fetchRiwayat(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // log(pesanan.length);
    final con = Provider.of<TiketController>(context, listen: false);
    return Scaffold(
      backgroundColor: const Color.fromRGBO(199, 223, 240, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Center(child: Text('Admin GAJEDOT EM')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Image.asset('assets/images/logo.png'),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  log(con.pesanan.length);
                },
                child: Text('')),
            DataTable(
                columns: const <DataColumn>[
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Pemesan',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Status',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Aksi',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                  DataColumn(
                    label: Expanded(
                      child: Text(
                        'Aksi',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                  ),
                ],
                rows: List<DataRow>.generate(con.pesanan.length, (index) {
                  // print('jumlah peasanan : ${pesanan.length}');
                  // // print(pesanan[index].id);
                  // print('cek');
                  List<PesananElement> jenisTiket = con.pesanan[index].pesanan;
                  int jumlahTiket = 0;
                  for (var element in jenisTiket) {
                    jumlahTiket += element.counter;
                  }
                  return DataRow(
                    cells: [
                      DataCell(Text(con.pesanan[index].pemesan)),
                      DataCell(Text(con.pesanan[index].status)),
                      DataCell(Text(con.pesanan[index].status)),
                      DataCell(Text(jumlahTiket.toString())),
                    ],
                  );
                })),
          ],
        ),
      ),
    );
  }
}

// class DataRow {
//   String? id;
//   String? name;
//   String? email;
//   String? detail;
//   List<DataCell>? cells;

//   DataRow({this.id, this.name, this.email, this.detail, this.cells});
// }
