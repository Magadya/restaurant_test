import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/order.dart';
import '../../../../domain/entities/product.dart';
import '../cubit/order/order_cubit.dart';
import '../cubit/product/product_cubit.dart';
import '../cubit/product/product_state.dart';
import '../widgets/product_card.dart';

class OrderPage extends StatefulWidget {
  final int? tableId;

  const OrderPage({Key? key, this.tableId}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> with SingleTickerProviderStateMixin {
  final List<OrderItem> selectedItems = [];
  late TabController _tabController;
  bool showCart = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Заказ - Стол ${widget.tableId}'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Пицца'),
            Tab(text: 'Напитки'),
          ],
        ),
        actions: [
          Badge(
            label: Text(selectedItems.length.toString()),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                setState(() {
                  showCart = !showCart;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          if (showCart) _buildCart(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildProductGrid(ProductType.pizza),
                _buildProductGrid(ProductType.drink),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: selectedItems.isNotEmpty ? _buildBottomBar() : null,
    );
  }

  Widget _buildProductGrid(ProductType type) {
    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is ProductLoaded) {
          final products = state.products.where((product) => product.type == type).toList();

          if (products.isEmpty) {
            return Center(
              child: Text(
                'Нет доступных ${type == ProductType.pizza ? 'пицц' : 'напитков'}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              final orderItem = selectedItems.firstWhere(
                (item) => item.product.id == product.id,
                orElse: () => OrderItem(product: product, quantity: 0),
              );

              return ProductCard(
                product: product,
                quantity: orderItem.quantity,
                onAdd: () => _addToOrder(product),
                onRemove: () => _removeFromOrder(product),
              );
            },
          );
        }
        if (state is ProductError) {
          return Center(
            child: Text(state.message),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildCart() {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Корзина',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    showCart = false;
                  });
                },
              ),
            ],
          ),
          if (selectedItems.isEmpty)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Корзина пуста'),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: selectedItems.length,
              itemBuilder: (context, index) {
                final item = selectedItems[index];
                return Card(
                  child: ListTile(
                    leading: Image.asset(
                      item.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.product.name),
                    subtitle: Text(
                      '${item.product.price.toStringAsFixed(2)} \$ x ${item.quantity}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => _removeFromOrder(item.product),
                        ),
                        Text(item.quantity.toString()),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => _addToOrder(item.product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Итого:',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  '${_calculateTotal().toStringAsFixed(2)} \$',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: _createOrder,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 16,
                ),
              ),
              child: const Text(
                'Оформить заказ',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToOrder(Product product) {
    setState(() {
      final existingItemIndex = selectedItems.indexWhere((item) => item.product.id == product.id);

      if (existingItemIndex == -1) {
        selectedItems.add(OrderItem(
          product: product,
          quantity: 1,
        ));
      } else {
        final existingItem = selectedItems[existingItemIndex];
        selectedItems[existingItemIndex] = OrderItem(
          product: product,
          quantity: existingItem.quantity + 1,
        );
      }
    });
  }

  void _removeFromOrder(Product product) {
    setState(() {
      final existingItemIndex = selectedItems.indexWhere((item) => item.product.id == product.id);

      if (existingItemIndex != -1) {
        final existingItem = selectedItems[existingItemIndex];
        if (existingItem.quantity > 1) {
          selectedItems[existingItemIndex] = OrderItem(
            product: product,
            quantity: existingItem.quantity - 1,
          );
        } else {
          selectedItems.removeAt(existingItemIndex);
        }
      }
    });
  }

  double _calculateTotal() {
    return selectedItems.fold(
      0,
      (total, item) => total + (item.product.price * item.quantity),
    );
  }

  void _createOrder() {
    if (widget.tableId == null || selectedItems.isEmpty) return;

    final order = OrderModel(
      id: 0,
      // ID будет назначен базой данных
      tableId: widget.tableId!,
      items: List.from(selectedItems),
      status: OrderStatus.new_,
      createdAt: DateTime.now(),
      totalAmount: _calculateTotal(),
    );

    context.read<OrderCubit>().createOrder(order);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Заказ успешно создан'),
        backgroundColor: AppColors.success,
      ),
    );

    context.go('/');
  }
}


