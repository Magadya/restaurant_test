import '../entities/order.dart';
import '../entities/product.dart';
import '../entities/table.dart';

abstract class RestaurantRepository {
  Future<List<Product>> getProducts();

  Future<List<Product>> getProductsByCategory(String category);

  Future<Product> getProductById(int id);

  Future<List<RestaurantTable>> getTables();

  Future<RestaurantTable> getTableById(int id);

  Future<void> addTable(String number);

  Future<void> removeTable(int id);

  Future<void> updateTableStatus(int id, bool isOccupied);

  Future<List<OrderModel>> getOrders();

  Future<OrderModel> getOrderById(int id);

  Future<List<OrderModel>> getOrdersByTable(int tableId);

  Future<int> saveOrder(OrderModel order);

  Future<void> updateOrderStatus(int id, OrderStatus status);

  Future<void> deleteOrder(int id);
}
