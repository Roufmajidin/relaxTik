import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum RequestState { empty, loading, loaded, error }

final FirebaseAuth _auth = FirebaseAuth.instance;

// Instance CollectionReference untuk mengakses koleksi 'users'
final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('users');

class LoginController extends ChangeNotifier {
  RequestState _loginState = RequestState.empty;
  RequestState get loginState => _loginState;

  Future<void> loginWithEmail(String email, String password) async {
    try {
      // _loginState = RequestState.loading;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      notifyListeners();

      print(email);

      // Jika login berhasil, simpan informasi pengguna ke koleksi "users"
      if (userCredential.user != null) {
        Map<String, dynamic> userData = {
          'email': email,
        };

        await saveUserData(email, userData);
      }

      _loginState = RequestState.loaded;
      notifyListeners();
    } catch (e) {
      _loginState = RequestState.error;
      notifyListeners();
      print('Error saat login: $e');
    }
  }

  Future<void> saveUserData(String email, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(email).set(userData);
    } catch (e) {
      print('Error saat menyimpan data pengguna: $e');
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      _loginState = RequestState.loading;
      notifyListeners();

      await _auth.signOut();

      _loginState = RequestState.loaded;
      notifyListeners();
    } catch (e) {
      _loginState = RequestState.error;
      notifyListeners();
      print('Error during logout: $e');
    }
  }
}
