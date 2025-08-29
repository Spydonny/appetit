import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class MapRepo {
  final String baseUrl;
  final http.Client client;

  MapRepo({required this.baseUrl, http.Client? client})
      : client = client ?? http.Client();

  Future<GeocodeResponse> forwardGeocode(ForwardGeocodeRequest req) async {
    final url = Uri.parse("$baseUrl/maps/forward-geocode");
    final resp = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(req.toJson()),
    );

    if (resp.statusCode == 200) {
      return GeocodeResponse.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception("Forward geocode failed: ${resp.body}");
    }
  }

  Future<GeocodeResponse> reverseGeocode(ReverseGeocodeRequest req) async {
    final url = Uri.parse("$baseUrl/maps/reverse-geocode");
    final resp = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(req.toJson()),
    );

    if (resp.statusCode == 200) {
      return GeocodeResponse.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception("Reverse geocode failed: ${resp.body}");
    }
  }

  Future<AddressValidationResponse> validateAddress(OrderAddressData req) async {
    final url = Uri.parse("$baseUrl/maps/validate-address");
    final resp = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(req.toJson()),
    );

    if (resp.statusCode == 200) {
      return AddressValidationResponse.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception("Validate address failed: ${resp.body}");
    }
  }

  Future<GeocodeResponse> quickReverse({
    required double lat,
    required double lng,
    String language = "ru",
    bool precise = true,
  }) async {
    final url = Uri.parse(
        "$baseUrl/maps/quick-reverse?lat=$lat&lng=$lng&language=$language&precise=$precise");

    final resp = await client.get(url);

    if (resp.statusCode == 200) {
      return GeocodeResponse.fromJson(jsonDecode(resp.body));
    } else {
      throw Exception("Quick reverse geocode failed: ${resp.body}");
    }
  }
}
