class Orders {
  final int id;
  final String pemesan;
  final String status;
  final List<Ticket> pesanan;
  final String orderId;
  final String totalAmount;
  final String checkoutLink;
  final String createdAt; // Ubah tipe data menjadi DateTime
  final String updatedAt;

  Orders({
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

  // Factory constructor untuk mengubah JSON data menjadi instance Orders
  factory Orders.fromJson(Map<String, dynamic> json) {
    // Ubah createdAt dari String menjadi DateTime
    final createdAtString = json['created_at'];
    final createdAt = json['created_at'];

    return Orders(
      id: json['id'],
      pemesan: json['pemesan'],
      status: json['status'],
      pesanan:
          List<Ticket>.from(json['pesanan'].map((x) => Ticket.fromJson(x))),
      orderId: json['order_id'],
      totalAmount: json['total_amount'],
      checkoutLink: json['checkout_link'],
      createdAt: json[
          'createdAt'], // Gunakan createdAt yang telah diubah menjadi DateTime
      updatedAt: json['updated_at'],
    );
  }
}

class Ticket {
  final String nama;
  final int hargaTiket;
  final String gambar;
  final int counter;

  Ticket({
    required this.nama,
    required this.hargaTiket,
    required this.gambar,
    required this.counter,
  });

  // Factory constructor untuk mengubah JSON data menjadi instance Ticket
  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      nama: json['nama'],
      hargaTiket: json['harga_tiket'],
      gambar: json['gambar'],
      counter: json['counter'],
    );
  }
}
