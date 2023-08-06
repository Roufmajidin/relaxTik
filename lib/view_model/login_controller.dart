import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:relax_tik/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/model_email.dart';

enum RequestStateLogin { empty, loading, loaded, error }

final FirebaseAuth _auth = FirebaseAuth.instance;
final api = APIEmail();
// Instance CollectionReference untuk mengakses koleksi 'users'
final CollectionReference _usersCollection =
    FirebaseFirestore.instance.collection('users');

class LoginController extends ChangeNotifier {
  RequestStateLogin _loginState = RequestStateLogin.empty;
  RequestStateLogin get loginState => _loginState;
  UserModel? _user;
  // Getter for user
  var isLogin = false;
  UserModel? get user => _user;
  String? _email;
  String? get emailUser => _email;
  void setUser(UserModel user) {
    _user = user;
    notifyListeners();
  }

  Future<User?> loginWithEmail(String email, String password) async {
    try {
      _loginState = RequestStateLogin.loading;
      notifyListeners();

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .get();

      if (userData.exists) {
        _user = UserModel(
          email: userCredential.user!.email!,
          nama: userData['nama'],
        );
        print(_user?.nama);
        _email = userCredential.user!.email;
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setString('email', email);
      prefs.setString('password', password);
      _email = userCredential.user!.email;
      print('this email : $_email');
      notifyListeners();

      isLogin = true;
      notifyListeners();

      _loginState = RequestStateLogin.loaded;
      notifyListeners();
    } catch (e) {
      _loginState = RequestStateLogin.error;
      notifyListeners();
      print('Error saat login: $e');
    }
    return null;
  }

  // local

  Future<void> saveUserData(String email, Map<String, dynamic> userData) async {
    try {
      await _usersCollection.doc(email).set(userData);
    } catch (e) {
      print('Error saat menyimpan data pengguna: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      // _loginState = RequestStateLogin.loading;
      notifyListeners();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      await _auth.signOut();
      _email = '';
      _user = null;

      // _loginState = RequestStateLogin.loaded;
      notifyListeners();
    } catch (e) {
      // _loginState = RequestStateLogin.error;
      notifyListeners();
      print('Error during logout: $e');
    }
    notifyListeners();
  }

  Future forgotPassword({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  Future<void> openGmailApp() async {
    const url = 'https://mail.google.com';
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

  void register(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController,
      TextEditingController usernameController) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.email)
          .set({
        'email': userCredential.user!.email,
        'nama': usernameController.text,
        'gambar': null
        // Anda dapat menyimpan data tambahan lainnya sesuai kebutuhan aplikasi Anda.
      });
      // Registrasi berhasil, Anda dapat menambahkan kode navigasi ke halaman berikutnya di sini.
      print('Registrasi berhasil: ${userCredential.user!.email}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('Password terlalu lemah.');
      } else if (e.code == 'email-already-in-use') {
        print('Email sudah digunakan pada akun lain.');
      }
    } catch (e) {
      print('Terjadi kesalahan: $e');
    }
  }

  // local
  Future<void> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var email = prefs.getString('email');

    print('Email yang tersimpan di SharedPreferences: $email');
    notifyListeners();
  }

  Future<bool> checkLoginStatus(context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedEmail = prefs.getString('email');
    String? savedPassword = prefs.getString('password');
    print('saved1: $savedEmail');
    print('saved2: $savedPassword');
    // final prov = Provider.of<LoginController>(context, listen: false);
    if (savedEmail != null && savedPassword != null) {
      await loginWithEmail(savedEmail, savedPassword);
      // getEmail();

      return true;
    }
    notifyListeners();

    return false;
  }

  notifyListeners();
}
