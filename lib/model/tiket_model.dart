import 'package:cloud_firestore/cloud_firestore.dart';

class TiketModel {
  final String docId;
  final String nama;
  final int hargaTiket;
  int counter;

  final String gambar;

  TiketModel({
    required this.docId,
    required this.nama,
    required this.hargaTiket,
    required this.gambar,
    required this.counter,
  });
  factory TiketModel.fromJson(DocumentSnapshot doc) {
    return TiketModel(
      docId: doc.id,
      nama: doc.get("nama"),
      hargaTiket: doc.get("harga_tiket"),
      gambar: doc.get("gambar"),
      counter: doc.get("counter"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'user_id': doc_id,
      'nama': nama,
      'harga_tiket': hargaTiket,
      'gambar': gambar,
      'counter': counter,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga_tiket': hargaTiket,
      'gambar': gambar,
      'counter': counter,
    };
  }
}
