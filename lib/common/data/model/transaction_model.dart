// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

import 'package:pawon_ibu_app/common/data/model/user_model.dart';

class TransactionModel {
  final int? id;
  final int? transactionStatus;
  final int? totalBill;
  final dynamic receivedPaymentTotal;
  final DateTime? createdAt;
  final dynamic telephone;
  final dynamic address;
  final int? userId;
  final UserModel? user;

  TransactionModel({
    this.id,
    this.transactionStatus,
    this.totalBill,
    this.receivedPaymentTotal,
    this.createdAt,
    this.telephone,
    this.address,
    this.userId,
    this.user,
  });

  factory TransactionModel.fromRawJson(String str) =>
      TransactionModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionModel.fromJson(Map<String, dynamic> json) =>
      TransactionModel(
        id: json["id"],
        transactionStatus: json["transaction_status"],
        totalBill: json["total_bill"],
        receivedPaymentTotal: json["received_payment_total"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        telephone: json["telephone"],
        address: json["address"],
        userId: json["user_id"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_status": transactionStatus,
        "total_bill": totalBill,
        "received_payment_total": receivedPaymentTotal,
        "created_at": createdAt?.toIso8601String(),
        "telephone": telephone,
        "address": address,
        "user_id": userId,
        "user": user?.toJson(),
      };
}
