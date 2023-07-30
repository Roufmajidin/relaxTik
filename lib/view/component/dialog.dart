import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:relax_tik/model/tiket_model.dart';
import 'package:relax_tik/view_model/tiket-controller.dart';

class WidgetDialog extends StatefulWidget {
  var status;
  TiketModel wisata;

  WidgetDialog({
    super.key,
    required this.status,
    required this.wisata,
  });

  @override
  State<WidgetDialog> createState() => _WidgetDialogState();
}

class _WidgetDialogState extends State<WidgetDialog> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();

  TextEditingController hargaController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();

  // final KunjunganDetail widget;
  @override
  Widget build(BuildContext context) {
    var con = Provider.of<TiketController>(context, listen: false);

    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              const Color.fromARGB(255, 21, 62, 96), // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Button border radius
          ),
        ),
        child: Text(
          widget.status,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showDialog(
              useSafeArea: true,
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.close),
                      ),
                    );
                  }),
                  insetPadding: const EdgeInsets.all(26),
                  content: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.height,
                      // form widget
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(12),
                          height: 2,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Update Data Wisata',
                          style: TextStyle(
                              color: Colors.grey[600], // Set the text color.
                              fontSize: 16 // Set the text size.
                              ),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: namaController
                                    ..text = widget.wisata.nama,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    return null;
                                  },
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nama Wisata',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: hargaController
                                    ..text =
                                        widget.wisata.hargaTiket.toString(),
                                  onChanged: (value) {},
                                  validator: (value) {
                                    return null;
                                  },
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Harga Tiket',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      log("memilih image");

                                      con.updatepickImage();
                                      setState(() {
                                        log("dan image terupdate");
                                        // gambarKader == kaderProv.gambarKader;
                                        print("Updated");
                                      });
                                    },
                                    child: SizedBox(
                                        height: 40,
                                        child: Consumer<TiketController>(
                                          builder: (context, cn, _) =>
                                              Image.network(
                                                  cn.gambarTiketUpdate == ''
                                                      ? widget.wisata.gambar
                                                      : cn.gambarTiketUpdate),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 65,
                                  ),
                                  SizedBox(
                                    width: 240,
                                    height: 40,
                                    child: TextFormField(
                                      controller: gambarController,
                                      enabled: false,
                                      validator: (value) {
                                        return null;
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        // logika kalo terpilih image nya ganti text ke TERPILIH
                                        labelText: con.gambarTiket == ''
                                            ? "pilih image"
                                            : "image Terpilih",
                                        labelStyle: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                onPressed: () async {
                                  var tiket = TiketModel(
                                      docId: widget.wisata.docId,
                                      nama: namaController.text,
                                      hargaTiket:
                                          int.parse(hargaController.text),
                                      gambar: con.gambarTiketUpdate == ''
                                          ? widget.wisata.gambar
                                          : con.gambarTiketUpdate,
                                      counter: 0);
                                  con.fungsiDataWisata(
                                      status: "edit", tiket: tiket);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Data Wisata berhasil diperbarui!'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  namaController.clear();
                                  hargaController.clear();
                                  con.gambarTiket = '';
                                  con.gambarTiketUpdate = '';
                                },
                                child: const Center(
                                  child: Text(
                                    "Update",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              });
        });
  }
}

class WidgetDialogAdd extends StatefulWidget {
  var status;

  WidgetDialogAdd({
    super.key,
    required this.status,
  });

  @override
  State<WidgetDialogAdd> createState() => _WidgetDialogAddState();
}

class _WidgetDialogAddState extends State<WidgetDialogAdd> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();

  TextEditingController hargaController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();

  // final KunjunganDetail widget;
  @override
  Widget build(BuildContext context) {
    var con = Provider.of<TiketController>(context, listen: false);

    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              const Color.fromARGB(255, 21, 62, 96), // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Button border radius
          ),
        ),
        child: Text(
          widget.status,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showDialog(
              useSafeArea: true,
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.close),
                      ),
                    );
                  }),
                  insetPadding: const EdgeInsets.all(26),
                  content: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.height,
                      // form widget
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(12),
                          height: 2,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.status} Data Wisata',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        Form(
                          key: _formKey,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: namaController,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    return null;
                                  },
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Nama Wisata',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              SizedBox(
                                height: 40,
                                child: TextFormField(
                                  autofocus: true,
                                  controller: hargaController,
                                  onChanged: (value) {},
                                  validator: (value) {
                                    return null;
                                  },
                                  obscureText: false,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    labelText: 'Harga Tiket',
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      log("memilih image");

                                      con.updatepickImage();
                                      setState(() {
                                        log("dan image terupdate");
                                        // gambarKader == kaderProv.gambarKader;
                                        print("Updated");
                                      });
                                    },
                                    child: SizedBox(
                                        height: 40,
                                        child: Consumer<TiketController>(
                                          builder: (context, cn, _) =>
                                              Image.network(cn
                                                          .gambarTiketUpdate ==
                                                      ''
                                                  ? "https://kapau.agamkab.go.id/frontand-template-ridho/images/gambargaleri.jpg"
                                                  : cn.gambarTiketUpdate),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 65,
                                  ),
                                  SizedBox(
                                    width: 240,
                                    height: 40,
                                    child: TextFormField(
                                      controller: gambarController,
                                      enabled: false,
                                      validator: (value) {
                                        return null;
                                      },
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        border: const OutlineInputBorder(),
                                        // logika kalo terpilih image nya ganti text ke TERPILIH
                                        labelText: con.gambarTiket == ''
                                            ? "pilih image"
                                            : "image Terpilih",
                                        labelStyle: const TextStyle(
                                            color: Colors.green),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30,
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue),
                                onPressed: () async {
                                  String id = DateTime.now()
                                      .millisecondsSinceEpoch
                                      .toString();
                                  var tiket = TiketModel(
                                      docId: id,
                                      nama: namaController.text,
                                      hargaTiket:
                                          int.parse(hargaController.text),
                                      gambar: con.gambarTiketUpdate == ''
                                          ? "https://kapau.agamkab.go.id/frontand-template-ridho/images/gambargaleri.jpg"
                                          : con.gambarTiketUpdate,
                                      counter: 0);
                                  con.fungsiDataWisata(
                                      status: "tambah", tiket: tiket);
                                  Navigator.of(context).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'berhasil Menambhakan Data Wisata!'),
                                      duration: Duration(seconds: 3),
                                    ),
                                  );
                                  namaController.clear();
                                  hargaController.clear();
                                  con.gambarTiket = '';
                                  con.gambarTiketUpdate = '';
                                },
                                child: const Center(
                                  child: Text(
                                    "Tambah",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ]),
                    ),
                  ),
                );
              });
        });
  }
}

class WidgetDialogDelete extends StatefulWidget {
  var status;
  TiketModel wisata;

  WidgetDialogDelete({
    super.key,
    required this.status,
    required this.wisata,
  });

  @override
  State<WidgetDialogDelete> createState() => _WidgetDialogDeleteState();
}

class _WidgetDialogDeleteState extends State<WidgetDialogDelete> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController namaController = TextEditingController();

  TextEditingController hargaController = TextEditingController();
  final TextEditingController gambarController = TextEditingController();

  // final KunjunganDetail widget;
  @override
  Widget build(BuildContext context) {
    var con = Provider.of<TiketController>(context, listen: false);

    return TextButton(
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor:
              Color.fromARGB(255, 251, 51, 51), // Button background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0), // Button border radius
          ),
        ),
        child: Text(
          widget.status,
          style: const TextStyle(color: Colors.white),
        ),
        onPressed: () {
          showDialog(
              useSafeArea: true,
              context: context,
              barrierDismissible: false, // user must tap button!
              builder: (BuildContext context) {
                return AlertDialog(
                  icon: Builder(builder: (context) {
                    return GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Align(
                        alignment: Alignment.topRight,
                        child: Icon(Icons.close),
                      ),
                    );
                  }),
                  insetPadding: const EdgeInsets.all(26),
                  content: SingleChildScrollView(
                    physics: const NeverScrollableScrollPhysics(),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.height,
                      // form widget
                      child: Column(children: [
                        Container(
                          alignment: Alignment.center,
                          margin: const EdgeInsets.all(12),
                          height: 2,
                          width: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${widget.status} Data Wisata',
                          style: TextStyle(
                              color: Colors.grey[600], // Set the text color.
                              fontSize: 16 // Set the text size.
                              ),
                        ),
                        const SizedBox(height: 60),
                        Center(
                          child: Text(
                              "Apakah Anda Yakin Akan Menghapus Tiket ${widget.wisata.nama} ?"),
                        ),
                        const SizedBox(height: 60),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 243, 33, 33)),
                          onPressed: () async {
                            var tiket = TiketModel(
                                docId: widget.wisata.docId,
                                nama: namaController.text,
                                hargaTiket: 120000,
                                gambar: con.gambarTiketUpdate == ''
                                    ? "https://kapau.agamkab.go.id/frontand-template-ridho/images/gambargaleri.jpg"
                                    : con.gambarTiketUpdate,
                                counter: 0);
                            con.fungsiDataWisata(status: "hapus", tiket: tiket);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content:
                                    Text('berhasil Menghapus Data Wisata!'),
                                duration: Duration(seconds: 3),
                              ),
                            );
                            namaController.clear();
                            hargaController.clear();
                            con.gambarTiket = '';
                            con.gambarTiketUpdate = '';
                          },
                          child: const Center(
                            child: Text(
                              "Delete",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        )
                      ]),
                    ),
                  ),
                );
              });
        });
  }
}
