import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relax_tik/model/model_email.dart';
import 'package:relax_tik/model/tiket_model.dart';

import '../model/Pesanan.dart';

enum RequestState { empty, loading, loaded, error }

class TiketController extends ChangeNotifier {
  List<TiketModel> dataTiketWisata = [];
  List<TiketModel> _cartItemsPending = [];
  List<TiketModel> get cartItemsPending => _cartItemsPending;

  List<TiketModel> _cartItems = [];

  List<TiketModel> get cartItems => _cartItems;
  List nama = [];
  String dataLink = '';
// get data pesanan user
  List<DataPesanan> _pesanan = [];
  List<DataPesanan> get pesanan => _pesanan;
  RequestState _requestState = RequestState.empty;
  RequestState get requestState => _requestState;
  int tot = 0;
  String gambarKaderUpdate = "";
  List<PesananElement> _pesananPending = [];
  List<PesananElement> get pesananPending => _pesananPending;
  Future fetchTiket() async {
    // _requestState = RequestState.loading;
    notifyListeners();
    final snapshot = await FirebaseFirestore.instance.collection('wisata');

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

  Future<void> fetchRiwayat() async {
    print("ok");

    _requestState = RequestState.loading;
    notifyListeners();
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    try {
      _pesanan = await APIEmail.getRiwayat(email: user?.email);
      print(pesanan.length);
      _requestState = RequestState.loaded;

      notifyListeners();
    } catch (e) {
      _requestState = RequestState.error;
      notifyListeners();
      print(e);
      throw "Cant get data";
    }
  }

  void addToCart(TiketModel item) {
    if (nama.contains(item.nama)) {
      item.counter += 1;
    } else {
      nama.add(item.nama);
      item.counter += 1;
      _cartItems.add(item);
    }
    log("total adalah ${totalHarga}");
    log(_cartItems.length.toString());
    // for (var element in cartItems) {
    //   log(element.nama);
    // }
    notifyListeners();
  }

  void removeFromCart(TiketModel item) {
    if (nama.contains(item.nama)) {
      item.counter -= 1;
      notifyListeners();
    } else {
      nama.add(item.nama);
      item.counter -= 1;
      // _cartItems.add(item);
      // _cartItems.remove(item);
      notifyListeners();
    }
    item.counter == 0 ? _cartItems.remove(item) : null;
    notifyListeners();

    log(cartItems.length.toString());
    log("total adalah ${totalHarga}");
    for (var element in cartItems) {
      log(element.nama);
    }
    notifyListeners();
  }

  int get totalHarga {
    int total = 0;
    for (var item in _cartItems) {
      total += item.hargaTiket * item.counter;
      notifyListeners();
    }
    notifyListeners();

    return total;
  }

  Future<void> bayar(cart) async {
    try {
      final result = await APIEmail.bayar(cart, totalHarga);
      Map<String, dynamic> parsedData = jsonDecode(result);
      String url = parsedData['data'];
      dataLink = url;
      print(dataLink);

      notifyListeners();
    } catch (e) {
      print(e);
    }
    notifyListeners();
  }

  Future<void> reloadHalaman() async {
    await Future.delayed(Duration(seconds: 2));

    fetchRiwayat();
    // _cartItems = [];
    notifyListeners();
  }

  Future<void> refreshCart() async {
    // await Future.delayed(Duration(seconds: 2));

    _cartItems = [];
    notifyListeners();
  }

  Future<void> getPendingPesanan({int? id}) async {
    try {
      var pesanan = await APIEmail.getPendingPesanan(id: id);

      // Now you can access the pesanan field

      log('ini adalah ${pesanan.checkoutLink}');
      List<TiketModel> newCartItems = [];
      for (var element in pesanan.pesanan) {
        log('nama pesanan : ${element.nama}');
        log('nama pesanan : ${element.counter}');
        // Buat list baru untuk menampung data tiket baru

        TiketModel tiket = TiketModel(
          docId:
              "", // Provide the docId value here, you can get it from somewhere else
          nama: element.nama,
          hargaTiket: element
              .hargaTiket, // Ubah key sesuai dengan model TiketModel Anda
          gambar:
              element.gambar, // Ubah key sesuai dengan model TiketModel Anda
          counter: element.counter,
        );

        newCartItems.add(tiket); // Tambahkan tiket ke list baru
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
  }
}
