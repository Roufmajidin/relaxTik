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
  List<TiketModel> _cartItems = [];
  List<TiketModel> get cartItems => _cartItems;
  List nama = [];
  String dataLink = '';
// get data pesanan user
  List<Pesanan> _pesanan = [];
  List<Pesanan> get pesanan => _pesanan;
  RequestState _requestState = RequestState.empty;
  RequestState get requestState => _requestState;
  String _message = '';
  String posisiKader = '';
  String get message => _message;
  String gambarKader = '';
  String gambarKaderUpdate = "";

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
      notifyListeners();
    } else {
      nama.add(item.nama);
      item.counter += 1;
      _cartItems.add(item);
      notifyListeners();
    }
    notifyListeners();
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
    }

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
}
