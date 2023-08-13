import 'dart:convert';

import 'package:pawon_ibu_app/common/data/model/payment_type.dart';
import 'package:pawon_ibu_app/common/data/model/transaction_detail_model.dart';
import 'package:pawon_ibu_app/common/data/model/user_model.dart';

class TransactionModel {
  final int? id;
  final int? transactionStatus;
  final int? totalBill;
  final int? receivedPaymentTotal;
  final DateTime? createdAt;
  final dynamic telephone;
  final dynamic address;
  final int? userId;
  final dynamic expenses;
  final int? paymentId;
  final UserModel? user;
  final List<TransactionDetailModel>? transactionDetail;
  final PaymentType? paymentType;

  TransactionModel({
    this.id,
    this.transactionStatus,
    this.totalBill,
    this.receivedPaymentTotal,
    this.createdAt,
    this.telephone,
    this.address,
    this.userId,
    this.expenses,
    this.paymentId,
    this.user,
    this.transactionDetail,
    this.paymentType,
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
        expenses: json["expenses"],
        paymentId: json["payment_id"],
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
        transactionDetail: json["transaction_detail"] == null
            ? []
            : List<TransactionDetailModel>.from(json["transaction_detail"]!
                .map((x) => TransactionDetailModel.fromJson(x))),
        paymentType: json["payment_type"] == null
            ? null
            : PaymentType.fromJson(json["payment_type"]),
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
        "expenses": expenses,
        "payment_id": paymentId,
        "user": user?.toJson(),
        "transaction_detail": transactionDetail == null
            ? []
            : List<dynamic>.from(transactionDetail!.map((x) => x.toJson())),
        "payment_type": paymentType?.toJson(),
      };
}
