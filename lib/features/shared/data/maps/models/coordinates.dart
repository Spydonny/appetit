import 'package:equatable/equatable.dart';

class Coordinates extends Equatable {
  final double lat;
  final double lng;

  const Coordinates({required this.lat, required this.lng});

  factory Coordinates.fromJson(Map<String, dynamic> json) => Coordinates(
    lat: (json["lat"] as num).toDouble(),
    lng: (json["lng"] as num).toDouble(),
  );

  Map<String, dynamic> toJson() => {"lat": lat, "lng": lng};

  @override
  List<Object?> get props => [lat, lng];
}
