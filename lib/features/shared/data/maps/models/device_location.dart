import 'package:equatable/equatable.dart';

class DeviceLocation extends Equatable {
  final double? accuracyM;
  final String source;

  const DeviceLocation({this.accuracyM, this.source = "html5"});

  factory DeviceLocation.fromJson(Map<String, dynamic> json) => DeviceLocation(
    accuracyM: json["accuracy_m"]?.toDouble(),
    source: json["source"] ?? "html5",
  );

  Map<String, dynamic> toJson() => {
    if (accuracyM != null) "accuracy_m": accuracyM,
    "source": source,
  };

  @override
  List<Object?> get props => [accuracyM, source];
}
