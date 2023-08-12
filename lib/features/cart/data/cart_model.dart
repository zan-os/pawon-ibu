import 'dart:convert';

import '../../../common/data/model/product_model.dart';

class CartModel {
  final int? id;
  final int? qty;
  final int? totalBill;
  final ProductModel? product;

  CartModel({
    this.id,
    this.qty,
    this.totalBill,
    this.product,
  });

  factory CartModel.fromRawJson(String str) =>
      CartModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        id: json["id"],
        qty: json["qty"],
        totalBill: json["total_bill"],
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "qty": qty,
        "total_bill": totalBill,
        "product": product?.toJson(),
      };
}
