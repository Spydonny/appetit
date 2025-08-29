import 'package:equatable/equatable.dart';

class GeocodeResponse extends Equatable {
  final String status;
  final List<dynamic> results;
  final String? errorMessage;

  const GeocodeResponse({
    required this.status,
    required this.results,
    this.errorMessage,
  });

  factory GeocodeResponse.fromJson(Map<String, dynamic> json) =>
      GeocodeResponse(
        status: json["status"],
        results: json["results"] ?? [],
        errorMessage: json["error_message"],
      );

  @override
  List<Object?> get props => [status, results, errorMessage];
}
