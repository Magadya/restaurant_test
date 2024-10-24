import 'package:dartz/dartz.dart';
import '../../domain/repositories/table_repository.dart';
import '../../domain/entities/table.dart';
import '../../core/errors/failures.dart';
import '../datasources/local/database_helper.dart';

class TableRepositoryImpl implements TableRepository {
  final DatabaseHelper databaseHelper;

  TableRepositoryImpl(this.databaseHelper);

  @override
  Future<Either<Failure, List<RestaurantTable>>> getTables() async {
    try {
      final db = await databaseHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('tables');

      final tables = maps.map((map) => RestaurantTable(
        id: map['id'],
        number: map['number'],
        isOccupied: map['isOccupied'] == 1,
      )).toList();

      return Right(tables);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> addTable(String number) async {
    try {
      final db = await databaseHelper.database;
      await db.insert('tables', {
        'number': number,
        'isOccupied': 0,
      });
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteTable(int id) async {
    try {
      final db = await databaseHelper.database;
      await db.delete(
        'tables',
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }

  @override
  Future<Either<Failure, Unit>> updateTableStatus(int id, bool isOccupied) async {
    try {
      final db = await databaseHelper.database;
      await db.update(
        'tables',
        {'isOccupied': isOccupied ? 1 : 0},
        where: 'id = ?',
        whereArgs: [id],
      );
      return const Right(unit);
    } catch (e) {
      return Left(DatabaseFailure());
    }
  }
}