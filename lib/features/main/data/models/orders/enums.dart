enum OrderStatus { newOrder, processing, completed, cancelled }
enum FulfillmentType { delivery, pickup }
enum PaymentMethod { cod, online }

extension OrderStatusX on OrderStatus {
  String get value {
    switch (this) {
      case OrderStatus.newOrder:
        return 'NEW';
      case OrderStatus.processing:
        return 'PROCESSING';
      case OrderStatus.completed:
        return 'COMPLETED';
      case OrderStatus.cancelled:
        return 'CANCELLED';
    }
  }

  static OrderStatus fromString(String? status) {
    switch (status?.toUpperCase()) {
      case 'PROCESSING':
        return OrderStatus.processing;
      case 'COMPLETED':
        return OrderStatus.completed;
      case 'CANCELLED':
        return OrderStatus.cancelled;
      case 'NEW':
      default:
        return OrderStatus.newOrder;
    }
  }
}

extension FulfillmentTypeX on FulfillmentType {
  String get value {
    switch (this) {
      case FulfillmentType.delivery:
        return 'delivery';
      case FulfillmentType.pickup:
        return 'pickup';
    }
  }

  static FulfillmentType fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'pickup':
        return FulfillmentType.pickup;
      case 'delivery':
      default:
        return FulfillmentType.delivery;
    }
  }
}

extension PaymentMethodX on PaymentMethod {
  String get value {
    switch (this) {
      case PaymentMethod.cod:
        return 'cod';
      case PaymentMethod.online:
        return 'online';
    }
  }

  static PaymentMethod fromString(String? val) {
    switch (val?.toLowerCase()) {
      case 'online':
        return PaymentMethod.online;
      case 'cod':
      default:
        return PaymentMethod.cod;
    }
  }
}
