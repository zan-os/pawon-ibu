import 'dart:convert';

class PaymentType {
  final int? id;
  final DateTime? createdAt;
  final String? name;
  final String? accountNumber;
  final String? image;

  PaymentType({
    this.id,
    this.createdAt,
    this.name,
    this.accountNumber,
    this.image,
  });

  factory PaymentType.fromRawJson(String str) =>
      PaymentType.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentType.fromJson(Map<String, dynamic> json) => PaymentType(
        id: json["id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        name: json["name"],
        accountNumber: json["account_number"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt?.toIso8601String(),
        "name": name,
        "account_number": accountNumber,
        "image": image,
      };
}
