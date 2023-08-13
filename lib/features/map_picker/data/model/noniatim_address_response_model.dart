import 'dart:convert';

List<NoniatimAddressResponseModel> noniatimAddressResponseModelFromJson(
        String str) =>
    List<NoniatimAddressResponseModel>.from(
        json.decode(str).map((x) => NoniatimAddressResponseModel.fromJson(x)));

String noniatimAddressResponseModelToJson(
        List<NoniatimAddressResponseModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class NoniatimAddressResponseModel {
  int placeId;
  String licence;
  String osmType;
  int osmId;
  List<String> boundingbox;
  String lat;
  String lon;
  String displayName;
  String noniatimAddressResponseModelClass;
  String type;
  double importance;

  NoniatimAddressResponseModel({
    required this.placeId,
    required this.licence,
    required this.osmType,
    required this.osmId,
    required this.boundingbox,
    required this.lat,
    required this.lon,
    required this.displayName,
    required this.noniatimAddressResponseModelClass,
    required this.type,
    required this.importance,
  });

  factory NoniatimAddressResponseModel.fromJson(Map<String, dynamic> json) =>
      NoniatimAddressResponseModel(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        boundingbox: List<String>.from(json["boundingbox"].map((x) => x)),
        lat: json["lat"],
        lon: json["lon"],
        displayName: json["display_name"],
        noniatimAddressResponseModelClass: json["class"],
        type: json["type"],
        importance: json["importance"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "boundingbox": List<dynamic>.from(boundingbox.map((x) => x)),
        "lat": lat,
        "lon": lon,
        "display_name": displayName,
        "class": noniatimAddressResponseModelClass,
        "type": type,
        "importance": importance,
      };
}
