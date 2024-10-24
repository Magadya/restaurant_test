import 'package:get_it/get_it.dart';
import 'package:restaurant_test/data/repositories/order_repository_impl.dart';
import 'package:restaurant_test/data/repositories/product_repository_impl.dart';
import 'package:restaurant_test/data/repositories/table_repository_impl.dart';


import '../domain/repositories/order_repository.dart';
import '../domain/repositories/product_repository.dart';
import '../domain/repositories/table_repository.dart';
import '../domain/usecases/orders/add_order.dart';
import '../domain/usecases/orders/delete_order.dart';
import '../domain/usecases/orders/get_orders.dart';
import '../domain/usecases/orders/update_order.dart';
import '../domain/usecases/products/get_products.dart';
import '../domain/usecases/tables/add_table.dart';
import '../domain/usecases/tables/delete_table.dart';
import '../domain/usecases/tables/get_tables.dart';
import '../domain/usecases/tables/update_table.dart';
import '../presentation/presentation/cubit/order/order_cubit.dart';
import '../presentation/presentation/cubit/product/product_cubit.dart';
import '../presentation/presentation/cubit/table/table_cubit.dart';
import 'datasources/local/database_helper.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Cubits
  sl.registerFactory(
    () => OrderCubit(
      getOrders: sl(),
      addOrder: sl(),
      updateOrder: sl(),
    ),
  );

  sl.registerFactory(
    () => ProductCubit(
      getProducts: sl(),
    ),
  );

  sl.registerFactory(
    () => TableCubit(
      getTables: sl(),
      addTable: sl(),
      deleteTable: sl(),
      updateTableStatus: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => GetOrders(sl()));
  sl.registerLazySingleton(() => AddOrder(sl()));
  sl.registerLazySingleton(() => UpdateOrder(sl()));
  sl.registerLazySingleton(() => DeleteOrder(sl()));
  sl.registerLazySingleton(() => GetProducts(sl()));
  sl.registerLazySingleton(() => GetTables(sl()));
  sl.registerLazySingleton(() => AddTable(sl()));
  sl.registerLazySingleton(() => DeleteTable(sl()));
  sl.registerLazySingleton(() => UpdateTableStatus(sl()));

  // Repositories
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<TableRepository>(
    () => TableRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => DatabaseHelper.instance);
}
