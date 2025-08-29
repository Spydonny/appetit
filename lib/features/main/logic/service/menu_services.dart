import '../../data/data.dart';

class MenuService {
  final MenuRepo repo;

  MenuService({required this.repo});

  Future<List<Category>> fetchCategories({String lc = "ru"}) async {
    return await repo.getCategories(lc: lc);
  }

  Future<List<MenuItem>> fetchItems({
    int? categoryId,
    String? search,
    bool? active = true,
    String lc = "ru",
  }) async {
    return await repo.getItems(
      categoryId: categoryId,
      search: search,
      active: active,
      lc: lc,
    );
  }

  Future<MenuItem> fetchItem(int id, {String lc = "ru"}) async {
    return await repo.getItem(id, lc: lc);
  }
}

