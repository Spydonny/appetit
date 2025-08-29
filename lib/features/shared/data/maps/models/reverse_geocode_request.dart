import 'package:equatable/equatable.dart';

class ReverseGeocodeRequest extends Equatable {
  final double lat;
  final double lng;
  final String language;
  final String region;
  final String? resultType;
  final String? locationType;

  const ReverseGeocodeRequest({
    required this.lat,
    required this.lng,
    this.language = "ru",
    this.region = "KZ",
    this.resultType,
    this.locationType,
  });

  Map<String, dynamic> toJson() => {
    "lat": lat,
    "lng": lng,
    "language": language,
    "region": region,
    if (resultType != null) "result_type": resultType,
    if (locationType != null) "location_type": locationType,
  };

  @override
  List<Object?> get props => [lat, lng, language, region, resultType, locationType];
}
