import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_test/presentation/presentation/cubit/table/table_state.dart';
import '../../../../domain/usecases/tables/add_table.dart';
import '../../../../domain/usecases/tables/delete_table.dart';
import '../../../../domain/usecases/tables/get_tables.dart';
import '../../../../domain/usecases/tables/update_table.dart';

class TableCubit extends Cubit<TableState> {
  final GetTables getTables;
  final AddTable addTable;
  final DeleteTable deleteTable;
  final UpdateTableStatus updateTableStatus;

  TableCubit({
    required this.getTables,
    required this.addTable,
    required this.deleteTable,
    required this.updateTableStatus,
  }) : super(TableInitial());

  Future<void> loadTables() async {
    emit(TableLoading());
    final result = await getTables();
    result.fold(
      (failure) => emit(TableError(failure.toString())),
      (tables) => emit(TableLoaded(tables)),
    );
  }

  Future<void> addNewTable(String number) async {
    final result = await addTable(number);
    result.fold(
      (failure) => emit(TableError(failure.toString())),
      (_) => loadTables(),
    );
  }

  Future<void> removeTable(int id) async {
    final result = await deleteTable(id);
    result.fold(
      (failure) => emit(TableError(failure.toString())),
      (_) => loadTables(),
    );
  }

  Future<void> updateStatus(int id, bool isOccupied) async {
    emit(TableLoading());
    final result = await this.updateTableStatus(id, isOccupied);
    result.fold(
      (failure) => emit(TableError(failure.toString())),
      (_) => loadTables(),
    );
  }
}
