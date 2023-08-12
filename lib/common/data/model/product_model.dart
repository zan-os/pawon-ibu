import 'dart:convert';

class ProductModel {
  final int id;
  final String createdAt;
  final String name;
  final String description;
  final int price;
  final int categoryId;
  final String? image;
  final double? weight;

  ProductModel({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.description,
    required this.price,
    required this.categoryId,
    this.image,
    this.weight,
  });

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        id: json["id"],
        createdAt: json["created_at"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        categoryId: json["category_id"],
        image: json["image"],
        weight: json["weight"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt,
        "name": name,
        "description": description,
        "price": price,
        "category_id": categoryId,
        "image": image,
        "weight": weight,
      };
}
