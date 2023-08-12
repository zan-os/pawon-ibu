import 'dart:convert';

class UserModel {
  final int? id;
  final int? roleId;
  final DateTime? createdAt;
  final String? firstName;
  final String? address;
  final String? telepon;
  final String? lat;
  final String? long;
  final String? lastName;

  const UserModel({
    this.id,
    this.roleId,
    this.createdAt,
    this.firstName,
    this.address,
    this.telepon,
    this.lat,
    this.long,
    this.lastName,
  });

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        roleId: json["role_id"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        firstName: json["first_name"],
        address: json["address"],
        telepon: json["telepon"],
        lat: json["lat"],
        long: json["long"],
        lastName: json["last_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "role_id": roleId,
        "created_at": createdAt?.toIso8601String(),
        "first_name": firstName,
        "address": address,
        "telepon": telepon,
        "lat": lat,
        "long": long,
        "last_name": lastName,
      };
}
