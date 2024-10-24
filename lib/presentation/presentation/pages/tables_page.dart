import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_texts.dart';
import '../cubit/table/table_cubit.dart';
import '../cubit/table/table_state.dart';
import '../widgets/add_table_dialog.dart';
import '../widgets/table_card.dart';

class TablesPage extends StatelessWidget {
  const TablesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppTexts.tables),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTableDialog(context),
            tooltip: AppTexts.addTable,
          ),
        ],
      ),
      body: BlocBuilder<TableCubit, TableState>(
        builder: (context, state) {
          if (state is TableLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TableLoaded) {
            if (state.tables.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      'Нет доступных столиков',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () => _showAddTableDialog(context),
                      icon: const Icon(Icons.add),
                      label: const Text(AppTexts.addTable),
                    ),
                  ],
                ),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.tables.length,
              itemBuilder: (context, index) {
                final table = state.tables[index];
                return TableCard(
                  table: table,
                  onTap: () => context.go('/order?tableId=${table.id}'),
                  onDelete: () => _showDeleteConfirmation(context, table.id),
                  onStatusChanged: (isOccupied) {
                    context.read<TableCubit>().updateStatus(
                          table.id,
                          isOccupied,
                        );
                  },
                );
              },
            );
          }

          if (state is TableError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.read<TableCubit>().loadTables(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Повторить'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showAddTableDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AddTableDialog(),
    );
  }

  void _showDeleteConfirmation(BuildContext context, int tableId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppTexts.deleteTable),
        content: const Text('Вы уверены, что хотите удалить этот столик?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppTexts.cancel),
          ),
          TextButton(
            onPressed: () {
              context.read<TableCubit>().removeTable(tableId);
              Navigator.pop(context);
            },
            child: Text(
              AppTexts.delete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
