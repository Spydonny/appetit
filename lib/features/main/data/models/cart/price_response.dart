import 'package:equatable/equatable.dart';
import 'price_details_line.dart';

class PriceResponse extends Equatable {
  final double subtotal;
  final double discount;
  final double total;
  final List<PriceDetailsLine> details;

  const PriceResponse({
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.details,
  });

  factory PriceResponse.fromJson(Map<String, dynamic> json) {
    return PriceResponse(
      subtotal: (json['subtotal'] as num).toDouble(),
      discount: (json['discount'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      details: (json['details'] as List)
          .map((e) => PriceDetailsLine.fromJson(e))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [subtotal, discount, total, details];
}
