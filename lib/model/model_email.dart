import 'dart:convert';
import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:relax_tik/model/Pesanan.dart';

class APIEmail {
  static const String baseUrl = 'https://mustiket-3371fb7c3fb2.herokuapp.com';
  Future sendOTP(email, otp) async {
    // log(email);
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

  // Simulate fetching data from an API

  static Future<List<DataPesanan>> getRiwayat({String? email}) async {
    final response = await http.get(
      Uri.parse('$baseUrl/payment_histories/$email'), //class all
    );
    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);
      final dataList = responseData;
      // log(responseData.toString());
      // print(dataList.length);
      // // return responseData;
      // print(dataList);
      return dataList
          .map<DataPesanan>((data) => DataPesanan.fromJson(data))
          .toList();
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

  static Future<DataPesanan> getPendingPesanan({int? id}) async {
    final response =
        await http.get(Uri.parse('$baseUrl/api/payment_histories/getById/$id'));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List<dynamic>;

      if (responseData.isNotEmpty) {
        final data = responseData[0]; // Take the first element from the list

        final pesananList = (data['pesanan'] as List<dynamic>)
            .map<PesananElement>((item) => PesananElement.fromJson(item))
            .toList();

        final dataPesanan = DataPesanan(
          id: data['id'],
          pemesan: data['pemesan'],
          status: data['status'],
          pesanan: pesananList,
          orderId: data['order_id'],
          totalAmount: data['total_amount'],
          checkoutLink: data['checkout_link'],
          createdAt: DateTime.parse(data['created_at']),
          updatedAt: DateTime.parse(data['updated_at']),
        );

        return dataPesanan;
      } else {
        throw Exception('Data not found');
      }
    } else {
      throw Exception('Failed to load Booking data');
    }
  }
}

class DataRow {
  final String id;
  final String name;
  final String email;
  final String detail;

  DataRow(
      {required this.id,
      required this.name,
      required this.email,
      required this.detail});
}
