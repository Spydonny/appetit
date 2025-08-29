import 'package:equatable/equatable.dart';

class ForwardGeocodeRequest extends Equatable {
  final String address;
  final String language;
  final String region;
  final String? components;
  final String? bounds;

  const ForwardGeocodeRequest({
    required this.address,
    this.language = "ru",
    this.region = "KZ",
    this.components,
    this.bounds,
  });

  Map<String, dynamic> toJson() => {
    "address": address,
    "language": language,
    "region": region,
    if (components != null) "components": components,
    if (bounds != null) "bounds": bounds,
  };

  @override
  List<Object?> get props => [address, language, region, components, bounds];
}
