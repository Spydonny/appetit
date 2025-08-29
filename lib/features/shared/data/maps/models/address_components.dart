import 'package:equatable/equatable.dart';

class AddressComponents extends Equatable {
  final String city;
  final String street;
  final String house;
  final String entrance;
  final String apartment;
  final String floor;
  final String comment;

  const AddressComponents({
    this.city = "",
    this.street = "",
    this.house = "",
    this.entrance = "",
    this.apartment = "",
    this.floor = "",
    this.comment = "",
  });

  factory AddressComponents.fromJson(Map<String, dynamic> json) =>
      AddressComponents(
        city: json["city"] ?? "",
        street: json["street"] ?? "",
        house: json["house"] ?? "",
        entrance: json["entrance"] ?? "",
        apartment: json["apartment"] ?? "",
        floor: json["floor"] ?? "",
        comment: json["comment"] ?? "",
      );

  Map<String, dynamic> toJson() => {
    "city": city,
    "street": street,
    "house": house,
    "entrance": entrance,
    "apartment": apartment,
    "floor": floor,
    "comment": comment,
  };

  @override
  List<Object?> get props => [city, street, house, entrance, apartment, floor, comment];
}
