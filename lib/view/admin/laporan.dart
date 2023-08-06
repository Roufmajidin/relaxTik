import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pdf/pdf.dart';

import 'package:relax_tik/view_model/tiket-controller.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import '../../format/converter.dart';

class Laporan extends StatefulWidget {
  const Laporan({Key? key}) : super(key: key);

  @override
  State<Laporan> createState() => _LaporanState();
}

class _LaporanState extends State<Laporan> {
  DateTime? _firstDate;
  DateTime? _lastDate;
  DateTime? _selectedDateStart;
  DateTime? _selectedDateEnd;

  @override
  void initState() {
    super.initState();
    _firstDate = DateTime.now().subtract(Duration(days: 30));
    _lastDate = DateTime.now().add(Duration(days: 30));
  }

  @override
  Widget build(BuildContext context) {
    final orderController = Provider.of<TiketController>(context);
    String _selectedStatus = 'pending'; // Default status is 'pending'

    return Scaffold(
      backgroundColor: const Color(0xffC7DFF0),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Center(child: Text("Cetak Laporan")),
        actions: [
          InkWell(
            onTap: () async {
              print('ok');
              getPDF();
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Image.asset('assets/images/logo.png'),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Silahkan Range Pada Calendar"),
            ),
            const SizedBox(
              height: 12,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final dateRange = await showDateRangePicker(
                    context: context,
                    firstDate: _firstDate!,
                    lastDate: _lastDate!,
                    saveText: 'Select',
                  );

                  if (dateRange != null &&
                      dateRange.start != null &&
                      dateRange.end != null) {
                    setState(() {
                      _selectedDateStart = dateRange.start;
                      _selectedDateEnd = dateRange.end;

                      // Panggil fungsi getOrdersByDateRange untuk mendapatkan pesanan sesuai range tanggal yang dipilih
                      orderController.fetchRange(_selectedDateStart!,
                          _selectedDateEnd!, _selectedStatus);

                      // Cetak hasil pesanan sesuai range tanggal yang dipilih
                      // print(ordersByDateRange);
                    });
                  }
                },
                child: Text('Select Range'),
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                  minimumSize: MaterialStateProperty.all<Size>(
                    Size(200, 0),
                  ), // Set the minimum width
                ),
              ),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _selectedStatus,
              onChanged: (newValue) {
                setState(() {
                  _selectedStatus = newValue!;
                  // Panggil fungsi fetchRange kembali ketika status berubah
                  if (_selectedDateStart != null && _selectedDateEnd != null) {
                    final status =
                        _selectedStatus == 'pending' ? 'pending' : 'paid';
                    orderController.fetchRange(
                        _selectedDateStart!, _selectedDateEnd!, status);
                  }
                });
              },
              items: <String>['pending', 'paid'].map((value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            Text(
              'Pesanan Tiket kurun Waktu:   ${_selectedDateStart} - ${_selectedDateEnd}',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 40,
            ),
            orderController.isLoading // Check if the controller is loading
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                    child: ListView.builder(
                      itemCount: orderController.pesanan.length,
                      itemBuilder: (context, index) {
                        final order = orderController.pesanan[index];
                        if (_selectedDateStart != null &&
                            _selectedDateEnd != null) {
                          final orderDate = order
                              .createdAt; // Use the DateTime object directly
                          if (orderDate.isAfter(_selectedDateEnd!) ||
                              orderDate.isBefore(_selectedDateStart!)) {
                            return Container();
                          }
                        }
                        return ExpansionTile(
                          // Add Row to show details to the left of the ExpansionTile
                          title: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Pemesan: ${order.status}'),
                                    Text('Pemesan: ${order.pemesan}'),
                                  ],
                                ),
                              ),
                              Text('Total: ${order.totalAmount}'),
                            ],
                          ),
                          children: [
                            // Add more details inside this list
                            // For example:
                            for (var element in order.pesanan)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18.0),
                                    child: Align(
                                        alignment: Alignment.topLeft,
                                        child: Text(element.nama)),
                                  ),
                                  Text(
                                    '( x ${element.counter.toString()})',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    '( ${element.hargaTiket.toString()})',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800),
                                  ),
                                ],
                              ),
                          ],
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color.fromRGBO(114, 136, 214, 1),
          onPressed: () {
            try {
              getPDF();
            } catch (e) {
              print("Error: $e");
            }
          },
          label: const Text(
            "Cetak",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  void openPDFFile() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mydocuments.pdf');

    bool exists = await file.exists();
    if (exists) {
      var status = await Permission.storage.request();
      if (status.isGranted) {
        OpenResult result = await OpenFile.open(file.path);
        print("Open file result: ${result.type}");
      } else {
        print("Permission to access storage denied.");
      }
    } else {
      print("File not found!");
    }
  }

  void getPDF() async {
    final pdf = pw.Document();
    final font = await rootBundle.load("assets/OpenSans-Regular.ttf");
    final ttf = pw.Font.ttf(font);
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) => pw.Center(
          child: pw.Text('Hello World!',
              style: pw.TextStyle(font: ttf, fontSize: 40)),
        ),
      ),
    );

    Uint8List bytes = await pdf.save();
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mydocuments.pdf');
    await file.writeAsBytes(bytes);

    openPDFFile();
  }
}
