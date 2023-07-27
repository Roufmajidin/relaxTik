import 'dart:convert';

List<DataPesanan> pesananFromJson(String str) => List<DataPesanan>.from(
    json.decode(str).map((x) => DataPesanan.fromJson(x)));

String pesananToJson(List<DataPesanan> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataPesanan {
  int id;
  String pemesan;
  String status;
  List<PesananElement> pesanan;
  String orderId;
  String totalAmount;
  String checkoutLink;
  DateTime createdAt;
  DateTime updatedAt;

  DataPesanan({
    required this.id,
    required this.pemesan,
    required this.status,
    required this.pesanan,
    required this.orderId,
    required this.totalAmount,
    required this.checkoutLink,
    required this.createdAt,
    required this.updatedAt,
  });

  factory DataPesanan.fromJson(Map<String, dynamic> json) => DataPesanan(
        id: json["id"],
        pemesan: json["pemesan"],
        status: json["status"],
        pesanan: List<PesananElement>.from(
            json["pesanan"].map((x) => PesananElement.fromJson(x))),
        orderId: json["order_id"],
        totalAmount: json["total_amount"],
        checkoutLink: json["checkout_link"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "pemesan": pemesan,
        "status": status,
        "pesanan": List<dynamic>.from(pesanan.map((x) => x.toJson())),
        "order_id": orderId,
        "total_amount": totalAmount,
        "checkout_link": checkoutLink,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}

class PesananElement {
  String nama;
  int hargaTiket;
  String gambar;
  int counter;

  PesananElement({
    required this.nama,
    required this.hargaTiket,
    required this.gambar,
    required this.counter,
  });

  factory PesananElement.fromJson(Map<String, dynamic> json) => PesananElement(
        nama: json["nama"],
        hargaTiket: json["harga_tiket"],
        gambar: json["gambar"],
        counter: json["counter"],
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "harga_tiket": hargaTiket,
        "gambar": gambar,
        "counter": counter,
      };
}
