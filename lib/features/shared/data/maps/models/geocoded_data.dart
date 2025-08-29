import 'package:equatable/equatable.dart';

class GeocodedData extends Equatable {
  final String formattedAddress;
  final double lat;
  final double lng;
  final String method;
  final List<String> resultTypes;

  const GeocodedData({
    required this.formattedAddress,
    required this.lat,
    required this.lng,
    required this.method,
    required this.resultTypes,
  });

  factory GeocodedData.fromJson(Map<String, dynamic> json) => GeocodedData(
    formattedAddress: json["formatted_address"],
    lat: (json["lat"] as num).toDouble(),
    lng: (json["lng"] as num).toDouble(),
    method: json["method"],
    resultTypes: List<String>.from(json["result_types"] ?? []),
  );

  Map<String, dynamic> toJson() => {
    "formatted_address": formattedAddress,
    "lat": lat,
    "lng": lng,
    "method": method,
    "result_types": resultTypes,
  };

  @override
  List<Object?> get props => [formattedAddress, lat, lng, method, resultTypes];
}
