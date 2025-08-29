import 'dart:convert';
import 'package:appetite_app/core/core.dart';
import 'package:http/http.dart' as http;
import '../models/models.dart';

class OrderRepo {
  final String baseUrl;

  OrderRepo({
    required this.baseUrl,
  });

  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${getIt<TokenNotifier>().token}',
  };

  Future<Order> createOrder(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/orders'),
      headers: _headers,
      body: jsonEncode(data),
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to create order: ${res.body}');
    }
    return Order.fromJson(jsonDecode(res.body));
  }

  Future<List<Order>> getMyOrders({int page = 1, int pageSize = 20}) async {
    final res = await http.get(
      Uri.parse('$baseUrl/orders/mine?page=$page&page_size=$pageSize'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch orders: ${res.body}');
    }
    final data = jsonDecode(res.body);
    return (data['items'] as List).map((e) => Order.fromJson(e)).toList();
  }

  Future<Order> getOrder(int id) async {
    final res = await http.get(
      Uri.parse('$baseUrl/orders/$id'),
      headers: _headers,
    );
    if (res.statusCode != 200) {
      throw Exception('Failed to fetch order: ${res.body}');
    }
    return Order.fromJson(jsonDecode(res.body));
  }
}
