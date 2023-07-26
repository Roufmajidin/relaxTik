import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:relax_tik/model/tiket_model.dart';

enum RequestState { empty, loading, loaded, error }

class TiketController extends ChangeNotifier {
  List<TiketModel> dataTiketWisata = [];
  List<TiketModel> _cartItems = [];

  List<TiketModel> get cartItems => _cartItems;

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

  void addToCart(TiketModel item) {
    _cartItems.add(item);
    notifyListeners();
    log("total adalah ${totalHarga}");
    log(cartItems.length.toString());
    for (var element in cartItems) {
      log(element.nama);
    }
  }

  void removeFromCart(TiketModel item) {
    _cartItems.remove(item);
    notifyListeners();

    log(cartItems.length.toString());
    log("total adalah ${totalHarga}");
    for (var element in cartItems) {
      log(element.nama);
    }
  }

  void updateCounterForItem(int index, int newCounter) {
    if (index >= 0 && index < dataTiketWisata.length) {
      dataTiketWisata[index].counter = newCounter;
      notifyListeners();
    }
  }

  int get totalHarga {
    int total = 0;
    for (var item in _cartItems) {
      total += item.hargaTiket * item.counter;
    }
    return total;
  }
}
