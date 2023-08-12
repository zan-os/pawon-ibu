// To parse this JSON data, do
//
//     final transactionDetailModel = transactionDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:pawon_ibu_app/common/data/model/transaction_model.dart';
import 'package:pawon_ibu_app/common/data/model/user_model.dart';

class TransactionDetailModel {
  final int? id;
  final int? transactionId;
  final int? productId;
  final int? qty;
  final int? price;
  final DateTime? createdAt;
  final int? userId;
  final TransactionModel? transaction;
  final Product? product;
  final UserModel? user;

  const TransactionDetailModel({
    this.id,
    this.transactionId,
    this.productId,
    this.qty,
    this.price,
    this.createdAt,
    this.userId,
    this.transaction,
    this.product,
    this.user,
  });

  factory TransactionDetailModel.fromRawJson(String str) =>
      TransactionDetailModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TransactionDetailModel.fromJson(Map<String, dynamic> json) =>
      TransactionDetailModel(
        id: json["id"],
        transactionId: json["transaction_id"],
        productId: json["product_id"],
        qty: json["qty"],
        price: json["price"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        userId: json["user_id"],
        transaction: json["transaction"] == null
            ? null
            : TransactionModel.fromJson(json["transaction"]),
        product:
            json["product"] == null ? null : Product.fromJson(json["product"]),
        user: json["user"] == null ? null : UserModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "transaction_id": transactionId,
        "product_id": productId,
        "qty": qty,
        "price": price,
        "created_at": createdAt?.toIso8601String(),
        "user_id": userId,
        "transaction": transaction?.toJson(),
        "product": product?.toJson(),
        "user": user?.toJson(),
      };
}

class Product {
  final String? name;
  final dynamic image;

  Product({
    this.name,
    this.image,
  });

  factory Product.fromRawJson(String str) => Product.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        name: json["name"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
      };
}
