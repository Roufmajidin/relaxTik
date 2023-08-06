import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:relax_tik/model/model_email.dart';
import 'package:relax_tik/model/tiket_model.dart';
import 'package:http/http.dart' as http;

import '../model/Pesanan.dart';
import '../model/order.dart';

enum RequestState { empty, loading, loaded, error }

class TiketController extends ChangeNotifier {
  static const String baseUrl = 'https://mustiket-3371fb7c3fb2.herokuapp.com';

  List<TiketModel> dataTiketWisata = [];
  List<TiketModel> _cartItemsPending = [];
  List<TiketModel> get cartItemsPending => _cartItemsPending;
  String gambarTiket = '';
  String gambarTiketUpdate = '';

  final List<TiketModel> _cartItems = [];

  List<TiketModel> get cartItems => _cartItems;
  List nama = [];
  String dataLink = '';
// get data pesanan user
  List<DataPesanan> _pesanan = [];
  List<DataPesanan> get pesanan => _pesanan;

  List<DataPesanan> _pesananUserById = [];
  List<DataPesanan> get pesananUserById => _pesananUserById;

// laporan
  List<Orders> _orders = [];
  List<Orders> get orders => _orders;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

// end of uhuy laporan
  RequestState _requestState = RequestState.empty;
  RequestState get requestState => _requestState;
  int tot = 0;
  String gambarKaderUpdate = "";
  final List<PesananElement> _pesananPending = [];
  List<PesananElement> get pesananPending => _pesananPending;

//  range pesanan user uhuy
  List<DataPesanan> getOrdersByDateRange(DateTime startDate, DateTime endDate) {
    return pesanan.where((order) {
      return order.createdAt.isAfter(startDate) &&
          order.createdAt.isBefore(endDate);
    }).toList();
  }

  Future<void> fetchRange(
      DateTime startDate, DateTime endDate, String status) async {
    _requestState = RequestState.loading;
    _isLoading = true;
    notifyListeners();

    try {
      _pesanan = await APIEmail.getRiwayatAll();
      _requestState = RequestState.loaded;
      _isLoading = false;
      notifyListeners();

      // Filter the results based on the date range and status
      _pesanan = getOrdersByDateRange(startDate, endDate)
          .where((order) => order.status == status)
          .toList();
      notifyListeners();
    } catch (e) {
      _requestState = RequestState.error;
      _isLoading = false;
      notifyListeners();
      throw "Can't get data";
    }
  }

  Future fetchTiket() async {
    // _requestState = RequestState.loading;
    notifyListeners();
    final snapshot = FirebaseFirestore.instance.collection('wisata');

    snapshot.snapshots().listen((snapshot) {
      dataTiketWisata = snapshot.docs
          .map((doc) => TiketModel(
                docId: doc.id,
                nama: doc.get('nama'),
                hargaTiket: doc.get('harga_tiket'),
                gambar: doc.get('gambar'),
                counter: doc.get('counter'),
              ))
          .toList();
      // _requestState = RequestState.loaded;

      notifyListeners();
    });
    notifyListeners();
  }

  // Future<List<DataRow>>? fetchSemuaData() async {
  //   _requestState = RequestState.loading;
  //   notifyListeners();
  //   try {
  //     List<DataPesanan> pesananData = await APIEmail.fetchSemuaData();

  //     // Convert DataPesanan to DataRow
  //     List<DataRow> dataRows = pesananData.map((dataPesanan) {
  //       return DataRow(
  //         id: 2,
  //         checkoutLink: "",
  //         createdAt: DateTime.now(),
  //         orderId: "",
  //         pesanan: [],
  //         pemesan: "",
  //         status: "",
  //         totalAmount: "",
  //         updatedAt: DateTime.now(),
  //       );
  //     }).toList();

  //     _requestState = RequestState.loaded;
  //     notifyListeners();
  //     return dataRows;
  //   } catch (e) {
  //     _requestState = RequestState.error;
  //     notifyListeners();
  //     print(e);
  //     throw "Can't get data";
  //   }
  // }
  Future<void> fetchRiwayatUser(emailUser) async {
    // print("ok");
    print('fungsi $emailUser');

    _requestState = RequestState.loading;
    notifyListeners();

    try {
      _pesananUserById = await APIEmail.getRiwayat(email: emailUser);
      // print(pesanan.le ngth);
      _requestState = RequestState.loaded;
      for (var element in pesanan) {
        print(element.pemesan);
      }
      notifyListeners();
    } catch (e) {
      _requestState = RequestState.error;
      notifyListeners();
      // print(e);
      throw "Cant get data";
    }
    notifyListeners();
  }

  Future<void> fetchRiwayat(emailUser) async {
    // print("ok");

    _requestState = RequestState.loading;
    notifyListeners();

    try {
      _pesanan = await APIEmail.getRiwayat(email: emailUser);
      _pesanan = await APIEmail.getRiwayat(email: emailUser);
      // print(pesanan.length);
      _requestState = RequestState.loaded;

      notifyListeners();
    } catch (e) {
      _requestState = RequestState.error;
      notifyListeners();
      // print(e);
      throw "Cant get data";
    }
    notifyListeners();
  }

  Future<void> fetchRiwayaAll() async {
    // print("ok");

    _requestState = RequestState.loading;
    notifyListeners();
    // final FirebaseAuth _auth = FirebaseAuth.instance;
    // final User? user = _auth.currentUser;
    try {
      _pesanan = await APIEmail.getRiwayatAll();
      // print(pesanan.le ngth);
      _requestState = RequestState.loaded;

      notifyListeners();
    } catch (e) {
      _requestState = RequestState.error;
      notifyListeners();
      // print(e);
      throw "Cant get data";
    }
    notifyListeners();
  }

  void addToCart(TiketModel item) {
    if (_cartItems.contains(item)) {
      int index = _cartItems.indexWhere((element) => element == item);
      _cartItems[index].counter += 1;
    } else {
      _cartItems.add(item);
      item.counter = 1;
    }
    // log("total adalah ${totalHarga}");
    // log(_cartItems.length.toString());
    notifyListeners();
  }

  void removeFromCart(TiketModel item) {
    if (_cartItems.contains(item)) {
      int index = _cartItems.indexWhere((element) => element == item);
      if (_cartItems[index].counter > 1) {
        _cartItems[index].counter -= 1;
      } else {
        _cartItems.removeAt(index);
        nama.remove(item.nama);
      }
      // log("total adalah ${totalHarga}");
      // log(_cartItems.length.toString());
      notifyListeners();
    }
  }

  int get totalHarga {
    int total = 0;
    for (var item in _cartItems) {
      total += item.hargaTiket * item.counter;
    }
    notifyListeners();

    return total;
  }

  Future<void> bayar(cart) async {
    _requestState = RequestState.loading;
    notifyListeners();
    try {
      final result = await APIEmail.bayar(cart, totalHarga);
      Map<String, dynamic> parsedData = jsonDecode(result);
      // String url =
      dataLink = parsedData['data'];
      _requestState = RequestState.loaded;

      notifyListeners();
      print('link terbaru : $dataLink');
    } catch (e) {
      _requestState = RequestState.error;
      notifyListeners();
      print(e);
    }
    notifyListeners();
  }

  Future<void> reloadHalaman() async {
    await Future.delayed(const Duration(milliseconds: 500));

    fetchRiwayaAll();
    fetchTiket();
    // _cartItems = [];
    notifyListeners();
  }

  Future<void> reloadHalamanUser(emailUser) async {
    await Future.delayed(const Duration(milliseconds: 500));

    fetchRiwayatUser(emailUser);
    // _cartItems = [];
    print('controller  $emailUser');
    notifyListeners();
  }

  Future<void> refreshCart() async {
    // await Future.delayed(Duration(seconds: 2));
    fetchRiwayaAll();

    _cartItems.clear();
    notifyListeners();
  }

  Future<void> getPendingPesanan({int? id}) async {
    try {
      var pesanan = await APIEmail.getPendingPesanan(id: id);

      // Now you can access the pesanan field

      // log('ini adalah ${pesanan.checkoutLink}');
      List<TiketModel> newCartItems = [];
      for (var element in pesanan.pesanan) {
        // log('nama pesanan : ${element.nama}');
        // log('nama pesanan : ${element.counter}');

        TiketModel tiket = TiketModel(
          docId: "",
          nama: element.nama,
          hargaTiket: element.hargaTiket,
          gambar: element.gambar,
          counter: element.counter,
        );

        newCartItems.add(tiket);
      }

      _cartItemsPending =
          newCartItems; // Timpa _cartItemsPending dengan list baru
      dataLink = pesanan.checkoutLink;
      print('harga : ${pesanan.totalAmount}');
      int intValue = double.parse(pesanan.totalAmount).toInt();
      print(intValue);
      tot = intValue;
      notifyListeners();
    } catch (e) {
      print(e);
      throw "Can't get by Id";
    }
    notifyListeners();
  }

  // update
  void pickImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('gambarTiket/${DateTime.now()}.jpg');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      gambarTiket = value;
      print("terpilih gambar $value");

      notifyListeners();
    });
    // notifyListeners();
  }

  void updatepickImage() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('gambarTiket/${DateTime.now()}.jpg');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      gambarTiketUpdate = value;
      print("terpilih gambar $gambarTiketUpdate");

      notifyListeners();
    });
  }

  Future<void> fungsiDataWisata(
      {required status, required TiketModel tiket}) async {
    // TODOD : 1 update data ke collection wisata
    if (status == 'edit') {
      await FirebaseFirestore.instance
          .collection("wisata")
          .doc(tiket.docId)
          .update(tiket.toMap());
      print("ini id nya : ${tiket.docId} Sukses Update Data tiket");
    } else if (status == 'tambah') {
      await FirebaseFirestore.instance
          .collection("wisata")
          .doc(tiket.docId)
          .set(tiket.toMap());
      print("ini id nya : ${tiket.docId} Sukses menambah Data tiket");
    } else if (status == 'hapus') {
      await FirebaseFirestore.instance
          .collection("wisata")
          .doc(tiket.docId)
          .delete();
      print("ini id nya : ${tiket.docId} Sukses menaghapus Data tiket");
    }
    notifyListeners();
  }
}
