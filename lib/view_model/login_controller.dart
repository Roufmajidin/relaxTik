import 'dart:developer';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/model_email.dart';

enum RequestState { empty, loading, loaded, error }

final FirebaseAuth _auth = FirebaseAuth.instance;
final api = APIEmail();
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

  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> openGmailApp() async {
    final url = 'https://mail.google.com';
    var uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      throw 'Could not launch';
    }
  }

  String generateOTP() {
    Random random = Random();
    int otpLength = 4;
    String otp = '';

    for (int i = 0; i < otpLength; i++) {
      otp += random.nextInt(10).toString();
    }

    return otp;
  }

  // save OTP ke dalam Shared Preferences
  Future<void> saveOTPToSharedPreferences(String otp, String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('otp', otp);
    sendOTPByEmail(email, otp);
    notifyListeners();
  }

// ambil OTP dari Shared Preferences
  Future<String?> getOTPFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('otp');
  }

//Fungsi untuk mengirim OTP melalui email
  void sendOTPByEmail(String email, String otp) async {
    try {
      final sendReport = await api.sendOTP(email, otp);
      print('Message sent: ${sendReport.sent}');
      notifyListeners();
    } catch (e) {
      print('Error sending email: $e');
      notifyListeners();
    }
    notifyListeners();
  }

  void changePassword({required String newPassword}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updatePassword(newPassword);
        print('Password changed successfully!');
        notifyListeners();
      } else {
        print('User is not signed in.');
        notifyListeners();
      }
    } catch (e) {
      print('Error changing password: $e');
      notifyListeners();
    }
  }
}
