// isi controller mun di GETX

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ControllerProvider extends ChangeNotifier {
  Future<void> postPaymentToXendit() async {
    // Uri apiURL = Uri.parse('https://api.xendit.co/balance');
    Uri apiURL = Uri.parse('https://api.xendit.co/payments');
    // Uri apiURL = Uri.parse('https://api.xendit.co/customers');
    // Uri apiURL = Uri.parse('https://api.xendit.co/qr_codes');
    // Uri apiURL = Uri.parse('https://api.xendit.co/callback_virtual_accounts');

    // Ganti dengan API Key Xendit Anda
    String apiKey =
        'xnd_development_c87nmgt97GWLv3QwUdY1rtymgenS71BM6kuSt1sZFll6bPaDiKagvYIVndjgQ:';
    String encodedApiKey = base64.encode(utf8.encode(
        'xnd_development_UX3zb6bGgO5SGyPwhT3X8Wgytcd2WxIPXXVdbdAL8xvOrXyhSGoktN1qFONvcz:'));
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Basic $encodedApiKey',
    };
    print(encodedApiKey);
    Map<String, dynamic> data = {
      'payer_email': 'hildan@mail.com', //
      'description': "bayar air panas",
      'amount': 10000,
      //

      // 'external_id': 'pay-FIT3', //
      // 'bank_code': "BRI",
      // 'name': "Musl",
      // //
      // 'is_closed': true,
      // 'is_single_use': true,
      // 'expected_amount': 12000,
    };
    try {
      http.Response response =
          await http.post(apiURL, headers: headers, body: jsonEncode(data));

      if (response.statusCode == 200) {
        // Berhasil melakukan pembayaran
        print(response.body);
      } else {
        // Gagal melakukan pembayaran
        print('Payment failed.');
        print(response.body);
        print(response.statusCode);
      }
    } catch (e) {
      // Terjadi error saat melakukan request
      print('Error: $e');
    }

    // try {
    //   http.Response response =
    //       await http.post(apiURL, headers: headers, body: json.encode(data));

    //   if (response.statusCode == 200) {
    //     // Berhasil melakukan pembayaran
    //     print('Payment successful!');
    //   } else {
    //     // Gagal melakukan pembayaran
    //     print('Payment failed.');
    //     print(response.body);
    //     print(response.statusCode);
    //   }
    // } catch (e) {
    //   // Terjadi error saat melakukan request
    //   print('Error: $e');
    // }
  }
}
