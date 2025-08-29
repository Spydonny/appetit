enum FulfillmentType { delivery, pickup }

extension FulfillmentTypeExt on FulfillmentType {
  String get value {
    switch (this) {
      case FulfillmentType.delivery:
        return "delivery";
      case FulfillmentType.pickup:
        return "pickup";
    }
  }

  static FulfillmentType fromString(String value) {
    switch (value) {
      case "delivery":
        return FulfillmentType.delivery;
      case "pickup":
        return FulfillmentType.pickup;
      default:
        throw ArgumentError("Unknown fulfillment type: $value");
    }
  }
}
