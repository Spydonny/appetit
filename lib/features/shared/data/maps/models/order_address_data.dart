import 'package:equatable/equatable.dart';
import 'address_components.dart';
import 'geocoded_data.dart';
import 'coordinates.dart';
import 'device_location.dart';

class OrderAddressData extends Equatable {
  final String typedAddress;
  final AddressComponents components;
  final GeocodedData? geocoded;
  final Coordinates? finalPin;
  final DeviceLocation? deviceLoc;

  const OrderAddressData({
    required this.typedAddress,
    required this.components,
    this.geocoded,
    this.finalPin,
    this.deviceLoc,
  });

  Map<String, dynamic> toJson() => {
    "typed_address": typedAddress,
    "components": components.toJson(),
    if (geocoded != null) "geocoded": geocoded!.toJson(),
    if (finalPin != null) "final_pin": finalPin!.toJson(),
    if (deviceLoc != null) "device_loc": deviceLoc!.toJson(),
  };

  @override
  List<Object?> get props => [typedAddress, components, geocoded, finalPin, deviceLoc];
}
