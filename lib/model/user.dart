import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? docId;
  String? nama;
  String? email;
  String? gambar;

  UserModel({
    this.docId,
    this.nama,
    this.email,
    this.gambar,
  });
  factory UserModel.fromJson(DocumentSnapshot doc) {
    return UserModel(
      docId: doc.id,
      nama: doc.get("nama"),
      email: doc.get("email"),
      gambar: doc.get("gambar"),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'user_id': doc_id,
      'nama': nama,
      'email': email,
      'gambar': gambar,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'gambar': gambar,
    };
  }
}
