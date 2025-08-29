import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class CartRepo {
  final String baseUrl;

  CartRepo({required this.baseUrl});

  Future<PriceResponse> calculatePrice(PriceRequest request) async {
    final uri = Uri.parse('$baseUrl/cart/price');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PriceResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to calculate price: ${response.body}');
    }
  }

  Future<PromoValidateResponse> validatePromo(PromoValidateRequest request) async {
    final uri = Uri.parse('$baseUrl/cart/promo/validate');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return PromoValidateResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to validate promo: ${response.body}');
    }
  }
}