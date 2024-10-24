
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../../presentation/presentation/pages/home_page.dart';
import '../../presentation/presentation/pages/order_page.dart';
import '../../presentation/presentation/pages/tables_page.dart';


final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
      routes: [
        GoRoute(
          path: 'tables',
          builder: (context, state) => const TablesPage(),
        ),
        GoRoute(
          path: 'order',
          builder: (context, state) {
            final tableId = int.tryParse(state.uri.queryParameters['tableId'] ?? '');
            return OrderPage(tableId: tableId);
          },
        ),
      ],
    ),
  ],
);