import 'package:equatable/equatable.dart';
import 'address_components.dart';
import 'geocoded_data.dart';

class AddressValidationResponse extends Equatable {
  final bool isValid;
  final AddressComponents components;
  final GeocodedData? geocoded;

  const AddressValidationResponse({
    required this.isValid,
    required this.components,
    this.geocoded,
  });

  factory AddressValidationResponse.fromJson(Map<String, dynamic> json) =>
      AddressValidationResponse(
        isValid: json["is_valid"],
        components: AddressComponents.fromJson(json["components"]),
        geocoded:
        json["geocoded"] != null ? GeocodedData.fromJson(json["geocoded"]) : null,
      );

  @override
  List<Object?> get props => [isValid, components, geocoded];
}
