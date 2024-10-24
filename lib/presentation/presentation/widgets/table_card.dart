import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/constants/app_colors.dart';
import '../../../domain/entities/table.dart';
import '../cubit/table/table_cubit.dart';
import '../cubit/table/table_state.dart';


class TableCard extends StatelessWidget {
  final RestaurantTable table;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final ValueChanged<bool> onStatusChanged;

  const TableCard({
    Key? key,
    required this.table,
    required this.onTap,
    required this.onDelete,
    required this.onStatusChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 4),
                  Text(
                    'Стол ${table.number}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  BlocBuilder<TableCubit, TableState>(
                    builder: (context, state) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Switch(
                            value: table.isOccupied,
                            onChanged: state is TableLoading ? null : onStatusChanged,
                            activeColor: AppColors.error,
                          ),
                          if (state is TableLoading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                  Text(
                    table.isOccupied ? 'Занят' : 'Свободен',
                    style: TextStyle(
                      color: table.isOccupied ? AppColors.error : AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 2,
              right: 2,
              child: IconButton(
                icon: const Icon(Icons.close),
                color: Colors.grey,
                onPressed: onDelete,
                tooltip: 'Удалить столик',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
