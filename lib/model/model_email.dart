import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:relax_tik/model/Pesanan.dart';

class APIEmail {
  static const String baseUrl = 'https://fa49-103-191-218-82.ngrok-free.app';
  Future sendOTP(email, otp) async {
    log(email);
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const servisId = 'service_gyix20h';
    const userId = 'kgBftW4780LNwN4e2';

    final response = await http.post(url,
        headers: {
          'content-type': 'application/json',
          'origin': 'http://localhost'
        },
        body: json.encode({
          'service_id': servisId,
          'template_id': 'template_kft1yri',
          'user_id': userId,
          'template_params': {
            'name': "Hallo, ${email.toString()}",
            'subject': 'gofit',
            'to_email': email.toString(),
            'reply_to': email.toString(),
            'message': "this your otp ${otp.toString()}",
          }
        }));
    print(response);
    return response.statusCode;
  }

  static Future<List<Pesanan>> getRiwayat({String? email}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payment_histories/$email'), //class all
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final dataList = responseData;
      log(responseData.toString());
      print(dataList.length);
      // return responseData;
      print(dataList);
      return dataList.map<Pesanan>((data) => Pesanan.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load Booking data');
    }
  }

  static Future<dynamic> bayar(data, totalBayar) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final User? user = _auth.currentUser;
    print('user : ${user!.email}');
    String pesanan = jsonEncode(data);
    final a = {
      "payer_email": user.email,
      "description": pesanan,
      "total_amount": totalBayar
    };
    final response =
        await http.post(Uri.parse('$baseUrl/api/payment_histories'),
            headers: {
              'Content-Type': 'application/json',
            },
            body: jsonEncode(a));
    print(response.body);

    if (response.statusCode == 200) {
      return response.body;
    } else {
      print(response.statusCode);
      throw "Can't pay the haha";
    }
  }
}
