import '../../data/data.dart';

class OrderService {
  final OrderRepo repository;

  OrderService(this.repository);

  Future<Order> createOrder(Map<String, dynamic> data) async {
    if ((data['items'] as List).isEmpty) {
      throw Exception("Items required");
    }
    return await repository.createOrder(data);
  }

  Future<List<Order>> getMyOrders({int page = 1, int pageSize = 20}) async {
    final orders = await repository.getMyOrders(page: page, pageSize: pageSize);
    // например, можно отсортировать или отфильтровать
    return orders;
  }

  Future<Order> getOrder(int id) async {
    return await repository.getOrder(id);
  }
}
