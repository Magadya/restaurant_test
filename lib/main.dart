import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:restaurant_test/presentation/presentation/cubit/order/order_cubit.dart';
import 'package:restaurant_test/presentation/presentation/cubit/product/product_cubit.dart';
import 'package:restaurant_test/presentation/presentation/cubit/table/table_cubit.dart';

import 'core/routes/router.dart';
import 'data/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<OrderCubit>()..loadOrders(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<TableCubit>()..loadTables(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<ProductCubit>()..loadProducts(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Restaurant App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routerConfig: router,
      ),
    );
  }
}
