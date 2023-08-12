import 'dart:convert';

class BestSalesModel {
  final String? productName;
  final int? productPrice;
  final int? totalSold;

  BestSalesModel({
    this.productName,
    this.productPrice,
    this.totalSold,
  });

  factory BestSalesModel.fromRawJson(String str) =>
      BestSalesModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory BestSalesModel.fromJson(Map<String, dynamic> json) => BestSalesModel(
        productName: json["product_name"],
        productPrice: json["product_price"],
        totalSold: json["total_sold"],
      );

  Map<String, dynamic> toJson() => {
        "product_name": productName,
        "product_price": productPrice,
        "total_sold": totalSold,
      };
}
