import 'package:equatable/equatable.dart';

class PromoValidateResponse extends Equatable {
  final bool valid;
  final double discount;
  final String? reason;

  const PromoValidateResponse({
    required this.valid,
    required this.discount,
    this.reason,
  });

  factory PromoValidateResponse.fromJson(Map<String, dynamic> json) {
    return PromoValidateResponse(
      valid: json['valid'],
      discount: (json['discount'] as num).toDouble(),
      reason: json['reason'],
    );
  }

  @override
  List<Object?> get props => [valid, discount, reason];
}
