import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/menu/modification_type.dart';
import '../models/models.dart';

class MenuRepo {
  final String baseUrl;
  final http.Client _client;

  MenuRepo({required this.baseUrl, http.Client? client})
      : _client = client ?? http.Client();

  Future<dynamic> _get(String path, {Map<String, String>? query}) async {
    final uri = Uri.parse('$baseUrl$path').replace(queryParameters: query);
    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception('Not found');
    } else {
      throw Exception('Request failed: ${response.statusCode}');
    }
  }

  Future<List<Category>> getCategories({String lc = "ru"}) async {
    final data = await _get(
      '/menu/categories',
      query: {'lc': lc},
    );
    return (data as List).map((e) => Category.fromJson(e)).toList();
  }

  Future<List<MenuItem>> getItems({
    int? categoryId,
    String? search,
    bool? active = true,
    String lc = "ru",
  }) async {
    final query = <String, String>{'lc': lc};
    if (categoryId != null) query['category_id'] = categoryId.toString();
    if (search != null && search.isNotEmpty) query['search'] = search;
    if (active != null) query['active'] = active.toString();

    final data = await _get('/menu/items', query: query);
    return (data as List).map((e) => MenuItem.fromJson(e)).toList();
  }

  Future<MenuItem> getItem(int id, {String lc = "ru"}) async {
    final data = await _get('/menu/items/$id', query: {'lc': lc});
    return MenuItem.fromJson(data);
  }

  Future<List<ModificationType>> getModificationTypes({
    String? category,
    bool isActive = true,
    String lc = "ru",
  }) async {
    final query = <String, String>{
      'is_active': isActive.toString(),
      'lc': lc,
    };
    if (category != null) query['category'] = category;

    final data = await _get('/modifications/types', query: query);
    return (data as List).map((e) => ModificationType.fromJson(e)).toList();
  }
}
